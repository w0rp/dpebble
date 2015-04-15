/**
 * This module defines compass operations for a Pebble watch.
 */
module pebble.compass;

/// Enum describing the current state of the Compass Service calibration.
enum CompassStatus {
    /// Compass is calibrating: data is invalid and should not be used.
    data_invalid = 0,
    /// Compass is calibrating: the data is valid but the calibration
    /// is still being refined.
    calibrating = 1,
    /// Compass data is valid and the calibration has completed.
    calibrated = 2
}

///
alias CompassStatusDataInvalid = CompassStatus.data_invalid;
///
alias CompassStatusCalibrating = CompassStatus.calibrating;
///
alias CompassStatusCalibrated = CompassStatus.calibrated;

/**
 * Represents an angle relative to a reference direction,
 * e.g. (magnetic) north.
 *
 * The angle value is scaled linearly, such that a value of TRIG_MAX_ANGLE
 * corresponds to 360 degrees or 2 PI radians.
 * Thus, if heading towards north, north is 0, east is TRIG_MAX_ANGLE/4,
 * south is TRIG_MAX_ANGLE/2, and so on.
 */
alias int CompassHeading;

/// Structure containing a single heading towards magnetic and true north.
struct CompassHeadingData {
    /// measured angle relative to magnetic north
    CompassHeading magnetic_heading;
    /// measured angle relative to true north
    // (or to magnetic north if declination is invalid)
    CompassHeading true_heading;
    /// indicates the current state of the Compass Service calibration.
    CompassStatus compass_status;
    /// true, if the current declination is known and applied to
    /// `true_heading`, false otherwise.
    bool is_declination_valid;
}

/**
 * Callback type for compass heading events
 *
 * Params:
 * heading = copy of last recorded heading
 */
alias extern(C) void function
(CompassHeadingData heading) CompassHeadingHandler;

/**
 * Set the minimum angular change required to generate new compass heading
 * events.
 *
 * The angular distance is measured relative to the last delivered heading
 * event. Use 0 to be notified of all movements.
 * Negative values and values > TRIG_MAX_ANGLE / 2 are not valid.
 * The default value of this property is TRIG_MAX_ANGLE / 360.
 *
 * Returns: 0 on success, Non-Zero, if the filter is invalid.
 *
 * See_Also: compass_service_subscribe
 */
extern(C) int compass_service_set_heading_filter(CompassHeading filter);

/**
 * Subscribe to the compass heading event service. Once subscribed, the
 * handler gets called every time the angular distance relative to the
 * previous value exceeds the configured filter.
 *
 * Params:
 * handler = A callback to be executed on heading events
 *
 * See_Also: compass_service_set_heading_filter
 * See_Also: compass_service_unsubscribe
 */
extern(C) void compass_service_subscribe(CompassHeadingHandler handler);

/**
 * Unsubscribe from the compass heading event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 *
 * See_Also: compass_service_subscribe
 */
extern(C) void compass_service_unsubscribe();

/**
 * Peek at the last recorded reading.
 *
 * Params:
 * data = a pointer to a pre-allocated CompassHeadingData.
 *
 * Return: Always returns 0 to indicate success.
 */
extern(C) int compass_service_peek(CompassHeadingData* data);

