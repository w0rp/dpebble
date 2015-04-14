/**
 * This module mirrors the basalt and aplite Pebble headers with color
 * definitions, etc.
 */
module pebble;

// TODO: Pebble declared its own tm struct.
// We should probably use that instead.
import core.stdc.time;
import core.stdc.config;
import core.stdc.string : strlen;


@nogc:
nothrow:

/**
 * Button ID values
 *
 * See_Also: click_recognizer_get_button_id
 */
enum ButtonId {
    /// Back button
    back = 0,
    /// Up button
    up = 1,
    /// Select (middle) button
    select = 2,
    /// Down button
    down = 3,
    /// Total number of buttons
    num = 4
}

///
alias BUTTON_ID_BACK = ButtonId.back;
///
alias BUTTON_ID_UP = ButtonId.up;
///
alias BUTTON_ID_SELECT = ButtonId.select;
///
alias BUTTON_ID_DOWN = ButtonId.down;
///
alias NUM_BUTTONS = ButtonId.num;

/**
 * Get the ISO locale name for the language currently set on the watch.
 *
 * Note: It is possible for the locale to change while your app is running.
 * And thus, two calls to i18n_get_system_locale may return different values.
 *
 * Returns: A string containing the ISO locale name (e.g. "fr", "en_US", ...)
 */
extern(C) const(char)* i18n_get_system_locale();

enum WatchInfoModel {
    /// Unknown model
    unknown = 0,
    /// Original Pebble
    original = 1,
    /// Pebble Steel
    steel = 2,
    /// Pebble Time
    time = 3
}

///
alias WATCH_INFO_MODEL_UNKNOWN = WatchInfoModel.unknown;
///
alias WATCH_INFO_MODEL_PEBBLE_ORIGINAL = WatchInfoModel.original;
///
alias WATCH_INFO_MODEL_PEBBLE_STEEL = WatchInfoModel.steel;
///
alias WATCH_INFO_MODEL_PEBBLE_TIME = WatchInfoModel.time;

/// The different watch colors.
enum WatchInfoColor {
    /// Unknown color
    unknown = 0,
    /// Black
    black = 1,
    /// White
    white = 2,
    /// Red
    red = 3,
    /// Orange
    orange = 4,
    /// Grey
    grey = 5,
    /// Stainless Steel
    stainless_steel = 6,
    /// Matte Black
    matte_black = 7,
    /// Blue
    blue = 8,
    /// Green
    green = 9,
    /// Pink
    pink = 10,
    /// White
    time_white = 11,
    /// Black
    time_black = 12,
    /// Red
    time_red = 13
}

///
alias WATCH_INFO_COLOR_UNKNOWN = WatchInfoColor.unknown;
///
alias WATCH_INFO_COLOR_BLACK = WatchInfoColor.black;
///
alias WATCH_INFO_COLOR_WHITE = WatchInfoColor.white;
///
alias WATCH_INFO_COLOR_RED = WatchInfoColor.red;
///
alias WATCH_INFO_COLOR_ORANGE = WatchInfoColor.orange;
///
alias WATCH_INFO_COLOR_GREY = WatchInfoColor.grey;
///
alias WATCH_INFO_COLOR_STAINLESS_STEEL = WatchInfoColor.stainless_steel;
///
alias WATCH_INFO_COLOR_MATTE_BLACK = WatchInfoColor.matte_black;
///
alias WATCH_INFO_COLOR_BLUE = WatchInfoColor.blue;
///
alias WATCH_INFO_COLOR_GREEN = WatchInfoColor.green;
///
alias WATCH_INFO_COLOR_PINK = WatchInfoColor.pink;
///
alias WATCH_INFO_COLOR_TIME_WHITE = WatchInfoColor.time_white;
///
alias WATCH_INFO_COLOR_TIME_BLACK = WatchInfoColor.time_black;
///
alias WATCH_INFO_COLOR_TIME_RED = WatchInfoColor.time_red;

/**
 * Data structure containing the version of the firmware running on the watch.
 *
 * The version of the firmware has the form X.[X.[X]].
 * If a version number is not present it will be 0.
 *
 * For example: the version numbers of 2.4.1 are 2, 4, and 1.
 * The version numbers of 2.4 are 2, 4, and 0.
 */
extern(C) struct WatchInfoVersion {
  /// Major version number
  ubyte major;
  /// Minor version number
  ubyte minor;
  /// Patch version number
  ubyte patch;
}

/**
 * Provides the model of the watch.
 * Returns: A WatchInfoModel representing the model of the watch.
 */
extern(C) WatchInfoModel watch_info_get_model();

/**
 * Provides the version of the firmware running on the watch.
 *
 * Returns: A WatchInfoVersion representing the version of the firmware running on the watch.
 */
extern(C) WatchInfoVersion watch_info_get_firmware_version();

/**
 * Provides the color of the watch.
 *
 * Returns: A WatchInfoColor representing the color of the watch.
 */
extern(C) WatchInfoColor watch_info_get_color();

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

/// Weekday values
enum WeekDay {
    /// Today
    today = 0,
    /// Sunday
    sunday = 1,
    /// Monday
    monday = 2,
    /// Tuesday
    tuesday = 3,
    /// Wednesday
    wednesday = 4,
    /// Thursday
    thursday = 5,
    /// Friday
    friday = 6,
    /// Saturday
    saturday = 7
}

///
alias TODAY = WeekDay.today;
///
alias SUNDAY = WeekDay.sunday;
///
alias MONDAY = WeekDay.monday;
///
alias TUESDAY = WeekDay.tuesday;
///
alias WEDNESDAY = WeekDay.wednesday;
///
alias THURSDAY = WeekDay.thursday;
///
alias FRIDAY = WeekDay.friday;
///
alias SATURDAY = WeekDay.saturday;

/**
 * Copies a time string into the buffer, formatted according to the user's
 * time display preferences (such as 12h/24h time).
 *
 * Example results: "7:30" or "15:00".
 * Note: AM/PM are also outputted with the time if the user's preference is
 * 12h time.
 *
 * Params:
 * buffer = A pointer to the buffer to copy the time string into
 * size = The maximum size of buffer
 */
extern(C) void clock_copy_time_string(char* buffer, ubyte size);

/**
 * Gets the user's 12/24h clock style preference.
 *
 * Returns: true if the user prefers 24h-style time display or false
 * if the user prefers 12h-style time display.
 */
extern(C) bool clock_is_24h_style();

/**
 * Converts a (day, hour, minute) specification to a UTC timestamp
 * occurring in the future
 *
 * Always returns a timestamp for the next occurring instance,
 *
 * example: specifying TODAY@14:30 when it is 14:40 will return a timestamp for 7 days from
 * now at 14:30
 *
 * Note: This function does not support Daylight Saving Time (DST) changes,
 * events scheduled during a DST change will be off by an hour.
 *
 * Params:
 * day = Day of week including support for specifying TODAY.
 * hour = hour specified in 24-hour format [0-23]
 * minute = minute [0-59]
 */
extern(C) time_t clock_to_timestamp(WeekDay day, int hour, int minute);

/**
 * Checks if timezone is currently set, otherwise gmtime == localtime.
 *
 * Returns: true if timezone has been set, false otherwise.
 */
extern(C) bool clock_is_timezone_set();

/// Undocumented...
extern(C) void clock_get_timezone(char *buf);

/**
 * Callback type for bluetooth connection events
 *
 * Params:
 * connected = true on bluetooth connection, false on disconnection.
 */
alias extern(C) void function(bool connected) BluetoothConnectionHandler;

/**
 * Query the bluetooth connection service for the current connection status.
 *
 * Returns: true if connected, false otherwise.
 */
extern(C) bool bluetooth_connection_service_peek();

/**
 * Subscribe to the bluetooth event service. Once subscribed,
 * the handler gets called on every bluetooth connection event.
 *
 * Params:
 * handler = A callback to be executed on connection event.
 */
extern(C) void bluetooth_connection_service_subscribe
(BluetoothConnectionHandler handler);

/**
 * Unsubscribe from the bluetooth event service
 * Once unsubscribed, the previously registered
 * handler will no longer be called.
 */
extern(C) void bluetooth_connection_service_unsubscribe();

/**
 * Callback type for focus events.
 *
 * Params:
 * in_focus = true if the app is in focus, false otherwise.
 */
alias extern(C) void function(bool in_focus) AppFocusHandler;

/**
 * Subscribe to the focus event service. Once subscribed, the handler gets
 * called every time the app focus changes.
 *
 * Note: In focus events are triggered when the app is no longer covered by a
 * modal window.
 *
 * Out focus events are triggered when the app becomes covered by a modal
 * window.
 *
 * handler = A callback to be executed on in-focus events.
 */
extern(C) void app_focus_service_subscribe(AppFocusHandler handler);

/**
 * Unsubscribe from the focus event service. Once unsubscribed, the previously
 * registered handler will no longer be called.
 */
extern(C) void app_focus_service_unsubscribe();

/// Structure for retrieval of the battery charge state.
extern(C) struct BatteryChargeState {
    /// A percentage (0-100) of how full the battery is.
    ubyte charge_percent;
    /// true if the battery is currently being charged. false if not.
    bool is_charging;
    /// true if the charger cable is connected. false if not.
    bool is_plugged;
}

/**
 * Callback type for battery state change events
 *
 * Params:
 * charge = The state of the battery.
 */
alias extern(C) void function(BatteryChargeState charge) BatteryStateHandler;

/**
 * Subscribe to the battery state event service. Once subscribed,
 * the handler gets called on every battery state change.
 *
 * Params:
 * handler = A callback to be executed on battery state change event
 */
extern(C) void battery_state_service_subscribe(BatteryStateHandler handler);

/**
 * Unsubscribe from the battery state event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void battery_state_service_unsubscribe();

/**
 * Peek at the last known battery state.
 *
 * Returns: A BatteryChargeState containing the last known data.
 */
extern(C) BatteryChargeState battery_state_service_peek();

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


/**
 * Converts from a fixed point value representation of trig_angle to
 * the equivalent value in degrees
 */
@safe pure
auto TRIGANGLE_TO_DEG(N)(N trig_angle) {
    return trig_angle * 360 / TRIG_MAX_ANGLE;
}

/// Magnetic field data.
extern(C) struct MagData {
align(1):
    /// magnetic field along the x axis
    short x;
    /// magnetic field along the y axis
    short y;
    /// magnetic field along the z axis
    short z;
}

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
extern(C) struct CompassHeadingData {
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

/**
 * Time unit flags that can be used to create a bitmask for use in
 * tick_timer_service_subscribe().This will also be passed to \ref TickHandler.
 */
enum TimeUnits {
    /// Flag to represent the "seconds" time unit.
    second = 1,
    /// Flag to represent the "minutes" time unit.
    minute = 2,
    /// Flag to represent the "hours" time unit.
    hour = 4,
    /// Flag to represent the "days" time unit.
    day = 8,
    /// Flag to represent the "months" time unit.
    month = 16,
    /// Flag to represent the "years" time unit.
    year = 32
}

///
alias SECOND_UNIT = TimeUnits.second;
///
alias MINUTE_UNIT = TimeUnits.minute;
///
alias HOUR_UNIT = TimeUnits.hour;
///
alias DAY_UNIT = TimeUnits.day;
///
alias MONTH_UNIT = TimeUnits.month;
///
alias YEAR_UNIT = TimeUnits.year;

/// FIXME: tm was redefined here.

/**
 * Callback type for tick timer events
 *
 * Params:
 * tick_time = the time at which the tick event was triggered
 * units_changed = which unit change triggered this tick event
 */
alias extern(C) void function (tm* tick_time, TimeUnits units_changed) TickHandler;

/**
 * Subscribe to the tick timer event service. Once subscribed, the
 * handler gets called on every requested unit change.
 *
 * Calling this function multiple times will override the units and
 * handler (i.e., only the last tick_units and handler passed will be used).
 *
 * Params:
 * tick_units = A bitmask of all the units that have changed
 * handler = The callback to be executed on tick events
 */
extern(C) void tick_timer_service_subscribe
(TimeUnits tick_units, TickHandler handler);

/**
 * Unsubscribe from the tick timer event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void tick_timer_service_unsubscribe();

/// A reference to a data logging session on Pebble OS.
alias void* DataLoggingSessionRef;

/**
 * The different types of session data that Pebble supports. This type
 * describes the type of a singular item in the data session. Every item in
 * a given session is the same type and size.
 */
enum DataLoggingItemType {
    /**
     * Array of bytes. Remember that this is the type of a single item in the
     * logging session, so using this type means you'll be logging multiple
     * byte arrays (each a fixed length described by item_length) for
     * the duration of the session.
     */
    byte_array = 0,
    /**
     * Unsigned integer. This may be a 1, 2, or 4 byte integer depending on
     * the item_length parameter
     */
    _uint = 2,
    /**
     * Signed integer. This may be a 1, 2, or 4 byte integer depending on
     * the item_length parameter
     */
    _int = 3
}

///
alias DATA_LOGGING_BYTE_ARRAY = DataLoggingItemType.byte_array;
///
alias DATA_LOGGING_UINT = DataLoggingItemType._uint;
///
alias DATA_LOGGING_INT = DataLoggingItemType._int;

/**
 * Enumerated values describing the possible outcomes of data logging
 * operations
 */
enum DataLoggingResult {
    /// Successful operation.
    success = 0,
    /// Someone else is writing to this logging session.
    busy = 1,
    /// No more space to save data.
    full = 2,
    /// The logging session does not exist.
    not_found = 3,
    /// The logging session was made inactive.
    closed = 4,
    /// An invalid parameter was passed to one of the functions.
    invalid_params = 5
}

///
alias DATA_LOGGING_SUCCESS = DataLoggingResult.success;
///
alias DATA_LOGGING_BUSY = DataLoggingResult.busy;
///
alias DATA_LOGGING_FULL = DataLoggingResult.full;
///
alias DATA_LOGGING_NOT_FOUND = DataLoggingResult.not_found;
///
alias DATA_LOGGING_CLOSED = DataLoggingResult.closed;
///
alias DATA_LOGGING_INVALID_PARAMS = DataLoggingResult.invalid_params;

/**
 * Create a new data logging session.
 *
 * Params:
 * tag = A tag associated with the logging session.
 * item_type = The type of data stored in this logging session
 * item_length = The size of a single data item in bytes
 * resume = true if we want to look for a logging session of the same tag and
 *     resume logging to it. If this is false and a session with the specified
 *     tag exists, that session will be closed and a new session will be
 *     opened.
 *
 * Returns: An opaque reference to the data logging session.
 */
extern(C) DataLoggingSessionRef data_logging_create
(uint tag, DataLoggingItemType item_type, ushort item_length, bool resume);


/**
 * Finish up a data logging_session. Logging data is kept until it has
 * successfully been transferred over to the phone, but no data may be added
 * to the session after this function is called.
 *
 * Params:
 * logging_session = a reference to the data logging session previously
 *     allocated using data_logging_create
 */
extern(C) void data_logging_finish(DataLoggingSessionRef logging_session);

/**
 * Add data to the data logging session. If a phone is available,
 * the data is sent directly to the phone. Otherwise, it is saved to the
 * watch storage until the watch is connected to a phone.
 *
 * Params:
 * logging_session = A reference to the data logging session you want to add
 *     the data to.
 * data = A pointer to the data buffer that contains multiple items.
 * num_items = The number of items to log. This means data must be at least
 *     (num_items * item_length) long in bytes.
 *
 *  Returns: DATA_LOGGING_SUCCESS on success.
 *  Returns: DATA_LOGGING_NOT_FOUND if the logging session is invalid.
 *  Returns: DATA_LOGGING_CLOSED if the session is not active.
 *  Returns: DATA_LOGGING_BUSY if the session is not available for writing.
 *  Returns: DATA_LOGGING_INVALID_PARAMS if num_items is 0 or data is NULL.
 */
extern(C) DataLoggingResult data_logging_log
(DataLoggingSessionRef logging_session, const(void)* data, uint num_items);

/**
 * A type used for UUID values.
 */
extern(C) struct Uuid {
align(1):
    ubyte byte0;
    ubyte byte1;
    ubyte byte2;
    ubyte byte3;
    ubyte byte4;
    ubyte byte5;
    ubyte byte6;
    ubyte byte7;
    ubyte byte8;
    ubyte byte9;
    ubyte byte10;
    ubyte byte11;
    ubyte byte12;
    ubyte byte13;
    ubyte byte14;
    ubyte byte15;
}

/// The size of UUIDs.
enum UUID_SIZE = 16;

/// This function mirrors a macro in the C header.
@safe pure
Uuid UuidMake
(ubyte p0, ubyte p1, ubyte p2, ubyte p3, ubyte p4, ubyte p5, ubyte p6,
ubyte p7, ubyte p8, ubyte p9, ubyte p10, ubyte p11, ubyte p12, ubyte p13,
ubyte p14, ubyte p15) {
    return Uuid(
        p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15
    );
}

/**
 * Creates a Uuid from an array of bytes with 16 bytes in Big Endian order.
 *
 * Returns: The created Uuid
 */
@safe pure
Uuid UuidMakeFromBEBytes(ubyte[16] b) {
    return Uuid(
        b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10],
        b[11], b[12], b[13], b[14], b[15]
    );
}

/**
 * Creates a Uuid from an array of bytes with 16 bytes in Little Endian order.
 *
 * Returns: The created Uuid.
 */
@safe pure
Uuid UuidMakeFromLEBytes(ubyte[16] b) {
    return Uuid(
        b[15], b[14], b[13], b[12], b[11], b[10], b[9], b[8],
        b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0]
    );
}

@safe pure
bool uuid_equal(const(Uuid)* uu1, const(Uuid)* uu2) {
    if (uu1 is null) {
        return uu2 is null;
    } else if (uu2 is null) {
        return false;
    }

    return *uu1 == *uu2;
}

/**
 * Writes UUID in a string form into buffer that looks like the following...
 * {12345678-1234-5678-1234-567812345678}
 *
 * Params:
 * uuid = The Uuid to write into the buffer as human-readable string
 * buffer = Memory to write the string to. Must be at least
 * UUID_STRING_BUFFER_LENGTH bytes long.
 */
extern(C) void uuid_to_string(const(Uuid)* uuid, char* buffer);

/// The minimum required length of a string used to hold a uuid
// (including null).
enum UUID_STRING_BUFFER_LENGTH = 32 + 4 + 2 + 1;

/// Suggested log level values
enum AppLogLevel: ubyte {
    error = 1,
    warning = 50,
    info = 100,
    _debug = 200,
    verbose = 255
}

///
alias APP_LOG_LEVEL_ERROR = AppLogLevel.error;
///
alias APP_LOG_LEVEL_WARNING = AppLogLevel.warning;
///
alias APP_LOG_LEVEL_INFO = AppLogLevel.info;
///
alias APP_LOG_LEVEL_DEBUG = AppLogLevel._debug;
///
alias APP_LOG_LEVEL_VERBOSE = AppLogLevel.verbose;

/**
 *  Log an app message.
 *
 *  See_Also: snprinf for defaults about the C formatting string.
 *
 *  Params:
 *  log_level = The log level.
 *  src_filename = The source file where the log originates from.
 *  src_line_number = The line number in the source file where the log
 *  originates from.
 *  fmt = A C formatting string
 *  ... = The arguments for the formatting string
 */
extern(C) void app_log(AppLogLevel log_level, const(char)* src_filename,
int src_line_number, const(char)* fmt, ...);

// TODO: Implement more arguments than just the format string.
/**
 * This function matches the helper macro which comes with Pebble.
 *
 * Params:
 * level = The log level to log output as
 * fmt = A C formatting string
 * args = The arguments for the formatting string
 */
void APP_LOG(AppLogLevel log_level, const(char)* fmt,
int src_line_number = __LINE__, const(char)* src_filename = __FILE__.ptr) {
    app_log(log_level, src_filename, src_line_number, fmt);
}

/// Return values for dictionary write/conversion functions.
enum DictionaryResult {
    /// The operation returned successfully
    ok = 0,
    /// There was not enough backing storage to complete the operation.
    not_enough_storage = 2,
    /// One or more arguments were invalid or uninitialized
    invalid_args= 4,
    /// The lengths and/or count of the dictionary its tuples are inconsistent
    internal_inconsistency = 8,
    /// A requested operation required additional memory to be allocated, but
    /// the allocation failed, likely due to insufficient remaining heap
    /// memory.
    malloc_failed = 16
}

///
alias DICT_OK = DictionaryResult.ok;
///
alias DICT_NOT_ENOUGH_STORAGE = DictionaryResult.not_enough_storage;
///
alias DICT_INVALID_ARGS = DictionaryResult.invalid_args;
///
alias DICT_INTERNAL_INCONSISTENCY = DictionaryResult.internal_inconsistency;
///
alias DICT_MALLOC_FAILED = DictionaryResult.malloc_failed;

/// Values representing the type of data that the `value` field of a
/// Tuple contains.
enum TupleType: ubyte {
    /// The value is an array of bytes.
    byte_array = 0,
    /// The value is a zero-terminated, UTF-8 C-string.
    cstring = 1,
    /// The value is an unsigned integer. The tuple's `.length` field is
    /// used to determine the size of the integer (1, 2, or 4 bytes).
    _uint = 2,
    /// The value is a signed integer. The tuple's `.length` field is used to
    /// determine the size of the integer (1, 2, or 4 bytes).
    _int = 3
}

///
alias TUPLE_BYTE_ARRAY = TupleType.byte_array;
///
alias TUPLE_CSTRING = TupleType.cstring;
///
alias TUPLE_UINT = TupleType._uint;
///
alias TUPLE_INT = TupleType._int;

/**
 * The value itself.
 * The different union fields are provided for convenience,
 * avoiding the need for manual casts.
 *
 * Note: The array length is of incomplete length on purpose, to
 * facilitate variable length data and because a data length of
 * zero is valid.
 *
 * Note: __Important: The integers are little endian!__
 */
union TupleValue {
    /// The byte array value. Valid when `.type` is TUPLE_BYTE_ARRAY.
    uint* data;
    /// The C-string value. Valid when `.type` is TUPLE_CSTRING.
    char* cstring;
    /**
     * The 16-bit unsigned integer value. Valid when `.type` is TUPLE_UINT
     * and `.length` is 2 byte.
     */
    uint uint8;
    ushort uint16;
    /**
     * The 32-bit unsigned integer value. Valid when `.type` is TUPLE_UINT
     * and `.length` is 4 byte.
     */
    uint uint32;
    /**
     * The 8-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 1 byte.
     */
    byte int8;
    /**
     * The 16-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 2 byte.
     */
    short int16;
    /**
     * The 32-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 4 byte.
     */
    int int32;
}


/**
 * Data structure for one serialized key/value tuple
 *
 * Note: The structure is variable length! The length depends on the
 * value data that the tuple contains.
 */
extern(C) struct Tuple {
align(1):
    /// The key
    uint key;
    /// The type of data that the `.value` fields contains.
    TupleType type;
    /// The length of `.value` in bytes.
    ushort length;
    /// The value itself.
    TupleValue value;
}

extern(C) struct Dictionary {};

/**
 * An iterator can be used to iterate over the key/value tuples in an existing
 * dictionary, using dict_read_begin_from_buffer(), dict_read_first()
 * dict_read_next().
 *
 * An iterator can also be used to append key/value tuples to a dictionary,
 * for example using \ref dict_write_data() or \ref dict_write_cstring().
 */
struct DictionaryIterator {
    /// The dictionary being iterated.
    Dictionary* dictionary;
    /// Points to the first memory address after the last byte
    /// of the dictionary.
    const(void)* end;
    /**
     * Points to the next Tuple in the dictionary. Given the end of the
     * Dictionary has not yet been reached: when writing, the next key/value
     * pair will be written at the cursor. When reading, the next call
     * dict_read_next() will return the cursor.
     */
    Tuple* cursor;
}

/// TODO: Implement this function in D.

/**
 * Calculates the number of bytes that a dictionary will occupy, given
 * one or more value lengths that need to be stored in the dictionary.
 *
 * Note: The formula to calculate the size of a Dictionary in bytes is:
 * 1 + (n * 7) + D1 + ... + Dn
 *
 * Where `n` is the number of Tuples in the Dictionary and `Dx` are the sizes
 * of the values in the Tuples. The size of the Dictionary header is 1 byte.
 * The size of the header for each Tuple is 7 bytes.
 *
 * Params:
 * tuple_count = The total number of key/value pairs in the dictionary.
 * ... = The sizes of each of the values that need to be
 *     stored in the dictionary.
 *
 * Returns: The total number of bytes of storage needed.
 */
@trusted pure
extern(C) uint dict_calc_buffer_size(const ubyte tuple_count, ...);

/**
 * Calculates the size of data that has been written to the dictionary.
 *
 * AKA, the "dictionary size". Note that this is most likely different
 * than the size of the backing storage/backing buffer.
 *
 * Params:
 * iter = The dictionary iterator
 *
 * Returns: The total number of bytes which have been written
 * to the dictionary.
 */
@trusted pure
extern(C) uint dict_size(const(DictionaryIterator)* iter);

/**
 * Initializes the dictionary iterator with a given buffer and size,
 * resets and empties it, in preparation of writing key/value tuples.
 *
 * Params:
 * iter = The dictionary iterator.
 * buffer = The storage of the dictionary.
 * size = The storage size of the dictionary.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 *
 * See_Also: dict_calc_buffer_size
 * See_Also: dict_write_end
 */
extern(C) DictionaryResult dict_write_begin
(DictionaryIterator* iter, ubyte* buffer, const ushort size);

/**
 * Adds a key with a byte array value pair to the dictionary.
 *
 * Note: The data will be copied into the backing storage of the dictionary.
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * data = Pointer to the byte array.
 * size = Length of the byte array.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_write_data(DictionaryIterator* iter,
const uint key, const ubyte* data, const ushort size);

/**
 * Adds a key with a C string value pair to the dictionary.
 *
 * Note: The string will be copied into the backing storage of the dictionary.
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * cstring = Pointer to the zero-terminated C string.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_cstring
(DictionaryIterator* iter, const uint key, const char* cstring);

/**
 * Adds a key with an integer value pair to the dictionary.
 *
 * Note: There is _no_ checking for duplicate keys. dict_write_int() is only
 * for serializing a single integer. width_bytes can only be 1, 2, or 4.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * integer = Pointer to the integer value.
 * width_bytes = The width of the integer value.
 * is_signed = Whether the integer's type is signed or not.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_write_int(DictionaryIterator* iter,
const uint key, const(void)* integer, const ubyte width_bytes,
const bool is_signed);

/**
 * Add a key-value pair to the dictionary.
 *
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator
 * key = The key
 * value = The value;
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_uint8
(DictionaryIterator* iter, const uint key, const ubyte value);
/// ditto
extern(C) DictionaryResult dict_write_uint16
(DictionaryIterator* iter, const uint key, const ushort value);
/// ditto
extern(C) DictionaryResult dict_write_uint32
(DictionaryIterator* iter, const uint key, const uint value);
/// ditto
extern(C) DictionaryResult dict_write_int8
(DictionaryIterator* iter, const uint key, const byte value);
/// ditto
extern(C) DictionaryResult dict_write_int16
(DictionaryIterator* iter, const uint key, const short value);
/// ditto
extern(C) DictionaryResult dict_write_int32
(DictionaryIterator* iter, const uint key, const int value);

/**
 * End a series of writing operations to a dictionary.
 *
 * This must be called before reading back from the dictionary.
 *
 * Params:
 * iter = The dictionary iterator
 *
 * Returns: The size in bytes of the finalized dictionary, or 0 if the
 * parameters were invalid.
 */
extern(C) uint dict_write_end (DictionaryIterator* iter);

private void checkDictionaryResult(DictionaryResult result) {
    switch (result) {
    case DICT_NOT_ENOUGH_STORAGE:
        assert(false, "Not enough storage for a dictionary!");
    case DICT_INVALID_ARGS:
        assert(false, "Invalid arguments for dict_write!");
    default:
        assert(false, "This should never be reached.");
    }
}

// TODO: Write 'dict_write' as a wrapper with assertions.

/// A wrapper function for conveniently writing to a dictionary iterator.
void write(DictionaryIterator* iter, const uint key,
const ubyte* data, const ushort size) {
    checkDictionaryResult(dict_write_data(iter, key, data, size));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ubyte[] data) {
    checkDictionaryResult(dict_write_data(iter, key, data.ptr, cast(ushort) data.length));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const char* cstring) {
    checkDictionaryResult(dict_write_cstring(iter, key, cstring));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ubyte value) {
    checkDictionaryResult(dict_write_uint8(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ushort value) {
    checkDictionaryResult(dict_write_uint16(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const uint value) {
    checkDictionaryResult(dict_write_uint32(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const byte value) {
    checkDictionaryResult(dict_write_int8(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const short value) {
    checkDictionaryResult(dict_write_int16(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const int value) {
    checkDictionaryResult(dict_write_int32(iter, key, value));
}


/**
 * Initializes the dictionary iterator with a given buffer and size,
 * in preparation of reading key/value tuples.
 *
 * Params:
 * iter = The dictionary iterator
 * buffer = The storage of the dictionary
 * size = The storage size of the dictionary
 *
 * Returns: The first tuple in the dictionary, or NULL in case the
 * dictionary was empty or if there was a parsing error.
 */
extern(C) Tuple* dict_read_begin_from_buffer
(DictionaryIterator* iter, const ubyte* buffer, const ushort size);

/**
 * Progresses the iterator to the next key/value pair.
 *
 * Params:
 * iter The dictionary iterator
 *
 * Returns: The next tuple in the dictionary, or NULL in case the end has
 * been reached or if there was a parsing error.
 */
extern(C) Tuple* dict_read_next(DictionaryIterator* iter);

/**
 * Resets the iterator back to the same state as a call to
 * dict_read_begin_from_buffer() would do.
 *
 * Params:
 * iter = The dictionary iterator.
 *
 * Returns: The first tuple in the dictionary, or NULL in case the dictionary
 * was empty or if there was a parsing error.
 */
extern(C) Tuple* dict_read_first(DictionaryIterator* iter);

///
struct TupletBytesType {
    /// Pointer to the data
    const (ubyte)* data;
    /// Length of the data
    const ushort length;

    /**
     * Return a slice using the length in the struct.
     *
     * Returns: A slice of the memory.
     */
    @system pure
    const(ubyte)[] slice() const {
        return data[0 .. (length - 1)];
    }
}

///
struct TupletCStringType {
    /// Pointer to the c-string data.
    const (char)* data;
    /// Length of the c-string, including terminating zero.
    const ushort length;

    /**
     * Return the C-string value from this tuplet as a slice of memory,
     * using the length in the struct.
     *
     * Returns: A slice of the character memory.
     */
    @system pure
    const(char)[] slice() const {
        return data[0 .. (length - 1)];
    }
}

///
struct TupletIntType {
    /// Actual storage of the integer.
    /// The signedness can be derived from the `.type` value.
    uint storage;
    /// Width of the integer.
    const ushort width;
}

/**
 * Non-serialized, template data structure for a key/value pair.
 *
 * For strings and byte arrays, it only has a pointer to the actual data.
 * For integers, it provides storage for integers up to 32-bits wide.
 * The Tuplet data structure is useful when creating dictionaries from values
 * that are already stored in arbitrary buffers.
 *
 * See_Also: Tuple, which is the header of a serialized key/value pair.
 */
extern(C) struct Tuplet {
    /**
     * The type of the Tuplet. This determines which of the struct
     * fields in the anonymous union are valid.
     */
    TupleType type;
    /// The key.
    uint key;

    /**
     * Anonymous union containing the reference to the Tuplet's value, being
     * either a byte array, c-string or integer. See documentation of `.bytes`,
     * `.cstring` and `.integer` fields.
     */
    union {
        /// Valid when `.type.` is TUPLE_BYTE_ARRAY.
        TupletBytesType bytes;
        /// Valid when `.type.` is TUPLE_CSTRING.
        TupletCStringType cstring;
        /// Valid when `.type.` is TUPLE_INT or TUPLE_UINT
        TupletIntType integer;
    }

    /**
     * Create a Tuplet with a byte array value.
     *
     * Params:
     * key = The key
     * data = Pointer to the bytes
     * length = Length of the buffer
     */
    @nogc @safe pure nothrow
    this(uint key, const(ubyte)* data, const ushort length) {
        this.type = TUPLE_BYTE_ARRAY;
        this.key = key;
        this.bytes = TupletBytesType(data, length);
    }

    /**
     * Create a Tuplet with a byte array slice.
     *
     * Params:
     * key = The key
     * data = A slice of bytes.
     */
    @nogc @safe pure nothrow
    this(uint key, const(ubyte)[] data) {
        this(key, data.ptr, cast(ushort) data.length);
    }

    /**
     * Create a Tuplet with a c-string value
     *
     * Params:
     * key = The key
     * cstring = The c-string value
     */
    @nogc @trusted pure nothrow
    this(uint key, const (char)* cstring) {
        this.type = TUPLE_CSTRING;
        this.key = key;

        if (cstring !is null) {
            this.cstring = TupletCStringType(
                cstring,
                cast(ushort)(strlen(cstring) + 1)
            );
        } else {
            this.cstring = TupletCStringType(null, 0);
        }
    }

    /**
     * Create a Tuplet with an integer value.
     *
     * Params:
     * key = The key
     * integer = The integer value
     */
    @nogc @trusted pure nothrow
    this(uint key, ubyte integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, ubyte.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, byte integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, byte.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, ushort integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, ushort.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, short integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, short.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, uint integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, uint.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, int integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, int.sizeof);
    }
}



/**
 * Create a Tuplet with a byte array value.
 *
 * Params:
 * key = The key
 * data = Pointer to the bytes
 * length = Length of the buffer
 */
deprecated("Use the matching constructor for Tuplet instead.")
@safe pure
Tuplet TupletBytes(uint key, const (ubyte)* data, const ushort length) {
    return Tuplet(key, data, length);
}

/**
 * Create a Tuplet with a c-string value
 *
 * Params:
 * key = The key
 * cstring = The c-string value
 */
@trusted pure
deprecated("Use the matching constructor for Tuplet instead.")
Tuplet TupletCString(uint key, const(char*) cstring) {
    return Tuplet(key, cstring);
}

/**
 * Create a Tuplet with an integer value.
 *
 * Params:
 * key = The key
 * integer = The integer value
 */
@safe pure
deprecated("Use the matching constructor for Tuplet instead.")
Tuplet TupletInteger(uint key, ubyte integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, byte integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, ushort integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, short integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, uint integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, int integer) {
    return Tuplet(key, integer);
}

/**
 * Callback for \ref dict_serialize_tuplets() utility.
 *
 * Params:
 * data = The data of the serialized dictionary
 * size = The size of data
 * context = The context pointer as passed in to dict_serialize_tuplets()
 *
 * See_Also: dict_serialize_tuplets
 */
alias extern(C) void function (const(ubyte)* data, ushort size, void* context)
DictionarySerializeCallback;

/**
 * Utility function that takes a list of Tuplets from which a dictionary
 * will be serialized, ready to transmit or store.
 *
 * Note: The callback will be called before the function returns, so
 * the data the that `context` points to, can be stack allocated.
 *
 * Params:
 * callback = The callback that will be called with the serialized data of the
 *     generated dictionary.
 * context = Pointer to any application specific data that gets passed into
 *     the callback.
 * tuplets = An array of Tuplets that need to be serialized into the
 *     dictionary.
 * tuplets_count = The number of tuplets that follow.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_serialize_tuplets
(DictionarySerializeCallback callback, void* context, const Tuplet* tuplets,
const ubyte tuplets_count);

/**
 * Utility function that takes an array of Tuplets and serializes them into
 * a dictionary with a given buffer and size.
 *
 * Params:
 * tuplets = The array of tuplets
 * tuplets_count = The number of tuplets in the array
 * buffer = The buffer in which to write the serialized dictionary
 * size_in_out = The buffer size in bytes will be taken here, and the value
 *     given here will be set to the number of bytes written.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_serialize_tuplets_to_buffer
(const Tuplet* tuplets, const ubyte tuplets_count, ubyte* buffer,
uint* size_in_out);

/**
 * Serializes an array of Tuplets into a dictionary with a given buffer and
 * size.
 *
 * Params:
 * iter = The dictionary iterator.
 * tuplets = The array of tuplets.
 * tuplets_count = The number of tuplets in the array.
 * buffer = The buffer in which to write the serialized dictionary.
 * size_in_out = The buffer size in bytes will be taken here, and the value
 *     given here will be set to the number of bytes written.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_serialize_tuplets_to_buffer_with_iter
(DictionaryIterator* iter, const Tuplet* tuplets, const ubyte tuplets_count,
ubyte* buffer, uint* size_in_out);

/**
 * Serializes a Tuplet and writes the resulting Tuple into a dictionary.
 *
 * Params:
 * iter = The dictionary iterator.
 * tuplet = The Tuplet describing the key/value pair to write.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_tuplet
(DictionaryIterator* iter, const Tuplet* tuplet);

/**
 * Calculates the number of bytes that a dictionary will occupy, given
 * one or more Tuplets that need to be stored in the dictionary.
 *
 * Note: See dict_calc_buffer_size() for the formula for the calculation.
 *
 * Params:
 * tuplets = An array of Tuplets that need to be stored in the dictionary.
 * tuplets_count = The total number of Tuplets that follow.
 *
 * Returns: The total number of bytes of storage needed.
 * See_Also: Tuplet
 */
extern(C) uint dict_calc_buffer_size_from_tuplets
(const Tuplet* tuplets, const ubyte tuplets_count);

/**
 * Type of the callback used in dict_merge().
 *
 * Params:
 * key = The key that is being updated.
 * new_tuple = The new tuple. The tuple points to the actual,
 *     updated destination dictionary or NULL_TUPLE in case there was an
 *     error (e.g. backing buffer was too small).  Therefore the Tuple can be
 *     used after the callback returns, until the destination dictionary
 *     storage is free'd (by the application itself).
 * old_tuple = The values that will be replaced with `new_tuple`.
 *     The key, value and type will be equal to the previous tuple in the
 *     old destination dictionary, however the `old_tuple points to a
 *     stack-allocated copy of the old data.
 * context = Pointer to application specific data. The storage backing
 *     `old_tuple` can only be used during the callback and will no longer be
 *     valid after the callback returns.
 *
 * See_Also: dict_merge
 */
alias extern(C) void function
(uint key, const(Tuple)* new_tuple, const(Tuple)* old_tuple, void* context)
DictionaryKeyUpdatedCallback;

/**
 * Merges entries from another "source" dictionary into a "destination"
 * dictionary.
 *
 * All Tuples from the source are written into the destination dictionary,
 * while updating the exsting Tuples with matching keys.
 *
 * Params:
 * dest = The destination dictionary to update
 * dest_max_size_in_out = In: the maximum size of buffer backing `dest`.
 *     Out: the final size of the updated dictionary.
 * source = The source dictionary of which its Tuples will be used to
 *     update dest.
 * update_existing_keys_only = Specify True if only the existing keys in
 *     `dest` should be updated.
 * key_callback = The callback that will be called for each Tuple in the
 *     merged destination dictionary.
 * context = Pointer to app specific data that will get passed in when
 *     `update_key_callback` is called.
 *
 * Returns: DICT_OK, DICT_INVALID_ARGS, DICT_NOT_ENOUGH_STORAGE
 */
extern(C) DictionaryResult dict_merge(DictionaryIterator* dest,
uint* dest_max_size_in_out, DictionaryIterator* source,
const bool update_existing_keys_only,
const DictionaryKeyUpdatedCallback key_callback, void* context);

/**
 * Tries to find a Tuple with specified key in a dictionary.
 *
 * Params:
 * iter = Iterator to the dictionary to search in.
 * key = The key for which to find a Tuple.
 *
 * Returns: Pointer to a found Tuple, or NULL if there was no Tuple with
 *     the specified key.
 */
extern(C) Tuple* dict_find(const(DictionaryIterator)* iter, const uint key);

/// AppMessage result codes.
enum AppMessageResult {
    /// All good, operation was successful.
    ok = 0,
    /// The other end did not confirm receiving the sent data with an
    /// (n)ack in time.
    sendTimeout = 2,
    /// The other end rejected the sent data, with a "nack" reply.
    sendRejected = 4,
    /// The other end was not connected.
    notConnected = 8,
    /// The local application was not running.
    notRunning = 16,
    /// The function was called with invalid arguments.
    invalidArgs = 32,
    /// There are pending (in or outbound) messages that need to be
    //processed first before new ones can be received or sent.
    busy = 64,
    /// The buffer was too small to contain the incoming message.
    overflow = 128,
    /// The resource had already been released.
    alreadyReleased = 512,
    /// The callback node was already registered, or its ListNode
    /// has not been initialized.
    callbackAlreadyRegistered = 1024,
    /// The callback could not be deregistered, because it had not
    /// been registered before.
    callbackNotRegistered = 2048,
    /// The support library did not have sufficient application memory
    /// to perform the requested operation.
    outOfMemory = 4096,
    /// App message was closed.
    closed = 8192,
    /// An internal OS error prevented APP_MSG from completing an operation.
    internalError = 16384
}

///
alias APP_MSG_OK = AppMessageResult.ok;
///
alias APP_MSG_SEND_TIMEOUT = AppMessageResult.sendTimeout;
///
alias APP_MSG_SEND_REJECTED = AppMessageResult.sendRejected;
///
alias APP_MSG_NOT_CONNECTED = AppMessageResult.notConnected;
///
alias APP_MSG_APP_NOT_RUNNING = AppMessageResult.notRunning;
///
alias APP_MSG_INVALID_ARGS = AppMessageResult.invalidArgs;
///
alias APP_MSG_BUSY = AppMessageResult.busy;
///
alias APP_MSG_BUFFER_OVERFLOW = AppMessageResult.overflow;
///
alias APP_MSG_ALREADY_RELEASED = AppMessageResult.alreadyReleased;
///
alias APP_MSG_CALLBACK_ALREADY_REGISTERED =
    AppMessageResult.callbackAlreadyRegistered;
///
alias APP_MSG_CALLBACK_NOT_REGISTERED = AppMessageResult.callbackNotRegistered;
///
alias APP_MSG_OUT_OF_MEMORY = AppMessageResult.outOfMemory;
///
alias APP_MSG_CLOSED = AppMessageResult.closed;
///
alias APP_MSG_INTERNAL_ERROR = AppMessageResult.internalError;

/**
 * Open AppMessage to transfers.
 *
 * Use dict_calc_buffer_size_from_tuplets() or dict_calc_buffer_size()
 * to estimate the size you need.
 *
 * Note: It is recommended that if the Inbox will be used, that at least the
 * Inbox callbacks should be registered before this call. Otherwise it is
 * possible for an Inbox message to be NACK'ed without being seen by the
 * application.
 *
 * Params:
 * size_inbound = The required size for the Inbox buffer.
 * size_outbound = The required size for the Outbox buffer.
 *
 * Returns: A result code such as APP_MSG_OK or APP_MSG_OUT_OF_MEMORY.
 */
extern(C) AppMessageResult app_message_open
(const uint size_inbound, const uint size_outbound);

/// Deregisters all callbacks and their context.
extern(C) void app_message_deregister_callbacks();

/**
 * Called after an incoming message is received.
 *
 * Params:
 * iterator = The dictionary iterator to the received message.
 *     Never NULL. Note that the iterator cannot be modified or
 *     saved off. The library may need to re-use the buffered space where
 *     this message is supplied.  Returning from the callback indicates to the
 *     library that the received message contents are no longer needed or
 *     have already been externalized outside its buffering space and iterator.
 * context = Pointer to application data as specified when registering the
 *     callback.
 */
alias extern(C) void function (DictionaryIterator* iterator, void* context)
AppMessageInboxReceived;

/**
 * Called after an incoming message is dropped.
 *
 * Params:
 * result = The reason why the message was dropped.
 *     Some possibilities include APP_MSG_BUSY and APP_MSG_BUFFER_OVERFLOW.
 * context = Pointer to application data as specified when registering the
 * callback.
 *
 * Note that you can call app_message_outbox_begin() from this handler to
 * prepare a new message. This will invalidate the previous dictionary
 * iterator; do not use it after calling app_message_outbox_begin().
 */
alias extern(C) void function(AppMessageResult reason, void* context)
AppMessageInboxDropped;

/**
 * Called after an outbound message has been sent and the reply has been
 * received.
 *
 * Params:
 * iterator = The dictionary iterator to the sent message. The iterator will
 *     be in the final state that was sent. Note that the iterator cannot be
 *     modified or saved off as the library will re-open the dictionary with
 *     dict_begin() after this callback returns.
 * context = Pointer to application data as specified when registering the
 *     callback.
 */
alias extern(C) void function(DictionaryIterator* iterator, void* context)
AppMessageOutboxSent;

/**
 * Called after an outbound message has not been sent successfully.
 *
 * Note that you can call app_message_outbox_begin() from this handler to
 * prepare a new message. This will invalidate the previous dictionary
 * iterator; do not use it after calling app_message_outbox_begin().
 *
 * Params:
 * iterator = The dictionary iterator to the sent message. The iterator will
 *     be in the final state that was sent. Note that the iterator cannot be
 *     modified or saved off as the library will re-open the dictionary with
 *     dict_begin() after this callback returns.
 * result = The result of the operation. Some possibilities for the value
 *     include \ref APP_MSG_SEND_TIMEOUT, APP_MSG_SEND_REJECTED,
 *     APP_MSG_NOT_CONNECTED, APP_MSG_APP_NOT_RUNNING, and the combination
 *     `(APP_MSG_NOT_CONNECTED | APP_MSG_APP_NOT_RUNNING)`.
 * context = Pointer to application data as specified when registering the
 *     callback.
 */
alias extern(C) void function(DictionaryIterator* iterator,
AppMessageResult reason, void* context) AppMessageOutboxFailed;

/**
 * Gets the context that will be passed to all AppMessage callbacks.
 *
 * Returns: The current context on record.
 */
extern(C) void* app_message_get_context();

/**
 * Sets the context that will be passed to all AppMessage callbacks.
 *
 * Params:
 * context = The context that will be passed to all AppMessage callbacks.
 *
 * Returns: The previous context that was on record.
 */
extern(C) void* app_message_set_context(void* context);

/**
 * Registers a function that will be called after any Inbox message is
 * received successfully.
 *
 * Only one callback may be registered at a time. Each subsequent call to this
 * function will replace the previous callback. The callback is optional;
 * setting it to NULL will deregister the current callback and no function will
 * be called anymore.
 *
 * Params:
 * received_callback = The callback that will be called going forward; NULL to
 *     not have a callback.
 *
 * Returns: The previous callback (or NULL) that was on record.
 */
extern(C) AppMessageInboxReceived app_message_register_inbox_received
(AppMessageInboxReceived received_callback);

/**
 * Registers a function that will be called after any Inbox message is
 * received but dropped by the system.
 *
 * Only one callback may be registered at a time. Each subsequent call to this
 * function will replace the previous callback. The callback is optional;
 * setting it to NULL will deregister the current callback and no function will
 * be called anymore.
 *
 * Params:
 * dropped_callback = The callback that will be called going forward;
 *     NULL to not have a callback.
 *
 * Returns: The previous callback (or NULL) that was on record.
 */
extern(C) AppMessageInboxDropped app_message_register_inbox_dropped
(AppMessageInboxDropped dropped_callback);

/**
 * Registers a function that will be called after any Outbox message is sent
 * and an ACK reply occurs in a timely fashion.
 *
 * Only one callback may be registered at a time. Each subsequent call to this
 * function will replace the previous callback. The callback is optional;
 * setting it to NULL will deregister the current callback and no function will
 * be called anymore.
 *
 * Params:
 * sent_callback = The callback that will be called going forward; NULL to not
 *     have a callback.
 *
 * Returns: The previous callback (or NULL) that was on record.
 */
extern(C) AppMessageOutboxSent app_message_register_outbox_sent
(AppMessageOutboxSent sent_callback);

/**
 * Registers a function that will be called after any Outbox message is not
 * sent with a timely ACK reply. The call to \ref app_message_outbox_send()
 * must have succeeded.
 *
 * Only one callback may be registered at a time. Each subsequent call to this
 * function will replace the previous callback. The callback is optional;
 * setting it to NULL will deregister the current callback and no function will
 * be called anymore.
 *
 * Params:
 * failed_callback = The callback that will be called going forward; NULL to
 *     not have a callback.
 *
 * Returns: The previous callback (or NULL) that was on record.
 */
extern(C) AppMessageOutboxFailed app_message_register_outbox_failed
(AppMessageOutboxFailed failed_callback);

/**
 * Programatically determine the inbox size maximum in the current
 * configuration.
 *
 * Returns: The inbox size maximum on this firmware.
 *
 * See_Also: APP_MESSAGE_INBOX_SIZE_MINIMUM
 * See_Also: app_message_outbox_size_maximum()
 */
extern(C) uint app_message_inbox_size_maximum();

/**
 * Programatically determine the outbox size maximum in the current
 * configuration.
 *
 * Returns: The outbox size maximum on this firmware.
 *
 * See_Also: APP_MESSAGE_OUTBOX_SIZE_MINIMUM
 * See_Also: app_message_inbox_size_maximum()
 */
extern(C) uint app_message_outbox_size_maximum();

/**
 * Begin writing to the Outbox's Dictionary buffer.
 *
 * Note: After a successful call, one can add values to the dictionary using
 * functions like dict_write_data() and friends.
 *
 * Params:
 * iterator = Location to write the DictionaryIterator pointer.
 *     This will be NULL on failure.
 *
 * Returns: A result code, including but not limited to APP_MSG_OK,
 *     APP_MSG_INVALID_ARGS or APP_MSG_BUSY.
 *
 * See_Also: Dictionary
 */
extern(C) AppMessageResult app_message_outbox_begin
(DictionaryIterator** iterator);

/**
 * Sends the outbound dictionary.
 *
 * Returns: A result code, including but not limited to APP_MSG_OK or
 *     APP_MSG_BUSY. The APP_MSG_OK code does not mean that the message was
 *     sent successfully, but only that the start of processing was successful.
 *     Since this call is asynchronous, callbacks provide the final result
 *     instead.
 *
 * See_Also: AppMessageOutboxSent
 * See_Also: AppMessageOutboxFailed
 */
extern(C) AppMessageResult app_message_outbox_send();

/**
 * As long as the firmware maintains its current major version, inboxes of
 * this size or smaller will be allowed.
 *
 * See_Also: app_message_inbox_size_maximum()
 * See_Also: APP_MESSAGE_OUTBOX_SIZE_MINIMUM
 */
enum size_t APP_MESSAGE_INBOX_SIZE_MINIMUM = 124;

/**
 * As long as the firmware maintains its current major version, outboxes of
 * this size or smaller will be allowed.
 *
 * See_Also: app_message_outbox_size_maximum()
 * See_Also: APP_MESSAGE_INBOX_SIZE_MINIMUM
 */
enum size_t APP_MESSAGE_OUTBOX_SIZE_MINIMUM = 636;

/**
 * Called whenever a Tuple changes. This does not necessarily mean the value
 * in the Tuple has changed. When the internal "current" dictionary gets
 * updated, existing Tuples might get shuffled around in the backing buffer,
 * even though the values stay the same. In this callback, the client code
 * gets the chance to remove the old reference and start using the new one.
 * In this callback, your application MUST clean up any references to the
 * `old_tuple` of a PREVIOUS call to this callback (and replace it with the
 * `new_tuple` that is passed in with the current call).
 *
 * Params:
 * key = The key for which the Tuple was changed.
 * new_tuple = The new tuple. The tuple points to the actual, updated
 *     "current" dictionary, as backed by the buffer internal to the AppSync
 *     struct. Therefore the Tuple can be used after the callback returns,
 *     until the AppSync is deinited. In case there was an error
 *     (e.g. storage shortage), this `new_tuple` can be `NULL_TUPLE`.
 * old_tuple = The values that will be replaced with `new_tuple`. The key,
 *     value and type will be equal to the previous tuple in the old
 *     destination dictionary; however, the `old_tuple` points to a
 *     stack-allocated copy of the old data. This value will be `NULL_TUPLE`
 *     when the initial values are being set.
 * context = Pointer to application specific data, as set using
 *     app_sync_init().
 *
 * See_Also: app_sync_init()
 */
alias extern(C) void function
(uint key, const(Tuple)* new_tuple, const(Tuple)* old_tuple, void* context)
AppSyncTupleChangedCallback;

/**
 * Called whenever there was an error.
 *
 * Params:
 * dict_error = The dictionary result error code, if the error was dictionary
 *     related.
 * app_message_error = The app_message result error code, if the error was
 *     app_message related.
 * context = Pointer to application specific data, as set using
 *     app_sync_init().
 *
 * See_Also: app_sync_init()
 */
alias extern(C) void function(DictionaryResult dict_error,
AppMessageResult app_message_error, void* context) AppSyncErrorCallback;

/// The callback type for an AppSync context.
struct CallbackType {
    /// The callback for a value being changed.
    AppSyncTupleChangedCallback value_changed;
    /// The sync error callback.
    AppSyncErrorCallback error;
    /// The callback context.
    void* context;
}

/// An AppSync context.
struct AppSync {
    /// The current dictionary iterator.
    DictionaryIterator current_iter;

    union {
        /// The current dictionary.
        Dictionary* current;
        /// The buffer.
        ubyte* buffer;
    }

    /// The size of the buffer.
    ushort buffer_size;
    /// The callback
    CallbackType callback;
}

/**
 * Initialized an AppSync system with specific buffer size and initial keys
 * and values. The `callback.value_changed` callback will be called
 * __asynchronously__ with the initial keys and values, as to avoid
 * duplicating code to update your app's UI.
 *
 * Note: Only updates for the keys specified in this initial array will be
 * accepted by AppSync, updates for other keys that might come in will just be
 * ignored.
 *
 * Params:
 * s = The AppSync context to initialize.
 * buffer = The buffer that AppSync should use.
 * buffer_size = The size of the backing storage of the "current" dictionary.
 *     Use dict_calc_buffer_size_from_tuplets() to estimate the size you need.
 * keys_and_initial_values = An array of Tuplets with the initial keys and
 *     values.
 * count = The number of Tuplets in the `keys_and_initial_values` array.
 * tuple_changed_callback = The callback that will handle changed
 *     key/value pairs.
 * error_callback = The callback that will handle errors.
 * context = Pointer to app specific data that will get passed into calls
 *     to the callbacks.
 */
extern(C) void app_sync_init(AppSync* s, ubyte* buffer,
const ushort buffer_size, const Tuplet* keys_and_initial_values,
const ubyte count, AppSyncTupleChangedCallback tuple_changed_callback,
AppSyncErrorCallback error_callback, void* context);

/**
 * Cleans up an AppSync system. It frees the buffer allocated by an
 * app_sync_init() call and deregisters itself from the AppMessage subsystem.
 *
 * Params:
 * s = The AppSync context to deinit.
 */
extern(C) void app_sync_deinit(AppSync* s);

/**
 * Updates key/value pairs using an array of Tuplets.
 *
 * Note: The call will attempt to send the updated keys and values to the
 * application on the other end.
 *
 * Only after the other end has acknowledged the update, the `.value_changed`
 * callback will be called to confirm the update has completed and your
 * application code can update its user interface.
 *
 * Params:
 * s = The AppSync context.
 * keys_and_values_to_update = An array of Tuplets with the keys and
 *     values to update. The data in the Tuplets are copied during the call,
 *     so the array can be stack-allocated.
 * count = The number of Tuplets in the `keys_and_values_to_update` array.
 *
 * Returns: The result code from the AppMessage subsystem. Can be
 *     APP_MSG_OK, APP_MSG_BUSY or APP_MSG_INVALID_ARGS.
 */
extern(C) AppMessageResult app_sync_set
(AppSync* s, const Tuplet* keys_and_values_to_update, const ubyte count);

/**
 * Finds and gets a tuple in the "current" dictionary.
 *
 * Params:
 * s = The AppSync context
 * key = The key for which to find a Tuple.
 *
 * Returns: Pointer to a found Tuple, or NULL if there was no Tuple with the
 *     specified key.
 */
extern(C) const(Tuple)* app_sync_get(const(AppSync)* s, const uint key);

struct ResourceHandleType {}

/**
 * Opaque reference to a resource.
 *
 * See_Also: resource_get_handle()
 */
alias ResourceHandleType* ResHandle;

// TODO: Define this.
// #define RESOURCE_ID_FONT_FALLBACK RESOURCE_ID_GOTHIC_14

/**
 * Gets the resource handle for a file identifier.
 *
 * The resource IDs are auto-generated by the Pebble build process, based
 * on the `appinfo.json`. The "name" field of each resource is prefixed
 * by `RESOURCE_ID_` and made visible to the application (through the
 * `build/src/resource_ids.auto.h` header which is automatically included).
 *
 * For example, given the following fragment of `appinfo.json`:
 *     ...
 *     "resources" : {
 *         "media": [
 *             {
 *                 "name": "MY_ICON",
 *                 "file": "img/icon.png",
 *                 "type": "png",
 *             },
 *          ...
 *
 * The generated file identifier for this resource is `RESOURCE_ID_MY_ICON`.
 * To get a resource handle for that resource write:
 *
 * ResHandle rh = resource_get_handle(RESOURCE_ID_MY_ICON);
 *
 * Params:
 * resource_id = The resource ID.
 */
extern(C) ResHandle resource_get_handle(uint resource_id);

/**
 * Gets the size of the resource given a resource handle.
 *
 * Params:
 * h = The handle to the resource
 *
 * Returns: The size of the resource in bytes.
 */
extern(C) size_t resource_size(ResHandle h);

/**
 * Copies the bytes for the resource with a given handle from flash storage
 * into a given buffer.
 *
 * Params:
 * h = The handle to the resource.
 * buffer = The buffer to load the resource data into.
 * max_length = The maximum number of bytes to copy.
 *
 * Returns: The number of bytes actually copied.
 */
extern(C) size_t resource_load(ResHandle h, ubyte* buffer, size_t max_length);

/**
 * Copies a range of bytes from a resource with a given handle into a
 * given buffer.
 *
 * Params:
 * h = The handle to the resource.
 * start_offset = The offset in bytes at which to start reading from the
 *     resource.
 * buffer = The buffer to load the resource data into.
 * num_bytes = The maximum number of bytes to copy.
 *
 * Returns: The number of bytes actually copied.
 */
extern(C) size_t resource_load_byte_range
(ResHandle h, uint start_offset, ubyte* buffer, size_t num_bytes);

/**
 * The event loop for apps, to be used in app's main().
 * Will block until the app is ready to exit.
 */
extern(C) void app_event_loop();

/// Possible error codes from app_worker_launch, app_worker_kill.
enum AppWorkerResult {
    /// Success.
    success = 0,
    /// No worker found for the current app.
    noWorker = 1,
    /// A worker for a different app is already running.
    differentApp = 2,
    /// The worker is not running.
    notRunning = 3,
    /// The worker is already running.
    alreadyRunning = 4,
    /// The user will be asked for confirmation.
    askingConfirmation = 5
}

///
alias APP_WORKER_RESULT_SUCCESS = AppWorkerResult.success;
///
alias APP_WORKER_RESULT_NO_WORKER = AppWorkerResult.noWorker;
///
alias APP_WORKER_RESULT_DIFFERENT_APP = AppWorkerResult.differentApp;
///
alias APP_WORKER_RESULT_NOT_RUNNING = AppWorkerResult.notRunning;
///
alias APP_WORKER_RESULT_ALREADY_RUNNING = AppWorkerResult.alreadyRunning;
///
alias APP_WORKER_RESULT_ASKING_CONFIRMATION =
    AppWorkerResult.askingConfirmation;

/**
 * Generic structure of a worker message that can be sent between an app and
 * its worker.
 */
struct AppWorkerMessage {
    ushort data0;
    ushort data1;
    ushort data2;
}

/**
 * Determine if the worker for the current app is running
 *
 * Returns: true if running.
 */
extern(C) bool app_worker_is_running();

/**
 * Launch the worker for the current app. Note that this is an asynchronous
 * operation, a result code of APP_WORKER_RESULT_SUCCESS merely means that the
 * request was successfully queued up.
 *
 * Returns: result code.
 */
extern(C) AppWorkerResult app_worker_launch();

/**
 * Kill the worker for the current app. Note that this is an asynchronous
 * operation, a result code of APP_WORKER_RESULT_SUCCESS merely means that the
 * request was successfully queued up.
 *
 * Returns: result code
 */
extern(C) AppWorkerResult app_worker_kill();

/**
 * Callback type for worker messages. Messages can be sent from worker to
 * app or vice versa.
 *
 * Params:
 * type = An application defined message type
 * data = pointer to message data. The receiver must know the structure of
 * the data provided by the sender.
 */
alias extern(C) void function(ushort type, AppWorkerMessage* data)
AppWorkerMessageHandler;

/**
 * Subscribe to worker messages. Once subscribed, the handler gets called on
 * every message emitted by the other task (either worker or app).
 *
 * Params:
 * handler = A callback to be executed when the event is received.
 *
 * Returns: true on success.
 */
extern(C) bool app_worker_message_subscribe(AppWorkerMessageHandler handler);

/**
 * Unsubscribe from worker messages. Once unsubscribed, the previously
 * registered handler will no longer be called.
 *
 * Returns: true on success
 */
extern(C) bool app_worker_message_unsubscribe();

/**
 * Send a message to the other task (either worker or app).
 *
 * Params:
 * type = An application defined message type.
 * data = the message data structure.
 */
extern(C) void app_worker_send_message(ubyte type, AppWorkerMessage* data);

/**
 * Intervals during which the Bluetooth module may enter a low power mode.
 * The sniff interval defines the period during which the Bluetooth module may
 * not exchange (ACL) packets. The longer the sniff interval, the more time the
 * Bluetooth module may spend in a low power mode.
 *
 * It may be necessary to reduce the sniff interval if an app requires reduced
 * latency when sending messages.
 *
 * Note: These settings have a dramatic effect on the Pebble's energy
 * consumption. Use the normal sniff interval whenever possible.
 * Note, however, that switching between modes increases power consumption
 * during the process. Frequent switching between modes is thus
 * discouraged. Ensure you do not drop to normal frequently.
 * The Bluetooth module is a major consumer of the Pebble's energy.
 */
enum SniffInterval {
    ///
    normal = 0,
    ///
    reduced = 1
}

///
alias SNIFF_INTERVAL_NORMAL = SniffInterval.normal;
///
alias SNIFF_INTERVAL_REDUCED = SniffInterval.reduced;

/**
 * Set the Bluetooth module's sniff interval.
 *
 * The sniff interval will be restored to normal by the OS after the app's
 * de-init handler is called. Set the sniff interval to normal whenever
 * possible.
 */
extern(C) void app_comm_set_sniff_interval(const SniffInterval interval);

/**
 * Get the Bluetooth module's sniff interval.
 *
 * Returns: The SniffInterval value corresponding to the current interval.
 */
extern(C) SniffInterval app_comm_get_sniff_interval();

/**
 * Waits for a certain amount of milliseconds
 *
 * Params:
 * millis = The number of milliseconds to wait for.
 */
extern(C) void psleep(int millis);

struct AppTimer {}

/**
 * The type of function which can be called when a timer fires.
 *
 * Params:
 * data = The callback data passed to app_timer_register().
 */
alias extern(C) void function (void* data) AppTimerCallback;

/**
 * Registers a timer that ends up in callback being called some
 * specified time in the future.
 *
 * Params:
 * timeout_ms = The expiry time in milliseconds from the current time.
 * callback = The callback that gets called at expiry time.
 * callback_data = The data that will be passed to callback.
 *
 * Returns: A pointer to an `AppTimer` that can be used to later reschedule
 *     or cancel this timer
 */
extern(C) AppTimer* app_timer_register
(uint timeout_ms, AppTimerCallback callback, void* callback_data);

/**
 * Reschedules an already running timer for some point in the future.
 *
 * Params:
 * timer_handle = The timer to reschedule.
 * new_timeout_ms = The new expiry time in milliseconds from the current time.
 *
 * Returns: true if the timer was rescheduled, false if the timer has
 *     already elapsed.
 */
extern(C) bool app_timer_reschedule
(AppTimer* timer_handle, uint new_timeout_ms);

/**
 * Cancels an already registered timer.
 * Once cancelled the handle may no longer be used for any purpose.
 */
extern(C) void app_timer_cancel(AppTimer* timer_handle);

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

/// The maximum size of a persist value in bytes.
enum size_t PERSIST_DATA_MAX_LENGTH = 256;

/// The maximum size of a persist string in bytes including the
/// NULL terminator.
enum size_t PERSIST_STRING_MAX_LENGTH = PERSIST_DATA_MAX_LENGTH;

/// Status codes.
/// See_Also: status_t
enum StatusCode : int {
    /// Operation completed successfully.
    success = 0,
    /// An error occurred (no description).
    error = -1,
    /// No idea what went wrong.
    unknownError = -2,
    /// There was a generic internal logic error.
    internalError = -3,
    /// The function was not called correctly.
    invalidArgument = -4,
    /// Insufficient allocatable memory available.
    outOfMemory = -5,
    /// Insufficient long-term storage available.
    outOfStorage = -6,
    /// Insufficient resources available.
    outOfResources = -7,
    /// Argument out of range (may be dynamic).
    outOfRange = -8,
    /// Target of operation does not exist.
    doesNotExist = -9,
    /// Operation not allowed (may depend on state).
    invalidOperation = -10,
    /// Another operation prevented this one.
    busy = -11,
    /// Equivalent of boolean true.
    _true = 1,
    /// Equivalent of boolean false.
    _false = 0,
    /// For list-style requests. At end of list.
    noMoreItems = 2,
    /// No action was taken as none was required.
    noActionRequired = 3
}

///
alias S_SUCCESS = StatusCode.success;
///
alias E_ERROR = StatusCode.error;
///
alias E_UNKNOWN = StatusCode.unknownError;
///
alias E_INTERNAL = StatusCode.internalError;
///
alias E_INVALID_ARGUMENT = StatusCode.invalidArgument;
///
alias E_OUT_OF_MEMORY = StatusCode.outOfMemory;
///
alias E_OUT_OF_STORAGE = StatusCode.outOfStorage;
///
alias E_OUT_OF_RESOURCES = StatusCode.outOfResources;
///
alias E_RANGE = StatusCode.outOfRange;
///
alias E_DOES_NOT_EXIST = StatusCode.doesNotExist;
///
alias E_INVALID_OPERATION = StatusCode.invalidOperation;
///
alias E_BUSY = StatusCode.busy;
///
alias S_TRUE = StatusCode._true;
///
alias S_FALSE = StatusCode._false;
///
alias S_NO_MORE_ITEMS = StatusCode.noMoreItems;
///
alias S_NO_ACTION_REQUIRED = StatusCode.noActionRequired;

// Because we can control the size of the enum in D, we can use the right type
// for the status code values.

/// Return value for system operations.
alias status_t = StatusCode;

/**
 * Checks whether a value has been set for a given key in persistent storage.
 *
 * Params:
 * key = The key of the field to check.
 *
 * Returns: true if a value exists, otherwise false.
 */
extern(C) bool persist_exists(const uint key);

/**
 * Gets the size of a value for a given key in persistent storage.
 *
 * Params:
 * key = The key of the field to lookup the data size.
 *
 * Returns: The size of the value in bytes or E_DOES_NOT_EXIST
 * if there is no field matching the given key.
 */
extern(C) int persist_get_size(const uint key);

/**
 * Reads a bool value for a given key from persistent storage.
 * If the value has not yet been set, this will return false.
 *
 * Params:
 * key = The key of the field to read from.
 *
 * Returns: The bool value of the key to read from.
 */
extern(C) bool persist_read_bool(const uint key);

/**
 * Reads an int value for a given key from persistent storage.
 *
 * Note: The int is a signed 32-bit integer.
 *
 * If the value has not yet been set, this will return 0.
 *
 * Params:
 * key = The key of the field to read from.
 *
 * Returns: The int value of the key to read from.
 */
extern(C) int persist_read_int(const uint key);

/**
 * Reads a blob of data for a given key from persistent storage into
 * a given buffer.
 *
 * If the value has not yet been set, the given buffer is left unchanged.
 *
 * Params:
 * key = The key of the field to read from.
 * buffer = The pointer to a buffer to be written to.
 * buffer_size = The maximum size of the given buffer.
 *
 * Returns: The number of bytes written into the buffer or E_DOES_NOT_EXIST
 * if there is no field matching the given key.
 */
extern(C) int persist_read_data
(const uint key, void* buffer, const size_t buffer_size);

/**
 * Reads a string for a given key from persistent storage into a given buffer.
 * The string will be null terminated.
 *
 * If the value has not yet been set, the given buffer is left unchanged.
 *
 * Params:
 * key = The key of the field to read from.
 * buffer = The pointer to a buffer to be written to.
 * buffer_size = The maximum size of the given buffer.
 *     This includes the null character.
 *
 * Returns: The number of bytes written into the buffer or E_DOES_NOT_EXIST
 *     if there is no field matching the given key.
 */
extern(C) int persist_read_string
(const uint key, char* buffer, const size_t buffer_size);

/**
 * Writes a bool value flag for a given key into persistent storage.
 *
 * Params:
 * key = The key of the field to write to.
 * value = The boolean value to write.
 */
extern(C) status_t persist_write_bool(const uint key, const bool value);

/**
 * Writes an int value for a given key into persistent storage.
 *
 * Note: The int is a signed 32-bit integer.
 *
 * Params:
 * key = The key of the field to write to.
 * value = The int value to write.
 */
extern(C) status_t persist_write_int(const uint key, const int value);

/**
 * Writes a blob of data of a specified size in bytes for a given key into
 * persistent storage.
 *
 * The maximum size is PERSIST_DATA_MAX_LENGTH
 *
 * Params:
 * key = The key of the field to write to.
 * data = The pointer to the blob of data.
 * size = The size in bytes.
 *
 * Returns: The number of bytes written.
 */
extern(C) int persist_write_data
(const uint key, const(void)* data, const size_t size);

/**
 * Writes a string a given key into persistent storage.
 * The maximum size is PERSIST_STRING_MAX_LENGTH including the null terminator.
 *
 * Params:
 * key = The key of the field to write to.
 * cstring = The pointer to null terminated string.
 *
 * Returns: The number of bytes written.
 */
extern(C) int persist_write_string(const uint key, const(char)* cstring);

/**
 * Deletes the value of a key from persistent storage.
 *
 * Params:
 * key = The key of the field to delete from.
 */
extern(C) status_t persist_delete(const uint key);

//TODO: We got to this point in our header translation.

/// The identifier for a wakeup event.
alias int WakeupId;

/**
 * The type of function which can be called when a wakeup event occurs.
 *
 * Params:
 * wakeup_id = The id of the wakeup event that occurred.
 * cookie = The scheduled cookie provided to wakeup_schedule.
 */
alias extern(C) void function(WakeupId wakeup_id, int cookie) WakeupHandler;

/**
 * Registers a WakeupHandler to be called when wakeup events occur.
 *
 * Params:
 * handler = The callback that gets called when the wakeup event occurs.
 */
extern(C) void wakeup_service_subscribe(WakeupHandler handler);

/**
 * Registers a wakeup event that triggers a callback at the specified time.
 *
 * Applications may only schedule up to 8 wakeup events.
 * Wakeup events are given a 1 minute duration window,
 * in that no application may schedule a wakeup event with 1 minute of a
 * currently scheduled wakeup event.
 *
 * Params:
 * timestamp = The requested time (UTC) for the wakeup event to occur
 * cookie = The application specific reason for the wakeup event.
 * notify_if_missed = On powering on Pebble, will alert user when
 *     notifications were missed due to Pebble being off.
 *
 * Returns: negative values indicate errors (StatusCode).
 *     E_RANGE if the event cannot be scheduled due to another event in
 *     that period.
 *     E_INVALID_ARGUMENT if the time requested is in the past.
 *     E_OUT_OF_RESOURCES if the application has already scheduled all
 *     8 wakeup events.
 *     E_INTERNAL if a system error occurred during scheduling.
 */
extern(C) WakeupId wakeup_schedule
(time_t timestamp, int cookie, bool notify_if_missed);

/**
 * Cancels a wakeup event.
 *
 * Params:
 * wakeup_id = Wakeup event to cancel
 */
extern(C) void wakeup_cancel(WakeupId wakeup_id);

/// Cancels all wakeup events for the app.
extern(C) void wakeup_cancel_all();

/**
 * Retrieves the wakeup event info for an app that was launched
 * by a wakeup_event (ie. launch_reason() === APP_LAUNCH_WAKEUP)
 * so that an app may display information regarding the wakeup event
 *
 * Params:
 * wakeup_id = WakeupId for the wakeup event that caused the app to wakeup.
 * cookie = App provided reason for the wakeup event.
 *
 * Returns: true if app was launched due to a wakeup event, false otherwise.
 */
extern(C) bool wakeup_get_launch_event(WakeupId* wakeup_id, int* cookie);

/**
 * Checks if the current WakeupId is still scheduled and therefore valid.
 *
 * Params:
 * wakeup_id = Wakeup event to query for validity and scheduled time.
 * timestamp = Optionally points to an address of a time_t variable to
 *     store the time that the wakeup event is scheduled to occur.
 *     (The time is in UTC, but local time when clock_is_timezone_set
 *     returns false).
 *     You may pass NULL instead if you do not need it.
 *
 * Returns: true if WakeupId is still scheduled, false if it doesn't exist or
 *     has already occurred
 */
extern(C) bool wakeup_query(WakeupId wakeup_id, time_t* timestamp);

/**
 * AppLaunchReason is used to inform the application about how it was launched
 *
 * Note: New launch reasons may be added in the future.
 * As a best practice, it is recommended to only handle the cases that
 * the app needs to know about, rather than trying to handle all
 * possible launch reasons.
 */
enum AppLaunchReason {
    /// App launched by the system
    system = 0,
    /// App launched by user selection in launcher menu.
    user = 1,
    /// App launched by mobile or companion app.
    phone = 2,
    /// App launched by wakeup event.
    wakeup = 3,
    /// App launched by worker calling worker_launch_app().
    worker = 4,
    /// App launched by user using quick launch.
    quickLaunch = 5,
    /// App launched by user opening it from a pin.
    timelineAction = 6
}

///
alias APP_LAUNCH_SYSTEM = AppLaunchReason.system;
///
alias APP_LAUNCH_USER = AppLaunchReason.user;
///
alias APP_LAUNCH_PHONE = AppLaunchReason.phone;
///
alias APP_LAUNCH_WAKEUP = AppLaunchReason.wakeup;
///
alias APP_LAUNCH_WORKER = AppLaunchReason.worker;
///
alias APP_LAUNCH_QUICK_LAUNCH = AppLaunchReason.quickLaunch;
///
alias APP_LAUNCH_TIMELINE_ACTION = AppLaunchReason.timelineAction;

/**
 * Provides the method used to launch the current application.
 *
 * Returns: The method or reason the current application was launched.
 */
extern(C) AppLaunchReason launch_reason();

/**
 * Get the argument passed to the app when it was launched.
 *
 * Note: Currently the only way to pass arguments to apps is by using an
 * openWatchApp action on a pin.
 *
 * Returns: The argument passed to the app, or 0 if the app wasn't launched
 *     from a Launch App action.
 */
extern(C) uint launch_get_args();

/// A 8-bit colour value with an alpha channel.
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


// TODO: This macro was defined for swapping out color and black and white.
// We should perhaps handle this somehow.

// #define COLOR_FALLBACK(color, bw) (color)

/**
 * Represents a point in a 2-dimensional coordinate system.
 *
 * Note: Conventionally, the origin of Pebble's 2D coordinate system
 * is in the upper, lefthand corner its x-axis extends to the right and
 * its y-axis extends to the bottom of the screen.
 */
struct GPoint {
    short x;
    short y;
}

/// A zero GPoint.
enum GPointZero = GPoint.init;

/**
 * Tests whether 2 points are equal.
 *
 * Params:
 * point_a = Pointer to the first point
 * point_b = Pointer to the second point
 *
 * Returns: `true` if both points are equal, `false` if not.
 */
deprecated("Use x == y instead of gpoint_equal(&x, &y)")
@safe pure
bool gpoint_equal(const GPoint* point_a, const GPoint* point_b) {
   return *point_a == *point_b;
}

/// Represents a 2-dimensional size.
struct GSize {
    /// The width
    short w;
    /// The height
    short h;
}

/// GSize of (0, 0).
enum GSizeZero = GSize.init;

/**
 * Tests whether 2 sizes are equal.
 *
 * Params:
 * size_a = Pointer to the first size.
 * size_b = Pointer to the second size.
 *
 * Returns: `true` if both sizes are equal, `false` if not.
 */
deprecated("Use x == y instead of gsize_equal(&x, &y)")
@safe pure
bool gsize_equal(const(GSize)* size_a, const(GSize)* size_b) {
    return *size_a == *size_b;
}

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


/// The format of a GBitmap can either be 1-bit or 8-bit.
enum GBitmapFormat {
    /// 1-bit black and white. 0 = black, 1 = white.
    _1bit = 0,
    /// 6-bit color + 2 bit alpha channel. See \ref GColor8 for pixel format.
    _8bit = 1,
    _1bitPalette = 2,
    _2bitPalette = 3,
    _4bitPalette = 4,
}

///
alias GBitmapFormat1Bit = GBitmapFormat._1bit;
///
alias GBitmapFormat8Bit = GBitmapFormat._8bit;
///
alias GBitmapFormat1BitPalette = GBitmapFormat._1bitPalette;
///
alias GBitmapFormat2BitPalette = GBitmapFormat._2bitPalette;
///
alias GBitmapFormat4BitPalette = GBitmapFormat._4bitPalette;

/// A opaque struct for a bitmap.
struct GBitmap {}

/// A opaque struct for a sequence of bitmaps.
struct GBitmapSequence {}

/**
 * Get the number of bytes per row in the bitmap data for the given GBitmap.
 * This can be used as a safe way of iterating over the rows in the bitmap,
 * since bytes per row should be set according to format.
 */
extern(C) ushort gbitmap_get_bytes_per_row(const(GBitmap)* bitmap);

/**
 * Returns: The format of the given GBitmap.
 */
extern(C) GBitmapFormat gbitmap_get_format(const(GBitmap)* bitmap);

/**
 * Get a pointer to the data section of the given GBitmap.
 *
 * See_Also: gbitmap_get_bytes_per_row
 */
extern(C) ubyte* gbitmap_get_data(const(GBitmap)* bitmap);

/**
 * Set the bitmap data for the given GBitmap.
 *
 * Params:
 * bitmap = A pointer to the GBitmap to set data to.
 * data = A pointer to the bitmap data.
 * format = The format of the bitmap data. If this is a palettized format,
 *     make sure that there is an accompanying call to gbitmap_set_palette.
 * row_size_bytes = How many bytes a single row takes. For example, bitmap
 *     data of format GBitmapFormat1Bit must have a row size as a multiple
 *     of 4 bytes.
 * free_on_destroy = Set whether the data should be freed when the GBitmap
 *     is destroyed.
 *
 * See_Also: gbitmap_destroy
 */
extern(C) void gbitmap_set_data(GBitmap* bitmap, ubyte* data,
GBitmapFormat format, ushort row_size_bytes, bool free_on_destroy);

/// See_Also: gbitmap_set_bounds
extern(C) GRect gbitmap_get_bounds(const(GBitmap)* bitmap);

/**
 * Set the bounds of the given GBitmap.
 *
 * See_Also: gbitmap_get_bounds
 */
extern(C) void gbitmap_set_bounds(GBitmap* bitmap, GRect bounds);

/// See_Also: gbitmap_get_palette
extern(C) GColor* gbitmap_get_palette(const(GBitmap)* bitmap);

/**
 * Set the palette for the given GBitmap.
 *
 * Params:
 * bitmap = A pointer to the GBitmap to set the palette to.
 * palette = The palette to be used. Make sure that the palette is large
 *     enough for the bitmap's format.
 * free_on_destroy = Set whether the palette data should be freed when the
 *     GBitmap is destroyed.
 *
 * See_Also: gbitmap_get_format
 * See_Also: gbitmap_destroy
 * See_Also: gbitmap_set_palette
 */
extern(C) void gbitmap_set_palette
(GBitmap* bitmap, GColor* palette, bool free_on_destroy);

// TODO: Wrap these in an RAII type.

/**
 * Creates a new GBitmap on the heap using a Pebble image file stored
 * as a resource.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * resource_id = The ID of the bitmap resource to load.
 *
 * Returns: A pointer to the \ref GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
extern(C) GBitmap* gbitmap_create_with_resource(uint resource_id);

/**
 * Creates a new GBitmap on the heap initialized with the provided
 * Pebble image data.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy() but the
 * image data will not be freed automatically. The developer is
 * responsible for keeping the image data in memory as long as the bitmap
 * is used and releasing it after the bitmap is destroyed.
 *
 * Note: One way to generate Pebble image data is to use bitmapgen.py in
 * the Pebble SDK to generate a .pbi file.
 *
 * Params: data = The Pebble image data. Must not be NULL. The function
 *     assumes the data to be correct; there are no sanity checks performed
 *     on the data. The data will not be copied and the pointer must remain
 *     valid for the lifetime of this GBitmap.
 *
 * Returns: A pointer to the GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
extern(C) GBitmap* gbitmap_create_with_data(const(ubyte)* data);

/**
 * Create a new GBitmap on the heap as a sub-bitmap of a 'base'
 * GBitmap, using a GRect to indicate what portion of the base to use. The
 * sub-bitmap will just reference the image data and palette of the base
 * bitmap.
 *
 * No deep-copying occurs as a result of calling this function, thus the caller
 * is responsible for making sure the base bitmap and palette will
 * remain available when using the sub-bitmap. Note that you should not
 * destroy the parent bitmap until the sub_bitmap has been destroyed.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * base_bitmap = The bitmap that the sub-bitmap of which the image data
 *     will be used by the sub-bitmap
 * sub_rect = The rectangle within the image data of the base bitmap. The
 *     bounds of the base bitmap will be used to clip `sub_rect`.
 *
 * Returns: A pointer to the GBitmap. `NULL` if the GBitmap could not
 *     be created.
 */
extern(C) GBitmap* gbitmap_create_as_sub_bitmap
(const(GBitmap)* base_bitmap, GRect sub_rect);

/**
 * The resulting \ref GBitmap must be destroyed using gbitmap_destroy().
 *
 * The developer is responsible for freeing png_data following this call.
 *
 * Note: PNG decoding currently supports 1,2,4 and 8 bit palettized
 *     and grayscale images.
 *
 * Params:
 * png_data = PNG image data.
 * png_data_size = PNG image size in bytes.
 *
 * Returns: A pointer to the \ref GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
extern(C) GBitmap* gbitmap_create_from_png_data
(const(ubyte)* png_data, size_t png_data_size);

/**
 * Creates a new blank GBitmap on the heap initialized to zeroes.
 * In the case that the format indicates a palettized bitmap,
 * a palette of appropriate size will also be allocated on the heap.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * size = The Pebble image dimensions as a GSize.
 * format = The GBitmapFormat the created image should be in.
 *
 * Returns: A pointer to the GBitmap. `NULL` if the GBitmap could not
 * be created
 */
extern(C) GBitmap* gbitmap_create_blank(GSize size, GBitmapFormat format);

/**
 * Creates a new blank GBitmap on the heap, initialized to zeroes, and assigns
 * it the given palette.
 *
 * No deep-copying of the palette occurs, so the caller is responsible for
 * making sure the palette remains available when using the resulting bitmap.
 * Management of that memory can be handed off to the system with the
 * free_on_destroy argument.
 *
 * Params:
 * size = The Pebble image dimensions as a GSize.
 * format = The GBitmapFormat the created image and palette should be in.
 * palette = A pointer to a palette that is to be used for this GBitmap.
 *     The palette should be large enough to hold enough colors for the
 *     specified format. For example, GBitmapFormat2BitPalette should have
 *     4 colors, since 2^2 = 4.
 * free_on_destroy = Set whether the palette data should be freed along with
 *     the bitmap data when the GBitmap is destroyed.
 *
 * Returns: A Pointer to the GBitmap. `NULL` if the GBitmap could not be
 *     created.
 */
extern(C) GBitmap* gbitmap_create_blank_with_palette
(GSize size, GBitmapFormat format, GColor* palette, bool free_on_destroy);

/**
 * Destroy a GBitmap.
 * This must be called for every bitmap that's been created with
 * gbitmap_create_*
 *
 * This function will also free the memory of the bitmap data (bitmap->addr)
 * if the bitmap was created with gbitmap_create_blank()
 * or gbitmap_create_with_resource().
 *
 * If the GBitmap was created with gbitmap_create_with_data(),
 * you must release the memory after calling gbitmap_destroy().
 */
extern(C) void gbitmap_destroy(GBitmap* bitmap);

/**
 * Loading the apng from resource, initializes header,
 * duration and frame count only (IHDR, acTL, alTL chunks)
 */
extern(C) GBitmapSequence* gbitmap_sequence_create_with_resource
(uint resource_id);

/**
 * Updates the contents of the bitmap sequence to the next frame
 * and returns the delay in milliseconds until the next frame.
 *
 * Note: GBitmap must be large enough to accommodate the bitmap_sequence image
 * gbitmap_sequence_get_bitmap_size
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 * bitmap = Pointer to the initialized GBitmap in which to render the bitmap
 *     sequence.
 *
 * Returns: True if frame was rendered. False if all frames (and loops) have
 *     been rendered for the sequence. Will also return false if frame could
 *     not be rendered (includes out of memory errors).
 */
extern(C) bool gbitmap_sequence_update_bitmap_next_frame
(GBitmapSequence* bitmap_sequence, GBitmap* bitmap, uint* delay_ms);

/**
 * Deletes the GBitmapSequence structure and frees any allocated
 * memory/decoder_data
 */
extern(C) void gbitmap_sequence_destroy(GBitmapSequence* bitmap_sequence);

/**
 * Restarts the GBitmapSequence by positioning the read_cursor at the
 * first frame
 */
extern(C) bool gbitmap_sequence_restart(GBitmapSequence* bitmap_sequence);

/**
 * This function gets the current frame number for the bitmap sequence.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: index of current frame in the current loop of the bitmap sequence.
 */
extern(C) int gbitmap_sequence_get_current_frame_idx
(GBitmapSequence* bitmap_sequence);

/**
 * This function sets the total number of frames for the bitmap sequence
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: number of frames contained in a single loop of the bitmap sequence.
 */
extern(C) int gbitmap_sequence_get_total_num_frames
(GBitmapSequence* bitmap_sequence);

/**
 * This function gets the loop count (number of times to repeat) the bitmap
 * sequence.
 *
 * Note: This value is initialized by the bitmap sequence data, and is modified
 * by gbitmap_sequence_set_loop_count.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: Loop count of bitmap sequence, 0 for infinite.
 */
extern(C) uint gbitmap_sequence_get_loop_count
(GBitmapSequence* bitmap_sequence);

/**
 * This function sets the loop count (number of times to repeat) the bitmap
 * sequence.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 * loop_count = Number of times to repeat the bitmap sequence.
 */
extern(C) void gbitmap_sequence_set_loop_count
(GBitmapSequence* bitmap_sequence, uint loop_count);

/**
 * This function gets the minimum required size (dimensions) necessary
 * to render the bitmap sequence to a GBitmap using the
 * gbitmap_sequence_update_bitmap_next_frame.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: Dimensions required to render the bitmap sequence to a GBitmap.
 */
extern(C) GSize gbitmap_sequence_get_bitmap_size
(GBitmapSequence* bitmap_sequence);

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

/**
 * Values to specify how the source image should be composited onto the
 * destination image.
 *
 * There is no notion of "transparency" in the graphics system. However, the
 * effect of transparency can be created by masking and using compositing
 * modes.
 *
 * Contrived example of how the different compositing modes affect drawing.
 * Often, the "destination image" is the render buffer and thus contains the
 * image of what has been drawn before or "underneath".
 *
 * See_Also: bitmap_layer_set_compositing_mode()
 * See_Also: graphics_context_set_compositing_mode()
 * See_Also: graphics_draw_bitmap_in_rect()
 */
enum GCompOp {
    /// Assign the pixel values of the source image to the destination pixels,
    /// effectively replacing the previous values for those pixels.
    assign = 0,
    /// Assign the **inverted** pixel values of the source image to the
    /// destination pixels, effectively replacing the previous values for
    /// those pixels.
    inverted = 1,
    /// Use the boolean operator `OR` to composite the source and destination
    /// pixels. The visual result of this compositing mode is the source's
    /// white pixels are painted onto the destination and the source's black
    /// pixels are treated as clear.
    or = 2,
    /// Use the boolean operator `AND` to composite the source and destination
    /// pixels. The visual result of this compositing mode is the source's
    /// black pixels are painted onto the destination and the source's white
    /// pixels are treated as clear.
    and = 3,
    /// Clears the bits in the destination image, using the source image as i
    /// mask. The visual result of this compositing mode is that for the parts
    /// where the source image is white, the destination image will be painted
    /// black. Other parts will be left untouched.
    clear = 4,
    /// Sets the bits in the destination image, using the source image as mask.
    /// The visual result of this compositing mode is that for the parts where
    /// the source image is black, the destination image will be painted white.
    /// Other parts will be left untouched. When drawing color PNGs, this mode
    /// will be required to apply any transparency.
    set = 5
}

///
alias GCompOpAssign = GCompOp.assign;
///
alias GCompOpAssignInverted = GCompOp.inverted;
///
alias GCompOpOr = GCompOp.or;
///
alias GCompOpAnd = GCompOp.and;
///
alias GCompOpClear = GCompOp.clear;
///
alias GCompOpSet = GCompOp.set;

struct GContext {}

/**
 * Sets the current stroke color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the stroke color.
 * color = The new stroke color.
 */
extern(C) void graphics_context_set_stroke_color(GContext* ctx, GColor color);

/**
 * Sets the current fill color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the fill color.
 * color = The new fill color.
 */
extern(C) void graphics_context_set_fill_color(GContext* ctx, GColor color);

/**
 * Sets the current text color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the text color.
 * color = The new text color.
 */
extern(C) void graphics_context_set_text_color(GContext* ctx, GColor color);

/**
 * Sets the current bitmap compositing mode of the graphics context.
 *
 * Note: At the moment, this only affects the bitmaps drawing operations
 * graphics_draw_bitmap_in_rect() and anything that uses that --, but it
 * currently does not affect the filling or stroking operations.
 *
 * Params:
 * ctx = The graphics context onto which to set the compositing mode.
 * mode = The new compositing mode.
 *
 * See_Also: GCompOp
 * See_Also: bitmap_layer_set_compositing_mode()
 */
extern(C) void graphics_context_set_compositing_mode
(GContext* ctx, GCompOp mode);

/**
 * Sets whether antialiasing is applied to stroke drawing.
 *
 * Note: Default value is true.
 *
 * Params:
 * ctx = The graphics context onto which to set the antialiasing.
 * enable = enable or disable anti-aliasing.
 */
extern(C) void graphics_context_set_antialiased(GContext* ctx, bool enable);

/**
 * Sets the width of the stroke for drawing routines
 *
 * Note: If stroke width of zero is passed, it will be ignored and will not
 * change the value stored in GContext. Currently, only odd stroke_width
 * values are supported. If an even value is passed in, the value will be
 * stored as is, but the drawing routines will round down to the
 * previous integral value when drawing. Default value is 1.
 *
 * Params:
 * ctx = The graphics context onto which to set the stroke width.
 * stroke_width = Width in pixels of the stroke.
 */
extern(C) void graphics_context_set_stroke_width
(GContext* ctx, ubyte stroke_width);

/**
 * Bit mask values to specify the corners of a rectangle.
 * The values can be combines using binary OR (`|`),
 *
 * For example: the mask to indicate top left and bottom right corners can:
 * be created as follows: GCornerTopLeft | GCornerBottomRight
 */
enum GCornerMask {
    /// No corners
    none = 0,
    /// Top-Left corner
    topLeft = 1,
    /// Top-Right corner
    topRight = 2,
    /// Bottom-Left corner
    bottomLeft = 4,
    /// Bottom-Right corner
    bottomRight = 8,
    /// All corners
    all = 15,
    /// Top corners
    top = 3,
    /// Bottom corners
    bottom = 12,
    /// Left corners
    left = 5,
    /// Right corners
    right = 10
}

///
alias GCornerNone = GCornerMask.none;
///
alias GCornerTopLeft = GCornerMask.topLeft;
///
alias GCornerTopRight = GCornerMask.topRight;
///
alias GCornerBottomRight = GCornerMask.bottomRight;
///
alias GCornersAll = GCornerMask.all;
///
alias GCornersTop = GCornerMask.top;
///
alias GCornersBottom = GCornerMask.bottom;
///
alias GCornersLeft = GCornerMask.left;
///
alias GCornersRight = GCornerMask.right;

/**
 * Draws a pixel at given point in the current stroke color
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * point = The point at which to draw the pixel.
 */
extern(C) void graphics_draw_pixel(GContext* ctx, GPoint point);

/**
 * Draws line in the current stroke color, current stroke width and AA flag.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * p0 = The starting point of the line
 * p1 = The ending point of the line
 */
extern(C) void graphics_draw_line(GContext* ctx, GPoint p0, GPoint p1);

/**
 * Draws a 1-pixel wide rectangle outline in the current stroke color.
 *
 * Params:
 * ctx = The destination graphics context in which to draw
 * rect = The rectangle for which to draw the outline.
 */
extern(C) void graphics_draw_rect(GContext* ctx, GRect rect);

/**
 * Fills a retangle with the current fill color, optionally rounding all or
 * a selection of its corners.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * rect = The rectangle to fill.
 * corner_radius = The rounding radius of the corners in pixels
 *     (maximum is 8 pixels)
 * corner_mask = Bitmask of the corners that need to be rounded.
 *
 * See_Also: GCornerMask
 */
extern(C) void graphics_fill_rect
(GContext* ctx, GRect rect, ushort corner_radius, GCornerMask corner_mask);

/**
 * Draws the outline of a circle in the current stroke color
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * p = The center point of the circle
 * radius = The radius in pixels.
 */
extern(C) void graphics_draw_circle(GContext* ctx, GPoint p, ushort radius);

/**
 * Fills a circle in the current fill color
 *
 * Params:
 * ctx = The destination graphics context in which to draw
 * p = The center point of the circle
 * radius = The radius in pixels
 */
extern(C) void graphics_fill_circle(GContext* ctx, GPoint p, ushort radius);

/**
 * Draws the outline of a rounded rectangle in the current stroke color.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * rect = The rectangle defining the dimensions of the rounded rectangle
 *     to draw.
 * radius = The corner radius in pixels.
 */
extern(C) void graphics_draw_round_rect
(GContext* ctx, GRect rect, ushort radius);

/**
 * Draws a bitmap into the graphics context, inside the specified rectangle
 *
 * Params:
 * ctx = The destination graphics context in which to draw the bitmap.
 * bitmap = The bitmap to draw.
 * rect = The rectangle in which to draw the bitmap.
 *
 * Note: If the size of `rect` is smaller than the size of the bitmap,
 * the bitmap will be clipped on right and bottom edges. If the size of `rect`
 * is larger than the size of the bitmap, the bitmap will be tiled
 * automatically in both horizontal and vertical directions, effectively
 * drawing a repeating pattern.
 *
 * See_Also: GBitmap
 * See_Also: GContext
 */
extern(C) void graphics_draw_bitmap_in_rect
(GContext* ctx, const(GBitmap)* bitmap, GRect rect);

/**
 * A shortcut to capture the framebuffer in the native format of the watch.
 *
 * See_Also: graphics_capture_frame_buffer_format
 */
extern(C) GBitmap* graphics_capture_frame_buffer(GContext* ctx);

/**
 * Captures the frame buffer for direct access, using the given format.
 * Graphics functions will not affect the frame buffer while it is captured.
 * The frame buffer is released when graphics_release_frame_buffer
 * is called.
 *
 * The frame buffer must be released before the end of a layer's
 * `.update_proc` for the layer to be drawn properly.
 *
 * While the frame buffer is captured calling graphics_capture_frame_buffer
 * will fail and return `NULL`.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 * format = The format in which the framebuffer should be captured.
 *     Supported formats are GBitmapFormat1Bit and GBitmapFormat8Bit.
 *
 * Returns: A pointer to the frame buffer. `NULL` if failed.
 *
 * See_Also: GBitmap
 * See_Also: GBitmapFormat
 */
extern(C) GBitmap* graphics_capture_frame_buffer_format
(GContext* ctx, GBitmapFormat format);

/**
 * Releases the frame buffer.
 * Must be called before the end of a layer's `.update_proc` for the layer
 * to be drawn properly.
 *
 * If `buffer` does not point to the address previously returned by
 * graphics_capture_frame_buffer the frame buffer will not be released.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 * buffer = The pointer to frame buffer.
 *
 * Returns: true if the frame buffer was released successfully.
 */
extern(C) bool graphics_release_frame_buffer
(GContext* ctx, GBitmap* buffer);

/**
 * Whether or not the frame buffer has been captured by
 * graphics_capture_frame_buffer.
 *
 * Graphics functions will not affect the frame buffer until it has been
 * released by
 *
 * graphics_release_frame_buffer.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 *
 * Returns: true if the frame buffer has been captured.
 */
extern(C) bool graphics_frame_buffer_is_captured(GContext* ctx);

/**
 * Data structure describing a naked path
 *
 * Note: Note that this data structure only refers to an array of points;
 * the points are not stored inside this data structure itself.
 *
 * In most cases, one cannot use a stack-allocated array of GPoints.
 * Instead one often needs to provide longer-lived (static or "global")
 * storage for the points.
 */
struct GPathInfo {
    /// The number of points in the `points` array.
    uint num_points;
    /// Pointer to an array of points.
    GPoint* points;
}

/**
 * Data structure describing a path, plus its rotation and translation.
 *
 * Note: See the remark with GPathInfo
 */
struct GPath {
    /// The number of points in the `points` array.
    uint num_points;
    /// Pointer to an array of points.
    GPoint* points;
    /// The rotation that will be used when drawing the path with
    /// gpath_draw_filled() or gpath_draw_outline()
    int rotation;
    /// The translation that will to be used when drawing the path with
    /// gpath_draw_filled() or gpath_draw_outline()
    GPoint offset;
}

/**
 * Creates a new GPath on the heap based on a series of points described by
 * a GPathInfo.
 *
 * Values after initialization:
 * `num_points` and `points` pointer: copied from the GPathInfo.
 * `rotation`: 0
 * `offset`: (0, 0)
 *
 * Returns: A pointer to the GPath. `NULL` if the GPath could not be created.
 */
extern(C) GPath* gpath_create(const(GPathInfo)* init);

/// Free a dynamically allocated gpath created with gpath_create().
extern(C) void gpath_destroy(GPath* gpath);

/**
 * Draws the fill of a path into a graphics context, using the current
 * fill color, relative to the drawing area as set up by the layering system.
 *
 * Params:
 * ctx = The graphics context to draw into.
 * path = The path to fill.
 *
 * See_Also: graphics_context_set_fill_color()
 */
extern(C) void gpath_draw_filled(GContext* ctx, GPath* path);

/**
 * Draws the outline of a path into a graphics context, using the
 * current stroke color, relative to the drawing area as set up by the
 * layering system.
 *
 * Params:
 * ctx = The graphics context to draw into.
 * path = The path to fill.
 *
 * See_Also: graphics_context_set_stroke_color()
 */
extern(C) void gpath_draw_outline(GContext* ctx, GPath* path);

/**
 * Sets the absolute rotation of the path.
 * The current rotation will be replaced by the specified angle.
 *
 * Note: Setting a rotation does not affect the points in the path directly.
 * The rotation is applied on-the-fly during drawing, either using
 * gpath_draw_filled() or gpath_draw_outline().
 *
 * Params:
 * path = The path onto which to set the rotation
 * angle = The absolute angle of the rotation. The angle is represented
 * in the same way that is used with sin_lookup(). See TRIG_MAX_ANGLE
 * for more information.
 */
extern(C) void gpath_rotate_to(GPath* path, int angle);

/**
 * Sets the absolute offset of the path. The current translation will be
 * replaced by the specified offset.
 *
 * Params:
 * path = The path onto which to set the translation.
 * point = The point which is used as the vector for the translation.
 *
 * Note: Setting a translation does not affect the points in the path directly.
 * The translation is applied on-the-fly during drawing, either using
 * gpath_draw_filled() or gpath_draw_outline().
 */
extern(C) void gpath_move_to(GPath* path, GPoint point);

struct GFontType{}

/**
 * Pointer to opaque font data structure.
 *
 * See_Also: fonts_load_custom_font()
 * See_Also: text_layer_set_font()
 * See_Also: graphics_draw_text()
 */
alias GFontType* GFont;

/**
 * Loads a system font corresponding to the specified font key.
 *
 * Note: This may load a font from the flash peripheral into RAM.
 *
 * Params:
 * font_key = The string key of the font to load. See `pebble_fonts.h`
 * for a list of system fonts.
 *
 * Returns:
 * An opaque pointer to the loaded font, or, a pointer to the default
 * (fallback) font if the specified font cannot be loaded.
 */
extern(C) GFont fonts_get_system_font(const(char)* font_key);

/**
 * Loads a custom font.
 *
 * Note: This may load a font from the flash peripheral into RAM.
 *
 * Params:
 * handle = The resource handle of the font to load. See resource_ids.auto.h
 *     for a list of resource IDs, and use resource_get_handle() to obtain
 *     the resource handle.
 *
 * Returns: An opaque pointer to the loaded font, or a pointer to the default
 *     (fallback) font if the specified font cannot be loaded.
 *
 * See_Also: Read the App Resources guide on how to embed a font into your app.
 */
extern(C) GFont fonts_load_custom_font(ResHandle handle);

/**
 * Unloads the specified custom font and frees the memory that is occupied by
 * it.
 *
 * Params: font = The font to unload.
 *
 * Note: When an application exits, the system automatically unloads all fonts
 * that have been loaded.
 */
extern(C) void fonts_unload_custom_font(GFont font);

/**
 * Text overflow mode controls the way text overflows when the string
 * that is drawn does not fit inside the area constraint.
 *
 * See_Also: graphics_draw_text
 * See_Also: text_layer_set_overflow_mode
 */
enum GTextOverflowMode {
    /// On overflow, wrap words to a new line below the current one.
    /// Once vertical space is consumed, the last line may be clipped.
    wordWrap = 0,
    /// On overflow, wrap words to a new line below the current one.
    /// Once vertical space is consumed, truncate as needed to fit a trailing
    /// ellipsis (...). Clipping may occur if the vertical space cannot
    /// accommodate the first line of text.
    ellipsis = 1,
    /// Acts like 'ellipsis', plus trims leading and
    /// trailing newlines, while treating all other newlines as spaces.
    fill = 2
}

///
alias GTextOverflowModeWordWrap = GTextOverflowMode.wordWrap;
///
alias GTextOverflowModeTrailingEllipsis = GTextOverflowMode.ellipsis;
///
alias GTextOverflowModeFill = GTextOverflowMode.fill;

/**
 * Text aligment controls the way the text is aligned inside the box the
 * text is drawn into.
 *
 * See_Also: graphics_draw_text
 * See_Also: text_layer_set_text_alignment
 */
enum GTextAlignment {
    /// Aligns the text to the left of the drawing box.
    left = 0,
    /// Aligns the text centered inside the drawing box.
    center = 1,
    /// Aligns the text to the right of the drawing box.
    right = 2
}

///
alias GTextAlignmentLeft = GTextAlignment.left;
///
alias GTextAlignmentCenter = GTextAlignment.center;
///
alias GTextAlignmentRight = GTextAlignment.right;

/// An opaque struct for text layout data.
struct TextLayout {}

deprecated("Use TextLayout* instead.")
alias TextLayout* GTextLayoutCacheRef;

deprecated("Use void* instead.")
alias void* ClickRecognizerRef;

/**
 * Draw text into the current graphics context, using the context's
 * current text color.
 *
 * The text will be drawn inside a box with the specified dimensions and
 * configuration, with clipping occuring automatically.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * text = The zero terminated UTF-8 string to draw.
 * font = The font in which the text should be set.
 * box = The bounding box in which to draw the text. The first line of text
 *     will be drawn against the top of the box.
 * overflow_mode = The overflow behavior, in case the text is larger than
 *     what fits inside the box.
 * alignment = The horizontal alignment of the text
 * layout = Optional layout cache data. Supply `NULL` to ignore the layout
 *     caching mechanism.
 */
extern(C) void graphics_draw_text
(GContext* ctx, const(char)* text, const GFont font, const GRect box,
const GTextOverflowMode overflow_mode, const GTextAlignment alignment,
const(TextLayout)* layout);

/**
 * Obtain the maximum size that a text with given font, overflow mode and
 * alignment occupies within a given rectangular constraint.
 *
 * Params:
 * text = The zero terminated UTF-8 string for which to calculate the size.
 * font = The font in which the text should be set while calculating the size.
 * box = The bounding box in which the text should be constrained.
 * overflow_mode = The overflow behavior, in case the text is larger than what
 *     fits inside the box.
 * alignment = The horizontal alignment of the text.
 *
 * Returns: The maximum size occupied by the text.
 */
extern(C) GSize graphics_text_layout_get_content_size
(const(char)* text, const GFont font, const GRect box,
const GTextOverflowMode overflow_mode, const GTextAlignment alignment);

/**
 * Function signature of the callback that handles a recognized click pattern.
 *
 * Params:
 * recognizer = The click recognizer that detected a "click" pattern.
 * context = Pointer to application specified data
 *    (see window_set_click_config_provider_with_context() and
 *    window_set_click_context()). This defaults to the window.
 *
 * See_Also: ClickConfigProvider
 */
alias extern(C) void function(void* recognizer, void* context) ClickHandler;

/**
 * This callback is called every time the window becomes visible
 * (and when you call window_set_click_config_provider() if
 * the window is already visible).
 *
 * These subscriptions will get used by the click recognizers of each of the
 * 4 buttons.
 *
 * context = Pointer to application specific data.
 *
 * See_Also: window_set_click_config_provider_with_context()
 * See_Also: window_single_click_subscribe()
 * See_Also: window_single_repeating_click_subscribe()
 * See_Also: window_multi_click_subscribe()
 * See_Also: window_long_click_subscribe()
 * See_Also: window_raw_click_subscribe()
 */
alias extern(C) void function(void* context) ClickConfigProvider;

/**
 * Gets the click count.
 *
 * You can use this inside a click handler implementation to get the click
 * count for multi_click and (repeated) click events.
 *
 * Params:
 * recognizer = The click recognizer for which to get the click count.
 *
 * Returns: The number of consecutive clicks, and for auto-repeating the
 * number of repetitions.
 */
extern(C) ubyte click_number_of_clicks_counted(void* recognizer);

/**
 * Gets the button identifier.
 *
 * You can use this inside a click handler implementation to get the button id
 * for the click event.
 *
 * Params:
 * recognizer = The click recognizer for which to get the button id that
 *     caused the click event
 *
 * Returns: The ButtonId of the click recognizer
 */
extern(C) ButtonId click_recognizer_get_button_id(void* recognizer);

/**
 * Is this a repeating click.
 *
 * You can use this inside a click handler implementation to find out whether
 * this is a repeating click or not.
 *
 * Params:
 * recognizer = The click recognizer for which to find out whether this is a
 * repeating click.
 *
 * Returns: true if this is a repeating click.
 */
extern(C) bool click_recognizer_is_repeating(void* recognizer);


/// An opaque data type for an interface layer.
struct Layer {}

/**
 * Function signature for a Layer's render callback (the name of the type
 * is derived from the words 'update procedure').
 *
 * The system will call the `.update_proc` callback whenever the Layer needs
 * to be rendered.
 *
 * Params:
 * layer = The layer that needs to be rendered.
 * ctx = The destination graphics context to draw into.
 *
 *
 * See_Also: Graphics
 * See_Also: layer_set_update_proc()
 */
alias extern(C) void function(Layer* layer, GContext* ctx) LayerUpdateProc;

/**
 * Creates a layer on the heap and sets its frame and bounds.
 *
 * Default values:
 * * `bounds` : origin (0, 0) and a size equal to the frame that is passed in.
 * * `clips` : `true`
 * * `hidden` : `false`
 * * `update_proc` : `NULL` (draws nothing)
 *
 * Params: frame The frame at which the layer should be initialized.
 *
 * See_Also: layer_set_frame()
 * See_Also: layer_set_bounds()
 *
 * Returns: A pointer to the layer. `NULL` if the layer could not be created.
 */
extern(C) Layer* layer_create(GRect frame);

/**
 * Creates a layer on the heap with extra space for callback data, and set
 * its frame andbounds.
 *
 * Default values:
 * * `bounds` : origin (0, 0) and a size equal to the frame that is passed in.
 * * `clips` : `true`
 * * `hidden` : `false`
 * * `update_proc` : `NULL` (draws nothing)
 *
 * Params:
 * frame = The frame at which the layer should be initialized.
 * data_size = The size (in bytes) of memory to allocate for callback data.
 *
 * See_Also: layer_create()
 * See_Also; layer_set_frame()
 * See_Also: layer_set_bounds()
 *
 * Returns: A pointer to the layer. `NULL` if the layer could not be created.
 */
extern(C) Layer* layer_create_with_data(GRect frame, size_t data_size);

/// Destroys a layer previously created by layer_create.
extern(C) void layer_destroy(Layer* layer);

/**
 * Marks the complete layer as "dirty", awaiting to be asked by the system to
 * redraw itself. Typically, this function is called whenever state has
 * changed that affects what the layer is displaying.
 *
 *
 * * The layer's `.update_proc` will not be called before this function
 * returns, but will be called asynchronously, shortly.
 * * Internally, a call to this function will schedule a re-render of the
 * window that the layer belongs to. In effect, all layers in that window's
 * layer hierarchy will be asked to redraw.
 * * If an earlier re-render request is still pending, this function is a
 * no-op.
 *
 * Params:
 * layer = The layer to mark dirty.
 */
extern(C) void layer_mark_dirty(Layer* layer);

/**
 * Sets the layer's render function.
 *
 * The system will call the `update_proc` automatically when the layer needs
 * to redraw itself.
 *
 * Params:
 * layer = Pointer to the layer structure.
 * update_proc = Pointer to the function that will be called when the layer
 *     needs to be rendered.
 *
 * Typically, one performs a series of drawing commands in the implementation
 * of the `update_proc`, See Drawing, PathDrawing and TextDrawing.
 *
 * See_Also: layer_mark_dirty().
 */
extern(C) void layer_set_update_proc
(Layer* layer, LayerUpdateProc update_proc);

/**
 * Sets the frame of the layer, which is it's bounding box relative to the
 * coordinate system of its parent layer.
 *
 * The size of the layer's bounds will be extended automatically, so that
 * the bounds cover the new frame.
 *
 * Params:
 * layer = The layer for which to set the frame.
 * frame = The new frame.
 *
 * See_Also: layer_set_bounds()
 */
extern(C) void layer_set_frame(Layer* layer, GRect frame);

/**
 * Gets the frame of the layer, which is it's bounding box relative to the
 * coordinate system of its parent layer.
 *
 * If the frame has changed, layer_mark_dirty() will be called automatically.
 *
 * Params:
 * layer = The layer for which to get the frame
 *
 * Returns: The frame of the layer
 *
 * See_Also: layer_set_frame
 */
extern(C) GRect layer_get_frame(const(Layer)* layer);

/**
 * Sets the bounds of the layer, which is it's bounding box relative to its
 * frame. If the bounds has changed, layer_mark_dirty() will be called
 * automatically.
 *
 * Params:
 * layer = The layer for which to set the bounds.
 * bounds = The new bounds
 *
 * See_Also: layer_set_frame()
 */
extern(C) void layer_set_bounds(Layer* layer, GRect bounds);

/**
 * Gets the bounds of the layer
 *
 * Params:
 * layer = The layer for which to get the bounds.
 *
 * Returns: The bounds of the layer
 *
 * See_Also: layer_set_bounds
 */
extern(C) GRect layer_get_bounds(const(Layer)* layer);

/**
 * Gets the window that the layer is currently attached to.
 *
 * Params:
 * layer = The layer for which to get the window.
 *
 * Returns: The window that this layer is currently attached to, or `NULL`
 *    if it has not been added to a window's layer hierarchy.
 *
 * See_Also: window_get_root_layer()
 * See_Also: layer_add_child()
 */
extern(C) Window* layer_get_window(const(Layer)* layer);

/**
 * Removes the layer from its current parent layer. If removed successfully,
 * the child's parent layer will be marked dirty automatically.
 *
 * Params: child The layer to remove.
 */
extern(C) void layer_remove_from_parent(Layer* child);

/**
 * Removes child layers from given layer. If removed successfully,
 * the child's parent layer will be marked dirty automatically.
 *
 * Params:
 * parent = The layer from which to remove all child layers.
 */
extern(C) void layer_remove_child_layers(Layer* parent);

/**
 * Adds the child layer to a given parent layer, making it appear
 * in front of its parent and in front of any existing child layers
 * of the parent.
 *
 * If the child layer was already part of a layer hierarchy, it will
 * be removed from its old parent first.
 *
 * If added successfully, the parent (and children) will be marked dirty
 * automatically.
 *
 * Params:
 * parent = The layer to which to add the child layer.
 * child = The layer to add to the parent layer.
 */
extern(C) void layer_add_child(Layer* parent, Layer* child);

/**
 * Inserts the layer as a sibling behind another layer.
 * The below_layer has to be a child of a parent layer,
 * otherwise this function will be a noop.
 * If inserted successfully, the parent (and children) will be marked dirty
 * automatically.
 *
 * Params:
 * layer_to_insert = The layer to insert into the hierarchy.
 * below_sibling_layer = The layer that will be used as the sibling layer
 *    above which the insertion will take place.
 */
extern(C) void layer_insert_below_sibling
(Layer* layer_to_insert, Layer* below_sibling_layer);

/**
 * Inserts the layer as a sibling in front of another layer. The above_layer
 * has to be a child of a parent layer, otherwise this function will be a noop.
 *
 * If inserted successfully, the parent (and children) will be marked dirty
 * automatically.
 *
 * Params:
 * layer_to_insert = The layer to insert into the hierarchy.
 * above_sibling_layer = The layer that will be used as the sibling layer
 *     below which the insertion will take place.
 */
extern(C) void layer_insert_above_sibling
(Layer* layer_to_insert, Layer* above_sibling_layer);

/**
 * Sets the visibility of the layer.
 * If the visibility has changed, layer_mark_dirty() will be called
 * automatically on the parent layer.
 *
 * Params:
 * layer = The layer for which to set the visibility.
 * hidden = Supply `true` to make the layer hidden, or `false` to make it
 *     non-hidden.
 */
extern(C) void layer_set_hidden(Layer* layer, bool hidden);

/**
 * Gets the visibility of the layer.
 *
 * Params:
 * layer = The layer for which to get the visibility.
 *
 * Returns: True if the layer is hidden, false if it is not hidden.
 */
extern(C) bool layer_get_hidden(const(Layer)* layer);


/**
 * Sets whether clipping is enabled for the layer. If enabled, whatever
 * the layer _and its children_ will draw using their `.update_proc`
 * callbacks, will be clipped by the this layer's frame.
 *
 * If the clipping has changed, layer_mark_dirty() will be called
 * automatically.
 *
 * Params:
 * layer = The layer for which to set the clipping property.
 * clips = Supply `true` to make the layer clip to its frame, or `false`
 *     to make it non-clipping.
 */
extern(C) void layer_set_clips(Layer* layer, bool clips);

/**
 * Gets whether clipping is enabled for the layer. If enabled, whatever the
 * layer _and its children_ will draw using their `.update_proc` callbacks,
 * will be clipped by the this layer's frame.
 *
 * Params:
 * layer = The layer for which to get the clipping property
 *
 * Returns: true if clipping is enabled for the layer, false if clipping is
 *     not enabled for the layer.
 */
extern(C) bool layer_get_clips(const(Layer)* layer);

/**
 * Gets the data from a layer that has been created with an extra data region.
 *
 * Params:
 * layer = The layer to get the data region from.
 *
 * Returns: A void pointer to the data region.
 */
extern(C) void* layer_get_data(const(Layer)* layer);

/// The basic building block of the user interface.
struct Window {}

/**
 * Function signature for a handler that deals with transition events of a
 * window.
 *
 * Params:
 * window = The window.
 *
 * See_Also: WindowHandlers
 * See_Also: window_set_window_handlers()
 */
alias extern(C) void function(Window* window) WindowHandler;

/**
 * WindowHandlers
 * These handlers are called by the WindowStack as windows get pushed
 * on / popped.
 *
 * All these handlers use WindowHandler as their function signature.
 *
 * See_Also: window_set_window_handlers()
 * See_Also: WindowStack
 */
struct WindowHandlers {
    /**
     * Called when the window is pushed to the screen when it's not loaded.
     * This is a good moment to do the layout of the window.
     */
    WindowHandler load;
    /**
     * Called when the window comes on the screen (again). E.g. when
     * second-top-most window gets revealed (again) after popping the top-most
     * window, but also when the window is pushed for the first time. This is a
     * good moment to start timers related to the window, or reset the UI, etc.
     */
    WindowHandler appear;
    /**
     * Called when the window leaves the screen, e.g. when another window
     * is pushed, or this window is popped. Good moment to stop timers related
     * to the window.
     */
    WindowHandler disappear;
    /**
     * Called when the window is deinited, but could be used in the future to
     * free resources bound to windows that are not on screen.
     */
    WindowHandler unload;
}

/**
 * Creates a new Window on the heap and initalizes it with the default values.
 *
 * * Background color : `GColorWhite`
 * * Root layer's `update_proc` : function that fills the window's background
 *     using `background_color`.
 * * Full screen : no
 * * `click_config_provider` : `NULL`
 * * `window_handlers` : all `NULL`
 * * `status_bar_icon` : `NULL` (none)
 *
 * Returns: A pointer to the window. `NULL` if the window could not be created.
 */
extern(C) Window* window_create();

/// Destroys a Window previously created by window_create.
extern(C) void window_destroy(Window* window);

/**
 * Sets the click configuration provider callback function on the window.
 *
 * This will automatically setup the input handlers of the window as well to
 * use the click recognizer subsystem.
 *
 * Params:
 * window = The window for which to set the click config provider.
 * click_config_provider = The callback that will be called to configure the
 *     click recognizers with the window.
 *
 * See_Also: Clicks
 * See_Also: ClickConfigProvider
 */
extern(C) void window_set_click_config_provider
(Window* window, ClickConfigProvider click_config_provider);

/**
 * Same as window_set_click_config_provider(), but will assign a custom
 * context pointer (instead of the window pointer) that will be passed into
 * the ClickHandler click event handlers.
 *
 * Params:
 * window = The window for which to set the click config provider.
 * click_config_provider = The callback that will be called to configure the
 *     click recognizers with the window.
 * context = Pointer to application specific data that will be passed to the
 *     click configuration provider callback (defaults to the window).
 *
 * See_Also: Clicks
 * See_Also: window_set_click_config_provider
 */
extern(C) void window_set_click_config_provider_with_context
(Window* window, ClickConfigProvider click_config_provider, void* context);

/**
 * Gets the current click configuration provider of the window.
 *
 * Params:
 * window = The window for which to get the click config provider.
 */
extern(C) ClickConfigProvider window_get_click_config_provider
(const(Window)* window);

/**
 * Gets the current click configuration provider context of the window.
 *
 * Params:
 * window = The window for which to get the click config provider context.
 */
extern(C) void* window_get_click_config_context(Window* window);

/**
 * Sets the window handlers of the window.
 *
 * These handlers get called e.g. when the user enters or leaves the window.
 *
 * Params:
 * window = The window for which to set the window handlers.
 * handlers = The handlers for the specified window.
 *
 * See_Also: WindowHandlers
 */
extern(C) void window_set_window_handlers
(Window* window, WindowHandlers handlers);

/**
 * Gets the root Layer of the window.
 * The root layer is the layer at the bottom of the layer hierarchy for
 * this window.
 *
 * It is the window's "canvas" if you will. By default, the root layer
 * only draws a solid fill with the window's background color.
 *
 * Params:
 * window = The window for which to get the root layer.
 *
 * Returns: The window's root layer
 */
extern(C) Layer* window_get_root_layer(const(Window)* window);

/**
 * Sets the background color of the window, which is drawn automatically by the
 * root layer of the window.
 *
 * Params:
 * window = The window for which to set the background color.
 * background_color = The new background color.
 *
 * See_Also: window_get_root_layer()
 */
extern(C) void window_set_background_color
(Window* window, GColor background_color);

/**
 * Sets whether or not the window is fullscreen, consequently hiding the
 * system status bar.
 *
 * Note: This needs to be called before pushing a window to the window stack.
 *
 * Params:
 * window = The window for which to set its full-screen property
 * enabled = true to make the window full-screen or false to leave space for
 *     the system status bar.
 *
 * See_Also: window_get_fullscreen()
 */
extern(C) void window_set_fullscreen(Window* window, bool enabled);

/**
 * Gets whether the window is full-screen, consequently hiding the sytem
 * status bar.
 *
 * Params:
 * window = The window for which to get its full-screen property.
 *
 * Returns: true if the window is marked as fullscreen, false if it is not
 *     marked as fullscreen.
 */
extern(C) bool window_get_fullscreen(const(Window)* window);

/**
 * Assigns an icon (max. 16x16 pixels) that can be displayed in the system
 * status bar.
 *
 * When no icon is assigned, the icon of the previous window on the window
 * stack is used.
 *
 * Note: This needs to be called before pushing a window to the window stack.
 *
 * Params:
 * window = The window for which to set the status bar icon.
 * icon = The new status bar icon.
 */
extern(C) void window_set_status_bar_icon
(Window* window, const(GBitmap)* icon);

/**
 * Gets whether the window has been loaded.
 *
 * If a window is loaded, its `.load` handler has been called
 * (and the `.unload` handler has not been called since).
 *
 * Params:
 * window = The window to query its loaded status.
 *
 * Returns: true if the window is currently loaded or false if not.
 *
 * See_Also: WindowHandlers
 */
extern(C) bool window_is_loaded(Window* window);

/**
 * Sets a pointer to developer-supplied data that the window uses, to
 * provide a means to access the data at later times in one of the window
 * event handlers.
 *
 * Params:
 * window = The window for which to set the user data.
 * data = A pointer to user data.
 *
 * See_Also: window_get_user_data
 */
extern(C) void window_set_user_data(Window* window, void* data);

/**
 * Gets the pointer to developer-supplied data that was previously
 * set using window_set_user_data().
 *
 * Params:
 * window = The window for which to get the user data.
 *
 * See_Also: window_set_user_data
 */
extern(C) void* window_get_user_data(const(Window)* window);

/**
 * Subscribe to single click events.
 *
 * Note: Must be called from the ClickConfigProvider.
 *
 * Note: window_single_click_subscribe() and
 * window_single_repeating_click_subscribe() conflict, and cannot both be
 * used on the same button.
 *
 * Note: When there is a multi_click and/or long_click setup,
 * there will be a delay before the single click.
 *
 * Params:
 * button_id = The button events to subscribe to.
 * handler = The ClickHandler to fire on this event. handler will get fired.
 *     On the other hand, when there is no multi_click nor long_click setup,
 *     the single click handler will fire directly on button down.
 *
 * See_Also: ButtonId
 * See_Also: Clicks
 * See_Also: window_single_repeating_click_subscribe
 */
extern(C) void window_single_click_subscribe
(ButtonId button_id, ClickHandler handler);

/**
 * Subscribe to single click event, with a repeat interval.
 * A single click is detected every time "repeat_interval_ms" has been reached.
 *
 * Note: Must be called from the ClickConfigProvider.
 * Note: window_single_click_subscribe() and
 * window_single_repeating_click_subscribe() conflict, and cannot both be used
 * on the same button.
 * Note: The back button cannot be overridden with a repeating click.
 *
 * Params:
 * button_id = The button events to subscribe to.
 * repeat_interval_ms = When holding down, how many milliseconds before the
 *     handler is fired again. A value of 0ms means "no repeat timer".
 *     The minimum is 30ms, and values below will be disregarded.
 *     If there is a long-click handler subscribed on this button,
 *     `repeat_interval_ms` will not be used.
 * handler = The ClickHandler to fire on this event.
 *
 * See_Also: window_single_click_subscribe
 */
extern(C) void window_single_repeating_click_subscribe
(ButtonId button_id, ushort repeat_interval_ms, ClickHandler handler);

/**
 * Subscribe to multi click events.
 *
 * Note: Must be called from the ClickConfigProvider.
 *
 * Params:
 * button_id = The button events to subscribe to.
 * min_clicks = Minimum number of clicks before handler is fired.
 *     Defaults to 2.
 * max_clicks = Maximum number of clicks after which the click counter is
 *     reset. A value of 0 means use "min" also as "max".
 * timeout = The delay after which a sequence of clicks is considered
 *     finished, and the click counter is reset. A value of 0 means to use
 *     the system default 300ms.
 * last_click_only = Defaults to false. When true, only the handler for the
 *     last multi-click is called.
 * handler = The ClickHandler to fire on this event. Fired for multi-clicks,
 *     as "filtered" by the `last_click_only`, `min`, and `max` parameters.
 */
extern(C) void window_multi_click_subscribe
(ButtonId button_id, ubyte min_clicks, ubyte max_clicks, ushort timeout,
bool last_click_only, ClickHandler handler);

/**
 * Subscribe to long click events.
 *
 * Note: Must be called from the ClickConfigProvider.
 * Note: The back button cannot be overridden with a long click.
 *
 * Params:
 * button_id = The button events to subscribe to.
 * delay_ms = Milliseconds after which "handler" is fired. A value of 0 means
 *     to use the system default 500ms.
 * down_handler = The ClickHandler to fire as soon as the button has been
 *     held for `delay_ms`. This may be NULL to have no down handler.
 * up_handler The ClickHandler to fire on the release of a long click.
 *     This may be NULL to have no up handler.
 */
extern(C) void window_long_click_subscribe(ButtonId button_id,
ushort delay_ms, ClickHandler down_handler, ClickHandler up_handler);

/**
 * Subscribe to raw click events.
 *
 * Note: Must be called from within the ClickConfigProvider.
 * Note: The back button cannot be overridden with a raw click.
 *
 * Params:
 * button_id = The button events to subscribe to.
 * down_handler = The ClickHandler to fire as soon as the button has been
 * pressed. This may be NULL to have no down handler.
 * up_handler = The ClickHandler to fire on the release of the button.
 * This may be NULL to have no up handler.
 * context = If this context is not NULL, it will override the general context.
 */
extern(C) void window_raw_click_subscribe(ButtonId button_id,
ClickHandler down_handler, ClickHandler up_handler, void* context);

/**
 * Set the context that will be passed to handlers for the given button's
 * events. By default the context passed to handlers is equal to the
 * ClickConfigProvider context (defaults to the window).
 *
 * Note: Must be called from within the ClickConfigProvider.
 *
 * Params:
 * button_id = The button to set the context for.
 * context = Set the context that will be passed to handlers for the given
 *     button's events.
 */
extern(C) void window_set_click_context(ButtonId button_id, void* context);

/**
 * Pushes the given window on the window navigation stack,
 * on top of the current topmost window of the app.
 *
 * Params:
 * window = The window to push on top.
 * animated = Pass in `true` to animate the push using a sliding animation,
 * or `false` to skip the animation.
 */
extern(C) void window_stack_push(Window* window, bool animated);

/**
 * Pops the topmost window on the navigation stack
 *
 * Params:
 * animated = See window_stack_remove()
 *
 * Returns: The window that is popped, or NULL if there are no windows to pop.
 */
extern(C) Window* window_stack_pop(bool animated);

/**
 * Pops all windows.
 *
 * See_Also: window_stack_remove() for a description of the `animated`
 * parameter and notes.
 */
extern(C) void window_stack_pop_all(const bool animated);

/**
 * Removes a given window from the window stack that belongs to the app task.
 *
 * Note: If there are no windows for the app left on the stack, the app
 * will be killed by the system, shortly. To avoid this, make sure to push
 * another window shortly after or before removing the last window.
 *
 * Params:
 * window = The window to remove. If the window is NULL or if it is not on the
 *     stack, this function is a no-op.
 * animated
 *     Pass in `true` to animate the removal of the window using
 *     a side-to-side sliding animation to reveal the next window.
 *     This is only used in case the window happens to be on top of the window
 *     stack (thus visible).
 *
 * Returns: true if window was successfully removed, false otherwise.
 */
extern(C) bool window_stack_remove(Window* window, bool animated);

/**
 * Gets the topmost window on the stack that belongs to the app.
 *
 * Returns: The topmost window on the stack that belongs to the app or
 * null if no app window could be found.
 */
extern(C) Window* window_stack_get_top_window();

/**
 * Checks if the window is on the window stack.
 *
 * Params:
 * window = The window to look for on the window stack.
 *
 * Returns: true if the window is currently on the window stack.
 */
extern(C) bool window_stack_contains_window(Window* window);

// TODO: Write a wrapper for the window pointers here.

struct Animation {}

/// Values that are used to indicate the different animation curves,
/// which determine the speed at which the animated value(s) change(s).
enum AnimationCurve {
    /// Linear curve: the velocity is constant.
    linear = 0,
    /// Bicubic ease-in: accelerate from zero velocity.
    easeIn = 1,
    /// Bicubic ease-in: decelerate to zero velocity.
    easeOut = 2,
    /// Bicubic ease-in-out: accelerate from zero velocity,
    /// decelerate to zero velocity
    easeInOut = 3,
    /// The default animation. (easeInOut)
    _default = easeInOut,
    /// Custom (user-provided) animation curve
    custom = 4,
    reserved1 = 5,
    reserved2 = 6,
    reserved3 = 7
}

///
alias AnimationCurveLinear = AnimationCurve.linear;
///
alias AnimationCurveEaseIn = AnimationCurve.easeIn;
///
alias AnimationCurveEaseOut = AnimationCurve.easeOut;
///
alias AnimationCurveEaseInOut = AnimationCurve.easeInOut;
///
alias AnimationCurveDefault = AnimationCurve._default;
///
alias AnimationCurveCustomFunction = AnimationCurve.custom;

/**
 * Creates a new Animation on the heap and initalizes it with the default
 * values.
 *
 * * Duration: 250ms,
 * * Curve: \ref AnimationCurveEaseInOut (ease-in-out),
 * * Delay: 0ms,
 * * Handlers: `{NULL, NULL}` (none),
 * * Context: `NULL` (none),
 * * Implementation: `NULL` (no implementation),
 * * Scheduled: no
 *
 * Returns: A pointer to the animation. `NULL` if the animation could not
 *     be created.
 */
extern(C) Animation* animation_create();

/**
 * Destroys an Animation previously created by animation_create.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_destroy(Animation* animation);

/**
 * Constant to indicate "infinite" duration.
 *
 * This can be used with \ref animation_set_duration() to indicate that the
 * animation should run indefinitely. This is useful when implementing for
 * example a frame-by-frame simulation that does not have a clear ending
 * (e.g. a game).
 *
 * Note: Note that `distance_normalized` parameter that is passed
 * into the `.update` implementation is meaningless in when an infinite
 * duration is used.
 *
 * Note: This can be returned by animation_get_duration (if the play count is
 * infinite)
 */
enum uint ANIMATION_DURATION_INFINITE = uint.max;

/// The normalized distance at the start of the animation.
enum uint ANIMATION_NORMALIZED_MIN = 0;

/// The normalized distance at the end of the animation.
enum uint ANIMATION_NORMALIZED_MAX = 65535;

/**
 * Copy an animation.
 *
 * Params:
 * from = The animation to copy.
 *
 * Returns: New animation.
 */
extern(C) Animation* animation_clone(Animation* from);

/**
 * Create a new sequence animation from a list of 2 or more other animations.
 * The returned animation owns the animations that were provided as arguments
 * and no further write operations on those handles are allowed. The variable
 * length argument list must be terminated with a null pointer.
 *
 * Note: The maximum number of animations that can be supplied to this method
 * is 20.
 *
 * Params:
 * animation_a = The first required component animation.
 * animation_b = The second required component animation.
 * animation_c = Either the third component, or null if only adding 2
 *     components.
 *
 * Returns: The newly created sequence animation.
 */
extern(C) Animation* animation_sequence_create
(Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);

/**
 * An alternate form of animation_sequence_create() that accepts an array of
 * other animations.
 *
 * Note: The maximum number of elements allowed in animation_array is 256.
 *
 * Params:
 * animation_array = An array of component animations to include.
 * array_len = The number of elements in the animation_array.
 *
 * Returns: The newly created sequence animation.
 */
extern(C) Animation* animation_sequence_create_from_array
(Animation** animation_array, uint array_len);

/**
 * Create a new spawn animation from a list of 2 or more other animations.
 * The returned animation owns the animations that were provided as arguments
 * and no further write operations on those handles are allowed. The variable
 * length argument list must be terminated with a null pointer.
 *
 * Note: The maximum number of animations that can be supplied to this method
 * is 20.
 *
 * Params:
 * animation_a = The first required component animation.
 * animation_b = The second required component animation.
 * animation_c = Either the third component, or null if only adding 2
 *     components.
 *
 * Returns: The newly created spawn animation or NULL on failure.
 */
extern(C) Animation* animation_spawn_create
(Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);

/**
 * An alternate form of animation_spawn_create() that accepts an array of other
 * animations.
 *
 * Note: The maximum number of elements allowed in animation_array is 256
 *
 * Params:
 * animation_array = An array of component animations to include.
 * array_len = The number of elements in the animation_array.
 *
 * Returns: The newly created spawn animation or NULL on failure.
 */
extern(C) Animation* animation_spawn_create_from_array
(Animation** animation_array, uint array_len);

/**
 * Seek to a specific location in the animation. Only forward seeking is
 * allowed. Returns true if successful, false if the passed in seek location
 * is invalid.
 *
 * Params:
 * animation = The animation for which to set the position.
 * milliseconds = The new location.
 *
 * Returns: true if successful, false if the requested position is invalid.
 */
extern(C) bool animation_set_position(Animation* animation, uint milliseconds);

/**
 * Get the current location in the animation.
 *
 * Note: The animation must be scheduled to get the position. If it is not
 * schedule, this method will return false.
 *
 * Params:
 * animation = The animation for which to fetch the position.
 * position = Pointer to variable that will contain the position.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_get_position(Animation* animation, int* position);

/**
 * Set an animation to run in reverse (or forward).
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation to operate on.
 * reverse = Set to true to run in reverse, false to run forward.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_reverse(Animation* animation, bool reverse);

/**
 * Get the reverse setting of an animation.
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: the reverse setting.
 */
extern(C) bool animation_get_reverse(Animation* animation);

/**
 * Set an animation to play N times. The default is 1.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation to set the play count of.
 * play_count = Number of times to play this animation.
 *     Set to ANIMATION_PLAY_COUNT_INFINITE to make an animation repeat
 *     indefinitely.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_play_count(Animation* animation, uint play_count);

/**
 * Get the play count of an animation
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: The play count.
 */
extern(C) uint animation_get_play_count (Animation* animation);

/**
 * Sets the time in milliseconds that an animation takes from start to finish.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the duration.
 * duration_ms = The duration in milliseconds of the animation. This excludes
 *     any optional delay as set using animation_set_delay().
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_duration
(Animation* animation, uint duration_ms);

/**
 * Get the static duration of an animation from start to end (ignoring how
 * much has already played, if any).
 *
 * animation = The animation for which to get the duration.
 * include_delay = If true, include the delay time.
 * include_play_count = If true, incorporate the play_count.
 *
 * Returns: The duration, in milliseconds. This includes any optional delay a
 * set using animation_set_delay.
 */
extern(C) uint animation_get_duration
(Animation* animation, bool include_delay, bool include_play_count);

/**
 * Sets an optional delay for the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the delay.
 * delay_ms = The delay in milliseconds that the animation system should
 *     wait from the moment the animation is scheduled to starting the
 *     animation.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_delay(Animation* animation, uint delay_ms);

/**
 * Get the delay of an animation in milliseconds.
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: The delay in milliseconds.
 */
extern(C) uint animation_get_delay (Animation* animation);

/**
 * Sets the animation curve for the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the curve.
 * curve = The type of curve.
 *
 * Returns: true if successful, false on failure.
 * See_Also: AnimationCurve
 */
extern(C) bool animation_set_curve(Animation* animation, AnimationCurve curve);

/**
 * Gets the animation curve for the animation.
 *
 * Params:
 * animation = The animation for which to get the curve.
 *
 * Returns: The type of curve.
 */
extern(C) AnimationCurve animation_get_curve(Animation* animation);

/**
 * The function pointer type of a custom animation curve.
 *
 * Params:
 * linear_distance = The linear normalized animation distance to be curved.
 *
 * See_Also: animation_set_custom_curve
 */
alias extern(C) uint function(uint linear_distance) AnimationCurveFunction;

/**
 * Sets a custom animation curve function.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the curve.
 * curve_function = The custom animation curve function.
 *
 * Returns: true if successful, false on failure.
 * See_Also: AnimationCurveFunction
 */
extern(C) bool animation_set_custom_curve
(Animation* animation, AnimationCurveFunction curve_function);

/**
 * Gets the custom animation curve function for the animation.
 *
 * Params:
 * animation = The animation for which to get the curve.
 *
 * Returns: The custom animation curve function for the given animation.
 *     null if not set.
 */
extern(C) AnimationCurveFunction animation_get_custom_curve
(Animation* animation);

/**
 * The function pointer type of the handler that will be called when an
 * animation is started, just before updating the first frame of the animation.
 *
 * Note: This is called after any optional delay as set by
 *     animation_set_delay() has expired.
 *
 * Params:
 * animation = The animation that was started.
 * context = The pointer to custom, application specific data, as set using
 *     animation_set_handlers()
 *
 * See_Also: animation_set_handlers
 */
alias extern(C) void function
(Animation* animation, void* context)
AnimationStartedHandler;

/**
 * The function pointer type of the handler that will be called when the
 * animation is stopped.
 *
 * Params:
 * animation = The animation that was stopped.
 * finished = true if the animation was stopped because it was finished
 *     normally, or false if the animation was stopped prematurely, because it
 *     was unscheduled before finishing.
 * context = The pointer to custom, application specific data, as set using
 *     animation_set_handlers()
 *
 * See_Also: animation_set_handlers
 */
alias extern(C) void function
(Animation* animation, bool finished, void* context)
AnimationStoppedHandler;

/**
 * The handlers that will get called when an animation starts and stops.
 * See documentation with the function pointer types for more information.
 *
 * See_Also: animation_set_handlers
 */
struct AnimationHandlers {
    /// The handler that will be called when an animation is started.
    AnimationStartedHandler started;
    /// The handler that will be called when an animation is stopped.
    AnimationStoppedHandler stopped;
}

/**
 * Sets the callbacks for the animation.
 *
 * Often an application needs to run code at the start or at the end of an
 * animation. Using this function is possible to register callback functions
 * with an animation, that will get called at the start and end of the
 * animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will
 * return false (failure). An animation is immutable once it has been added to
 * a sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set up the callbacks.
 * callbacks = The callbacks.
 * context = A pointer to application specific data, that will be passed as an
 *     argument by the animation subsystem when a callback is called.
 *
 * Returns: true if successful, false on failure
 */
extern(C) bool animation_set_handlers
(Animation* animation, AnimationHandlers callbacks, void* context);

/**
 * Gets the application-specific callback context of the animation.
 *
 * This `void` pointer is passed as an argument when the animation system
 * calls AnimationHandlers callbacks. The context pointer can be set to point
 * to any application specific data using animation_set_handlers().
 *
 * Params: animation The animation.
 *
 * See_Also: animation_set_handlers
 */
extern(C) void* animation_get_context(Animation* animation);

/**
 * Schedules the animation. Call this once after configuring an animation to
 * get it to start running.
 *
 *
 * If the animation's implementation has a `.setup` callback it will get
 * called before this function returns.
 *
 * Note: If the animation was already scheduled, it will first unschedule it
 * and then re-schedule it again.
 *
 * Note that in that case, the animation's `.stopped` handler, the
 * implementation's `.teardown` and `.setup` will get called, due to the
 * unscheduling and scheduling.
 *
 * Params:
 * animation = The animation to schedule.
 *
 * Returns: true if successful, false on failure
 *
 * See_Also: animation_unschedule()
 */
extern(C) bool animation_schedule(Animation* animation);

/**
 * Unschedules the animation, which in effect stops the animation.
 *
 * Note: If the animation was not yet finished, unscheduling it will
 * cause its `.stopped` handler to get called, with the "finished" argument
 * set to false.
 *
 * Note: If the animation is not scheduled or null, calling this routine is
 * effectively a no-op.
 *
 * Params:
 * animation = The animation to unschedule.
 *
 * See_Also: animation_schedule()
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_unschedule(Animation* animation);

/**
 * Unschedules all animations of the application.
 *
 * See_Also: animation_unschedule
 */
extern(C) void animation_unschedule_all();

/**
 * Note: An animation will be scheduled when it is running and not finished
 * yet. An animation that has finished is automatically unscheduled.
 * For convenience, passing in a NULL animation argument will simply return
 * false.
 *
 * Params:
 * animation = The animation for which to get its scheduled state.
 *
 * Returns: true if the animation was scheduled, or false if it was not.
 *
 * See_Also: animation_schedule
 * See_Also: animation_unschedule
 */
extern(C) bool animation_is_scheduled(Animation* animation);

/**
 * Pointer to function that (optionally) prepares the animation for running.
 * This callback is called when the animation is added to the scheduler.
 *
 * Params:
 * animation = The animation that needs to be set up.
 *
 * See_Also: animation_schedule
 * See_Also: AnimationTeardownImplementation
 */
alias extern(C) void function
(Animation* animation)
AnimationSetupImplementation;

/**
 * Pointer to function that updates the animation according to the given
 * normalized distance.
 *
 * This callback will be called repeatedly by the animation scheduler
 * whenever the animation needs to be updated.
 *
 * This is a value between ANIMATION_NORMALIZED_MIN and
 * ANIMATION_NORMALIZED_MAX.
 *
 * At the start of the animation, the value will be ANIMATION_NORMALIZED_MIN.
 * At the end of the animation, the value will be ANIMATION_NORMALIZED_MAX.
 *
 * For each frame during the animation, the value will be the distance along
 * the animation path, mapped between ANIMATION_NORMALIZED_MIN and
 * ANIMATION_NORMALIZED_MAX based on the animation duration and the
 * AnimationCurve set.
 *
 * For example, say an animation was scheduled at t = 1.0s, has a delay of
 * 1.0s, a duration of 2.0s and a curve of AnimationCurveLinear.
 *
 * Then the .update callback will get called on t = 2.0s with
 * distance_normalized = ANIMATION_NORMALIZED_MIN. For each frame
 * thereafter until t = 4.0s, the update callback will get called where
 * distance_normalized is
 * (ANIMATION_NORMALIZED_MIN +
 * (((ANIMATION_NORMALIZED_MAX - ANIMATION_NORMALIZED_MIN) * t) / duration)).
 *
 * Other animation curves will result in a non-linear relation between
 * distance_normalized and time.
 *
 * Params:
 * animation = The animation that needs to update; gets passed in by the
 *     animation framework.
 * distance_normalized = The current normalized distance; gets passed in
 *     by the animation framework for each animation frame.
 */
alias extern(C) void function
(Animation* animation, uint distance_normalized)
AnimationUpdateImplementation;

/**
 * Pointer to function that (optionally) cleans up the animation.
 * This callback is called when the animation is removed from the scheduler.
 * In case the `.setup` implementation allocated any memory, this is a good
 * place to release that memory again.
 *
 * Params:
 * animation = The animation that needs to be teared down.
 *
 * See_Also: animation_unschedule
 * See_Also: AnimationSetupImplementation
 */
alias extern(C) void function(Animation*) AnimationTeardownImplementation;


/**
 * The 3 callbacks that implement a custom animation.
 *
 * Only the `.update` callback is mandatory, `.setup` and `.teardown` are
 * optional. See the documentation with the function pointer typedefs for more
 * information.
 *
 * Note: The `.setup` callback is called immediately after scheduling the
 * animation, regardless if there is a delay set for that animation using
 * animation_set_delay().
 *
 * The diagram below illustrates the order in which callbacks can be expected
 * to get called over the life cycle of an animation. It also illustrates where
 * the implementation of different animation callbacks are intended to be
 * “living”.  ![](animations.png)
 *
 * See_Also: AnimationSetupImplementation
 * See_Also: AnimationUpdateImplementation
 * See_Also: AnimationTeardownImplementation
 */
struct AnimationImplementation {
    /**
     * Called by the animation system when an animation is scheduled, to
     * prepare it for running. This callback is optional and can be left
     * null when not needed.
     */
    AnimationSetupImplementation setup;
    /**
     * Called by the animation system when the animation needs to calculate
     * the next animation frame. This callback is mandatory and should not be
     * left null.
     */
    AnimationUpdateImplementation update;
    /**
     * Called by the animation system when an animation is unscheduled, to
     * clean up after it has run. This callback is optional and can be left
     * null when not needed.
     */
    AnimationTeardownImplementation teardown;
}

/**
 * Sets the implementation of the custom animation.
 *
 * When implementing custom animations, use this function to specify what
 * functions need to be called to for the setup, frame update and teardown of
 * the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the implementation.
 * implementation = The structure with function pointers to the implementation
 *     of the setup, update and teardown functions.
 *
 * Returns: true if successful, false on failure.
 *
 * See_Also: AnimationImplementation
 */
extern(C) bool animation_set_implementation
(Animation* animation, const(AnimationImplementation)* implementation);

/**
 * Gets the implementation of the custom animation.
 *
 * Params:
 * animation = The animation for which to get the implementation.
 *
 * See_Also: AnimationImplementation
 *
 * Returns: null if animation implementation has not been setup.
 */
extern(C) const(AnimationImplementation)*
animation_get_implementation(Animation* animation);

/**
 * Function signature of a getter function to get the current property of type
 * short of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) short function(void*) Int16Getter;

/**
 * Function signature of a setter function to set a property of type
 * short onto the subject.
 *
 * See_Also: property_animation_update_int16()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, short int16) Int16Setter;

/**
 * Function signature of a setter function to set a property of type GPoint
 * onto the subject.
 *
 * See_Also: property_animation_update_gpoint()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GPoint gpoint) GPointSetter;

/**
 * Function signature of a getter function to get the current property of type
 * GPoint of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GPoint function(void* subject) GPointGetter;

/**
 * Function signature of a setter function to set a property of type
 * GRect onto the subject.
 *
 * See_Also: property_animation_update_grect()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GRect grect) GRectSetter;

/**
 * Function signature of a getter function to get the current property of type
 * GRect of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GRect function(void* subject) GRectGetter;

/**
 * Function signature of a setter function to set a property of type GColor8
 * onto the subject.
 *
 * See_Also: property_animation_update_gcolor8()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GColor8 gcolor) GColor8Setter;

/**
 * Function signature of a getter function to get the current property of type
 * GColor8 of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GColor8 function(void* subject) GColor8Getter;

/// The setter types for setting a animation properties.
union PropertyAnimationSetters {
    /// Use if the property to animate is a short.
    Int16Setter int16;
    /// Use if the property to animate is a GPoint.
    GPointSetter gpoint;
    /// Use if the property to animate is a GRect.
    GRectSetter grect;
    /// Use if the property to animate is a GColor8.
    GColor8Setter gcolor8;
}

/// The getter types for getting animation properties.
union PropertyAnimationGetters {
    /// Use if the property to animate is a short.
    Int16Getter int16;
    /// Use if the property to animate is a GPoint.
    GPointGetter gpoint;
    /// Use if the property to animate is a GRect.
    GRectGetter grect;
    /// Use if the property to animate is a GColor8.
    GColor8Getter gcolor8;
}

/**
 * Data structure containing the setter and getter function pointers that the
 * property animation should use.
 *
 * The specified setter function will be used by the animation's update
 * callback.
 *
 * Based on the type of the property (int16_t, GPoint or GRect), the
 * accompanying update callback should be used.
 *
 * The getter function is used when the animation is initialized, to assign
 * the current value of the subject's property as "from" or "to" value.
 *
 * See_Also: property_animation_update_int16(),
 * See_Also: property_animation_update_gpoint()
 * See_Also: property_animation_update_grect()
 * See_Also: property_animation_create().
 */
struct PropertyAnimationAccessors {
    PropertyAnimationSetters setter;
    PropertyAnimationGetters getter;
}

/**
 * Data structure containing a collection of function pointers that form the
 * implementation of the property animation.
 */
struct PropertyAnimationImplementation {
    /// The "inherited" fields from the Animation "base class".
    AnimationImplementation base;
    /// The accessors to set/get the property to be animated.
    PropertyAnimationAccessors accessors;
}

struct PropertyAnimation {}

/**
 * Convenience function to create and initialize a property animation that
 * animates the frame of a Layer. It sets up the PropertyAnimation to use
 * layer_set_frame() and layer_get_frame() as accessors and uses the `layer`
 * parameter as the subject for the animation.
 *
 * The same defaults are used as with animation_create().
 *
 * Note: Pass in null as one of the frame arguments to have it set
 * automatically to the layer's current frame. This will result in a call to
 * layer_get_frame() to get the current frame of the layer.
 *
 * Params:
 * layer = The layer that will be animated.
 * from_frame = The frame that the layer should animate from.
 * to_frame = The frame that the layer should animate to.
 *
 * Returns: A handle to the property animation.
 *     null if animation could not be created
 */
extern(C) PropertyAnimation* property_animation_create_layer_frame
(Layer* layer, GRect* from_frame, GRect* to_frame);

/**
 * Creates a new PropertyAnimation on the heap and and initializes it with the
 * specified values.
 *
 * The same defaults are used as with animation_create().
 *
 * If the from_value or the to_value is null, the getter accessor will be
 * called to get the current value of the property and be used instead.
 *
 * Params:
 * implementation = Pointer to the implementation of the animation. In most
 *     cases, it makes sense to pass in a `static const` struct pointer.
 * subject = Pointer to the "subject" being animated. This will be passed in
 *     when the getter/setter accessors are called,
 *     The value of this pointer will be copied into the `.subject` field of
 *     the PropertyAnimation struct.
 * from_value = Pointer to the value that the subject should animate from.
 * to_value = Pointer to the value that the subject should animate to.
 *
 * Note: Pass in null as one of the value arguments to have it set
 * automatically to the subject's current property value, as returned by the
 * getter function. Also note that passing in null for both from_value and
 * to_value, will result in the animation having the same from- and to- values,
 * effectively not doing anything.
 *
 * Returns: A handle to the property animation. null if animation could not be
 *     created.
 *
 * See_Also: PropertyAnimationAccessors
 * See_Also: GPointSetter
 */
extern(C) PropertyAnimation* property_animation_create
(const(PropertyAnimationImplementation)* implementation,
void* subject, void* from_value, void* to_value);

/**
 * Destroy a property animation allocated by property_animation_create() or
 * relatives.
 *
 * Params:
 * property_animation = The return value from property_animation_create.
 */
extern(C) void property_animation_destroy
(PropertyAnimation* property_animation);

/**
 * Default update callback for a property animations to update a property of
 * type int16_t.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types Int16Getter and Int16Setter.
 *
 * The implementation of this function will calculate the next value of the
 * animation and call the setter to set the new value upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation
 */
extern(C) void property_animation_update_int16
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Default update callback for a property animations to update a property of
 * type GPoint.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types GPointGetter and GPointSetter.
 *
 * The implementation of this function will calculate the next point of the
 * animation and call the setter to set the new point upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation.
 */
extern(C) void property_animation_update_gpoint
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Default update callback for a property animations to update a property of
 * type GRect.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types GRectGetter and GRectSetter. The implementation
 * of this function will calculate the next rectangle of the animation and
 * call the setter to set the new rectangle upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation
 */
extern(C) void property_animation_update_grect
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Convenience function to retrieve an animation instance from a property
 * animation instance.
 *
 * Params:
 * property_animation = The property animation.
 *
 * Returns: The Animation within this PropertyAnimation.
 */
extern(C) Animation* property_animation_get_animation
(PropertyAnimation* property_animation);


/**
 * Convenience function to clone a property animation instance
 *
 * Params:
 * from = The property animation
 *
 * Returns: A clone of the original Animation.
 */
PropertyAnimation* property_animation_clone(PropertyAnimation* from) {
    return cast(PropertyAnimation*) animation_clone(cast(Animation*) from);
}

/**
 * Helper function used by the property_animation_get|set_subject macros.
 *
 * Params:
 * property_animation = Handle to the property animation.
 * subject = The subject to get or set.
 * set = true to set new subject, false to retrieve existing value.
 *
 * Returns: true if successful, false on failure (usually a bad animation_h)
 */
pure
extern(C) bool property_animation_subject
(PropertyAnimation* property_animation, void** subject, bool set);

/**
 * Helper function used by the property_animation_get|set_from_.* macros.
 *
 * Params:
 * property_animation = Handle to the property animation.
 * from = Pointer to the value.
 * size = Size of the from value.
 * set = true to set new value, false to retrieve existing one.
 *
 * Returns: true if successful, false on failure (usually a bad animation_h)
 */
pure
extern(C) bool property_animation_from
(PropertyAnimation* property_animation, void* from, size_t size, bool set);


/**
 * Helper function used by the property_animation_get|set_to_.* macros
 *
 * Params:
 * property_animation = Handle to the property animation.
 * to = Pointer to the value.
 * size = Size of the to value.
 * set = true to set new value, false to retrieve existing one.
 *
 * Returns: true if successful, false on failure (usually a bad animation_h)
 */
pure
extern(C) bool property_animation_to
(PropertyAnimation* property_animation, void* to, size_t size, bool set);

/**
 * Convenience function to retrieve the 'from' GRect value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure
 */
deprecated("Use animation.from_grect instead of this function")
pure
bool property_animation_get_from_grect
(PropertyAnimation* property_animation, GRect* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, GRect.sizeof, false);
}

/// Get a 'from' GRect in a safe way.
/// An AssertionError will be thrown if getting the rect fails.
@trusted pure
@property GRect from_grect(const(PropertyAnimation)* property_animation) {
    GRect rect;

    auto returnValue = property_animation_from(
        cast(PropertyAnimation*) property_animation,
        &rect,
        GRect.sizeof,
        false
    );

    assert(returnValue, "Getting a GRect failed!");

    return rect;
}

/**
 * Convenience function to set the 'from' GRect value of property animation
 * handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.from = rect; instead of this function")
pure
bool property_animation_set_from_grect
(PropertyAnimation* property_animation, GRect* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, GRect.sizeof, true);
}

/// Set a 'from' GRect in a safe way.
/// An AssertionError will be thrown if setting the rect fails.
@trusted pure
@property void from
(PropertyAnimation* property_animation, GRect rect) {
    auto returnValue = property_animation_from(
        property_animation, &rect, GRect.sizeof, true);

    assert(returnValue, "Setting a GRect failed!");
}

/**
 * Convenience function to retrieve the 'from' GPoint value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure
 */
deprecated("Use animation.from_gpoint instead of this function")
pure
bool property_animation_get_from_gpoint
(PropertyAnimation* property_animation, GPoint* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, GPoint.sizeof, false);
}

/// Get a 'from' GPoint in a safe way.
/// An AssertionError will be thrown if getting the point fails.
@trusted pure
@property GPoint from_gpoint(const(PropertyAnimation)* property_animation) {
    GPoint point;

    auto returnValue = property_animation_from(
        cast(PropertyAnimation*) property_animation,
        &point,
        GPoint.sizeof,
        false
    );

    assert(returnValue, "Getting a GPoint failed!");

    return point;
}

/**
 * Convenience function to set the 'from' GPoint value of property animation
 * handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure
 */
deprecated("Use animation.from = point; instead of this function")
pure
bool property_animation_set_from_gpoint
(PropertyAnimation* property_animation, GPoint* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, GPoint.sizeof, true);
}

/// Set a 'from' GPoint in a safe way.
/// An AssertionError will be thrown if setting the point fails.
@trusted pure
@property void from
(PropertyAnimation* property_animation, GPoint point) {
    auto returnValue = property_animation_from(
        property_animation, &point, GPoint.sizeof, true);

    assert(returnValue, "Setting a GPoint failed!");
}

/**
 * Convenience function to retrieve the 'from' int16_t value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.from_int16; instead of this function")
pure
bool property_animation_get_from_int16
(PropertyAnimation* property_animation, short* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, short.sizeof, false);
}

/// Get a 'from' short in a safe way.
/// An AssertionError will be thrown if getting the short fails.
@trusted pure
@property short from_int16(const(PropertyAnimation)* property_animation) {
    short value;

    auto returnValue = property_animation_from(
        cast(PropertyAnimation*) property_animation,
        &value,
        short.sizeof,
        false
    );

    assert(returnValue, "Getting a GPoint failed!");

    return value;
}

/**
 * Convenience function to set the 'from' int16_t value of property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure
 */
deprecated("Use animation.from = value; instead of this function")
pure
bool property_animation_set_from_int16
(PropertyAnimation* property_animation, short* value_ptr) {
    return property_animation_from(
        property_animation, value_ptr, short.sizeof, true);
}

/// Set a 'from' short in a safe way.
/// An AssertionError will be thrown if setting the short fails.
@trusted pure
@property void from
(PropertyAnimation* property_animation, short value) {
    auto returnValue = property_animation_from(
        property_animation, &value, short.sizeof, true);

    assert(returnValue, "Setting a short failed!");
}

/**
 * Convenience function to retrieve the 'to' GRect value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.to_grect instead of this function")
pure
bool property_animation_get_to_grect
(PropertyAnimation* property_animation, GRect* value_ptr) {
    return property_animation_to(
        property_animation, value_ptr, GRect.sizeof, false);
}

/// Get a 'to' GRect in a safe way.
/// An AssertionError will be thrown if getting the rect fails.
@trusted pure
@property GRect to_grect(const(PropertyAnimation)* property_animation) {
    GRect rect;

    auto returnValue = property_animation_to(
        cast(PropertyAnimation*) property_animation,
        &rect,
        GRect.sizeof,
        false
    );

    assert(returnValue, "Getting a GRect failed!");

    return rect;
}

/**
 * Convenience function to set the 'to' GRect value of property animation
 * handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.to = rect; instead of this function")
pure
bool property_animation_set_to_grect
(PropertyAnimation* property_animation, GRect* value_ptr) {
    return property_animation_to(
        property_animation, value_ptr, GRect.sizeof, true);
}

/// Set a 'to' GRect in a safe way.
/// An AssertionError will be thrown if setting the rect fails.
@trusted pure
@property void to
(PropertyAnimation* property_animation, GRect rect) {
    auto returnValue = property_animation_to(
        property_animation, &rect, GRect.sizeof, true);

    assert(returnValue, "Setting a GRect failed!");
}

/**
 * Convenience function to retrieve the 'to' GPoint value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure
 */
deprecated("Use animation.to_gpoint instead of this function")
pure
bool property_animation_get_to_gpoint
(PropertyAnimation* property_animation, GPoint* value_ptr) {
    return property_animation_to(
        property_animation, value_ptr, GPoint.sizeof, false);
}

/// Get a 'to' GPoint in a safe way.
/// An AssertionError will be thrown if getting the point fails.
@trusted pure
@property GPoint to_gpoint(const(PropertyAnimation)* property_animation) {
    GPoint point;

    auto returnValue = property_animation_to(
        cast(PropertyAnimation*) property_animation,
        &point,
        GPoint.sizeof,
        false
    );

    assert(returnValue, "Getting a GPoint failed!");

    return point;
}

/**
 * Convenience function to set the 'to' GPoint value of property animation
 * handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.to = point; instead of this function")
pure
bool property_animation_set_to_gpoint
(PropertyAnimation* property_animation, GPoint* value_ptr) {
    return property_animation_to
        (property_animation, value_ptr, GPoint.sizeof, true);
}

/// Set a 'to' GPoint in a safe way.
/// An AssertionError will be thrown if setting the point fails.
@trusted pure
@property void to
(PropertyAnimation* property_animation, GPoint point) {
    auto returnValue = property_animation_to(
        property_animation, &point, GPoint.sizeof, true);

    assert(returnValue, "Setting a GPoint failed!");
}

/**
 * Convenience function to retrieve the 'to' int16_t value from property
 * animation handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = The value will be retrieved into this pointer.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.to_int16 instead of this function")
pure
bool property_animation_get_to_int16
(PropertyAnimation* property_animation, short* value_ptr) {
    return property_animation_to
        (property_animation, value_ptr, short.sizeof, false);
}

/// Get a 'to' short in a safe way.
/// An AssertionError will be thrown if getting the short fails.
@trusted pure
@property short to_int16(const(PropertyAnimation)* property_animation) {
    short value;

    auto returnValue = property_animation_to(
        cast(PropertyAnimation*) property_animation,
        &value,
        short.sizeof,
        false
    );

    assert(returnValue, "Getting a short failed!");

    return value;
}

/**
 * Convenience function to set the 'to' int16_t value of property animation
 * handle.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new value.
 *
 * Returns: true on success, false on failure.
 */
deprecated("Use animation.to = value; instead of this function")
pure
bool property_animation_set_to_int16
(PropertyAnimation* property_animation, short* value_ptr) {
    return property_animation_to
        (property_animation, value_ptr, short.sizeof, true);
}

/// Set a 'to' short in a safe way.
/// An AssertionError will be thrown if setting the short fails.
@trusted pure
@property void to
(PropertyAnimation* property_animation, short value) {
    auto returnValue = property_animation_to(
        property_animation, &value, short.sizeof, true);

    assert(returnValue, "Setting a short failed!");
}

/**
 * Retrieve the subject of a property animation
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer used to store the subject of this property animation.
 *
 * Returns: The subject of this PropertyAnimation.
 */
deprecated("Use animation.subject instead of this function")
pure
bool property_animation_get_subject
(PropertyAnimation* property_animation, void** value_ptr) {
    return property_animation_subject(property_animation, value_ptr, false);
}

/// Get a 'subject' in a safe way.
/// An AssertionError will be thrown if getting the subject fails.
@trusted pure
@property void* subject(const(PropertyAnimation)* property_animation) {
    void* subject;

    auto returnValue = property_animation_subject(
        cast(PropertyAnimation*) property_animation,
        &subject,
        false
    );

    assert(returnValue, "Getting the subject failed!");

    return subject;
}

/**
 * Set the subject of a property animation.
 *
 * Params:
 * property_animation = The PropertyAnimation to be accessed.
 * value_ptr = Pointer to the new subject value.
 */
deprecated("Use animation.subject = subject; instead of this function")
pure
bool property_animation_set_subject
(PropertyAnimation* property_animation, void** value_ptr) {
    return property_animation_subject(property_animation, value_ptr, true);
}

/// Get a 'subject' in a safe way.
/// An AssertionError will be thrown if getting the short fails.
@trusted pure
@property void subject(PropertyAnimation* property_animation, void* subject) {
    auto returnValue = property_animation_subject(
        property_animation, &subject, true);

    assert(returnValue, "Getting the subject failed!");
}

struct TextLayer {}

/**
 * Creates a new TextLayer on the heap and initializes it with the default
 * values.
 *
 * Font: Raster Gothic 14-point Boldface (system font)
 * Text Alignment: GTextAlignmentLeft
 * Text color: GColorBlack
 * Background color: GColorWhite
 * Clips: `true`
 * Hidden: `false`
 * Caching: `false`
 *
 * The text layer is automatically marked dirty after this operation.
 *
 * Params:
 * frame = The frame with which to initialze the TextLayer.
 *
 * Returns: A pointer to the TextLayer. null if the TextLayer could not be
 * created.
 */
extern(C) TextLayer* text_layer_create(GRect frame);

/// Destroys a TextLayer previously created by text_layer_create.
extern(C) void text_layer_destroy(TextLayer* text_layer);

/**
 * Gets the "root" Layer of the text layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * text_layer = Pointer to the TextLayer for which to get the "root" Layer.
 *
 * Returns: The "root" Layer of the text layer.
 */
extern(C) Layer* text_layer_get_layer(TextLayer* text_layer);

/**
 * Sets the pointer to the string where the TextLayer is supposed to find
 * the text at a later point in time, when it needs to draw itself.
 *
 * Params:
 * text_layer = The TextLayer of which to set the text.
 * text = The new text to set onto the TextLayer. This must be
 *     a null-terminated and valid UTF-8 string!
 *
 * Note: The string is not copied, so its buffer most likely cannot be stack
 * allocated, but is recommended to be a buffer that is long-lived, at least
 * as long as the TextLayer is part of a visible Layer hierarchy.
 *
 * See_Also: text_layer_get_text
 */
extern(C) void text_layer_set_text(TextLayer* text_layer, const(char)* text);

/**
 * Gets the pointer to the string that the TextLayer is using.
 *
 * Params:
 * text_layer = The TextLayer for which to get the text.
 *
 * See_Also: text_layer_set_text
 */
extern(C) const(char)* text_layer_get_text(TextLayer* text_layer);

/**
 * Sets the background color of bounding box that will be drawn behind the
 * text.
 *
 * Params:
 * text_layer = The TextLayer of which to set the background color.
 * color = The new \ref GColor to set the background to.
 *
 * See_Also: text_layer_set_text_color
 */
extern(C) void text_layer_set_background_color
(TextLayer* text_layer, GColor color);

/**
 * Sets the color of text that will be drawn
 *
 * Params:
 * text_layer = The TextLayer of which to set the text color.
 * color = The new GColor to set the text color to.
 *
 * See_Also: text_layer_set_background_color
 */
extern(C) void text_layer_set_text_color
(TextLayer* text_layer, GColor color);

/**
 * Sets the line break mode of the TextLayer
 *
 * Params:
 * text_layer = The TextLayer of which to set the overflow mode.
 * line_mode = The new GTextOverflowMode to set.
 */
extern(C) void text_layer_set_overflow_mode
(TextLayer* text_layer, GTextOverflowMode line_mode);

/**
 * Sets the font of the TextLayer
 *
 * Params:
 * text_layer = The TextLayer of which to set the font.
 * font = The new GFont for the TextLayer.
 *
 * See_Also: fonts_get_system_font
 * See_Also: fonts_load_custom_font
 */
extern(C) void text_layer_set_font(TextLayer* text_layer, GFont font);

/**
 * Sets the alignment of the TextLayer
 *
 * Params:
 * text_layer = The TextLayer of which to set the alignment.
 * text_alignment = The new text alignment for the TextLayer.
 *
 * See_Also: GTextAlignment
 */
extern(C) void text_layer_set_text_alignment
(TextLayer* text_layer, GTextAlignment text_alignment);

/**
 * Calculates the size occupied by the current text of the TextLayer.
 *
 * Params:
 * text_layer = The TextLayer for which to calculate the text's size.
 *
 * Returns: The size occupied by the current text of the TextLayer.
 */
extern(C) GSize text_layer_get_content_size(TextLayer* text_layer);

/**
 * Update the size of the text layer.
 * This is a convenience function to update the frame of the TextLayer.
 *
 * Params:
 * text_layer = The TextLayer of which to set the size.
 * max_size = The new size for the TextLayer.
 */
extern(C) void text_layer_set_size
(TextLayer* text_layer, const GSize max_size);



/// Function signature for the `.content_offset_changed_handler` callback.
alias extern(C) void function
(ScrollLayer* scroll_layer, void* context) ScrollLayerCallback;

/**
 * All the callbacks that the ScrollLayer exposes for use by applications.
 *
 * Note: The context parameter can be set using scroll_layer_set_context() and
 * gets passed in as context with all of these callbacks.
 */
struct ScrollLayerCallbacks {
    /**
     * Provider function to set up the SELECT button handlers. This will be
     * called after the scroll layer has configured the click configurations
     * for the up/down buttons, so it can also be used to modify the default
     * up/down scrolling behavior.
     */
    ClickConfigProvider click_config_provider;

    /**
     * Called every time the the content offset changes. During a scrolling
     * animation, it will be called for each intermediary offset as well.
     */
    ScrollLayerCallback content_offset_changed_handler;
}

/**
 * Creates a new ScrollLayer on the heap and initalizes it with the default
 * values:
 *
 * Clips: `true`
 * Hidden: `false`
 * Content size: `frame.size`
 * Content offset: GPointZero
 * Callbacks: None (null for each one)
 * Callback context: null
 *
 * Returns: A pointer to the ScrollLayer. null if the ScrollLayer could not
 * be created.
 */
extern(C) ScrollLayer* scroll_layer_create(GRect frame);

/// Destroys a ScrollLayer previously created by scroll_layer_create.
extern(C) void scroll_layer_destroy(ScrollLayer* scroll_layer);

/**
 * Gets the "root" Layer of the scroll layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * scroll_layer = Pointer to the ScrollLayer for which to get the "root" Layer.
 *
 * Returns: The "root" Layer of the scroll layer.
 */
extern(C) Layer* scroll_layer_get_layer(const(ScrollLayer)* scroll_layer);

/**
 * Adds the child layer to the content sub-layer of the ScrollLayer.
 * This will make the child layer part of the scrollable contents.
 * The content sub-layer of the ScrollLayer will become the parent of the
 * child layer.
 *
 * Note: You may need to update the size of the scrollable contents using
 * scroll_layer_set_content_size().
 *
 * Params:
 * scroll_layer = The ScrollLayer to which to add the child layer.
 * child = The Layer to add to the content sub-layer of the ScrollLayer.
 */
extern(C) void scroll_layer_add_child(ScrollLayer* scroll_layer, Layer* child);

/**
 * Convenience function to set the ClickConfigProvider callback on the
 * given window to scroll layer's internal click config provider.
 * This internal click configuration provider, will set up the default
 * UP & DOWN scrolling behavior.
 *
 * This function calls \ref window_set_click_config_provider_with_context to
 * accomplish this.
 *
 * If you application has set a `.click_config_provider` callback using
 * scroll_layer_set_callbacks(), this will be called by the internal click
 * config provider, after configuring the UP & DOWN buttons. This allows your
 * application to configure the SELECT button behavior and optionally override
 * the UP & DOWN button behavior. The callback context for the SELECT click
 * recognizer is automatically set to the scroll layer's context (see
 * scroll_layer_set_context() ). This context is passed into ClickHandler
 * callbacks. For the UP and DOWN buttons, the scroll layer itself is passed
 * in by default as the callback context in order to deal with those buttons
 * presses to scroll up and down automatically.
 *
 * Params:
 * scroll_layer = The ScrollLayer that needs to receive click events.
 * window = The window for which to set the click configuration.
 *
 * See_Also: Clicks
 * See_Also: window_set_click_config_provider_with_context
 */
extern(C) void scroll_layer_set_click_config_onto_window
(ScrollLayer* scroll_layer, Window* window);

/**
 * Sets the callbacks that the scroll layer exposes.
 * The `context` as set by scroll_layer_set_context() is passed into each
 * of the callbacks. See ScrollLayerCallbacks for the different callbacks.
 *
 * Note: If the `context` is NULL, a pointer to scroll_layer is used as context
 * parameter instead when calling callbacks.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to assign new callbacks.
 * callbacks = The new callbacks.
 */
extern(C) void scroll_layer_set_callbacks
(ScrollLayer* scroll_layer, ScrollLayerCallbacks callbacks);

/**
 * Sets a new callback context. This context is passed into the scroll layer's
 * callbacks and also the ClickHandler for the SELECT button.
 *
 * If null or not set, the context defaults to a pointer to the ScrollLayer
 * itself.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to assign the new callback context.
 * context = The new callback context.
 *
 * See_Also: scroll_layer_set_click_config_onto_window
 * See_Also: scroll_layer_set_callbacks
 */
extern(C) void scroll_layer_set_context
(ScrollLayer* scroll_layer, void* context);

/**
 * Scrolls to the given offset, optionally animated.
 *
 * Note: When scrolling down, the offset's `.y` decrements. When scrolling up,
 * the offset's `.y` increments. If scrolled completely to the top, the offset
 * is GPointZero.
 *
 * Note: The `.x` field must be `0`. Horizontal scrolling is not supported.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to set the content offset.
 * offset = The final content offset.
 * animated = Pass in `true` to animate to the new content offset, or
 *     false to set the new content offset without animating.
 *
 * See_Also: scroll_layer_get_content_offset
 */
extern(C) void scroll_layer_set_content_offset
(ScrollLayer* scroll_layer, GPoint offset, bool animated);

/**
 * Gets the point by which the contents are offset.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to get the content offset.
 *
 * See_Also: scroll_layer_set_content_offset
 */
extern(C) GPoint scroll_layer_get_content_offset(ScrollLayer* scroll_layer);

/**
 * Sets the size of the contents layer. This determines the area that is
 * scrollable. At the moment, this needs to be set "manually" and is not
 * derived from the geometry of the contents layers.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to set the content size.
 * size = The new content size.
 *
 * See_Also: scroll_layer_get_content_size
 */
extern(C) void scroll_layer_set_content_size
(ScrollLayer* scroll_layer, GSize size);

/**
 * Gets the size of the contents layer.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to get the content size.
 *
 * See_Also: scroll_layer_set_content_size
 */
extern(C) GSize scroll_layer_get_content_size
(const(ScrollLayer)* scroll_layer);

/**
 * Set the frame of the scroll layer and adjusts the internal layers' geometry
 * accordingly. The scroll layer is marked dirty automatically.
 *
 * Params:
 * scroll_layer = The ScrollLayer for which to set the frame.
 * frame = The new frame.
 */
extern(C) void scroll_layer_set_frame(ScrollLayer* scroll_layer, GRect frame);

/**
 * The click handlers for the UP button that the scroll layer will install as
 * part of scroll_layer_set_click_config_onto_window().
 *
 * Note: This handler is exposed, in case one wants to implement an alternative
 * handler for the UP button, as a way to invoke the default behavior.
 *
 * Params:
 * recognizer = The click recognizer for which the handler is called.
 * context = A void pointer to the ScrollLayer that is the context of the
 *     click event.
 */
extern(C) void scroll_layer_scroll_up_click_handler
(void* recognizer, void* context);

/**
 * The click handlers for the DOWN button that the scroll layer will install as
 * part of scroll_layer_set_click_config_onto_window().
 *
 * Note: This handler is exposed, in case one wants to implement an alternative
 * handler for the DOWN button, as a way to invoke the default behavior.
 *
 * Params:
 * recognizer = The click recognizer for which the handler is called.
 * context = A void pointer to the ScrollLayer that is the context of the
 *     click event.
 */
extern(C) void scroll_layer_scroll_down_click_handler
(void* recognizer, void* context);

/**
 * Sets the visibility of the scroll layer shadow.
 * If the visibility has changed, layer_mark_dirty() will be called
 * automatically on the scroll layer.
 *
 * Params:
 * scroll_layer = The scroll layer for which to set the shadow visibility.
 * hidden = Supply true to make the shadow hidden, or false to make it
 *     non-hidden.
 */
extern(C) void scroll_layer_set_shadow_hidden
(ScrollLayer* scroll_layer, bool hidden);

/**
 * Gets the visibility of the scroll layer shadow.
 *
 * Params:
 * scroll_layer = The scroll layer for which to get the visibility.
 *
 * Returns: true if the shadow is hidden, false if it is not hidden.
 */
extern(C) bool scroll_layer_get_shadow_hidden
(const(ScrollLayer)* scroll_layer);

/// Layer that inverts anything "below it".
struct InverterLayer {}

/**
 * Creates a new InverterLayer on the heap and initializes it with the
 * default values.
 *
 * Clips: `true`
 * Hidden: `false`
 *
 * Returns: A pointer to the InverterLayer. null if the InverterLayer could
 * not be created.
 */
extern(C) InverterLayer* inverter_layer_create(GRect frame);

/// Destroys an InverterLayer previously created by inverter_layer_create.
extern(C) void inverter_layer_destroy(InverterLayer* inverter_layer);

/**
 * Gets the "root" Layer of the inverter layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * inverter_layer = Pointer to the InverterLayer for which to get the "root"
 *     Layer.
 *
 * Returns: The "root" Layer of the inverter layer.
 */
extern(C) Layer* inverter_layer_get_layer(InverterLayer* inverter_layer);

/**
 * Section drawing function to draw a basic section cell with the title,
 * subtitle, and icon of the section.
 *
 * Call this function inside the `.draw_row` callback implementation, see
 * MenuLayerCallbacks.
 *
 * Params:
 * ctx = The destination graphics context.
 * cell_layer = The layer of the cell to draw.
 * title = If non-null, draws a title in larger text (24 points, bold
 *     Raster Gothic system font).
 * subtitle = If non-null, draws a subtitle in smaller text (18 points,
 *     Raster Gothic system font). If null, the title will be centered
 *     vertically inside the menu cell.
 * icon = If non-null, draws an icon to the left of the text. If null,
 *     the icon will be omitted and the leftover space is used for the title
 *     and subtitle.
 */
extern(C) void menu_cell_basic_draw(GContext* ctx, const(Layer)* cell_layer,
const(char)* title, const(char)* subtitle, GBitmap* icon);

/**
 * Cell drawing function to draw a basic menu cell layout with title, subtitle.
 * Cell drawing function to draw a menu cell layout with only one big title.
 *
 * Call this function inside the `.draw_row` callback implementation, see
 * MenuLayerCallbacks.
 *
 * Params:
 * ctx = The destination graphics context.
 * cell_layer = The layer of the cell to draw.
 * title = If non-null, draws a title in larger text (28 points, bold
 *     Raster Gothic system font).
 */
extern(C) void menu_cell_title_draw
(GContext* ctx, const(Layer)* cell_layer, const(char)* title);

/**
 * Section header drawing function to draw a basic section header cell layout
 * with the title of the section.
 *
 * Call this function inside the `.draw_header` callback implementation, see
 * MenuLayerCallbacks.
 *
 * Params:
 * ctx = The destination graphics context.
 * cell_layer = The layer of the cell to draw.
 * title = If non-null, draws the title in small text (14 points, bold
 *     Raster Gothic system font).
 */
extern(C) void menu_cell_basic_header_draw
(GContext* ctx, const(Layer)* cell_layer, const(char)* title);

/// Default section header height in pixels.
enum short MENU_CELL_BASIC_HEADER_HEIGHT = 16;

///
enum short MENU_INDEX_NOT_FOUND = short.min;

/**
 * Data structure to represent an menu item's position in a menu, by
 * specifying the section index and the row index within that section.
 */
struct MenuIndex {
    /// The index of the section.
    ushort section;
    /// The index of the row within the section with index `.section`
    ushort row;

    /// Compare two MenuIndex objects, first by section, then by row.
    @nogc @safe pure nothrow
    int opCmp(MenuIndex other) const {
        if (section < other.section) {
            return -1;
        }

        if (section > other.section) {
            return 1;
        }

        if (row < other.row) {
            return -1;
        }

        if (row > other.row) {
            return 1;
        }

        return 0;
    }
}

/**
 * Comparator function to determine the order of two MenuIndex values.
 *
 * Params:
 * a = Pointer to the menu index of the first item.
 * b = Pointer to the menu index of the second item.
 *
 * Returns: 0 if A and B are equal, 1 if A has a higher section & row
 *     combination than B or else -1.
 */
deprecated("Use a < b instead of menu_index_compare(&a, &b) == -1, etc.")
short menu_index_compare(MenuIndex* a, MenuIndex* b) {
    return cast(short) a.opCmp(*b);
}

///
struct MenuCellSpan {
    ///
    short y;
    ///
    short h;
    ///
    short sep;
    ///
    MenuIndex index;
}

struct MenuLayer {}

/**
 * Function signature for the callback to get the number of sections in a menu.
 *
 * Params:
 * menu_layer = The menu layer for which the data is requested.
 * callback_context = The callback context.
 *
 * Returns: The number of sections in the menu.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) ushort function
(MenuLayer* menu_layer, void* callback_context)
MenuLayerGetNumberOfSectionsCallback;

/**
 * Function signature for the callback to get the number of rows in a
 * given section in a menu.
 *
 * Params:
 * menu_layer = The menu layer for which the data is requested.
 * section_index = The index of the section of the menu for which the
 *     number of items it contains is requested
 * callback_context = The callback context.
 *
 * Returns: The number of rows in the given section in the menu.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) ushort function
(MenuLayer* menu_layer, ushort section_index, void* callback_context)
MenuLayerGetNumberOfRowsInSectionsCallback;

/**
 * Function signature for the callback to get the height of the menu cell
 * at a given index.
 *
 * Params:
 * menu_layer = The menu layer for which the data is requested.
 * cell_index = The MenuIndex for which the cell height is requested.
 * callback_context = The callback context.
 *
 * Returns: The height of the cell at the given MenuIndex.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) short function
(MenuLayer* menu_layer, MenuIndex* cell_index, void* callback_context)
MenuLayerGetCellHeightCallback;

/**
 * Function signature for the callback to get the height of the section header
 * at a given section index.
 *
 * Params:
 * menu_layer = The menu layer for which the data is requested.
 * section_index = The index of the section for which the header height is
 *     requested.
 * callback_context = The callback context.
 *
 * Returns: The height of the section header at the given section index.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) short function
(MenuLayer* menu_layer, ushort section_index, void* callback_context)
MenuLayerGetHeaderHeightCallback;

/**
 * Function signature for the callback to get the height of the separator
 * at a given index.
 *
 * Params:
 * menu_layer = The menu layer for which the data is requested.
 * cell_index = The MenuIndex for which the cell height is requested.
 * callback_context = The callback context.
 *
 * Returns: The height of the separator at the given MenuIndex.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) short function
(MenuLayer* menu_layer, MenuIndex* cell_index, void* callback_context)
MenuLayerGetSeparatorHeightCallback;

/**
 * Function signature for the callback to render the menu cell at a given
 * MenuIndex.
 *
 * Note: The `cell_layer` argument is provided to make it easy to re-use an
 * `.update_proc` implementation in this callback. Only the bounds and frame
 * of the `cell_layer` are actually valid and other properties should be
 * ignored.
 *
 * Params:
 * ctx = The destination graphics context to draw into.
 * cell_layer = The cell's layer, containing the geometry of the cell.
 * cell_index = The MenuIndex of the cell that needs to be drawn.
 * callback_context = The callback context.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) void function(GContext* ctx, const(Layer)* cell_layer,
MenuIndex* cell_index, void* callback_context)
MenuLayerDrawRowCallback;

/**
 * Function signature for the callback to render the section header at a given
 * section index.
 *
 * Note: The `cell_layer` argument is provided to make it easy to re-use an
 * `.update_proc` implementation in this callback. Only the bounds and frame
 * of the `cell_layer` are actually valid and other properties should be
 * ignored.
 *
 * Params:
 * ctx = The destination graphics context to draw into
 * cell_layer = The header cell's layer, containing the geometry of the
 *     header cell
 * section_index = The section index of the section header that needs to
 *     be drawn
 * callback_context = The callback context
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) void function (GContext* ctx, const(Layer)* cell_layer,
ushort section_index, void* callback_context)
MenuLayerDrawHeaderCallback;

/**
 * Function signature for the callback to render the separator at a given
 * MenuIndex.
 *
 * Note: The `cell_layer` argument is provided to make it easy to re-use an
 * `.update_proc` implementation in this callback. Only the bounds and frame
 * of the `cell_layer` are actually valid and other properties should be
 * ignored.
 *
 * Params:
 * ctx = The destination graphics context to draw into.
 * cell_layer = The cell's layer, containing the geometry of the cell.
 * cell_index = The MenuIndex of the separator that needs to be drawn.
 * callback_context = The callback context.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) void function(GContext* ctx, const(Layer)* cell_layer,
MenuIndex* cell_index, void* callback_context) MenuLayerDrawSeparatorCallback;

/**
 * Function signature for the callback to handle the event that a user hits
 * the SELECT button.
 *
 * Params:
 * menu_layer = The menu layer for which the selection event occurred.
 * cell_index = The MenuIndex of the cell that is selected.
 * callback_context = The callback context.
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) void function
(MenuLayer* menu_layer, MenuIndex* cell_index, void* callback_context)
MenuLayerSelectCallback;

/**
 * Function signature for the callback to handle a change in the current
 * selected item in the menu.
 *
 * Params:
 * menu_layer = The menu layer for which the selection event occurred.
 * new_index = The MenuIndex of the new item that is selected now.
 * old_index = The MenuIndex of the old item that was selected before.
 * callback_context = The callback context
 *
 * See_Also: menu_layer_set_callbacks()
 * See_Also: MenuLayerCallbacks
 */
alias extern(C) void function(MenuLayer* menu_layer,
MenuIndex new_index, MenuIndex old_index, void* callback_context)
MenuLayerSelectionChangedCallback;

/// Data structure containing all the callbacks of a MenuLayer.
struct MenuLayerCallbacks {
    /**
     * Callback that gets called to get the number of sections in the menu.
     * This can get called at various moments throughout the life of a menu.
     *
     * Note: When null, the number of sections defaults to 1.
     */
    MenuLayerGetNumberOfSectionsCallback get_num_sections;

    /**
     * Callback that gets called to get the number of rows in a section. This
     * can get called at various moments throughout the life of a menu.
     *
     * Note: Must be set to a valid callback; null causes undefined behavior.
     */
    MenuLayerGetNumberOfRowsInSectionsCallback get_num_rows;

    /**
     * Callback that gets called to get the height of a cell.
     * This can get called at various moments throughout the life of a menu.
     *
     * Note: When null, the default height of 44 pixels is used.
     */
    MenuLayerGetCellHeightCallback get_cell_height;

    /**
     * Callback that gets called to get the height of a section header.
     * This can get called at various moments throughout the life of a menu.
     *
     * Note: When null, the defaults height of 0 pixels is used. This disables
     * section headers.
     */
    MenuLayerGetHeaderHeightCallback get_header_height;

    /**
     * Callback that gets called to render a menu item.
     *
     * This gets called for each menu item, every time it needs to be
     * re-rendered.
     *
     * Note: Must be set to a valid callback; `NULL` causes undefined behavior.
     */
    MenuLayerDrawRowCallback draw_row;

    /**
     * Callback that gets called to render a section header.
     * This gets called for each section header, every time it needs to be
     * re-rendered.
     *
     * Note: Must be set to a valid callback, unless `.get_header_height` is
     * null. Causes undefined behavior otherwise.
     */
    MenuLayerDrawHeaderCallback draw_header;

    /**
     * Callback that gets called when the user triggers a click with the
     * SELECT button.
     *
     * Note: When null, click events for the SELECT button are ignored.
     */
    MenuLayerSelectCallback select_click;

    /**
     * Callback that gets called when the user triggers a long click with the
     * SELECT button.
     *
     * Note: When null, long click events for the SELECT button are ignored.
     */
    MenuLayerSelectCallback select_long_click;

    /**
     * Callback that gets called whenever the selection changes.
     *
     * Note: When null, selection change events are ignored.
     */
    MenuLayerSelectionChangedCallback selection_changed;

    /**
     * Callback that gets called to get the height of a separator.
     * This can get called at various moments throughout the life of a menu.
     *
     * Note: When null, the default height of 1 is used.
     */
    MenuLayerGetSeparatorHeightCallback get_separator_height;

    /**
     * Callback that gets called to render a separator.
     *
     * This gets called for each separator, every time it needs to be
     * re-rendered.
     *
     * Note: Must be set to a valid callback, unless `.get_separator_height` is
     * null. Causes undefined behavior otherwise.
     */
    MenuLayerDrawSeparatorCallback draw_separator;
}

/**
 * Creates a new MenuLayer on the heap and initalizes it with the default
 * values.
 *
 * Clips: `true`
 * Hidden: `false`
 * Content size: `frame.size`
 * Content offset: GPointZero
 * Callbacks: None (null for each one)
 * Callback context: null
 *
 * After the relevant callbacks are called to populate the menu, the item at
 * MenuIndex(0, 0) will be selected initially.
 *
 * Returns: A pointer to the MenuLayer. null if the MenuLayer could not
 *     be created.
 */
extern(C) MenuLayer* menu_layer_create(GRect frame);

/// Destroys a MenuLayer previously created by menu_layer_create.
extern(C) void menu_layer_destroy(MenuLayer* menu_layer);

/**
 * Gets the "root" Layer of the menu layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * menu_layer = Pointer to the MenuLayer for which to get the "root" Layer.
 *
 * Returns: The "root" Layer of the menu layer.
 */
extern(C) Layer* menu_layer_get_layer(const(MenuLayer)* menu_layer);

/**
 * Gets the ScrollLayer of the menu layer, which is the layer responsible for
 * the scrolling of the menu layer.
 *
 * Params:
 * menu_layer = Pointer to the MenuLayer for which to get the ScrollLayer.
 *
 * Returns: The ScrollLayer of the menu layer.
 */
extern(C) ScrollLayer* menu_layer_get_scroll_layer
(const(MenuLayer)* menu_layer);

/**
 * Sets the callbacks for the MenuLayer.
 *
 * Params:
 * menu_layer = Pointer to the MenuLayer for which to set the callbacks
 *     and callback context.
 * callback_context = The new callback context. This is passed into each
 *     of the callbacks and can be set to point to application provided data.
 * callbacks = The new callbacks for the MenuLayer. The storage for this
 *     data structure must be long lived. Therefore, it cannot be
 *     stack-allocated.
 *
 * See_Also: MenuLayerCallbacks
 */
extern(C) void menu_layer_set_callbacks
(MenuLayer* menu_layer, void* callback_context, MenuLayerCallbacks callbacks);

/**
 * Convenience function to set the ClickConfigProvider callback on the
 * given window to menu layer's internal click config provider. This internal
 * click configuration provider, will set up the default UP & DOWN
 * scrolling / menu item selection behavior.
 *
 * This function calls scroll_layer_set_click_config_onto_window to
 * accomplish this.
 *
 * Click and long click events for the SELECT button can be handled by
 * installing the appropriate callbacks using menu_layer_set_callbacks().
 * This is a deviation from the usual click configuration provider pattern.
 *
 * Params:
 * menu_layer = The MenuLayer that needs to receive click events.
 * window = The window for which to set the click configuration.
 *
 * See_Also: Clicks
 * See_Also: window_set_click_config_provider_with_context()
 * See_Also: scroll_layer_set_click_config_onto_window()
 */
extern(C) void menu_layer_set_click_config_onto_window
(MenuLayer* menu_layer, Window* window);

/**
 * Values to specify how a (selected) row should be aligned relative to the
 * visible area of the MenuLayer.
 */
enum MenuRowAlign {
    /// Don't align or update the scroll offset of the MenuLayer.
    none = 0,
    /// Scroll the contents of the MenuLayer in such way that the selected row
    /// is centered relative to the visible area.
    center = 1,
    /// Scroll the contents of the MenuLayer in such way that the selected row
    /// is at the top of the visible area.
    top = 2,
    /// Scroll the contents of the MenuLayer in such way that the selected row
    /// is at the bottom of the visible area.
    bottom = 3
}

///
enum MenuRowAlignNone = MenuRowAlign.none;
///
enum MenuRowAlignCenter = MenuRowAlign.center;
///
enum MenuRowAlignTop = MenuRowAlign.top;
///
enum MenuRowAlignBottom = MenuRowAlign.bottom;

/**
 * Selects the next or previous item, relative to the current selection.
 *
 * Note: If there is no next/previous item, this function is a no-op.
 *
 * Params:
 * menu_layer = The MenuLayer for which to select the next item.
 * up = Supply `false` to select the next item in the list (downwards),
 *     or `true` to select the previous item in the list (upwards).
 * scroll_align = The alignment of the new selection.
 * animated = Supply `true` to animate changing the selection, or `false`
 *     to change the selection instantly.
 */
extern(C) void menu_layer_set_selected_next
(MenuLayer* menu_layer, bool up, MenuRowAlign scroll_align, bool animated);

/**
 * Selects the item with given MenuIndex.
 *
 * Note: If the section and/or row index exceeds the avaible number of sections
 * or resp. rows, the exceeding index/indices will be capped, effectively
 * selecting the last section and/or row, resp.
 *
 * Params:
 * menu_layer = The MenuLayer for which to change the selection.
 * index = The index of the item to select.
 * scroll_align = The alignment of the new selection.
 * animated = Supply `true` to animate changing the selection, or `false`
 *     to change the selection instantly.
 */
extern(C) void menu_layer_set_selected_index(MenuLayer* menu_layer,
MenuIndex index, MenuRowAlign scroll_align, bool animated);

/**
 * Gets the MenuIndex of the currently selection menu item.
 *
 * Params:
 * menu_layer = The MenuLayer for which to get the current selected index.
 */
extern(C) MenuIndex menu_layer_get_selected_index
(const(MenuLayer)* menu_layer);

/**
 * Reloads the data of the menu. This causes the menu to re-request the menu
 * item data, by calling the relevant callbacks.
 *
 * The current selection and scroll position will not be changed. See the
 * note with menu_layer_set_selected_index() for the behavior if the
 * old selection is no longer valid.
 *
 * Params:
 * menu_layer = The MenuLayer for which to reload the data.
 */
extern(C) void menu_layer_reload_data(MenuLayer* menu_layer);

/**
 * By default, there are no 2.x style shadows on MenuLayers.
 * This allows for the shadows to be toggled on the given MenuLayer.
 */
extern(C) void menu_layer_shadow_enable(MenuLayer* menu_layer, bool enable);

/// Wrapper around MenuLayer, that uses static data to display a list menu.
struct SimpleMenuLayer {}

/**
 * Function signature for the callback to handle the event that a user hits
 * the SELECT button.
 *
 * Params:
 * index = The row index of the item.
 * context = The callback context.
 */
alias extern(C) void function(int index, void* context)
SimpleMenuLayerSelectCallback;

/// Data structure containing the information of a menu item.
struct SimpleMenuItem {
    /// The title of the menu item. Required.
    const(char)* title;
    /// The subtitle of the menu item. Optional, leave null if unused.
    const(char)* subtitle;
    /// The icon of the menu item. Optional, leave null if unused.
    GBitmap* icon;
    /// The callback that needs to be called upon a click on the SELECT button.
    /// Optional, leave null if unused.
    SimpleMenuLayerSelectCallback callback;
}

/// Data structure containing the information of a menu section.
struct SimpleMenuSection {
    /// Title of the section. Optional, leave null if unused.
    const(char)* title;
    /// Array of items in the section.
    const(SimpleMenuItem)* items;
    /// Number of items in the `.items` array.
    uint num_items;
}

/**
 * Creates a new SimpleMenuLayer on the heap and initializes it.
 *
 * It also sets the internal click configuration provider onto given window.
 *
 * Note: The `sections` array is not deep-copied and can therefore not be
 * stack allocated, but needs to be backed by long-lived storage.
 *
 * Note: This function does not add the menu's layer to the window.
 *
 * Params:
 * frame = The frame at which to initialize the menu.
 * window = The window onto which to set the click configuration provider.
 * sections = Array with sections that need to be displayed in the menu.
 * num_sections = The number of sections in the `sections` array.
 * callback_context = Pointer to application specific data, that is passed
 *     into the callbacks.
 *
 * Returns: A pointer to the SimpleMenuLayer. null if the SimpleMenuLayer
 * could not be created.
 */
extern(C) SimpleMenuLayer* simple_menu_layer_create
(GRect frame, Window* window, const(SimpleMenuSection)* sections,
int num_sections, void* callback_context);

// Destroys a SimpleMenuLayer previously created by simple_menu_layer_create.
extern(C) void simple_menu_layer_destroy(SimpleMenuLayer* menu_layer);

/**
 * Gets the "root" Layer of the simple menu layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * simple_menu = Pointer to the SimpleMenuLayer for which to get the "root"
 *     Layer.
 *
 * Returns: The "root" Layer of the menu layer.
 */
extern(C) Layer* simple_menu_layer_get_layer
(const(SimpleMenuLayer)* simple_menu);

/**
 * Gets the row index of the currently selection menu item.
 *
 * Params:
 * simple_menu = The SimpleMenuLayer for which to get the current selected
 *     row index.
 */
extern(C) int simple_menu_layer_get_selected_index
(const(SimpleMenuLayer)* simple_menu);

/**
 * Selects the item in the first section at given row index.
 *
 * Params:
 * simple_menu = The SimpleMenuLayer for which to change the selection.
 * index = The row index of the item to select.
 * animated = Supply `true` to animate changing the selection, or `false`
 *     to change the selection instantly.
 */
extern(C) void simple_menu_layer_set_selected_index
(SimpleMenuLayer* simple_menu, int index, bool animated);

/**
 * Params:
 * simple_menu = The SimpleMenuLayer to get the MenuLayer from.
 *
 * Returns: The MenuLayer.
 */
extern(C) MenuLayer* simple_menu_layer_get_menu_layer
(SimpleMenuLayer* simple_menu);

/// The width of the action bar in pixels.
enum ACTION_BAR_WIDTH = 20;

/// The maximum number of action bar items.
enum NUM_ACTION_BAR_ITEMS = 3;

struct ActionBarLayer {}

/**
 * Creates a new ActionBarLayer on the heap and initalizes it with the
 * default values.
 *
 * Background color: GColorBlack
 * No click configuration provider (`NULL`)
 * No icons
 * Not added to / associated with any window, thus not catching any button
 * input yet.
 *
 * Returns: A pointer to the ActionBarLayer. null if the ActionBarLayer could
 * not be created.
 */
extern(C) ActionBarLayer* action_bar_layer_create();

/// Destroys a ActionBarLayer previously created by action_bar_layer_create.
extern(C) void action_bar_layer_destroy(ActionBarLayer* action_bar_layer);

/**
 * Gets the "root" Layer of the action bar layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * action_bar_layer = Pointer to the ActionBarLayer for which to get the
 *     "root" Layer.
 *
 * Returns: The "root" Layer of the action bar layer.
 */
extern(C) Layer* action_bar_layer_get_layer(ActionBarLayer* action_bar_layer);

/**
 * Sets the context parameter, which will be passed in to ClickHandler
 * callbacks and the ClickConfigProvider callback of the action bar.
 *
 * Note: By default, a pointer to the action bar itself is passed in, if the
 * context has not been set or if it has been set to null.
 *
 * Params:
 * action_bar = The action bar for which to assign the new context.
 * context = The new context.
 *
 * See_Also: action_bar_layer_set_click_config_provider()
 * See_Also: Clicks
 */
extern(C) void action_bar_layer_set_context
(ActionBarLayer* action_bar, void* context);

/**
 * Sets the click configuration provider callback of the action bar.
 * In this callback your application can associate handlers to the different
 * types of click events for each of the buttons, see Clicks.
 *
 * Note: If the action bar had already been added to a window and the window
 * is currently on-screen, the click configuration provider will be called
 * before this function returns. Otherwise, it will be called by the system
 * when the window becomes on-screen.
 *
 * Note: The `.raw` handlers cannot be used without breaking the automatic
 * highlighting of the segment of the action bar that for which a button is.
 *
 * See_Also: action_bar_layer_set_icon()
 *
 * Params:
 * action_bar = The action bar for which to assign a new click configuration
 *     provider.
 * click_config_provider = The new click configuration provider.
 */
extern(C) void action_bar_layer_set_click_config_provider
(ActionBarLayer* action_bar, ClickConfigProvider click_config_provider);

/**
 * Sets an action bar icon onto one of the 3 slots as identified by `button_id`.
 * Only BUTTON_ID_UP, BUTTON_ID_SELECT and BUTTON_ID_DOWN can be used.
 * Whenever an icon is set, the click configuration provider will be called,
 * to give the application the opportunity to reconfigure the button
 * interaction.
 *
 * Params:
 * action_bar = The action bar for which to set the new icon.
 * button_id = The identifier of the button for which to set the icon.
 * icon = Pointer to the GBitmap icon
 *
 * See_Also: action_bar_layer_set_click_config_provider()
 */
extern(C) void action_bar_layer_set_icon
(ActionBarLayer* action_bar, ButtonId button_id, const(GBitmap)* icon);

/**
 * Convenience function to clear out an existing icon.
 * All it does is call `action_bar_layer_set_icon(action_bar, button_id, NULL)`
 *
 * Params:
 * action_bar = The action bar for which to clear an icon.
 * button_id = The identifier of the button for which to clear the icon.
 *
 * See_Also: action_bar_layer_set_icon()
 */
extern(C) void action_bar_layer_clear_icon
(ActionBarLayer* action_bar, ButtonId button_id);

/**
 * Adds the action bar's layer on top of the window's root layer. It also
 * adjusts the layout of the action bar to match the geometry of the window it
 * gets added to.
 *
 * Lastly, it calls window_set_click_config_provider_with_context() on
 * the window to set it up to work with the internal callback and raw click
 * handlers of the action bar, to enable the highlighting of the section of the
 * action bar when the user presses a button.
 *
 * Note: After this call, do not use
 * window_set_click_config_provider_with_context() with the window that
 * the action bar has been added to (this would de-associate the action bar's
 * click config provider and context). Instead use
 * action_bar_layer_set_click_config_provider() and
 * action_bar_layer_set_context() to register the click configuration
 * provider to configure the buttons actions.
 *
 * Note: It is advised to call this is in the window's `.load` or `.appear`
 * handler. Make sure to call \ref action_bar_layer_remove_from_window() in the
 * window's `.unload` or `.disappear` handler.
 *
 * Note: Adding additional layers to the window's root layer after this call
 * can occlude the action bar.
 *
 * Params:
 * action_bar = The action bar to associate with the window.
 * window = The window with which the action bar is to be associated.
 */
extern(C) void action_bar_layer_add_to_window
(ActionBarLayer* action_bar, Window* window);

/**
 * Removes the action bar from the window and unconfigures the window's
 * click configuration provider. null is set as the window's new click config
 * provider and also as its callback context. If it has not been added to a
 * window before, this function is a no-op.
 *
 * Params:
 * action_bar = The action bar to de-associate from its current window.
 */
extern(C) void action_bar_layer_remove_from_window(ActionBarLayer* action_bar);

/**
 * Sets the background color of the action bar. Defaults to GColorBlack.
 *
 * The action bar's layer is automatically marked dirty.
 *
 * Params:
 * action_bar = The action bar of which to set the background color.
 * background_color = The new background color.
 */
extern(C) void action_bar_layer_set_background_color
(ActionBarLayer* action_bar, GColor background_color);

struct BitmapLayer {}

// TODO: We got here last in our journey through the headers.

alias extern(C) void function (NumberWindow*, void*) NumberWindowCallback;
alias _Anonymous_34 NumberWindowCallbacks;
alias _Anonymous_35 VibePattern;


enum _Anonymous_8 {
    ACCEL_SAMPLING_10HZ = 10,
    ACCEL_SAMPLING_25HZ = 25,
    ACCEL_SAMPLING_50HZ = 50,
    ACCEL_SAMPLING_100HZ = 100
}

enum _Anonymous_10 {
    CompassStatusDataInvalid = 0,
    CompassStatusCalibrating = 1,
    CompassStatusCalibrated = 2
}

enum _Anonymous_12
{
    SECOND_UNIT = 1,
    MINUTE_UNIT = 2,
    HOUR_UNIT = 4,
    DAY_UNIT = 8,
    MONTH_UNIT = 16,
    YEAR_UNIT = 32
}





struct _Anonymous_34
{
    NumberWindowCallback incremented;
    NumberWindowCallback decremented;
    NumberWindowCallback selected;
}

struct _Anonymous_35
{
    const(uint)* durations;
    uint num_segments;
}



struct NumberWindow;





struct ScrollLayer;


struct RotBitmapLayer;



extern(C) BitmapLayer* bitmap_layer_create (GRect frame);
extern(C) void bitmap_layer_destroy (BitmapLayer* bitmap_layer);
extern(C) Layer* bitmap_layer_get_layer (const(BitmapLayer)* bitmap_layer);
extern(C) const(GBitmap)* bitmap_layer_get_bitmap (BitmapLayer* bitmap_layer);
extern(C) void bitmap_layer_set_bitmap (BitmapLayer* bitmap_layer, const(GBitmap)* bitmap);
extern(C) void bitmap_layer_set_alignment (BitmapLayer* bitmap_layer, GAlign alignment);
extern(C) void bitmap_layer_set_background_color (BitmapLayer* bitmap_layer, GColor color);
extern(C) void bitmap_layer_set_compositing_mode (BitmapLayer* bitmap_layer, GCompOp mode);
extern(C) RotBitmapLayer* rot_bitmap_layer_create (GBitmap* bitmap);
extern(C) void rot_bitmap_layer_destroy (RotBitmapLayer* bitmap);
extern(C) void rot_bitmap_layer_set_corner_clip_color (RotBitmapLayer* bitmap, GColor color);
extern(C) void rot_bitmap_layer_set_angle (RotBitmapLayer* bitmap, int angle);
extern(C) void rot_bitmap_layer_increment_angle (RotBitmapLayer* bitmap, int angle_change);
extern(C) void rot_bitmap_set_src_ic (RotBitmapLayer* bitmap, GPoint ic);
extern(C) void rot_bitmap_set_compositing_mode (RotBitmapLayer* bitmap, GCompOp mode);
extern(C) NumberWindow* number_window_create (const(char)* label, NumberWindowCallbacks callbacks, void* callback_context);
extern(C) void number_window_destroy (NumberWindow* number_window);
extern(C) void number_window_set_label (NumberWindow* numberwindow, const(char)* label);
extern(C) void number_window_set_max (NumberWindow* numberwindow, int max);
extern(C) void number_window_set_min (NumberWindow* numberwindow, int min);
extern(C) void number_window_set_value (NumberWindow* numberwindow, int value);
extern(C) void number_window_set_step_size (NumberWindow* numberwindow, int step);
extern(C) int number_window_get_value (const(NumberWindow)* numberwindow);
extern(C) Window* number_window_get_window (NumberWindow* numberwindow);
extern(C) void vibes_cancel ();
extern(C) void vibes_short_pulse ();
extern(C) void vibes_long_pulse ();
extern(C) void vibes_double_pulse ();
extern(C) void vibes_enqueue_custom_pattern (VibePattern pattern);
extern(C) void light_enable_interaction ();
extern(C) void light_enable (bool enable);
extern(C) tm* localtime (const(time_t)* timep);
extern(C) tm* gmtime (const(time_t)* timep);
extern(C) time_t mktime (tm* tb);
extern(C) time_t time (time_t* tloc);
extern(C) ushort time_ms (time_t* tloc, ushort* out_ms);
