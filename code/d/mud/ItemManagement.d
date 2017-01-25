import std.typecons : Tuple, Typedef;
import std.exception : enforce;
import std.algorithm.mutation : remove;

class Containable {
	ContainableIdType id;
}

alias Typedef!(ulong, ulong.init, "ContainableIdType") ContainableIdType;
alias Typedef!(ulong, ulong.init, "CharacterIdType") CharacterIdType;
alias Typedef!(ulong, ulong.init, "ItemIdType") ItemIdType;

interface ITransfer {
	void begin();

	void failedAsync(); // the request failed for asyncronous reasons, like the requested number of elements was not avaiable in the source, the target is already ful, etc

	void commited(); // was successfully executed
}


// keeps track of which items are in containables (not all have to be accessible by the players/characters/NPCs)
// and who can access what and do transfer items
class ContainableManager {
	struct StackedItemInfo {
		ContainableIdType containableId; // the id of the containable in which the item is located in
		ItemIdType itemId; // unique for the itemized with the specific attributes (radiation, age, production history, etc)

		ulong count;
	}

	struct ContainableInfo {
		double availableVolume;

		CharacterIdType ownerId;
		ContainableIdType id;
	}

	final bool allowedToTransferAsSource(CharacterIdType queryCharacterId, ContainableIdType containableId) {
		// if the character owns the containable the transfer is possible
		if( queryIsContainableOwnedBy(containableId, queryCharacterId) ) {
			return true;
		}

		return false;
	}

	final bool allowedToTransferAsDestination(CharacterIdType queryCharacterId, ContainableIdType containableId) {
		// if the character owns the containable the transfer is possible
		if( queryIsContainableOwnedBy(containableId, queryCharacterId) ) {
			return true;
		}

		return false;
	}

	static struct BeginTransferWithCheckAsyncArguments {
		CharacterIdType initiatorCharacterId;
		ContainableIdType sourceContainableId, destinationContainableId;
		ItemIdType itemId;
		ulong count;
	}


	// \param asyncTransferNotifier is used to notify the initiator(code) about the progress of the transfer
	final void beginTransferWithCheckAsync(BeginTransferWithCheckAsyncArguments arguments, ITransfer asyncTransferNotifier, out bool initialCheckSuccess) {
		initialCheckSuccess = false;

		if( !allowedToTransferAsSource(arguments.initiatorCharacterId, arguments.sourceContainableId) || allowedToTransferAsDestination(arguments.initiatorCharacterId, arguments.destinationContainableId) ) {
			// TODO< log >
			return;
		}

		// check if containables exist
		if( !(arguments.sourceContainableId in containableByIdCached) || !(arguments.destinationContainableId in containableByIdCached)) {
			// TODO< log >
			return;
		}

		// check if the requested # of items is available
		assert(TupleOfContainableItemIds(arguments.sourceContainableId, arguments.itemId) in stackedItemInfoByContainableAndItemIdCached);
		if( stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(arguments.sourceContainableId, arguments.itemId)].count < arguments.count ) {
			// TODO< log >
			return;
		}

		initialCheckSuccess = true;

		// async part, which we just do for now syncronously

		asyncTransferNotifier.begin(); // inform that we have begun it

		removeItemsFromContainable(arguments.sourceContainableId, arguments.itemId, arguments.count);
		checkContainableForEmptyTypesAndRemoveEmptyByItemId(arguments.sourceContainableId, arguments.itemId);
		addItemsToContainableWithCreation(arguments.destinationContainableId, arguments.itemId, arguments.count);

		asyncTransferNotifier.commited();
	}

	private final bool queryIsContainableOwnedBy(ContainableIdType containableId, CharacterIdType queryCharacterId) {
		assert( queryCharacterId in containablesByOwnerCached );
		// TODO< linear search -> speed this up >
		foreach( ContainableInfo* iContainableInfo; containablesByOwnerCached[queryCharacterId] ) {
			if( iContainableInfo.id == containableId ) {
				return true;
			}
		}
		return false;
	}

	// creates the item in the containable if it doesn't exist
	private final void addItemsToContainableWithCreation(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		createItemInContainableIfItDoesntExist(containableId, itemId);
		addItemsToContainable(containableId, itemId, count);
	}

	private final void createItemInContainableIfItDoesntExist(ContainableIdType containableId, ItemIdType itemId, ulong count = 0) {
		if( (TupleOfContainableItemIds(containableId, itemId) in stackedItemInfoByContainableAndItemIdCached) ) {
			return;
		}

		StackedItemInfo *createdStackedItemInfo = new StackedItemInfo;
		createdStackedItemInfo.containableId = containableId;
		createdStackedItemInfo.itemId = itemId;
		createdStackedItemInfo.count = count;
		stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)] = createdStackedItemInfo;
	}

	private final void addItemsToContainable(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		enforce(TupleOfContainableItemIds(containableId, itemId) in stackedItemInfoByContainableAndItemIdCached, "item has to exist already in containable");

		stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)].count += count;
	}

	private final void removeItemsFromContainable(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		assert(TupleOfContainableItemIds(containableId, itemId) in stackedItemInfoByContainableAndItemIdCached);
		enforce(stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)].count >= count);

		stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)].count -= count;
	}

	private final void checkContainableForEmptyTypesAndRemoveEmptyByItemId(ContainableIdType containableId, ItemIdType itemId) {
		assert(TupleOfContainableItemIds(containableId, itemId) in stackedItemInfoByContainableAndItemIdCached);
		if( stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)].count == 0 ) {
			// remove
			{ // from array
				bool found = false;

				StackedItemInfo* stackedItemInfoToRemove = stackedItemInfoByContainableAndItemIdCached[TupleOfContainableItemIds(containableId, itemId)];
				// TODO< linear search -> speed this up >
				foreach( i, iStackedItem; stackedItems ) {
					if( iStackedItem is stackedItemInfoToRemove ) {
						stackedItems = stackedItems.remove(i);
						found = true;
						break;
					}
				}
				assert(found);

			}
			
			// from dictionary
			{
				stackedItemInfoByContainableAndItemIdCached.remove(TupleOfContainableItemIds(containableId, itemId));
			}
		}
	}

	private StackedItemInfo*[] stackedItems;
	private StackedItemInfo*[TupleOfContainableItemIds] stackedItemInfoByContainableAndItemIdCached;

	private ContainableInfo*[] containables;
	private ContainableInfo*[][CharacterIdType] containablesByOwnerCached;
	private ContainableInfo*[ContainableIdType] containableByIdCached;

	private alias Tuple!(ContainableIdType, ItemIdType) TupleOfContainableItemIds;
	
}

