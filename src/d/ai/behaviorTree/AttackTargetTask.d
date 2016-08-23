module Server.Ai.BehaviorTree.AttackTargetTask;

import Server.Ai.BehaviorTree.Task;
import Server.Helper.TypeIdObject;

/** \brief abstract class, everthing which derives from this is a Attack target task
 *
 */
abstract class AttackTargetTask : Task
{
   /** \brief ...
    *
    * \param Target ...
    */
   final public void setTarget(TypeIdObject Target)
   {
      this.Target = Target;
   }

   protected TypeIdObject Target;
}
