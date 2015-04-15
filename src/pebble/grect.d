module pebble.grect;

import pebble.gpoint;

@nogc:
nothrow:

/**
 * Represents a rectangle and defining it using the origin of
 * the upper-lefthand corner and its size.
 */
struct GRect {
    GPoint origin;
    GSize size;

    /// Create a rectangle with an origin and a size.
    @nogc @safe pure nothrow
    this(GPoint origin, GSize size) {
        this.origin = origin;
        this.size = size;
    }

    deprecated(
        "Use GRect(GPoint(x, y), GSize(w, h)) "
        "instead of GRect(x, y, w, h)"
    )
    @nogc @safe pure nothrow
    this(short x, short y, short w, short h) {
        this(GPoint(x, y), GSize(w, h));
    }


    /**
     * Tests whether the size of the rectangle is (0, 0).
     *
     * Note: If the width and/or height of a rectangle is negative, this
     * function will return `true`!
     *
     * Returns: `true` if the rectangle its size is (0, 0), or `false` if not.
    */
    @nogc @safe pure nothrow
    @property bool is_empty() const {
        return size.w == 0 && size.h == 0;
    }

    /**
     * Converts the rectangle's values so that the components of its size
     * (width and/or height) are both positive.
     *
     * If the width and/or height are negative, the origin will offset,
     * so that the final rectangle overlaps with the original.
     *
     * For example, a GRect with size (-10, -5) and origin (20, 20),
     * will be standardized to size (10, 5) and origin (10, 15).
     */
    @nogc @safe pure nothrow
    void standardize() {
        if (size.w < 0) {
            origin.x += size.w;
            size.w = -size.w;
        }

        if (size.h < 0) {
            origin.y += size.h;
            size.h = -size.h;
        }
    }
}

/// A zero GRect.
enum GRectZero = GRect.init;

deprecated("Use x == y instead of grect_equal(&x, &y)")
@safe pure
bool grect_equal(const GRect* rect_a, const GRect* rect_b) {
    return *rect_a == *rect_b;
}

deprecated("Use x.is_empty instead of grect_is_empty(&x)")
@safe pure
bool grect_is_empty(const GRect* rect) {
    return rect.is_empty;
}

deprecated("Use x.standardize() instead of grect_standardize(&x)")
@safe pure
void grect_standardize(GRect* rect) {
    rect.standardize();
}

// TODO: Implement this in D instead.
/// Clip one rectangle with another.
extern(C) void grect_clip(GRect* rect_to_clip, const GRect* rect_clipper);


/**
 * Tests whether a rectangle contains a point.
 *
 * Params:
 * rect = The rectangle
 * point = The point
 *
 * Returns: `true` if the rectangle contains the point, or `false` if it
 *     does not.
 */
extern(C) bool grect_contains_point(const(GRect)* rect, const(GPoint)* point);


/**
 * Convenience function to compute the center-point of a given rectangle.
 *
 * This is equal to `(rect->x + rect->width / 2, rect->y + rect->height / 2)`.
 *
 * Params:
 * rect = The rectangle for which to calculate the center point.
 *
 * Returns: The point at the center of `rect`
 */
extern(C) GPoint grect_center_point(const(GRect)* rect);

/**
 * Reduce the width and height of a rectangle by insetting each of the edges
 * with a fixed inset. The returned rectangle will be centered relative to
 * the input rectangle.
 *
 * Note: The function will trip an assertion if the crop yields a rectangle
 * with negative width or height.
 *
 * A positive inset value results in a smaller rectangle, while negative
 * inset value results in a larger rectangle.
 *
 * Params:
 * rect = The rectangle that will be inset.
 * crop_size_px = The inset by which each of the rectangle will be inset.
 *
 * Returns: The cropped rectangle.
 */
extern(C) GRect grect_crop(GRect rect, const int crop_size_px);

/**
 * Values to specify how two things should be aligned relative to each other.
 *
 * See_Also: bitmap_layer_set_alignment()
 */
enum GAlign {
    /// Align by centering.
    center = 0,
    /// Align by making the top edges overlap and left edges overlap.
    topLeft = 1,
    /// Align by making the top edges overlap and left edges overlap.
    topRight = 2,
    /// Align by making the top edges overlap and centered horizontally.
    top = 3,
    /// Align by making the left edges overlap and centered vertically.
    left = 4,
    /// Align by making the bottom edges overlap and centered horizontally.
    bottom = 5,
    /// Align by making the right edges overlap and centered vertically.
    right = 6,
    /// Align by making the bottom edges overlap and right edges overlap.
    bottomRight = 7,
    /// Align by making the bottom edges overlap and left edges overlap.
    bottomLeft = 8
}

///
alias GAlignCenter = GAlign.center;
///
alias GAlignTopLeft = GAlign.topLeft;
///
alias GAlignTopRight = GAlign.topRight;
///
alias GAlignTop = GAlign.top;
///
alias GAlignLeft = GAlign.left;
///
alias GAlignBottom = GAlign.bottom;
///
alias GAlignRight = GAlign.right;
///
alias GAlignBottomRight = GAlign.bottomRight;
///
alias GAlignBottomLeft = GAlign.bottomLeft;

/**
 * Aligns one rectangle within another rectangle, using an alignment parameter.
 * The relative coordinate systems of both rectangles are assumed to be the
 * same. When clip is true, `rect` is also clipped by the constraint.
 *
 * Params:
 * rect = The rectangle to align (in place).
 * inside_rect = The rectangle in which to align `rect`.
 * alignment = Determines the alignment of `rect` within `inside_rect` by
 *     specifying what edges of should overlap.
 * clip = Determines whether `rect` should be trimmed using the edges of
 *     `inside_rect` in case `rect` extends outside of the area that
 *     `inside_rect` covers after the alignment.
 */
extern(C) void grect_align(GRect* rect, const(GRect)* inside_rect,
const GAlign alignment, const bool clip);

