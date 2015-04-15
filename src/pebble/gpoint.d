module pebble.gpoint;

@nogc:
nothrow:

/**
 * Represents a point in a 2-dimensional coordinate system.
 *
 * Note: Conventionally, the origin of Pebble's 2D coordinate system
 * is in the upper, lefthand corner its x-axis extends to the right and
 * its y-axis extends to the bottom of the screen.
 */
struct GPoint {
    short x;
    short y;
}

/// A zero GPoint.
enum GPointZero = GPoint.init;

/**
 * Tests whether 2 points are equal.
 *
 * Params:
 * point_a = Pointer to the first point
 * point_b = Pointer to the second point
 *
 * Returns: `true` if both points are equal, `false` if not.
 */
deprecated("Use x == y instead of gpoint_equal(&x, &y)")
@safe pure
bool gpoint_equal(const GPoint* point_a, const GPoint* point_b) {
   return *point_a == *point_b;
}

