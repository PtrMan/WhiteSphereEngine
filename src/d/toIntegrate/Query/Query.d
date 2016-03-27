
import std.stdio;
import std.algorithm : sort;

// query inspired by articles of the AI of AI WAR

struct Row(E...) {
	this(E content) {
    	this.content = content;
   	}
 
   	E content;
}
 
class Query(E...) {
	public alias Row!(E) RowType;
	
   	public RowType[] result;
   	
   	final public void addElement(E args) {
      	result ~= RowType(args);
   	}
   	
   	final public Query!(E) where(bool delegate(ref RowType) filterFunction) {
      	Query!(E) resultQuery = new Query!(E)();
 
      	RowType[] outputResult;
 
      	foreach( element; this.result ) {
         	if( filterFunction(element) ) {
            	outputResult ~= element;
         	}
      	}
 
      	resultQuery.Result = outputResult;
 
      	return resultQuery;
   	}
 
   	final public Query!(E) whereMany(bool delegate(ref RowType)[] filterFunctions) {
      	Query!(E) resultQuery = new Query!(E)();
 
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
 
   	final public @property uint length() {
      	return this.result.length;
   	}
 
   	final public void apply(void delegate(ref RowType) iterationDelegate) {
      	foreach( iterationI; 0..this.result.length ) {
         	iterationDelegate(this.result[iterationI]);
      	}
   	}
 
   	/*
    final public Query!(Type) sortBy() {
        sort!("a.A < b.A")(this.Result);
 
        return this;
    }
    */
}

import std.stdio : writeln;

 
void main()
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
