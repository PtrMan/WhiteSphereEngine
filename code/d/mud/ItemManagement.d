class Containable {
	ContainableIdType id;
}

// TODO< typedef >
alias ContainableIdType Typedef!ulong;
alias CharacterIdType Typedef!ulong;
alias ItemIdType Typedef!ulong;

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


	// \param asyncTransferNotifier is used to notify the initiator(code) about the progress of the transfer
	final void beginTransferWithCheckAsync(CharacterIdType initiatorCharacterId, ContainableIdType sourceContainableId, ContainableIdType destinationContainableId, ItemIdType itemId, ulong count, ITransfer asyncTransferNotifier, out bool initialCheckSuccess) {
		initialCheckSuccess = false;

		if( !allowedToTransferAsSource(initiatorCharacterId, sourceContainableId) || allowedToTransferAsDestination(initiatorCharacterId, destinationContainableId) ) {
			// TODO< log >
			return;
		}

		// check if containables exist
		if( !(sourceContainableId in containableByIdCached) || !(destinationContainableId in containableByIdCached)) {
			// TODO< log >
			return;
		}

		// check if the requested # of items is available
		assert(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId) in stackedItemInfoByContainableAndItemIdCached);
		if( stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)].count < count ) {
			// TODO< log >
			return;
		}

		initialCheckSuccess = true;

		// async part, which we just do for now syncronously

		asyncTransferNotifier.begin(); // inform that we have begun it

		removeItemsFromContainable(sourceContainableId, itemId, count);
		checkContainableForEmptyTypesAndRemoveEmptyByItemId(sourceContainableId, itemId);
		addItemsToContainableWithCreation(destinationContainableId, itemId, count);

		asyncTransferNotifier.commited();
	}

	private final bool queryIsContainableOwnedBy(ContainableIdType containableId, CharacterIdType queryCharacterId) {
		assert( queryCharacterId in containablesByOwnerCached );
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

	private final void createItemInContainableIfItDoesntExist(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		if( (Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId) in stackedItemInfoByContainableAndItemIdCached) ) {
			return;
		}

		StackedItemInfo createdStackedItemInfo;
		createdStackedItemInfo.containableId = containableId;
		createdStackedItemInfo.itemId = itemId;
		createdStackedItemInfo.count = 0;
		stackedItemInfoByContainableAndItemIdCached[(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)] = createdStackedItemInfo;
	}

	private final void addItemsToContainable(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		ensure(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId) in stackedItemInfoByContainableAndItemIdCached, "item has to exist already in containable");

		stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)].count += count;
	}

	private final void removeItemsFromContainable(ContainableIdType containableId, ItemIdType itemId, ulong count) {
		assert(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId) in stackedItemInfoByContainableAndItemIdCached);
		if( stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)].count < count ) {
			throw new Exception(); // hard error
		}

		stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)].count -= count;
	}

	private final void checkContainableForEmptyTypesAndRemoveEmptyByItemId(ContainableIdType containableId, ItemIdType itemId) {
		assert(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId) in stackedItemInfoByContainableAndItemIdCached);
		if( stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)].count == 0 ) {
			// remove
			{ // from array
				bool found = false;

				StackedItemInfo* stackedItemInfoToRemove = stackedItemInfoByContainableAndItemIdCached[Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId)];
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
				stackedItemInfoByContainableAndItemIdCached.remove(Tuple!((ContainableIdType, ItemIdType))(sourceContainableId, itemId));
			}
		}
	}

	private StackedItemInfo*[] stackedItems;
	private StackedItemInfo*[Tuple!(ContainableIdType, ItemIdType)] stackedItemInfoByContainableAndItemIdCached;

	private ContainableInfo*[] containables;
	private ContainableInfo*[][CharacterIdType] containablesByOwnerCached;
	private ContainableInfo*[ContainableIdType] containableByIdCached;
	
}

