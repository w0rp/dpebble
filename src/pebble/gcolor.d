/**
 * Pebble color data structures, and operations on them.
 */
module pebble.gcolor;

import pebble.versions;

@nogc:
nothrow:

/// A color for aplite Pebble watches, which have only 2 colors.
enum GColorMonoChrome {
  /// Represents "clear" or transparent.
  clear = ~0,
  /// Represents black.
  black = 0,
  /// Represents white.
  white = 1,
}

///
alias GColorClear = GColorMonoChrome.clear;
///
alias GColorBlack = GColorMonoChrome.black;
///
alias GColorWhite = GColorMonoChrome.white;

/**
 * A 8-bit colour value with an alpha channel.
 *
 * These colors are only available on the basalt pebble watches.
 */
struct GColor8 {
    ubyte argb;

    /// Blue
    @safe pure
    @property ubyte b() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return argb >> 6;
    }

    /// Set the blue value.
    @safe pure
    @property void b(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b00_11_11_11 | value << 6;
    }

    /// Green
    @safe pure
    @property ubyte g() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return (argb & 0b00_11_00_00) >> 4;
    }

    /// Set the green value.
    @safe pure
    @property void g(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_00_11_11 | value << 4;
    }

    /// Red
    @safe pure
    @property ubyte r() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return (argb & 0b00_00_11_00) >> 2;
    }

    /// Set the red value.
    @safe pure
    @property void r(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_11_00_11 | value << 2;
    }

    /**
     * The alpha value.
     *
     * 3 = 100% opaque,
     * 2 = 66% opaque,
     * 1 = 33% opaque,
     * 0 = transparent.
     */
    @safe pure
    @property ubyte a() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return argb & 0b00_00_00_11;
    }

    /// Set the alpha value.
    @safe pure
    @property void a(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_11_11_00 | value;
    }
}

alias GColor8 GColor;

/**
 * Comparison function for GColors.
 *
 * This simply returns x == y in D, so it is not recommended and exists only
 * for helping port code to D.
 */
deprecated("Use x == y instead of GColorEq(x, y)")
@safe pure
bool GColorEq(GColor8 x, GColor8 y) {
    return x == y;
}

/**
 * This function simply returns one of the two arguments given to it, depending
 * on the platform, for falling back from a more complex color
 * to a black and white color on watches with less colours.
 *
 * This is to replicate the effects of a macro defined in the official Pebble
 * SDK headers.
 *
 * Because this function simply returns one of its arguments, a good D
 * compiler should able to inline this function and reduce it to just one
 * of the arguments itself with no runtime cost.
 */
@safe pure
auto COLOR_FALLBACK(GColor color, GColorMonoChrome bw) {
    version(PEBBLE_APLITE) {
        return bw;
    } else {
        return color;
    }
}

