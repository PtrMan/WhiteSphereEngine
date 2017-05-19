import NumericSpatialVectors : SpatialVector;

//class AttachmentPoint {
//	public uint sourceIndex;
//}

//class VehicleFrame {
//}

class Anchor {
	public final this(SpatialVector!(3, float) absolutPosition, SpatialVector!(3, float) normalizedDirection) {
		this.absolutPosition = absolutPosition;
		this.normalizedDirection = normalizedDirection;
	}

	public SpatialVector!(3, float) absolutPosition;
	public SpatialVector!(3, float) normalizedDirection;

	// TODO< orientation >	
}

class RecordedSlot {
	public final this(FrameInstance frameInstance) {
		this.frameInstance = frameInstance;
	}

	//public string elementtype;
	
	public FrameInstance frameInstance;
}

class PrototypeWithAnchorAndConfiguration {
	public final this(Anchor anchor) {
		this.anchor = anchor;
	}

	//public IPrototype prototype;    not required because the "blueprint tree" contains this
	public Anchor anchor;
	//public InstatiationConfiguration configuration;   not required because the "blueprint tree" contains this
}

class InstatiationConfiguration {

}


/**
 * Prototypes of Frames which can get Instantiated with a from the outside fed configuration
 */
interface IPrototype {
	// it will be from outside gurantueed that childrenPrototypes is empty
	FrameInstance instantiate(Anchor anchor, InstatiationConfiguration configuration, out PrototypeWithAnchorAndConfiguration[] childrenPrototypes);

	string getTypeName();
}

class FrameInstance {
	// fromPrototype : is the prototype from which it got instantiated, just used to get the typename
	public final this(Anchor anchor, IPrototype fromPrototype) {
		this.protectedAnchor = anchor;
		this.fromPrototype = fromPrototype;
	}

	public final @property Anchor anchor() {
		return protectedAnchor;
	}

	public final @property typeName() {
		return fromPrototype.getTypeName();
	}

	// TODO< configuration? >

	protected Anchor protectedAnchor;
	protected IPrototype fromPrototype;
}






// prototype for the vehicle
class TestVehiclePrototype : IPrototype {
	public final FrameInstance instantiate(Anchor anchor, InstatiationConfiguration configuration, out PrototypeWithAnchorAndConfiguration[] childrenPrototypes) {
		FrameInstance resultInstance = new FrameInstance(anchor, this);

		childrenPrototypes ~= new PrototypeWithAnchorAndConfiguration(new Anchor(new SpatialVector!(3, float)(1.0f, 0.0f, 0.0f), new SpatialVector!(3, float)(1.0f, 0.0f, 0.0f)));
		childrenPrototypes ~= new PrototypeWithAnchorAndConfiguration(new Anchor(new SpatialVector!(3, float)(-1.0f, 0.0f, 0.0f), new SpatialVector!(3, float)(-1.0f, 0.0f, 0.0f)));

		return resultInstance;
	}

	public final string getTypeName() {
		return "testVehicleFrame";
	}
}

// prototype for weapons
class TestWeaponPrototype : IPrototype {
	public final FrameInstance instantiate(Anchor anchor, InstatiationConfiguration configuration, out PrototypeWithAnchorAndConfiguration[] childrenPrototypes) {
		FrameInstance resultInstance = new FrameInstance(anchor, this);
		return resultInstance;
	}

	public final string getTypeName() {
		return "weapon";
	}
}



// used to store the configurations of the to instantiate prototypes
// can be described as a blueprint of the thing to be created
class PrototypeInstantiationTreeElement {
	public string nameOfPrototypeToInstantiate;

	public InstatiationConfiguration instantiationConfiguration; // contains the configuration of the Element which is passed into the prototype

	public PrototypeInstantiationTreeElement[] childrens;
}


// todo: walk configuration tree and instantiate
// check if number of child prototypes equals the number of childrens in th tree
class InstatiationWalkerAndRecorder {
	// all recorded instantiated slots of the design
	public RecordedSlot[] recordedInstantiatedSlots;

	public IPrototype[string] allPrototypesByName;

	public final void walkAndRecordRecursive(Anchor parentAnchor, PrototypeInstantiationTreeElement protoInstantiationTreeElement) {
		// TODO< check if prototype exists in dictionary >
		IPrototype prototypeToInstantiate = allPrototypesByName[protoInstantiationTreeElement.nameOfPrototypeToInstantiate];

		PrototypeWithAnchorAndConfiguration[] childrenPrototypes;
		FrameInstance instatatedFrameInstance = prototypeToInstantiate.instantiate(parentAnchor, protoInstantiationTreeElement.instantiationConfiguration, childrenPrototypes);
		if( childrenPrototypes.length != protoInstantiationTreeElement.childrens.length ) {
			// TODO< throw error >
		}

		recordedInstantiatedSlots ~= new RecordedSlot(instatatedFrameInstance);

		for( uint childrenI = 0; childrenI < childrenPrototypes.length; childrenI++ ) {
			PrototypeInstantiationTreeElement childrenProtoInstantiationTreeElement = protoInstantiationTreeElement.childrens[childrenI];
			PrototypeWithAnchorAndConfiguration childrenPrototypeWithAnchorAndConfiguration = childrenPrototypes[childrenI];

			walkAndRecordRecursive(childrenPrototypeWithAnchorAndConfiguration.anchor, childrenProtoInstantiationTreeElement);
		}
	}
}

// used to retrive the information of a slot configuration
/*
interface ISlotsFrame {
	uint getNumberOfSlots();

	Slot getSlot(uint index);
}*/

/*
class TestVehicleFrame : ISlotsFrame {
	public final uint getNumberOfSlots() {
		return 2;
	}

	public final Slot getSlot(uint index) {
		Slot resultSlot = new Slot("generic");

		if( index == 0 ) {
			resultSlot.absolutPosition = new SpatialVector!(3, float)(1.0f, 0.0f, 0.0f);
			resultSlot.normalizedDirection = new SpatialVector!(3, float)(1.0f, 0.0f, 0.0f);
		}
		else if( index == 1 ) {
			resultSlot.absolutPosition = new SpatialVector!(3, float)(-1.0f, 0.0f, 0.0f);
			resultSlot.normalizedDirection = new SpatialVector!(3, float)(-1.0f, 0.0f, 0.0f);
		}

		return resultSlot;
	}
}
*/

import std.stdio : writeln;

// todo < mathematica test output >
void printMathematicaForAnchor(Anchor anchor) {
	writeln("Line[{{", anchor.absolutPosition.x, ",", anchor.absolutPosition.y, ",", anchor.absolutPosition.z, "},{", (anchor.absolutPosition.x + anchor.normalizedDirection.x), ",", (anchor.absolutPosition.y + anchor.normalizedDirection.y), ",", (anchor.absolutPosition.z + anchor.normalizedDirection.z), "}}],");
}


void main(string[] args) {
	PrototypeInstantiationTreeElement root = new PrototypeInstantiationTreeElement();
	root.nameOfPrototypeToInstantiate = "testVehicleFrame";
	root.childrens ~= new PrototypeInstantiationTreeElement();
	root.childrens ~= new PrototypeInstantiationTreeElement();
	root.childrens[0].nameOfPrototypeToInstantiate = "weapon";
	root.childrens[1].nameOfPrototypeToInstantiate = "weapon";

	InstatiationWalkerAndRecorder instatiationWalkerAndRecorder = new InstatiationWalkerAndRecorder();
	instatiationWalkerAndRecorder.allPrototypesByName["weapon"] = new TestWeaponPrototype();
	instatiationWalkerAndRecorder.allPrototypesByName["testVehicleFrame"] = new TestVehiclePrototype();

	instatiationWalkerAndRecorder.walkAndRecordRecursive(null, root);





	writeln("Graphics3D[{");

	// TODO

	foreach( RecordedSlot iterationRecordedSlot; instatiationWalkerAndRecorder.recordedInstantiatedSlots ) {
		// TODO< lookup or the type in a map and get the color >
		if( iterationRecordedSlot.frameInstance.anchor !is null ) {
			printMathematicaForAnchor(iterationRecordedSlot.frameInstance.anchor);
		}

	}

	writeln("}]");
}
