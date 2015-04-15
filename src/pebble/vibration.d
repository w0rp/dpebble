/**
 * This module defines control over Pebble vibration.
 */
module pebble.vibration;

@nogc:
nothrow:

/**
 * Data structure describing a vibration pattern.
 * A pattern consists of at least 1 vibe-on duration, optionally followed by
 * alternating vibe-off + vibe-on durations. Each segment may have a different
 * duration.
 */
struct VibePattern {
    /**
     * Pointer to an array of segment durations, measured in milli-seconds.
     * The maximum allowed duration is 10000ms.
     */
    const(uint)* durations;
    /// The length of the array of durations.
    uint num_segments;
}

/**
 * Cancel any in-flight vibe patterns; this is a no-op if there is no
 * on-going vibe.
 */
extern(C) void vibes_cancel();

/// Makes the watch emit one short vibration.
extern(C) void vibes_short_pulse();

/// Makes the watch emit one long vibration.
extern(C) void vibes_long_pulse();

/// Makes the watch emit two brief vibrations.
extern(C) void vibes_double_pulse();

/**
 * Makes the watch emit a ‘custom’ vibration pattern.
 *
 * Params:
 * pattern = An arbitrary vibration pattern.
 *
 * See_Also: VibePattern
 */
extern(C) void vibes_enqueue_custom_pattern(VibePattern pattern);

