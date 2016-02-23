module ColorRgb;

import NumericSpatialVectors;

class ColorRgb(Type) : NumericVector!(3, Type, true) {
	final @property Type r() {
        return this.data[0];
    }

    final @property Type r(Type value) {
        return this.data[0] = value;
    }

    final @property Type g() {
        return this.data[1];
    }

    final @property Type g(Type value) {
        return this.data[1] = value;
    }

    final @property Type b() {
        return this.data[2];
    }

    final @property Type b(Type value) {
        return this.data[2] = value;
    }


    public final this(Type r, Type g, Type b) {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    public final ColorRgb!Type clone() {
        return new ColorRgb!Type(r, g, b);
    }
}
