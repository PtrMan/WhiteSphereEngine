import std.stdio : writeln;
 
import std.stdio;
import std.algorithm : sort;
 
// query inspired by articles of the AI of AI WAR

struct Row(E...) {
   this(E Content) {
      this.Content = Content;
   }
 
   E Content;
}
 
class Query(E...) {
   public Row!(E) []Result;
 
   final public void addElement(E args) {
      Result ~= Row!(E)(args);
   }
 
 
   final public Query!(E) where(bool delegate(ref Row!(E)) FilterFunction) {
      Query!(E) ResultQuery;
 
      ResultQuery = new Query!(E)();
 
      Row!(E) []OutputResult;
 
      foreach (Element; this.Result) {
         if( FilterFunction(Element) ) {
            OutputResult ~= Element;
         }
      }
 
      ResultQuery.Result = OutputResult;
 
      return ResultQuery;
   }
 
   final public Query!(E) whereMany(bool delegate(ref Row!(E)) []FilterFunctions) {
      Query!(E) ResultQuery;
 
      ResultQuery = new Query!(E)();
 
      Row!(E) []OutputResult;
 
      foreach( Element; this.Result ) {
         bool Accept;
 
         Accept = true;
 
         foreach( CurrentFilterFunction; FilterFunctions ) {
            if( !CurrentFilterFunction(Element) ) {
               Accept = false;
               break;
            }
         }
 
         if( Accept ) {
            OutputResult ~= Element;
         }
      }
 
      ResultQuery.Result = OutputResult;
 
      return ResultQuery;
   }
 
   final public uint count() {
      return this.Result.length;
   }
 
   final public void foreach_(void delegate(ref Row!(E)) IterationDelegate) {
      foreach( IterationI; 0..this.Result.length ) {
         IterationDelegate(this.Result[IterationI]);
      }
   }
 
   /*
    final public Query!(Type) sortBy() {
        sort!("a.A < b.A")(this.Result);
 
        return this;
    }
    */
}
 
void main()
{
   Query!(bool, float) ax = new Query!(bool, float)();
 
   //ax.get0();
   ax.addElement(false, 5.0f);
   ax.addElement(false, 8.0f);
 
   float Z = 6.0f;
 
   void foreachFunction(ref Row!(bool, float) Z) {
      Z.Content[0] = Z.Content[1] < 6.0f;
   }
 
   ax.foreach_(&foreachFunction);
 
   bool filterFunction0(ref Row!(bool, float) Input) {
      return Input.Content[0];
   }
 
   writeln(ax.where(&filterFunction0).count());
 
}
