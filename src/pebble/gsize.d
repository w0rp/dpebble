module pebble.gsize;

@nogc:
nothrow:

/// Represents a 2-dimensional size.
struct GSize {
    /// The width
    short w;
    /// The height
    short h;
}

/// GSize of (0, 0).
enum GSizeZero = GSize.init;

/**
 * Tests whether 2 sizes are equal.
 *
 * Params:
 * size_a = Pointer to the first size.
 * size_b = Pointer to the second size.
 *
 * Returns: `true` if both sizes are equal, `false` if not.
 */
deprecated("Use x == y instead of gsize_equal(&x, &y)")
@safe pure
bool gsize_equal(const(GSize)* size_a, const(GSize)* size_b) {
    return *size_a == *size_b;
}

