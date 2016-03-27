module math.RungeKutta4;

struct RungeKutta4State(Vectortype) {
	Vectortype x;      // position
	Vectortype v;      // velocity
}

// needs to be implemented by the phsics simulation which uses the RungeKutta4 solver
interface IAcceleration(Vectortype) {
	Vectortype calculateAcceleration(ref RungeKutta4State!Vectortype state, float time);
}

// see http://gafferongames.com/game-physics/integration-basics/
class RungeKutta4(Vectortype) {
	public struct Derivative {
		Vectortype dx;      // dx/dt = velocity
		Vectortype dv;      // dv/dt = acceleration
	};
	
	Derivative evaluate(ref RungeKutta4State!Vectortype initial, float t, float dt, ref Derivative d) {
		RungeKutta4State!Vectortype state;
		state.x = initial.x + d.dx*dt;
		state.v = initial.v + d.dv*dt;

		Derivative output;
		output.dx = state.v;
		output.dv = acceleration.calculateAcceleration(state, t+dt);
		return output;
	}
	
	void integrate(ref RungeKutta4State!Vectortype state, float t, float dt) {
		Derivative a,b,c,d, dummy;

		a = evaluate( state, t, 0.0f, dummy );
		b = evaluate( state, t, dt*0.5f, a );
		c = evaluate( state, t, dt*0.5f, b );
		d = evaluate( state, t, dt, c );

		Vectortype dxdt = ( a.dx + (b.dx + c.dx)*2.0f + d.dx ) * (1.0f / 6.0f);
		Vectortype dvdt = ( a.dv + (b.dv + c.dv)*2.0f + d.dv ) * (1.0f / 6.0f);

		state.x = state.x + dxdt * dt;
		state.v = state.v + dvdt * dt;
	}

	IAcceleration!Vectortype acceleration;
}
