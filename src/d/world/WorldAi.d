module world.WorldAi;

// TODO< put this somewhere central >
import std.typecons : Typedef;

alias Typedef!(uint, uint.init, "elementId") ElementIdType;





// general class
class ResearchTreeElement {
	ResearchTreeElement parents[]; // parents which enable it, used by AI to determine research queue
	ResearchTreeElement children[]; // children which get enabled by it
	
	string humanName; // human readable name for the research
	
	// attributes
	double baseResearchTime; // in seconds
	
	// for AI
	bool isPseudo; // if this research is a pseudo research tree element, used only by AI to research for basic goals
}

// for AI
class AiResearchRoot {
	ResearchTreeElement[] researchForExpansion; // points at the research elements for expansion
	ResearchTreeElement[] researchForOffensive; // points at the research elements for offensive
}

class AiActiveResearch {
	final @property bool isCompleted() {
		return expendedBaseTime > researchTreeElement.baseResearchTime;
	}
	
	// multiplier can be either go from human brain power or AGI/ASI expense
	final void doResearch(double multiplier, double deltaT) {
		expendedBaseTime += (multiplier * deltaT);
	}
	
	ResearchTreeElement researchTreeElement;
	double expendedBaseTime; // in seconds
}


import std.typecons : Tuple;

import ai.behaviorTree.Task : BehaviorTreeTask = Task;
import ai.behaviorTree.EntityContext : BehaviorTreeContext = EntityContext;
import ai.query.Query;

// ai of the npc races

class NpcRaceEntityContext : BehaviorTreeContext {
	final this() {
		super("NpcRaceEntityContext");
	}
	
	static const size_t NEEDQUERYTABLEINDEXOFREQUIREMENT = 0;
	static const  size_t MASSINDEX = 1;
	// [ ] : id of the element
	// [ ] : requirement in kg of the element
	alias Tuple!(ElementIdType, "elementId", double, "requirementMass") NeedTableTupleType;
	alias Query!NeedTableTupleType NeedTableQueryType;
	
	NeedTableQueryType needQueryTable = new NeedTableQueryType;
	
	AiActiveResearch[] researchQueue;
	ResearchTreeElement[] alreadyResearched;
}


/**
 * Checks if the current research is done and puts a new research in line if its the case
 *
 *
 */
class NpcRaceCheckUpdateResearchTask : BehaviorTreeTask {
	BehaviorTreeTask.EnumReturn run(BehaviorTreeContext contextParameter, ref string errorMessage, ref uint errorDepth) {
		NpcRaceEntityContext context = cast(NpcRaceEntityContext)contextParameter;
		
		auto sumedQueryTableByRequirement = context.needQueryTable.aggregateSumByColumn!(NpcRaceEntityContext.NEEDQUERYTABLEINDEXOFREQUIREMENT);
		if( sumedQueryTableByRequirement.length == 0 ) { // check if we have nothing to decide to do
			return BehaviorTreeTask.EnumReturn.FINISHED;
		}
		
		NpcRaceEntityContext.NeedTableTupleType topRequirement = sumedQueryTableByRequirement.top!(NpcRaceEntityContext.MASSINDEX);
		// TODO< look if research queue is full, if not, decide the best research based on basic needs and required materials and energy >
		
		// NOTE< maybe we could use fuzzy logic in here to decide what to research >
		
		return BehaviorTreeTask.EnumReturn.RUNNING;
	}
	
	/** \brief resets the variables to its defaults
	 *
	 */
	void reset() {
		
	}
	
	/** \brief is cloning the objeect on which it got called
	 *
	 * \return ...
	 */
	BehaviorTreeTask clone() {
		return new NpcRaceCheckUpdateResearchTask;
	}
}