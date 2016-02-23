// playing around with Voro and particle systems and gaussian blur
// gausian blur seems to work

import NumericSpatialVectors;

template ISpatialScheme(SpatialType, ElementType) {
    interface ISpatialScheme {
        ElementType[] getElementsNearPosition(SpatialType position, float function(SpatialType first, SpatialType second) calcDistance, float maxDistance);
        ElementType getNearestElement(SpatialType position, float function(SpatialType first, SpatialType second) calcDistance);
    }
}

// Spatial Scheme for an Nondymic fixed sized array
template ArraySpatialScheme(SpatialType, ElementType) {
    class ArraySpatialScheme : ISpatialScheme!(SpatialType, ElementType) {
        public final ElementType[] getElementsNearPosition(SpatialType position, float function(SpatialType first, SpatialType second) calcDistance, float maxDistance) {
            // TODO
            return new ElementType[0];
        }

        public final ElementType getNearestElement(SpatialType position, float function(SpatialType first, SpatialType second) calcDistance) {
            ElementType nearestElement = elements[0];
            float nearestDistance = calcDistance(position, nearestElement.position);

            foreach( uint i; 1..elements.length ) {
                ElementType currentElement = elements[i];
                float currentDistance = calcDistance(position, currentElement.position);

                if( currentDistance < nearestDistance ) {
                    nearestDistance = currentDistance;
                    nearestElement = currentElement;
                }
            }

            return nearestElement;
        }

        public ElementType[] elements;
    }
}



import IMap2d : IMap2d;
import Map2d : Map2d;

// map helper
void setToZero(IMap2d!float map) {
    for( int y = 0; y < map.height; y++ ) {
        for( int x = 0; x < map.width; x++ ) {
            map.setAt(new SpatialVector!(2,int)(x, y), cast(float)0);
        }
    }
}


import Convolution;

import std.math : exp, sqrt, PI;

float gaussian(float a, float x, float b, float c) {
    float diff = x-b;
    return a*exp(-0.5f * (diff*diff) / (c*c));
}

float normalizedGaussian(float x, float mu, float sigma) {
    float a = 1.0f/(sigma*sqrt(2.0f*PI));
    return gaussian(a, x, mu, sigma);
}

// gaussian kernel helper
float[] calcGaussianKernel(uint width) {
    float[] kernel = new float[width];

    for( int i = 0; i < width; i++ ) {
        // offset from -1.0 to 1.0
        float offsetM1P1 = -1.0f + 2.0f * (cast(float)i / cast(float)width);

        float x = offsetM1P1 * 3.0f;

        kernel[i] = normalizedGaussian(x, 0.0f, 1.0f) * (1.0f/0.4f);
    }

    float sum = cast(float)0;

    foreach( float kernelValue; kernel ) {
        sum += kernelValue;
    }

    foreach( uint i; 0..kernel.length ) {
        kernel[i] /= sum;
    }

    return kernel;
}

SpatialVector!(2,float) convertVectorToFloat(SpatialVector!(2,int) parameter) {
    return new SpatialVector!(2,float)(parameter.x, parameter.y);
}

class Element {
    public SpatialVector!(2,float) position;
    public uint color;
}


// TODO< vorolio diagram and stuff >

class DistanceFamily {
    public final this(ISpatialScheme!(SpatialVector!(2,float), Element) spatialScheme, IMap2d!uint mapColors) {
        this.spatialScheme = spatialScheme;
        this.mapColors = mapColors;
    }

    final public void calcForImage(float function(SpatialVector!(2,float) first, SpatialVector!(2,float) second) calcDistance) {
        SpatialVector!(2,int) min = new SpatialVector!(2,int)(0, 0);
        SpatialVector!(2,int) max = new SpatialVector!(2,int)(mapColors.width, mapColors.height);
        calcForRange(calcDistance, min, max);
    }

    final public void calcForRange(float function(SpatialVector!(2,float) first, SpatialVector!(2,float) second) calcDistance, SpatialVector!(2,int) min, SpatialVector!(2,int) max) {
        for( int y = min.y; y < max.y; y++ ) {
            for( int x = min.x; x < max.x; x++ ) {
                SpatialVector!(2,int) position = new SpatialVector!(2,int)(x, y);
                calcForTexel(calcDistance, position);
            }
        }
    }

    final private void calcForTexel(float function(SpatialVector!(2,float) first, SpatialVector!(2,float) second) calcDistance, SpatialVector!(2,int) position) {
        SpatialVector!(2,float) positionAsFloat = convertVectorToFloat(position);

        Element closestsElement = spatialScheme.getNearestElement(positionAsFloat, calcDistance);
        mapColors.setAt(position, closestsElement.color);
    }

    private ISpatialScheme!(SpatialVector!(2,float), Element) spatialScheme;
    private IMap2d!uint mapColors;
}







// particle system for texture generation

class Particle {
    public SpatialVector!(3,float) position;
    public SpatialVector!(3,float) velocity;

    public void timestep(float deltaTime) {
        timestepMotion(deltaTime);
    }

    protected final void timestepMotion(float deltaTime) {
        position += velocity.scale(deltaTime);
    }
}

class ParticleWithTimer : Particle {
    public Timer!float timer;

    public override void timestep(float deltaTime) {
        timestepTimer(deltaTime);
        timestepMotion(deltaTime);
    }

    protected final void timestepTimer(float deltaTime) {
        timer.advance(deltaTime);
    }
}

struct DecrementalCounter(Type) {
    public Type value = cast(Type)0;

    public final void advance(Type deltaTime) {
        value -= deltaTime;
    }

    public final bool wasTriggered() {
        return value <= cast(Type)0;
    }
}

struct Timer(Type) {
    protected DecrementalCounter!Type counter;

    public final void resetTo(Type value) {
        counter.value = value;
    }

    public final void advance(Type deltaTime) {
        counter.advance(deltaTime);
    }

    public final bool wasTriggered() {
        return counter.wasTriggered();
    }
}

import Array : removeAt;

class ParticleSystem {
    public final void timestep(float deltaTime) {
        timestepParticles(deltaTime);
        checkAndApplyActionsForParticles();
    }

    protected final void timestepParticles(float deltaTime) {
        foreach( Particle iteratorParticle; particles ) {
            iteratorParticle.timestep(deltaTime);
        }
    }

    // checks if the timer of a particle triggered and applies some action to it
    protected final void checkAndApplyActionsForParticles() {
        for( uint particleI = 0; particleI < particles.length; particleI++ ) {
            ParticleWithTimer iteratorParticle = particles[particleI];

            if( iteratorParticle.timer.wasTriggered() ) {
                bool removeParticle;
                applyActionForParticle(iteratorParticle, removeParticle);

                if( removeParticle ) {
                    // remove particle
                    particles = removeAt(particles, particleI);

                    particleI--;
                    continue;
                }
            }
        }
    }

    protected final void applyActionForParticle(ParticleWithTimer particle, out bool removeParticle) {
        // TODO
        // for now we just delete the particle
        removeParticle = true;
    }

    public ParticleWithTimer[] particles;
}



void convertUintColorToGrayscale(IMap2d!uint uintColor, IMap2d!float grayOutput, float[] grayValues) {
    for( int y = 0; y < uintColor.height; y++ ) {
        for( int x = 0; x < uintColor.width; x++ ) {
            float grayValue = grayValues[uintColor.getAt(new SpatialVector!(2,int)(x, y))];
            grayOutput.setAt(new SpatialVector!(2,int)(x, y), grayValue);
        }
    }
}




import std.math : abs, fmax;

float calcDistanceManhattan(SpatialVector!(2,float) first, SpatialVector!(2,float) second) {
    return abs(first.x - second.x) + abs(first.y - second.y);
}

import std.stdio;

void main(string[] args) {
    IMap2d!uint colorMap = new Map2d!uint(30, 20);

    ArraySpatialScheme!(SpatialVector!(2,float), Element) spatialScheme = new ArraySpatialScheme!(SpatialVector!(2,float), Element)();
    DistanceFamily distanceFamily = new DistanceFamily(spatialScheme, colorMap);

    spatialScheme.elements.length = 3;
    spatialScheme.elements[0] = new Element();
    spatialScheme.elements[0].position = new SpatialVector!(2,float)(0.0f, 0.0f);
    spatialScheme.elements[0].color = 0;
    spatialScheme.elements[1] = new Element();
    spatialScheme.elements[1].position = new SpatialVector!(2,float)(10.0f, 0.0f);
    spatialScheme.elements[1].color = 1;
    spatialScheme.elements[2] = new Element();
    spatialScheme.elements[2].position = new SpatialVector!(2,float)(5.0f, 10.0f);
    spatialScheme.elements[2].color = 2;

    float function(SpatialVector!(2,float) first, SpatialVector!(2,float) second) calcDistance = &calcDistanceManhattan;
    distanceFamily.calcForImage(calcDistance);


    uint kernelWidth = 10;
    float[] blurKernel = calcGaussianKernel(kernelWidth);

    IMap2d!float map = new Map2d!float(30, 20);
    IMap2d!float temporary = new Map2d!float(30, 20);
    temporary.setToZero();

    convertUintColorToGrayscale(colorMap, map, [0.0f, 0.5f, 1.0f]);

    convoluteSeperable(map, temporary, blurKernel);

    // debug values
    for( int y = 0; y < map.height; y++ ) {
        for( int x = 0; x < map.width; x++ ) {
            float value = map.getAt(new SpatialVector!(2,int)(x, y));
            write(value, " ");
        }
    }
}