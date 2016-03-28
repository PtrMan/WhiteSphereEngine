import std.stdio;

struct EnqueueDequeuePolicy;

mixin template QueueStrategy(Type, PolicyQueueStrategy : EnqueueDequeuePolicy)
{
   public final void enqueue(Type Element, out bool Success)
   {
      this.storageEnqueue(Element, Success);
   }

   public final Type dequeue(out bool Success)
   {
      return this.storageDequeue(Success);
   }

   final public bool isEmpty()
   {
      return this.storageIsEmpty();
   }

   final public bool isNotEmpty()
   {
      return !this.isEmpty();
   }
}

import std.algorithm : remove;

struct DynamicArrayStoreStrategy;

mixin template ListStoreStrategy(Type, PolicyListStoreStrategy : DynamicArrayStoreStrategy, bool IteratorEnabled)
{
   protected final void storageEnqueue(Type Element, out bool Success)
   {
      Success = true;

      Data ~= Element;
   }

   protected final Type storageDequeue(out bool Success)
   {
      Type Result;

      Success = false;

      if( this.Data.length == 0 )
      {
         return Type.init;
      }

      Result = this.Data[0];
      this.Data = remove(this.Data, 0);

      Success = true;

      return Result;
   }

   protected final void deleteAll()
   {
      this.Data.length = 0;
   }

   final protected bool storageIsEmpty()
   {
      return this.Data.length == 0;
   }

   private Type[] Data;

   private alias typeof(this) OuterThisType;

   static if(IteratorEnabled)
   {
      final public Test0 getIterator()
      {
         return Test0(this);
      }

      private struct Test0
      {
         public this(OuterThisType Storage)
         {
            this.Storage = Storage;
         }

         public final @property bool empty() const
         {
            return this.CurrentIndex >= this.Storage.Data.length;
         }

         public final @property ref Type front()
         {
            return this.Storage.Data[this.CurrentIndex];
         }

         public final void popFront()
         {
            this.CurrentIndex++;
         }

         private OuterThisType Storage;
         private size_t CurrentIndex = 0;
      }
   }
}

struct FlushableStrategy;
struct UnflushableStrategy;

mixin template FlushStrategy(PolicyFlushStrategy : FlushableStrategy)
{
   public final void flush()
   {
      this.Storage.deleteAll();
   }
}

/*
mixin template AccessStrategy(PolicyAccessStrategy : )
{
   final public @property bool empty() const
   {
      return this.Storage.isEmpty();
   }


}
*/

template Queue(Type, PolicyQueueStrategy, PolicyListStoreStrategy, bool IteratorEnabled, PolicyFlushStrategy)
{
   class Queue
   {
      mixin ListStoreStrategy!(Type, PolicyListStoreStrategy, IteratorEnabled) Storage;
      mixin QueueStrategy!(Type, PolicyQueueStrategy);
      mixin FlushStrategy!(PolicyFlushStrategy);
   }
}

/*
class PredicateWithBitfieldIndex
{
   this(string Predicate, uint BitfieldIndex)
   {
      this.Predicate = Predicate;
      this.BitfieldIndex = BitfieldIndex;
   }

   public string Predicate;
   public uint BitfieldIndex;
}
*/

template StripsState(uint PredicateBitfieldSize, uint NumbersCount)
{
   struct StripsState
   {
      public bool[PredicateBitfieldSize] PredicateBitfield;
      public int[NumbersCount] Numbers;
   }
}

template StripsTreeNode(uint PredicateBitfieldSize, uint NumbersCount)
{
   class StripsTreeNode
   {
      public uint DoneActionIndex;
      public StripsTreeNode!(PredicateBitfieldSize, NumbersCount) Parent;

      public StripsState!(PredicateBitfieldSize, NumbersCount) StateAfterAction;
      public bool NoPossibleActions = false;
      public uint Depth;
      public int[] Variables; // the variables for the action

      public StripsTreeNode!(PredicateBitfieldSize, NumbersCount)[] Childrens;

      public this(StripsTreeNode!(PredicateBitfieldSize, NumbersCount) Parent, uint Depth)
      {
         this.Parent = Parent;
         this.Depth = Depth;
      }
   }
}
/** \brief all classes which inherit from this interface implement a Action for the STRIPS solver
 *
 */
template StripsAction(uint PredicateBitfieldSize, uint NumbersCount)
{
   interface StripsAction
   {
      /** \brief returns true if all Post conditions of this action do apply
       *
       * \param PostState is the state after the action would be applied
       * \return ...
       */
      public bool doesPostConditionsMatch(StripsState!(PredicateBitfieldSize, NumbersCount) PostState);

      /** \brief returns if the action needs/calculates variables
       *
       * \return ...
       */
      public bool hasVariable();

      /** \brief returns the possible variables for this poststate
       *
       * call to this is only valid if this.hasVariable() returns true
       *
       * \param PostState ...
       * \param PossibleVariables
       */
      public void getVariablesForPostCondition(StripsState!(PredicateBitfieldSize, NumbersCount) PostState, ref int[] PossibleVariables);

      /** \brief does do the action (in reverse) on the PostState with a variable
       *
       * Success is false if the action doesn't have a variable
       *
       * \param PostState is the state after the action would be applied
       * \param Success ...
       * \return the state after applying the reversed action (the pre condition) with the variable
       */
      public StripsState!(PredicateBitfieldSize, NumbersCount) doActionReverseWithVariable(StripsState!(PredicateBitfieldSize, NumbersCount) PostState, int Variable, out bool Success);

      /** \brief does do the action (in reverse) on the PostState
       *
       * Success is false if the action does have a variable
       *
       * \param PostState is the state after the action would be applied
       * \param Success ...
       * \return the state after applying the reversed action (the pre condition)
       */
      public StripsState!(PredicateBitfieldSize, NumbersCount) doActionReverseWithoutVariable(StripsState!(PredicateBitfieldSize, NumbersCount) PostState, out bool Success);

      /** \brief ...
       *
       * \return ...
       */
      public string getName();
   }
}

/*
class Action1 : StripsAction!(2)
{
   // allready documentated
   public bool doesPostConditionsMatch(StripsState!(2) PostState)
   {
      writeln(PostState.PredicateBitfield);

      return !PostState.PredicateBitfield[0] && PostState.PredicateBitfield[1];
   }

   // allready documentated
   public StripsState!(2) doActionReverse(StripsState!(2) PostState)
   {
      StripsState!(2) Result;

      Result.PredicateBitfield[0] = true;
      Result.PredicateBitfield[1] = false;

      return Result;
   }
}
*/

// Bitfield meaning:
// 0 : have bananas
// 1 : level high
// 
// Numbers meaning:
// 0 : BananasAt
// 1 : Location (At)
// 2 : BoxAt

class ActionTakeBananas : StripsAction!(2, 3)
{
   public bool doesPostConditionsMatch(StripsState!(2, 3) PostState)
   {
      bool Result;

      Result = true;

      Result = Result && PostState.PredicateBitfield[0]; // have bananas
      Result = Result && (PostState.Numbers[0] == PostState.Numbers[1]); // bananasAt == At
      Result = Result && PostState.PredicateBitfield[1]; // level is high

      return Result;
   }
   
   public bool hasVariable()
   {
      return true;
   }

   public void getVariablesForPostCondition(StripsState!(2, 3) PostState, ref int[] PossibleVariables)
   {
      PossibleVariables = [PostState.Numbers[0]];
   }

   public StripsState!(2, 3) doActionReverseWithVariable(StripsState!(2, 3) PostState, int Variable, out bool Success)
   {
      int Location;
      StripsState!(2, 3) Result;

      Success = true;

      // TODO< copy operation >
      Result = PostState;

      Location = Variable;

      Result.PredicateBitfield[0] = false; // don't have the bananas before
      Result.PredicateBitfield[1] = true; // level before is high

      Result.Numbers[0] = Location;
      Result.Numbers[1] = Location;

      return Result;
   }

   public StripsState!(2, 3) doActionReverseWithoutVariable(StripsState!(2, 3) PostState, out bool Success)
   {
      Success = false;

      return PostState;
   }

   public string getName()
   {
      return "TakeBananas";
   }
}

class ActionMoveBox : StripsAction!(2, 3)
{
   public bool doesPostConditionsMatch(StripsState!(2, 3) PostState)
   {
      // BoxAt(Y) != At(Y) and level is low
      return (PostState.Numbers[1] == PostState.Numbers[2]) && !PostState.PredicateBitfield[1];
   }

   public bool hasVariable()
   {
      return true;
   }

   public void getVariablesForPostCondition(StripsState!(2, 3) PostState, ref int[] PossibleVariables)
   {
      // all possible variables are the positions except the old position
      foreach( i; 0..4 )
      {
         if( i != PostState.Numbers[1] )
         {
            PossibleVariables ~= i;
         }
      }
   }

   public StripsState!(2, 3) doActionReverseWithVariable(StripsState!(2, 3) PostState, int Variable, out bool Success)
   {
      StripsState!(2, 3) Result;
      int Location;

      Success = true;

      Location = Variable;

      // TODO< copy operation >
      Result = PostState;

      Result.Numbers[1] = Location;
      Result.Numbers[2] = Location;

      Result.PredicateBitfield[1] = false; // level=low

      return Result;
   }

   public StripsState!(2, 3) doActionReverseWithoutVariable(StripsState!(2, 3) PostState, out bool Success)
   {
      Success = false;

      return PostState;
   }

   public string getName()
   {
      return "MoveBox";
   }
}

class ActionClimbDown : StripsAction!(2, 3)
{
   public bool doesPostConditionsMatch(StripsState!(2, 3) PostState)
   {
      // return true if level is low and at == boxAt
      return !PostState.PredicateBitfield[1] && PostState.Numbers[1] == PostState.Numbers[2];
   }

   public bool hasVariable()
   {
      return true;
   }

   public void getVariablesForPostCondition(StripsState!(2, 3) PostState, ref int[] PossibleVariables)
   {
      PossibleVariables = [PostState.Numbers[2]];
   }

   public StripsState!(2, 3) doActionReverseWithVariable(StripsState!(2, 3) PostState, int Variable, out bool Success)
   {
      StripsState!(2, 3) Result;
      int Location;

      Success = true;

      Location = Variable;

      // TODO< copy operation >
      Result = PostState;

      // can be optimized away
      Result.Numbers[1] = Location;
      Result.Numbers[2] = Location;

      Result.PredicateBitfield[1] = true;

      return Result;
   }

   public StripsState!(2, 3) doActionReverseWithoutVariable(StripsState!(2, 3) PostState, out bool Success)
   {
      Success = false;

      return PostState;
   }

   public string getName()
   {
      return "ClimbDown";
   }
}

class ActionClimbUp : StripsAction!(2, 3)
{
   public bool doesPostConditionsMatch(StripsState!(2, 3) PostState)
   {
      // return true if level is high and at == boxAt
      return PostState.PredicateBitfield[1] && PostState.Numbers[1] == PostState.Numbers[2];
   }

   public bool hasVariable()
   {
      return true;
   }

   public void getVariablesForPostCondition(StripsState!(2, 3) PostState, ref int[] PossibleVariables)
   {
      PossibleVariables = [PostState.Numbers[2]];
   }

   public StripsState!(2, 3) doActionReverseWithVariable(StripsState!(2, 3) PostState, int Variable, out bool Success)
   {

      StripsState!(2, 3) Result;
      int Location;

      Success = true;

      Location = Variable;

      // TODO< copy operation >
      Result = PostState;

      // can be optimized away
      Result.Numbers[1] = Location;
      Result.Numbers[2] = Location;

      Result.PredicateBitfield[1] = false;

      return Result;
   }

   public StripsState!(2, 3) doActionReverseWithoutVariable(StripsState!(2, 3) PostState, out bool Success)
   {
      Success = false;

      return PostState;
   }

   public string getName()
   {
      return "ClimbUp";
   }
}

class ActionMove : StripsAction!(2, 3)
{
   public bool doesPostConditionsMatch(StripsState!(2, 3) PostState)
   {
      // return true if the level is low
      return !PostState.PredicateBitfield[1];
   }

   public bool hasVariable()
   {
      return true;
   }

   public void getVariablesForPostCondition(StripsState!(2, 3) PostState, ref int[] PossibleVariables)
   {
      foreach( PossiblePosition; 0..4 )
      {
         int Distance = PossiblePosition - PostState.Numbers[1];

         if( Distance < 0 )
         {
            Distance *= -1;
         }

         if( Distance != 0 )
         {
            PossibleVariables ~= PossiblePosition;
         }
      }
   }

   public StripsState!(2, 3) doActionReverseWithVariable(StripsState!(2, 3) PostState, int Variable, out bool Success)
   {
      StripsState!(2, 3) Result;

      Success = true;

      Result = PostState;
      Result.Numbers[1] = Variable;

      return Result;
   }

   public StripsState!(2, 3) doActionReverseWithoutVariable(StripsState!(2, 3) PostState, out bool Success)
   {
      Success = false;

      return PostState;
   }

   public string getName()
   {
      return "Move";
   }
}


interface InitialChecker(size_t PredicateBitfieldSize, size_t NumbersCount)
{
   public bool isSimilarToInitialState(StripsState!(PredicateBitfieldSize, NumbersCount) State, StripsState!(PredicateBitfieldSize, NumbersCount) InitialState);
}

class MyInitialChecker : InitialChecker!(2, 3)
{
   public bool isSimilarToInitialState(StripsState!(2, 3) State, StripsState!(2, 3) InitialState)
   {
      bool Result;

      Result = true;

      Result = Result && (State.Numbers[0] == InitialState.Numbers[0]);
      Result = Result && (State.Numbers[1] == InitialState.Numbers[1]);
      Result = Result && (State.Numbers[2] == InitialState.Numbers[2]);

      Result = Result && (State.PredicateBitfield[0] == InitialState.PredicateBitfield[0]);
      Result = Result && (State.PredicateBitfield[1] == InitialState.PredicateBitfield[1]);

      return Result;
   }
}

class DoneAction
{
   this(uint ActionNumber, int[] ActionVariables)
   {
      this.ActionNumber = ActionNumber;
      this.ActionVariables = ActionVariables;
   }

   public uint ActionNumber;
   public int[] ActionVariables;
}

import std.algorithm : reverse;

import std.stdio : writeln;

/*
 *
 * the state of the world is composed out of
 * - predicates
 *   are implemented as a bitfield because it speeds up the algorithm extremly
 */
template StripsSolver(size_t PredicateBitfieldSize, size_t NumbersCount)
{
   class StripsSolver
   {
      public enum EnumResult
      {
         INTERNALERROR,
         NOSOLUTIONFOUND,
         OUTOFMEMORY,
         SOLUTIONFOUND,
         FAULTYACTION,    // a action is malformed
         SEARCHING
      }

      // call example ["Level(high)", "Level(low)"]
      // this is not used at runtime!
      
      /*
      static final public PredicateWithBitfieldIndex[] compiling_ConvertPredicatesToBifieldIndices(string []Predicates)
      {
         PredicateWithBitfieldIndex[] Result;
         uint BitfieldIndex;

         BitfieldIndex = 0;

         foreach( CurrentPredicate; Predicates )
         {
            Result ~= new PredicateWithBitfieldIndex(CurrentPredicate, BitfieldIndex);

            BitfieldIndex++;
         }

         return Result;
      }
      */

      public this()
      {
         this.TopmostSolverNodes = new TopmostQueueType();
      }

      final public void configure(uint MaxDepth, InitialChecker!(PredicateBitfieldSize, NumbersCount) OfInitialChecker)
      in
      {
         assert(MaxDepth > 0);
         assert(OfInitialChecker !is null);
      }
      body
      {
         this.MaxDepth = MaxDepth;

         this.OfInitialChecker = OfInitialChecker;
      }

      /** \brief ...
       *
       */
      final public void debugTree()
      {
         foreach( CurrentChild; this.SolverTree.Childrens )
         {
            this.debugTreeRecursive(CurrentChild, 0);
         }
      }

      /**
       * method
       */
      final private void debugTreeRecursive(StripsTreeNode!(PredicateBitfieldSize, NumbersCount) Node, uint Depth) 
      {
         string Space;

         foreach( i; 0..Depth )
         {
            Space ~= "  ";
         }

         writeln(Space, "Action:", this.Actions[Node.DoneActionIndex].getName());
         writeln(Space, "Variables:", Node.Variables);
         
         foreach( CurrentChild; Node.Childrens )
         {
            this.debugTreeRecursive(CurrentChild, Depth + 1);
         }
      }

      /** \brief ...
       *
       * \param Actions all actions which the solver can apply
       */
      final public void setActions(StripsAction!(PredicateBitfieldSize, NumbersCount) []Actions)
      {
         this.Actions = Actions;
      }

      final public void setGoalState(StripsState!(PredicateBitfieldSize, NumbersCount) GoalState)
      {
         this.GoalState = GoalState;

         this.GoalStateValid = true;
      }

      final public void setInitalState(StripsState!(PredicateBitfieldSize, NumbersCount) InitialState)
      {
         this.InitialState = InitialState;

         this.InitialStateValid = true;
      }

      final public void restart(out bool Success)
      {
         bool CalleeSuccess;

         Success = false;

         if( !this.InitialStateValid )
         {
            return;
         }

         this.FoundSolution = false;
         this.SolutionActionSequence.length = 0;

         this.SolverTree = new TreeNodeType(null, 0);

         this.TopmostSolverNodes.flush();
         this.TopmostSolverNodes.enqueue(this.SolverTree, CalleeSuccess);
         if( !CalleeSuccess )
         {
            return;
         }


         // TODO< generic equal operation >
         this.SolverTree.StateAfterAction = this.GoalState;
         this.SolverTree.Depth = 0;

         Success = true;
      }

      /** \brief returns the sequence of the actions for the solution
       *
       * does assert if no solution was found and this is non the less called
       *
       * \return ...
       */
      final public DoneAction[] getSolution()
      {
         assert(this.FoundSolution);

         return this.SolutionActionSequence;
      }

      // TODO< remember the taken actions and the PredicateBitfield in a tree >
      final public void think(out bool Success, out EnumResult Result, uint Iterations = uint.max)
      {
         Success = false;

         assert( this.SolverTree !is null );

         if( !this.InitialStateValid )
         {
            return;
         }

         if( !this.GoalStateValid )
         {
            return;
         }

         foreach( CurrentIteration; 0..Iterations )
         {
            this.doOneIteration(Result);

            if( Result == EnumResult.SOLUTIONFOUND )
            {
               break;
            }
            else if( Result == EnumResult.SEARCHING )
            {
               writeln("seaching...");
            }
            else
            {
               writeln("errorous");
               return;
            }
         }

         Success = true;
      }

      /** \brief ...
       *
       */
      final private void doOneIteration(out EnumResult Result)
      {
         bool CalleeSuccess;

         if( this.doesntExistAnySolution() )
         {
            Result = EnumResult.NOSOLUTIONFOUND;
            return;
         }

         if( this.isDepthOfAllPossibleSolutionsGreaterThan(this.MaxDepth) )
         {
            Result = EnumResult.NOSOLUTIONFOUND;
            return;
         }

         // get the next topmost Node we have to check

         StripsTreeNode!(PredicateBitfieldSize, NumbersCount) CurrentNode;

         CurrentNode = this.TopmostSolverNodes.dequeue(CalleeSuccess);
         if( !CalleeSuccess )
         {
            Result = EnumResult.INTERNALERROR;
            return;
         }

         // search for all possible actions, apply them and store the childs into the tree
         // and append it to the TopmostSolverNodes

         bool WasAnyActionApplied;

         WasAnyActionApplied = false;

         // TODO< if this is a memory block move this outside as a member >
         // NOTE< this is outside because it will be maybe much more faster if this is a not GC'ed array >
         // containts all possible variables for the matching of the post condition
         int[] PossibleVariables;

         foreach( ActionIndex; 0..this.Actions.length )
         {
            StripsAction!(PredicateBitfieldSize, NumbersCount) CurrentAction;

            CurrentAction = this.Actions[ActionIndex];

            if( CurrentAction.doesPostConditionsMatch(CurrentNode.StateAfterAction) )
            {
               StripsState!(PredicateBitfieldSize, NumbersCount) StateAfterAction;
               StripsTreeNode!(PredicateBitfieldSize, NumbersCount) NodeForPreAction;
               bool IsSimilarToInitialState;

               if( CurrentAction.hasVariable() )
               {
                  PossibleVariables.length = 0;

                  // saves data into PossibleVariables
                  CurrentAction.getVariablesForPostCondition(CurrentNode.StateAfterAction, PossibleVariables);
               }

               WasAnyActionApplied = true;


               if( CurrentAction.hasVariable() )
               {
                  foreach( CurrentVariable; PossibleVariables )
                  {
                     CalleeSuccess = false;

                     StateAfterAction = CurrentAction.doActionReverseWithVariable(CurrentNode.StateAfterAction, CurrentVariable, CalleeSuccess);

                     if( !CalleeSuccess )
                     {
                        Result = EnumResult.FAULTYACTION;
                        return;
                     }

                     NodeForPreAction = new StripsTreeNode!(PredicateBitfieldSize, NumbersCount)(CurrentNode, CurrentNode.Depth + 1);
                     NodeForPreAction.DoneActionIndex = ActionIndex;

                     // TODO< equal operation >
                     NodeForPreAction.StateAfterAction = StateAfterAction;

                     NodeForPreAction.Variables = [CurrentVariable];
                     
                     // add to tree
                     CurrentNode.Childrens ~= NodeForPreAction;

                     IsSimilarToInitialState = this.OfInitialChecker.isSimilarToInitialState(StateAfterAction, this.InitialState);
                     if( IsSimilarToInitialState )
                     {
                        this.setSolution(NodeForPreAction);

                        Result = EnumResult.SOLUTIONFOUND;
                        return;
                     }

                     this.TopmostSolverNodes.enqueue(NodeForPreAction, CalleeSuccess);
                     if( !CalleeSuccess )
                     {
                        Result = EnumResult.OUTOFMEMORY;
                        return;
                     }
                  }
               }
               else
               {
                  StateAfterAction = CurrentAction.doActionReverseWithoutVariable(CurrentNode.StateAfterAction, CalleeSuccess);

                  if( !CalleeSuccess )
                  {
                     Result = EnumResult.FAULTYACTION;
                     return;
                  }

                  NodeForPreAction = new StripsTreeNode!(PredicateBitfieldSize, NumbersCount)(CurrentNode, CurrentNode.Depth + 1);
                  NodeForPreAction.DoneActionIndex = ActionIndex;

                  // TODO< equal operation >
                  NodeForPreAction.StateAfterAction = StateAfterAction;

                  // add to tree
                  CurrentNode.Childrens ~= NodeForPreAction;

                  IsSimilarToInitialState = this.OfInitialChecker.isSimilarToInitialState(StateAfterAction, this.InitialState);
                  if( IsSimilarToInitialState )
                  {
                     this.setSolution(NodeForPreAction);

                     Result = EnumResult.SOLUTIONFOUND;
                     return;
                  }

                  this.TopmostSolverNodes.enqueue(NodeForPreAction, CalleeSuccess);
                  if( !CalleeSuccess )
                  {
                     Result = EnumResult.OUTOFMEMORY;
                     return;
                  }
               }
            }
         }

         if( !WasAnyActionApplied )
         {
            //writeln("no action was applied");

            CurrentNode.NoPossibleActions = true;
         }

         Result = EnumResult.SEARCHING;
      }

      /** \brief checks if no possible solution exists
       *
       * \return ...
       */
      final private bool doesntExistAnySolution()
      {
         return this.TopmostSolverNodes.isEmpty();
      }

      /** \brief checks if the maximal depth of each node is greater than the max depth
       *
       * \param MaxDepth ...
       * \return ...
       */
      final private bool isDepthOfAllPossibleSolutionsGreaterThan(uint MaxDepth)
      {
         foreach( CurrentNode; this.TopmostSolverNodes.getIterator() )
         {
            if( CurrentNode.Depth < MaxDepth )
            {
               return false;
            }
         }

         return true;
      }

      /** \brief sets the solution to the (reversed) action sequence to this node
       *
       * \param Node ...
       */
      final private void setSolution(TreeNodeType Node)
      {
         DoneAction[] ActionSequence;
         
         ActionSequence = this.getReversedActionSequenceFromNode(Node);

         reverse(ActionSequence);

         this.FoundSolution = true;
         this.SolutionActionSequence = ActionSequence;
      }

      final private DoneAction[] getReversedActionSequenceFromNode(TreeNodeType Node)
      {
         TreeNodeType IterationNode;
         DoneAction[] ActionSequence;

         IterationNode = Node;

         for(;;)
         {
            uint VariablesCount;

            assert(IterationNode !is null);

            if( Node is this.SolverTree )
            {
               break;
            }

            // NOTE< we need to rewrite the api that it returns the number of parameters >
            VariablesCount = 0;

            if( this.Actions[Node.DoneActionIndex].hasVariable() )
            {
               VariablesCount = 1;
            }

            ActionSequence ~= new DoneAction(Node.DoneActionIndex, Node.Variables);

            Node = Node.Parent;
         }

         return ActionSequence;
      }

      // Type aliases
      private alias StripsTreeNode!(PredicateBitfieldSize, NumbersCount) TreeNodeType;
      private alias Queue!(TreeNodeType, EnqueueDequeuePolicy, DynamicArrayStoreStrategy, true, FlushableStrategy) TopmostQueueType;

      private StripsAction!(PredicateBitfieldSize, NumbersCount)[] Actions;

      private StripsState!(PredicateBitfieldSize, NumbersCount) GoalState;
      private bool GoalStateValid = false;

      private StripsState!(PredicateBitfieldSize, NumbersCount) InitialState;
      private bool InitialStateValid = false;

      private TreeNodeType SolverTree;

      private TopmostQueueType TopmostSolverNodes;

      private uint MaxDepth;

      private InitialChecker!(PredicateBitfieldSize, NumbersCount) OfInitialChecker;

      private bool FoundSolution = false;
      private DoneAction[] SolutionActionSequence;
   }
}

int main() {
   StripsSolver!(2, 3) OfSolver;
   StripsState!(2, 3) GoalState;
   StripsState!(2, 3) InitialState;
   bool CalleeSuccess;

   OfSolver = new StripsSolver!(2, 3)();

   StripsAction!(2, 3)[] Actions;

   Actions ~= new ActionMove();
   Actions ~= new ActionClimbDown();
   Actions ~= new ActionClimbUp();
   Actions ~= new ActionMoveBox();
   Actions ~= new ActionTakeBananas();

   OfSolver.setActions(Actions);

   GoalState.PredicateBitfield = [true, false]; // wished final state
   InitialState.PredicateBitfield = [false, false]; // state now

   GoalState.Numbers = [2, 2, 2];
   InitialState.Numbers = [2, 0, 1];

   OfSolver.setGoalState(GoalState);
   OfSolver.setInitalState(InitialState);
   OfSolver.configure(9, new MyInitialChecker());

   OfSolver.restart(CalleeSuccess);
   if( !CalleeSuccess )
   {
      // TODO
      return 0;
   }

   StripsSolver!(2, 3).EnumResult OfResult;

   OfSolver.think(CalleeSuccess, OfResult);

   //OfSolver.debugTree();

   if( OfResult == StripsSolver!(2, 3).EnumResult.SOLUTIONFOUND )
   {
      writeln("found solution");

      DoneAction[] ActionSequence = OfSolver.getSolution();

      foreach( Action; ActionSequence )
      {
         writeln("Action:", Actions[Action.ActionNumber].getName());
         writeln("Variables:", Action.ActionVariables);
         writeln("---");
      }
   }
   else
   {
      writeln("found no solution");
   }

   DoneAction[] SolutionSequence;
 
   return 0;
}
