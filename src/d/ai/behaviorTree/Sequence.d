module Server.Ai.BehaviorTree.Sequence;

import Server.Ai.BehaviorTree.EntityContext;
import Server.Ai.BehaviorTree.Task;

class Sequence : Task
{
   public Task[] Childrens;

   final public void setInfiniteSequence(bool Infinite)
   {
      this.Infinite = Infinite;
   }

   public Task.EnumReturn run(EntityContext Context, ref string ErrorMessage, ref uint ErrorDepth)
   {
      Task.EnumReturn CalleeReturn;

      if( this.Childrens.length == 0 )
      {
         ErrorMessage = "this.Childrens does have a length of 0!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      for(;;)
      {
         if( this.CurrentIndex >= this.Childrens.length )
         {
            this.CurrentIndex = 0;

            if( !this.Infinite )
            {
               return Task.EnumReturn.FINISHED;
            }
         }

         CalleeReturn = this.Childrens[this.CurrentIndex].run(Context, ErrorMessage, ErrorDepth);

         if( CalleeReturn == Task.EnumReturn.FINISHED )
         {
            //return Task.EnumReturn.FINISHED;
         }
         else if( CalleeReturn == Task.EnumReturn.ERROR )
         {
            ErrorDepth++;
            return Task.EnumReturn.ERROR;
         }
         else // Task.EnumReturn.RUNNING
         {
            return Task.EnumReturn.RUNNING;
         }

         this.CurrentIndex++;
      }
   }

   public void reset()
   {
      this.CurrentIndex = 0;

      foreach( Task Children; this.Childrens )
      {
         Children.reset();
      }
   }

   public Task clone()
   {
      Sequence ClonedSequence;

      ClonedSequence = new Sequence();
      ClonedSequence.CurrentIndex = this.CurrentIndex;
      ClonedSequence.Infinite = this.Infinite;

      foreach( Task Children; this.Childrens )
      {
         ClonedSequence.Childrens ~= Children.clone();
      }

      return ClonedSequence;
   }

   private uint CurrentIndex = 0;
   private bool Infinite = false;
}
