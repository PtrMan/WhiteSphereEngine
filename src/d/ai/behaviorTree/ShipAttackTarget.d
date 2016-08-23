module Server.Ai.BehaviorTree.ShipAttackTarget;

import std.math : acos;

import Server.Ai.BehaviorTree.Task;
import Server.Ai.BehaviorTree.TargetDepending;
import Server.Ai.BehaviorTree.ShipEntityContext;
import Server.Ai.BehaviorTree.EntityContext;
import Server.ShooterLinearSolver;
import Server.Components.PhysicsComponent;
import Server.Components.Orientation;

import Server.GameObjects.Ship;

import Server.Helper.TypeIdObject;

import Engine.Common.Vector;
import Engine.Math.Math : degreesToRadiants;

// this lets an ship attack a target
// TODO< any mechanism (behavior) to follow the targetand shoot or some mechanism to realize that >
class ShipAttackTarget : Task, TargetDepending
{
   public Task.EnumReturn run(EntityContext Context, ref string ErrorMessage, ref uint ErrorDepth)
   {
      ShipEntityContext ShipContext;
      Ship OfShip;
      Vector2f ShipPosition, ShipVelocity;
      Vector2f TargetPosition, TargetVelocity;
      Vector2f ShootDirection;
      bool ShootSolutionFound;
      PhysicsComponent TargetPhysics;
      Vector2f AfterRotationShipDirection, ShipRotationDirection;
      float CurrentAngleCos, AfterRotationAngleCos;
      float CurrentAngle, CurrentAngleRadiants;
      float Hittime;
      float ShipRotationInRadiants;
      Vector2f ProjectedTargetPosition;

      if( this.Target.getType() == TypeIdObject.EnumObjectType.NOTHING )
      {
         ErrorMessage = "ShipAttackTarget Behavior: Target is nothing!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      if( Context.getType() != "ship" )
      {
         ErrorMessage = "ShipAttackTarget Behavior: Context doesn't have type \"ship\"!";
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

      TargetPhysics = ShipContext.getPhysicsOf(this.Target);

      if( TargetPhysics is null )
      {
         // if the target doesn't exist anymore we terminate
         return Task.EnumReturn.FINISHED;
      }

      ShipPosition = OfShip.getPhysicsComponent().getPosition();
      ShipVelocity = OfShip.getPhysicsComponent().getEuclidVelocity();

      TargetPosition = TargetPhysics.getPosition();
      TargetVelocity = TargetPhysics.getEuclidVelocity();

      // search for a vector which hits the target

      // TODO< get projectile veolicity (the slowest)
      float ProjectileVeolicity;

      ProjectileVeolicity = 5.0f;

      ShooterLinearSolver.solve(ShipPosition, ShipVelocity, TargetPosition, TargetVelocity, ProjectileVeolicity, Hittime, ShootDirection, ShootSolutionFound, ProjectedTargetPosition);

      if( !ShootSolutionFound )
      {
         // if no solution was found we return the running state
         // NOTE< could be wrong >
         return Task.EnumReturn.RUNNING;
      }

      // TODO< check if the hittime is too large because the target is too far away >
      if( false )
      {
         ShipContext.Controller.setShooting(false);
      }

      // rotate in the direction of the shoot vector and shoot if it is near enougth

      ShipRotationDirection = OfShip.getOrientation().getDirection();
      ShipRotationInRadiants = OfShip.getOrientation().getRotationRad();

      CurrentAngle = ShootDirection.dot(ShipRotationDirection);
      CurrentAngleRadiants = acos(CurrentAngle);

      // if the ship does allready face in the right direction
      if( CurrentAngleRadiants < degreesToRadiants(10.0f) )
      {
         ShipContext.Controller.setShooting(true);
      }
      else
      {
         ShipContext.Controller.setShooting(false);
      }


      // calculate rotation command

      AfterRotationShipDirection = Orientation.getDirectionForRotation(ShipRotationInRadiants + degreesToRadiants(2.0f));
      AfterRotationAngleCos = ShootDirection.normalized().dot(AfterRotationShipDirection);

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
      ShipAttackTarget Clone;

      Clone = new ShipAttackTarget();
      Clone.Target = this.Target; // right?

      return Clone;
   }
}
