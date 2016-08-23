module Server.Ai.BehaviorTree.TargetDepending;

import Server.Helper.TypeIdObject;

/** \brief everthing which derives from this can get a target (to attack)
 *
 */
interface TargetDepending
{
   /** \brief ...
    *
    * \param Target ...
    */
   public void setTarget(TypeIdObject Target);
}
