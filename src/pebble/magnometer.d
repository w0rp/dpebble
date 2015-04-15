/**
 * Magnometer data.
 */
module pebble.magnometer;

@nogc:
nothrow:

/// Magnetic field data.
struct MagData {
align(1):
    /// magnetic field along the x axis
    short x;
    /// magnetic field along the y axis
    short y;
    /// magnetic field along the z axis
    short z;
}

