/**
 * This module defines control over Accelerometer control on Pebble watches.
 */
module pebble.accelerometer;

import core.stdc.config;

@nogc:
nothrow:

/**
 * A single accelerometer sample for all three axes including timestamp and
 * vibration rumble status.
 */
extern(C) struct AccelData {
align(1):
    /// acceleration along the x axis
    short x;
    /// acceleration along the y axis
    short y;
    /// acceleration along the z axis
    short z;
    /// true if the watch vibrated when this sample was collected
    bool did_vibrate;
    /// timestamp, in milliseconds
    ulong timestamp;
}

/// A single accelerometer sample for all three axes.
extern(C) struct AccelRawData {
align(1):
    /// acceleration along the x axis.
    short x;
    /// acceleration along the y axis.
    short y;
    /// acceleration along the z axis.
    short z;
}

/// Enumerated values defining the three accelerometer axes.
enum AccelAxisType {
    /// Accelerometer's X axis. The positive direction along the X axis goes
    /// toward the right of the watch.
    x = 0,
    /// Accelerometer's Y axis. The positive direction along the Y axis goes
    /// toward the top of the watch.
    y = 1,
    /// Accelerometer's Z axis. The positive direction along the Z axis goes
    /// vertically out of the watchface.
    z = 2
}

///
alias ACCEL_AXIS_X = AccelAxisType.x;
///
alias ACCEL_AXIS_Y = AccelAxisType.y;
///
alias ACCEL_AXIS_Z = AccelAxisType.z;

/**
 * Callback type for accelerometer data events.
 *
 * Params:
 * data = Pointer to the collected accelerometer samples.
 * num_samples = the number of samples stored in data.
 */
alias extern(C) void function
(AccelData* data, uint num_samples) AccelDataHandler;

/**
 * Callback type for accelerometer raw data events
 *
 * Params:
 * data = Pointer to the collected accelerometer samples.
 * num_samples = The number of samples stored in data.
 * timestamp = The timestamp, in ms, of the first sample.
 */
alias extern(C) void function
(AccelRawData* data, uint num_samples, c_ulong timestamp) AccelRawDataHandler;

/**
 * Callback type for accelerometer tap events.
 *
 * Params:
 * axis = the axis on which a tap was registered (x, y, or z)
 * direction = the direction (-1 or +1) of the tap
 */
alias extern(C) void function
(AccelAxisType axis, int direction) AccelTapHandler;

/// Valid accelerometer sampling rates, in Hz.
enum AccelSamplingRate {
    /// 10 HZ sampling rate.
    _10hz = 10,
    /// 25 HZ sampling rate [Default].
    _25hz = 25,
    /// 50 HZ sampling rate.
    _50hz = 50,
    /// 100 HZ sampling rate.
    _100hz = 100
}

///
alias ACCEL_SAMPLING_10HZ = AccelSamplingRate._10hz;
///
alias ACCEL_SAMPLING_25HZ = AccelSamplingRate._25hz;
///
alias ACCEL_SAMPLING_50HZ = AccelSamplingRate._50hz;
///
alias ACCEL_SAMPLING_100HZ = AccelSamplingRate._100hz;

/**
 * Peek at the last recorded reading.
 *
 * Note: Cannot be used when subscribed to accelerometer data events.
 *
 * Params:
 * data = a pointer to a pre-allocated AccelData item.
 *
 * Returns: -1 if the accel is not running
 * Returns: -2 if subscribed to accelerometer events.
 */
extern(C) int accel_service_peek(AccelData* data);

/**
 * Change the accelerometer sampling rate.
 *
 * Params:
 * rate = The sampling rate in Hz (10Hz, 25Hz, 50Hz, and 100Hz possible)
 */
extern(C) int accel_service_set_sampling_rate(AccelSamplingRate rate);

/**
 *
 * Change the number of samples buffered between each accelerometer data event
 *
 * Params:
 * num_samples = the number of samples to buffer, between 0 and 25.
 */
extern(C) int accel_service_set_samples_per_update(uint num_samples);

/**
 * Subscribe to the accelerometer data event service. Once subscribed,
 * the handler gets called every time there are new accelerometer samples
 * available.
 *
 * Note: Cannot use accel_service_peek() when subscribed to accelerometer
 * data events.
 *
 * Params:
 * samples_per_update = the number of samples to buffer, between 0 and 25.
 * handler = A callback to be executed on accelerometer data events
 */
extern(C) void accel_data_service_subscribe
(uint samples_per_update, AccelDataHandler handler);

/**
 * Unsubscribe from the accelerometer data event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void accel_data_service_unsubscribe();

/**
 * Subscribe to the accelerometer tap event service. Once subscribed,
 * the handler gets called on every tap event emitted by the accelerometer.
 *
 * Params:
 * handler = A callback to be executed on tap event
 */
extern(C) void accel_tap_service_subscribe(AccelTapHandler handler);

/**
 * Unsubscribe from the accelerometer tap event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void accel_tap_service_unsubscribe();

/**
 * Subscribe to the accelerometer raw data event service. Once subscribed,
 * the handler gets called every time there are new accelerometer samples
 * available.
 *
 * Note: Cannot use \ref accel_service_peek() when subscribed to accelerometer
 * data events.
 *
 * Params:
 * samples_per_update = The number of samples to buffer, between 0 and 25.
 * handler = A callback to be executed on accelerometer data events
 */
extern(C) void accel_raw_data_service_subscribe
(uint samples_per_update, AccelRawDataHandler handler);

