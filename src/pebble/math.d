/**
 * This module defines Pebble math operations.
 *
 * The lookup functions can be used to look up geometry values efficiently.
 */
module pebble.math;

@nogc:
nothrow:

/**
 * The largest value that can result from a call to sin_lookup or cos_lookup.
 */
enum TRIG_MAX_RATIO = 0xffff;

/**
 * Angle value that corresponds to 360 degrees or 2 PI radians
 *
 * See_Also: sin_lookup
 * See_Also: cos_lookup
 */
enum TRIG_MAX_ANGLE = 0x10000;

/**
 * Look-up the sine of the given angle from a pre-computed table.
 *
 * The angle value is scaled linearly, such that a value of 0x10000
 * corresponds to 360 degrees or 2 PI radians.
 *
 * Params:
 * angle = The angle for which to compute the cosine.
 */
extern(C) int sin_lookup(int angle);

/**
 * Look-up the cosine of the given angle from a pre-computed table.
 *
 * This is equivalent to calling `sin_lookup(angle + TRIG_MAX_ANGLE / 4)`.
 *
 * The angle value is scaled linearly, such that a value of 0x10000
 * corresponds to 360 degrees or 2 PI radians.
 *
 * Params:
 * angle = The angle for which to compute the cosine.
 */
extern(C) int cos_lookup(int angle);

/**
 * Look-up the arctangent of a given x, y pair.
 *
 * The angle value is scaled linearly, such that a value of 0x10000
 * corresponds to 360 degrees or 2 PI radians.
 */
extern(C) int atan2_lookup(short y, short x);

/**
 * Converts from a fixed point value representation of trig_angle to
 * the equivalent value in degrees
 */
@safe pure
auto TRIGANGLE_TO_DEG(N)(N trig_angle) {
    return trig_angle * 360 / TRIG_MAX_ANGLE;
}

