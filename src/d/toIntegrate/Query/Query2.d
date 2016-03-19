import std.stdio;
import std.algorithm : sort;
 
class Query(Type)
{
    public Type[] Result;
 
    final public Query!(Type) where(bool delegate(Type x) FilterFunction)
    {
        Query!(Type) ResultQuery;
 
        ResultQuery = new Query!(Type)();
 
        Type []OutputResult;
 
        foreach (Element; this.Result)
        {
            if( FilterFunction(Element) )
            {
                OutputResult ~= Element;
            }
        }
 
        ResultQuery.Result = OutputResult;
 
        return ResultQuery;
    }
 
    final public uint count()
    {
        return this.Result.length;
    }
 
    final public Query!(Type) sortBy()
    {
        sort!("a.A < b.A")(this.Result);
 
        return this;
    }
}
 
int []where(int []Array, bool delegate(int x) FilterFunction)
{
    int []Output;
 
    foreach (Element; Array)
    {
        if( FilterFunction(Element) )
        {
            Output ~= Element;
        }
    }
 
    return Output;
}
 
void main() {
    bool xxx(int Value)
    {
        return Value < 8;
    }
 
    struct TestStruct
    {
        float A;
    }
 
    TestStruct []Structs;
    TestStruct Current;
 
    Current.A = 5.0f;
    Structs ~= Current;
 
 
    //auto XXXX = (int x) => x*x;
 
    //int [] Arr = where([0, 3, 7, 42], &xxx);
 
    //writeln(Arr);
 
    /*
    Query!(int) ResultQuery;
    Query!(int) MyQuery = new Query!(int)();
    MyQuery.Result = [0, 3, 7, 42];
    
    ResultQuery = MyQuery.where(&xxx);
    uint Count = MyQuery.where(&xxx).count();
    
    writeln(ResultQuery.Result);
    writeln(Count);
    */
 
 
 
    Query!(TestStruct) ResultQuery;
    Query!(TestStruct) MyQuery = new Query!(TestStruct)();
    MyQuery.Result = Structs;
 
    writeln(MyQuery.Result.length);
 
    ResultQuery = MyQuery.sortBy();
 
    writeln(ResultQuery.Result);
}