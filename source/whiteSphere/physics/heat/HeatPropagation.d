module whiteSphere.physics.heat.HeatPropagation;

struct Connection {
    Node target;
    float strength;

    public final this(Node target, float strength) {
        this.target = target;
        this.strength = strength;
    }
}

class Node {
    Connection[] neightborConnections;
  
    float heat, nextHeat;

    float cachedSummedNeightborStrength; // sum of all strength of all connections

    public final void recalcCache() {
        cachedSummedNeightborStrength = 0.0f;

        foreach( iterationConnection; neightborConnections ) {
            cachedSummedNeightborStrength += iterationConnection.strength;
        }
    }

    public final void update() {
        heat = nextHeat;
    }

    public final propagate(float heatFactor, float deltaTime) {
        float heatDelta = 0.0f;
    
        foreach( uint neightborI; 0 .. neightborConnections.length ) {
            Connection iterationneightborConnection = neightborConnections[neightborI];
            
            float currentDiff = iterationneightborConnection.target.heat - heat;

            float heatProductFactor = heatFactor * deltaTime;
            // TODO< precalc 1.0 / node.cachedSummedNeightborStrength >
            heatDelta += (currentDiff * heatProductFactor * iterationneightborConnection.strength) / cachedSummedNeightborStrength;
        }
        
        nextHeat = heat + heatDelta;
    }
}

class HeatSolver {
    Node[] nodes;

    public final void recalcCache() {
        foreach( iterationNode; nodes ) {
            iterationNode.recalcCache();
        }
    }

    public final void propagateAndUpdate(float heatFactor, float deltaTime) {
        foreach( iterationNode; nodes ) {
            iterationNode.propagate(heatFactor, deltaTime);
        }

        foreach( iterationNode; nodes ) {
            iterationNode.update();
        }
    }
}

// test, works
/* 
import std.stdio : writeln;


void main() {
    HeatSolver heatSolver = new HeatSolver();
    heatSolver.nodes ~= new Node();
    heatSolver.nodes ~= new Node();


    // let the heat propagate from 
    heatSolver.nodes[0].heat = 1.0f;
    heatSolver.nodes[1].heat = 0.0f;

    heatSolver.nodes[0].neightborConnections ~= Connection(heatSolver.nodes[1], 1.0f);
    heatSolver.nodes[1].neightborConnections ~= Connection(heatSolver.nodes[0], 1.0f);

    heatSolver.recalcCache();
    
    foreach( frameNumber; 0..10 ) {
        writeln(heatSolver.nodes[0].heat);
        writeln(heatSolver.nodes[1].heat);

        heatSolver.propagateAndUpdate(1.0f, 0.1f);

        writeln("---");
    }
}
*/
