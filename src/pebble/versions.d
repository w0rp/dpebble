/**
 * This module defines version settings for the Pebble library.
 */
module pebble.versions;

version(PEBBLE_APLITE) {
    version(PEBBLE_BASALT) {
        static assert(false,
            "PEBBLE_APLITE and PEBBLE_BASALT were defined at the same time!"
        );
    }
} else {
    // Use PEBBLE_BASALT by default.
    version = PEBBLE_BASALT;
}

