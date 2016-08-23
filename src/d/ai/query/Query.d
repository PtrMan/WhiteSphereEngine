module ai.query.Query;

import std.algorithm : sort;

// query inspired by articles of the AI of AI WAR

struct Row(TupleType) {
	this(TupleType content) {
    	this.content = content;
   	}
 
   	TupleType content;
}

class Query(TupleType) {
	public alias Row!(TupleType) RowType;
	
   	public RowType[] result;
   	
   	final public void addElement(TupleType args) {
      	result ~= RowType(args);
   	}
   	
   	final public Query!(TupleType) where(bool function(ref RowType) filterFunction) {
      	Query!(TupleType) resultQuery = new Query!(TupleType)();
 
      	RowType[] outputResult;
 
      	foreach( element; this.result ) {
         	if( filterFunction(element) ) {
            	outputResult ~= element;
         	}
      	}
 
      	resultQuery.result = outputResult;
 
      	return resultQuery;
   	}
 
   	final public Query!(TupleType) whereMany(bool function(ref RowType)[] filterFunctions) {
      	Query!(TupleType) resultQuery = new Query!(TupleType)();
 
      	RowType[] outputResult;
 
      	foreach( element; this.result ) {
         	bool accept = true;
 
         	foreach( currentFilterFunction; filterFunctions ) {
            	if( !currentFilterFunction(element) ) {
               		accept = false;
               		break;
            	}
         	}
 
         	if( accept ) {
            	outputResult ~= element;
         	}
      	}
 
      	resultQuery.result = outputResult;
      	return resultQuery;
   	}
 
   	final public @property size_t length() {
      	return this.result.length;
   	}
 
   	final public void apply(void delegate(ref RowType) iterationDelegate) {
      	foreach( iterationI; 0..this.result.length ) {
         	iterationDelegate(this.result[iterationI]);
      	}
   	}
 
   	/*
    final public Query!TupleType sortBy() {
        sort!("a.A < b.A")(this.Result);
 
        return this;
    }*/
    
   	
	final Query!TupleType aggregateSumByColumn(size_t columnIndex)() {
		Query!TupleType resultQuery = new Query!TupleType;
		
		void searchInResultQueryAndAddOrAppend(RowType row) {
			foreach( i; 0..resultQuery.length ) {
				if( resultQuery.result[i].content[columnIndex] == row.content[columnIndex]) {
					enum x = TupleType.expand.length;
					
					foreach (columnI, _; row.content) {
						static if( columnI != columnIndex ) {
							// we don't by mallice check if the types are addable, because the programmer is responsible for the correct types, and agregating of nonaddable columns doesnt make any sense
							resultQuery.result[i].content[columnI] += row.content[columnI];
						}
					}
					
					return;
				}
			}
			
			// if we are here it means that we didn't find it, so we just append it
			resultQuery.result ~= row;
		}
		
		foreach( iterationElement; this.result ) {
			searchInResultQueryAndAddOrAppend(iterationElement);
		}
		
		return resultQuery;
	}
	
	final @property TupleType top(size_t columnIndex)() {
		assert(result.length > 0, "Internal error, no top element");
		
		TupleType bestValue = result[0].content;
		
		foreach( iterationElement; result ) {
			if( iterationElement[columnIndex] > iterationElement.content[columnIndex] ) {
				bestValue = iterationElement.content;
			}
		}
		
		return bestValue;
	}
}


import std.stdio : writeln;

 
void main() {
	/*
	{
		Query!(bool, float) ax = new Query!(bool, float)();
	 
	   //ax.get0();
	   ax.addElement(false, 5.0f);
	   ax.addElement(false, 8.0f);
	 
	   float Z = 6.0f;
	 
	   void foreachFunction(ref ax.RowType Z) {
	      Z.Content[0] = Z.Content[1] < 6.0f;
	   }
	 
	   ax.apply(&foreachFunction);
	 
	   bool filterFunction0(ref ax.RowType Input) {
	      return Input.Content[0];
	   }
	 
	   writeln(ax.where(&filterFunction0).length);
	}
	*/
	
	/*
	writeln("TASK 2");
	
	
	
	{
		import std.typecons : Tuple;
		alias Tuple!(int, "type", float, "mass") QueryTupleType;
		
		Query!QueryTupleType ax = new Query!QueryTupleType();
		
		ax.addElement(QueryTupleType(0, 5.0f));
		ax.addElement(QueryTupleType(0, 3.0f));
		ax.addElement(QueryTupleType(1, 2.0f));
		//ax.addElement(0, 8.0f);
		//ax.addElement(1, 2.0f);
		
		Query!QueryTupleType axResult = ax.aggregateSumByColumn!0;
		
		writeln(axResult.result[0].content);
		
	}*/
}

