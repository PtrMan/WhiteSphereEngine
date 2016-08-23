module Server.Ai.BehaviorTree.TurretEntityContext;

import Server.Ai.BehaviorTree.EntityContext;
import Server.TurretCollection;
import Server.ShipCollection;
import Server.Components.PhysicsComponent;
import Server.Components.ControllerComponent;
import Server.Helper.TypeIdObject;
import Server.GameObjects.Ship;

class TurretEntityContext : EntityContext
{
   public TurretCollection Turrets;
   public ShipCollection Ships;
   public ControllerComponent Controller;
   public uint ControlledTurretId;

   this()
   {
      super("turret");
   }

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
