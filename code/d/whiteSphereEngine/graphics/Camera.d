module whiteSphereEngine.graphics.Camera;

import linopterixed.linear.Vector;
import math.VectorAlias;

import whiteSphereEngine.common.IValueIndirection;
import whiteSphereEngine.common.BakedValueIndirection;

// TODO< we need doublebuffering for multitreaded rendering and manipulation of the position, helper vectors, etc >
class Camera {
	static Camera make(IValueIndirection!Vector3p positionIndirection, IValueIndirection!Vector3f upVectorIndirection,  IValueIndirection!Vector3f orthogonalBasisForwardVectorIndirection) {
		Camera result = new Camera;
		result.positionIndirection = positionIndirection;
		result.upVectorIndirection = upVectorIndirection;
		result.orthogonalBasisForwardVectorIndirection = orthogonalBasisForwardVectorIndirection;
		return result;
	}

	// world space
	final @property Vector3p position() const {
		return positionIndirection.value;
	}

	final @property Vector3f upVector() const {
		return upVectorIndirection.value;
	}

	final @property Vector3f orthogonalBasisForwardVector() const {
		return orthogonalBasisForwardVectorIndirection.value;
	}

	final @property Vector3f orthogonalBasisSideVector() const {
		return crossProduct(upVector, orthogonalBasisForwardVector);
	}

	final @property Vector3f orthogonalBasisUpVector() const {
		return crossProduct!(float, true)(orthogonalBasisSideVector, upVector);
	}

	protected IValueIndirection!Vector3p positionIndirection; // indirection for position, is indirection to avoid duplicated values and manual syncronsation

	// both need to return 
	protected IValueIndirection!Vector3f upVectorIndirection, orthogonalBasisForwardVectorIndirection;
}

// camera without indirection for the values
class CameraWithoutIndirection : Camera {
	final this() {
		positionIndirection = new BakedValueIndirection!Vector3p(&storedPosition);
		upVectorIndirection = new BakedValueIndirection!Vector3f(&storedUpVector);
		orthogonalBasisForwardVectorIndirection = new BakedValueIndirection!Vector3f(&storedOrthogonalBasisForwardVector);
	}

	final @property Vector3p position(Vector3p value) {
		storedPosition = value;
		return value;
	}

	final @property Vector3f upVector(Vector3f value)  {
		storedUpVector = value;
		return value;
	}

	final @property Vector3f orthogonalBasisForwardVector(Vector3f value) {
		storedOrthogonalBasisForwardVector = value;
		return value;
	}

	protected Vector3p storedPosition;
	protected Vector3f storedUpVector, storedOrthogonalBasisForwardVector;
}
