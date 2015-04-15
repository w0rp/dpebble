/**
 * Miscellaneous Pebble functions and types.
 */
module pebble.misc;

import pebble.versions;

@nogc:
nothrow:

/**
 * The event loop for apps, to be used in app's main().
 * Will block until the app is ready to exit.
 */
extern(C) void app_event_loop();

/**
 * Waits for a certain amount of milliseconds
 *
 * Params:
 * millis = The number of milliseconds to wait for.
 */
extern(C) void psleep(int millis);

/**
 * Calculates the number of bytes of heap memory not currently being used
 * by the application.
 *
 * Returns: The number of bytes on the heap not currently being used.
 */
extern(C) size_t heap_bytes_free();

/**
 * Calculates the number of bytes of heap memory currently being used
 * by the application.
 *
 * Returns: The number of bytes on the heap currently being used.
 */
extern(C) size_t heap_bytes_used();

