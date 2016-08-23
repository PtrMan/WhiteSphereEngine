module Server.Ai.BehaviorTree.TurretAttackTarget;

import std.math : acos, atan;

import Server.Ai.BehaviorTree.Task;
import Server.Ai.BehaviorTree.TargetDepending;
import Server.Ai.BehaviorTree.ShipEntityContext;
import Server.Ai.BehaviorTree.EntityContext;
import Server.Ai.BehaviorTree.TurretEntityContext;
import Server.ShooterLinearSolver;
import Server.Components.PhysicsComponent;
import Server.Components.Orientation;

import Server.IPhysicsEngine;

import Server.GameObjects.Ship;
import Server.GameObjects.Turret;

import Server.Helper.TypeIdObject;

import Engine.Common.Vector;
import Engine.Common.GameTime;
import Engine.Math.Math : degreesToRadiants, clamp;

// this lets an turret attack a target
class TurretAttackTarget : TargetDepending, Task
{
   this(IPhysicsEngine OfPhysicsEngine)
   {
      this.OfPhysicsEngine = OfPhysicsEngine;
   }

   // no doc
   public Task.EnumReturn run(EntityContext Context, ref string ErrorMessage, ref uint ErrorDepth)
   {
      TurretEntityContext TurretContext;
      Turret OfTurret;
      PhysicsComponent TargetPhysics;
      Vector2f TurretPosition;
      Vector2f TargetPosition, TargetVelocity;
      
      Vector2f ShootDirection;
      float Hittime;
      bool ShootSolutionFound;

      float OtherAxisAngle;
      float CurrentAngle/*, CurrentAngleRadiants*/;

      float TargetCollisionRadius;
      Vector2f ProjectedTargetPosition;
      float TargetDistance;
      Vector2f TurretRotationDirection;

      float MaxAngleDifferenceForHit; /* the maximal angle difference in that we still can hit our target */
      float RotationDelta; /* the rotation delta speed which the turret should execute */

      float CurrentAngleRadiantsNoSign, CurrentAngleRadiantsSign;
      float TurretMaxTurnSpeed;

      if( this.Target.getType() == TypeIdObject.EnumObjectType.NOTHING )
      {
         ErrorMessage = "TurretAttackTarget Behavior: Target is nothing!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      if( Context.getType() != "turret" )
      {
         ErrorMessage = "TurretAttackTarget Behavior: Context doesn't have type \"turret\"!";
         ErrorDepth = 0;
         return Task.EnumReturn.ERROR;
      }

      TurretContext = cast(TurretEntityContext)Context;

      OfTurret = TurretContext.Turrets.getById(TurretContext.ControlledTurretId);

      if( OfTurret is null )
      {
         // if the turret doesn't anymore exist we return without error because it happend nothing really bad
         return Task.EnumReturn.FINISHED;
      }

      // NOTE< this doesn't belong into shipcontext >
      TargetPhysics = TurretContext.getPhysicsOf(this.Target);

      if( TargetPhysics is null )
      {
         // if the target doesn't exist anymore we terminate
         return Task.EnumReturn.FINISHED;
      }

      TurretPosition = OfTurret.getPhysicsComponent().getPosition();
      
      TargetPosition = TargetPhysics.getPosition();
      TargetVelocity = TargetPhysics.getEuclidVelocity();

      // NOTE< should maybe changed if we calculate collisions with the edge shiloute of the object we will shoot at >
      TargetCollisionRadius = TargetPhysics.getRadius();

      // search for a vector which hits the target

      // TODO< get projectile veolicity (the slowest) >
      float ProjectileVeolicity;

      ProjectileVeolicity = 500.0f;

      ShooterLinearSolver.solve(TurretPosition, new Vector2f(0.0f, 0.0f), TargetPosition, TargetVelocity, ProjectileVeolicity, Hittime, ShootDirection, ShootSolutionFound, ProjectedTargetPosition);

      if( !ShootSolutionFound )
      {
         // if no solution was found we return the running state
         // NOTE< could be wrong >
         return Task.EnumReturn.RUNNING;
      }

      // TODO< check if the hittime is too large because the target is too far away >
      if( false )
      {
         TurretContext.Controller.setShooting(false);
      }

      // rotate in the direction of the shoot vector and shoot if it is near enougth

      TurretRotationDirection = OfTurret.getOrientation.getDirection();

      CurrentAngle = TurretRotationDirection.dot(ShootDirection);

      // NOTE< this is needed >
      if( CurrentAngle >= 1.0f )
      {
         CurrentAngleRadiantsSign = CurrentAngleRadiantsNoSign = 0.0f;
      }
      else
      {
         CurrentAngleRadiantsSign = CurrentAngleRadiantsNoSign = acos(CurrentAngle);
      }
      
      OtherAxisAngle = TurretRotationDirection.flip90Degree().dot(ShootDirection);

      // NOTE< sign is right >
      if( OtherAxisAngle < 0.0f )
      {
         CurrentAngleRadiantsSign *= -1.0f;
      }

      // check if we would hit the target if we would shoot...

      // check if the angle is ok and if the projectile will hit the target

      TargetDistance = (TurretPosition - ProjectedTargetPosition).getLength();

      if( TargetDistance != 0.0f )
      {
         MaxAngleDifferenceForHit = atan( TargetCollisionRadius / TargetDistance );
      }
      else
      {
         MaxAngleDifferenceForHit = float.infinity;
      }

      if( CurrentAngleRadiantsNoSign < MaxAngleDifferenceForHit )
      {
         bool Hit;
         PhysicsComponent HitedComponent;

         // check if we would hit something else and not the target

         /* ignore result */this.OfPhysicsEngine.castRay(TurretPosition, TurretRotationDirection, Hit, HitedComponent, float.infinity /* max dinstance */);

         // TODO< if hit is true, integrate the propability curve of the exit angles and look if the propability is above the threashold of 50 percentage,
         //       if so, shoot, if not, dont shoot >

         if( Hit && HitedComponent.getTypeId().equals(this.Target) )
         {
            TurretContext.Controller.setShooting(true);
         }
         else
         {
            TurretContext.Controller.setShooting(false);            
         }
      }
      else
      {
         TurretContext.Controller.setShooting(false);
      }

      // calculate the new rotation commands

      // in radiants per second
      TurretMaxTurnSpeed = OfTurret.getMaxTurnPerSecond();

      // old code
      //RotationDelta = CurrentAngleRadiantsSign * cast(float)this.getRefreshtimeInTicks() * 200.0f;
      
      // unoptimized
      //RotationDelta = CurrentAngleRadiantsSign / (cast(float)this.getRefreshtimeInTicks() * (TurretMaxTurnSpeed / cast(float)GameTime.TICKSPERSECOND);
      // optimized
      RotationDelta = (CurrentAngleRadiantsSign * cast(float)GameTime.TICKSPERSECOND) / (cast(float)this.getRefreshtimeInTicks() * TurretMaxTurnSpeed); 

      RotationDelta = clamp(RotationDelta, -1.0f, 1.0f);

      TurretContext.Controller.rotate(RotationDelta);

      return Task.EnumReturn.RUNNING;
   }

   // no doc
   public void reset()
   {
      // nothing
   }

   // no doc
   public Task clone()
   {
      TurretAttackTarget Clone;

      Clone = new TurretAttackTarget(this.OfPhysicsEngine);
      Clone.Target = this.Target; // right?

      return Clone;
   }

   // no doc
   public void setTarget(TypeIdObject Target)
   {
      this.Target = Target;
   }

   protected TypeIdObject Target;

   private IPhysicsEngine OfPhysicsEngine;
}
