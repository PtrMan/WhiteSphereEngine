module whiteSphereEngine.graphics.Instanced;

import linopterixed.linear.Vector;
import math.VectorAlias;

import whiteSphereEngine.common.IValueIndirection;
import graphics.AbstractDecoratedMesh;

// TODO< we need doublebuffering for multitreaded rendering and manipulation of the position, scale, etc >
/** an instance which bundles the following computer graphics concepts into one object
 *  * position, orientation(rotation), scale
 *  * mesh
 *  * texture(s)
 *  * materials
 * 
 * instance is a misnomer because it doesn't have to be instanced
 */
struct Instanced {
	static Instanced *makeGc(AbstractDecoratedMesh abstractDecoratedMesh, IValueIndirection!Vector3p positionIndirection) {
		return new Instanced(abstractDecoratedMesh, positionIndirection);
	}

	protected final this(AbstractDecoratedMesh abstractDecoratedMesh, IValueIndirection!Vector3p positionIndirection) {
		scale = Vector3p.make(1.0, 1.0, 1.0);
		this.abstractDecoratedMesh = abstractDecoratedMesh;
		this.positionIndirection = positionIndirection;
	}

	AbstractDecoratedMesh abstractDecoratedMesh; // decorated mesh owned by renderer

	// world space
	final @property Vector3p position() const {
		return positionIndirection.value;
	}

	

	Vector3p scale;

	// TODO< textures >

	// TODO< materials >

	protected IValueIndirection!Vector3p positionIndirection; // indirection for position, is indirection to avoid duplicated values and manual syncronsation


	// commented because we don't jet have quaternions      protected IValueIndirection!(Quaternion!double) orientation;
}

// more implicit typename
alias Instanced RenderedInstanced;
