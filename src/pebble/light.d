/**
 * This module defines control over the Pebble's light.
 */
module pebble.light;

@nogc:
nothrow:

/**
 * Trigger the backlight and schedule a timer to automatically disable the
 * backlight after a short delay. This is the preferred method of interacting
 * with the backlight.
 */
extern(C) void light_enable_interaction();

/**
 * Turn the watch's backlight on or put it back into automatic control.
 *
 * Developers should take care when calling this function, keeping Pebble's
 * backlight on for long periods of time will rapidly deplete the battery.
 *
 * Params:
 * enable = Turn the backlight on if `true`, otherwise `false` to put it back
 *     into automatic control.
 */
extern(C) void light_enable (bool enable);

