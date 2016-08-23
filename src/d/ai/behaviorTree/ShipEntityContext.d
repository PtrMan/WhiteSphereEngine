module Server.Ai.BehaviorTree.ShipEntityContext;

import Server.Ai.BehaviorTree.EntityContext;
import Server.Components.ControllerComponent;
import Server.Components.PhysicsComponent;
import Server.ShipCollection;
import Server.Helper.TypeIdObject;
import Server.GameObjects.Ship;


/** \brief EntityContext for a Ship that contains all needed data for the Behavior Tree nodes
 *
 */
class ShipEntityContext : EntityContext
{
   this()
   {
      super("ship");
   }

   public ShipCollection Ships;
   public uint ControlledShipId;
   public ControllerComponent Controller;

   // TODO< move this into another class >
   /** \brief tries to returns the Physics Componenent of the Target
    *
    * \param Target ...
    * \return null if it was not found, else the PhysicsComponent
    */
   final public PhysicsComponent getPhysicsOf(TypeIdObject Target)
   {
      if( Target.getType() == TypeIdObject.EnumObjectType.SHIP )
      {
         Ship OfShip;

         OfShip = this.Ships.getById(Target.getId());

         if( OfShip is null )
         {
            return null;
         }

         return OfShip.getPhysicsComponent();
      }

      return null;
   }
}
