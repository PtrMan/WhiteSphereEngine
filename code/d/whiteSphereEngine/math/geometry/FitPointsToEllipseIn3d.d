module whiteSphereEngine.math.geometry.FitPointsToEllipseIn3d;

import std.math : abs;

import math.Matrix : Matrix, makeDiagonalMatrix = diagonal;
import math.NumericSpatialVectors;
import math.VectorAlias;
import whiteSphereEngine.math.geometry.DistancePointEllipseEllipsoid;
import whiteSphereEngine.math.optimization.HalfStepsizePatternSearch;
import whiteSphereEngine.math.Math;

private alias Matrix!(double, 1, 4) MatrixVector14Type;


import std.stdio; // for debugging

// helper, switches the coordinates that a > b if neccesary
private double distancePointEllipse(double a, double b, MatrixVector14Type point) {
    if( b > a ) {
        double temp = b;
        b = a;
        a = temp;

        temp = point[1, 0];
        point[1, 0] = point[0, 0];
        point[0, 0] = temp;
    }

    writeln("a = ", a);
    writeln("b = ", b);
    writeln("x = ", abs(point[0, 0]));
    writeln("y = ", abs(point[1, 0]));

    double closestX, closestY;
    // we do abs because negative values aren't allowed, and its symetric so we have to collapse everything into the 1st quadrant
    double resultDistance = whiteSphereEngine.math.geometry.DistancePointEllipseEllipsoid.distancePointEllipse(a, b, abs(point[0, 0]), abs(point[1, 0]), closestX, closestY);
    writeln("resultDistance = ", resultDistance);
    return resultDistance;
}

// helpers
private Real[Size] add(Real, uint Size)(Real[Size] a, Real[Size] b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] + b[i];
    }
    return result;
}

private Real[Size] sub(Real, uint Size)(Real[Size] a, Real[Size] b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] - b[i];
    }
    return result;
}

private Real[Size] scale(Real, uint Size)(Real[Size] a, Real b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] * b;
    }
    return result;
}


// see http://www.geometrictools.com/Documentation/LeastSquaresFitting.pdf   page 7
void fitPointsToEllipseIn3d(Vector3p[] points, out double a, out double b) {
    alias Matrix!(double, 4, 4) Matrix44Type;

    MatrixVector14Type[] pointsAsMatrices;

    MatrixVector14Type[] transformedPointsAsMatrices;

    // calculates the squared error metric for all points with the given parameters
    double calcSquaredMetricForParameters(double a, double b) {
        double squaredErrorMetric = 0;

        assert(transformedPointsAsMatrices.length != 0, "calcSquaredMetricForParameters() with array length == 0 is invalid!");

        foreach( iterationPoint; transformedPointsAsMatrices ) {
            writeln("distancePointEllipse() = ", distancePointEllipse(a, b, iterationPoint));

            squaredErrorMetric += sqr(distancePointEllipse(a, b, iterationPoint));
        }

        return squaredErrorMetric;
    }



    // U is the ellipsoid center
    // R is the orientation

    // a, b are the parameters for the ellise, (x/a)^2 + (y/b)^2 = 1


    Vector3p U = Vector3p.make(0, 0, 0);
    Matrix44Type R = makeDiagonalMatrix!(double, 4)(1,1,1,1); // for testing identity, TODO< make nonidentity and rotate >

    //Matrix33Type d = makeDiagonalMatrix!(double, 3)(1/sqr(a), 1/sqr(b), 1/sqr(c));

    //r.transpose * d * r * 


    const size_t halfStepsizePatternSearchMaxIterations = 40;
    const double halfStepsizePatternSearchInitialStepsize = 300000000000.0 * 60 * 6; // roughtly one AU

    /* uncommented because not used and outdated, but not in git jet
    double[1] optimizeForAResult;
    {
        // used by halfStepsizePatternSearch()
        double evaluateForA(double[1] samplePosition) {
            const double localA = samplePosition[0];
            return calcSquaredMetricForParameters(localA, b);
        }

        double[1] initialCenter = a;
        optimizeForAResult = halfStepsizePatternSearch!(double, 1)(&evaluateForA, initialCenter, halfStepsizePatternSearchInitialStepsize, halfStepsizePatternSearchMaxIterations);
    }
    */


    // we just translate it without transforming just for testing
    // TODO< retransform the points for each new parameter change >

    pointsAsMatrices.length = points.length;
    foreach( i, iterationPoint; points ) {
        pointsAsMatrices[i] = new Matrix!(double, 1, 4)();
        pointsAsMatrices[i][0, 0] = iterationPoint[0];
        pointsAsMatrices[i][1, 0] = iterationPoint[1];
        pointsAsMatrices[i][2, 0] = iterationPoint[2];
        pointsAsMatrices[i][3, 0] = 1;
    }

    transformedPointsAsMatrices.length = pointsAsMatrices.length;
    // TODO< transform >
    foreach( i, iterationPoint; pointsAsMatrices ) {
        transformedPointsAsMatrices[i] = iterationPoint;
    }



    // powell's method
    // described in http://www.aip.de/groups/soe/local/numres/bookcpdf/c10-5.pdf
    // page 4

    import std.stdio; // for debugging


    alias double[2] SearchVectorType; // parameter space

    // direction is not normalized
    // returns the position in parameter space where it got minimized
    SearchVectorType moveToMinimumAlongDirection(SearchVectorType start, SearchVectorType direction, double initialStepsize) {
        double evaluate(double[1] directionMultiplierVector) {
            double directionMultiplier = directionMultiplierVector[0];
            SearchVectorType samplePosition = add(start, scale(direction, directionMultiplier));
            return calcSquaredMetricForParameters(samplePosition[0], samplePosition[1]);
        }

        double[1] initialCenter = [0];
        double[1] directionMultiplierWhereMinimizedVector = halfStepsizePatternSearch!(double, 1)(&evaluate, initialCenter, initialStepsize, halfStepsizePatternSearchMaxIterations);
        double directionMultiplierWhereMinimized = directionMultiplierWhereMinimizedVector[0];

        writeln("directionMultiplierWhereMinimized = ", directionMultiplierWhereMinimized);

        return add(start, scale(direction, directionMultiplierWhereMinimized));
    }


    // initial guess

    const double FACTOR = 0.8;
    // we add a delta because else the value reaches zero while iterating and then all hell breakes loose
    a = halfStepsizePatternSearchInitialStepsize*FACTOR;
    b = halfStepsizePatternSearchInitialStepsize*FACTOR;

    SearchVectorType startingPosition = [a, b];

    uint N = 2;

    double[] initialStepsize;
    initialStepsize = [halfStepsizePatternSearchInitialStepsize, halfStepsizePatternSearchInitialStepsize, halfStepsizePatternSearchInitialStepsize];

    SearchVectorType[] u; // set of directions

    // initialize set of directions
    u.length = N+1;
    foreach( i; 1..N+1/* +1 because we have to iterate to N inclusive*/ ) {
        SearchVectorType direction;
        foreach( j; 0..direction.length) {
            direction[j] = 0;
        }
        writeln(i-1);
        direction[i-1] = 1;

        u[i] = direction;
    }

    SearchVectorType[] p;

    p.length = N+1;

    // save starting position as P_0
    p[0] = startingPosition;

    import std.stdio;
    writeln(p[0][0], p[0][1]);

    for(;;) {
        // move P_{i-1} to minimum along direction u_i and call this point P_i
        foreach( i; 1..N+1/* +1 because we have to iterate to N inclusive*/ ) {
            p[i] = moveToMinimumAlongDirection(p[i-1], u[i], initialStepsize[i]);
            
            assert(p[i].length == 2);

            import std.stdio;
            writeln("<", p[i-1][0], ",", p[i-1][1], ">");
            writeln("<", u[i][0], ",", u[i][1], ">");

            writeln("==> <", p[i][0], ",", p[i][1], ">");
        }

        // set u_i = u_{i+1}
        foreach( i; 1..N-1 ) {
            u[i] = u[i+1];
        }

        writeln("p[N] = <", p[N][0], ",", p[N][1], ">");
        writeln("p[0] = <", p[0][0], ",", p[0][1], ">");


        // set u_N <-- P_N-P_0
        u[N] = sub(p[N], p[0]);

        writeln("u[N] = <", u[N][0], ",", u[N][1], ">");
        writeln("p[N] = <", p[N][0], ",", p[N][1], ">");


        // move P_N to the minimum along direction u_N and call this point P_0
        p[0] = p[N] = moveToMinimumAlongDirection(p[N], u[N], initialStepsize[N]);

        // check if the function is still decreasing, if not break out
        // HACK< we break out immediatly >
        break;

        // TODO< check if function is still decreasing >
        assert(false, "TODO");
    }

    a = p[0][0];
    b = p[0][1];
}

// has main for interactive testing
void main() {
    Vector3p[] points;

    import std.math : cos, sin;

    foreach( i; 0..10 ) {
        points ~= Vector3p.make(cos(cast(double)i+0.1), sin(cast(double)i+0.1), 0.0f);    
    }
    
    // TODO< fill points with random points sampled from a elipse >

    double a, b;

    fitPointsToEllipseIn3d(points, /*out*/ a, /*out*/ b);

    import std.stdio;

    writeln("a = ", a);
    writeln("b = ", b);
}
