module world.WorldAi;

// TODO< put this somewhere central >
import std.typecons : Typedef;

alias Typedef!(uint, uint.init, "elementId") ElementIdType;

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
	
	NeedTableQueryType needQueryTable;
}


/**
 * 
 *
 *
 */
class NpcRaceDecideResearchTask : BehaviorTreeTask {
	BehaviorTreeTask.EnumReturn run(BehaviorTreeContext contextParameter, ref string errorMessage, ref uint errorDepth) {
		NpcRaceEntityContext context = cast(NpcRaceEntityContext)contextParameter;
		
		auto sumedQueryTableByRequirement = context.needQueryTable.aggregateSumByColumn!(NpcRaceEntityContext.NEEDQUERYTABLEINDEXOFREQUIREMENT);
		if( sumedQueryTableByRequirement.length == 0 ) { // check if we have nothing to decide to do
			return BehaviorTreeTask.EnumReturn.FINISHED;
		}
		
		NpcRaceEntityContext.NeedTableTupleType topRequirement = sumedQueryTableByRequirement.top!(NpcRaceEntityContext.MASSINDEX);
		// TODO< decide research based on what already was researched >
		
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
		return new NpcRaceDecideResearchTask;
	}
}