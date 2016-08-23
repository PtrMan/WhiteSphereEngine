module Server.Ai.BehaviorTree.ShipFlyToPoint;

import std.stdio : writeln; // for debugging

import std.math : acos;

import Engine.Common.Vector;
import Engine.Math.Math : degreesToRadiants;

import Server.GameObjects.Ship;
import Server.Components.ControllerComponent;
import Server.Components.Orientation;

import Server.Ai.BehaviorTree.Task;
import Server.Ai.BehaviorTree.EntityContext;
import Server.Ai.BehaviorTree.ShipEntityContext;


class ShipFlyToPoint : Task
{
   public Task.EnumReturn run(EntityContext Context, ref string ErrorMessage, ref uint ErrorDepth)
   {
      Vector2f Difference, Direction, ShipPosition, ShipVeolicity;
      Vector2f TargetVeolocity, VeolocityDifference;
      Vector2f AfterRotationShipDirection, ShipRotationDirection;
      ShipEntityContext ShipContext;
      Ship OfShip;
      float Distance;
      float CurrentAngleCos, AfterRotationAngleCos;
      float ShipRotationInRadiants;
      float CurrentAngle, CurrentAngleRadiants;

      if( this.TargetPosition is null )
      {
         ErrorMessage = "ShipFlyToPoint Behavior: TargetPosition is null!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      if( Context.getType() != "ship" )
      {
         ErrorMessage = "ShipFlyToPoint Behavior: Context doesn't have type \"ship\"!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      ShipContext = cast(ShipEntityContext)Context;


      OfShip = ShipContext.Ships.getById(ShipContext.ControlledShipId);

      if( OfShip is null )
      {
         // if the ship doesn't anymore exist we return without error because it happend nothing really bad
         return Task.EnumReturn.FINISHED;
      }

      ShipPosition  = OfShip.getPhysicsComponent().getPosition();
      ShipVeolicity = OfShip.getPhysicsComponent().getEuclidVeolicity();

      // calculate
      Difference = ShipPosition - this.TargetPosition;
      Distance   = Difference.getLength();
      Direction  = Difference.normalized();

      // ASK< limit, scale with a setable value? >
      TargetVeolocity = Difference.scale(-1.0f);

      VeolocityDifference = TargetVeolocity - ShipVeolicity;

      ShipRotationDirection = OfShip.getOrientation().getDirection();
      ShipRotationInRadiants = OfShip.getOrientation().getRotationRad();

      CurrentAngle = VeolocityDifference.normalized().dot(ShipRotationDirection);
      CurrentAngleRadiants = acos(CurrentAngle);

      // if the ship does allready face in the right direction
      if( CurrentAngleRadiants < degreesToRadiants(10.0f) )
      {
         // TODO< check if it does make sense to send a thrust command >

         writeln("thrust");
         ShipContext.Controller.setAcceleration(ControllerComponent.EnumAcceleration.FORWARD); 
      }

      // calculate rotation command

      AfterRotationShipDirection = Orientation.getDirectionForRotation(ShipRotationInRadiants + degreesToRadiants(2.0f));
      AfterRotationAngleCos = VeolocityDifference.normalized().dot(AfterRotationShipDirection);

      // TODO< actual sending of control information >

      // NOTE< the comarisation is in the wrong way because lower angles do have higher values >
      if( AfterRotationAngleCos > CurrentAngle )
      {
         writeln("Rotate p");
         ShipContext.Controller.pressedLeft();
      }
      else
      {
         writeln("Rotate m");
         ShipContext.Controller.pressedRight();
      }

      return Task.EnumReturn.RUNNING; 
   }

   public void reset()
   {
      // nothing
   }

   public Task clone()
   {
      ShipFlyToPoint Clone;

      Clone = new ShipFlyToPoint();
      Clone.TargetPosition = this.TargetPosition; // right?

      return Clone;
   }

   final public void setTargetPosition(Vector2f Position)
   {
      assert(!(Position is null), "Position was null!");

      this.TargetPosition = Position;
   }

   private Vector2f TargetPosition;
}
