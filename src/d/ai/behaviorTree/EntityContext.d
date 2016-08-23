module Server.Ai.BehaviorTree.EntityContext;

/** \brief Class that tells the behavior tree something about the context of usage, contains needed variables
 *
 */
abstract class EntityContext
{
   protected this(string Type)
   {
      this.Type = Type;
   }

   pure final public string getType()
   {
      return this.Type;
   }

   private string Type;
}
