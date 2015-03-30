/**
 * This module mirrors the basalt and aplite Pebble headers with color
 * definitions, etc.
 */
module pebble;

// TODO: Pebble declared its own tm struct.
// We should probably use that instead.
import core.stdc.time;
import core.stdc.config;

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
enum BUTTON_ID_BACK = ButtonId.back;
///
enum BUTTON_ID_UP = ButtonId.up;
///
enum BUTTON_ID_SELECT = ButtonId.select;
///
enum BUTTON_ID_DOWN = ButtonId.down;
///
enum NUM_BUTTONS = ButtonId.num;

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
enum WATCH_INFO_MODEL_UNKNOWN = WatchInfoModel.unknown;
///
enum WATCH_INFO_MODEL_PEBBLE_ORIGINAL = WatchInfoModel.original;
///
enum WATCH_INFO_MODEL_PEBBLE_STEEL = WatchInfoModel.steel;
///
enum WATCH_INFO_MODEL_PEBBLE_TIME = WatchInfoModel.time;

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
enum WATCH_INFO_COLOR_UNKNOWN = WatchInfoColor.unknown;
///
enum WATCH_INFO_COLOR_BLACK = WatchInfoColor.black;
///
enum WATCH_INFO_COLOR_WHITE = WatchInfoColor.white;
///
enum WATCH_INFO_COLOR_RED = WatchInfoColor.red;
///
enum WATCH_INFO_COLOR_ORANGE = WatchInfoColor.orange;
///
enum WATCH_INFO_COLOR_GREY = WatchInfoColor.grey;
///
enum WATCH_INFO_COLOR_STAINLESS_STEEL = WatchInfoColor.stainless_steel;
///
enum WATCH_INFO_COLOR_MATTE_BLACK = WatchInfoColor.matte_black;
///
enum WATCH_INFO_COLOR_BLUE = WatchInfoColor.blue;
///
enum WATCH_INFO_COLOR_GREEN = WatchInfoColor.green;
///
enum WATCH_INFO_COLOR_PINK = WatchInfoColor.pink;
///
enum WATCH_INFO_COLOR_TIME_WHITE = WatchInfoColor.time_white;
///
enum WATCH_INFO_COLOR_TIME_BLACK = WatchInfoColor.time_black;
///
enum WATCH_INFO_COLOR_TIME_RED = WatchInfoColor.time_red;

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
enum TODAY = WeekDay.today;
///
enum SUNDAY = WeekDay.sunday;
///
enum MONDAY = WeekDay.monday;
///
enum TUESDAY = WeekDay.tuesday;
///
enum WEDNESDAY = WeekDay.wednesday;
///
enum THURSDAY = WeekDay.thursday;
///
enum FRIDAY = WeekDay.friday;
///
enum SATURDAY = WeekDay.saturday;

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
alias void function(bool connected) BluetoothConnectionHandler;

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
alias void function(bool in_focus) AppFocusHandler;

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
alias void function(BatteryChargeState charge) BatteryStateHandler;

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
enum ACCEL_AXIS_X = AccelAxisType.x;
///
enum ACCEL_AXIS_Y = AccelAxisType.y;
///
enum ACCEL_AXIS_Z = AccelAxisType.z;

/**
 * Callback type for accelerometer data events.
 *
 * Params:
 * data = Pointer to the collected accelerometer samples.
 * num_samples = the number of samples stored in data.
 */
alias void function (AccelData* data, uint num_samples) AccelDataHandler;

/**
 * Callback type for accelerometer raw data events
 *
 * Params:
 * data = Pointer to the collected accelerometer samples.
 * num_samples = The number of samples stored in data.
 * timestamp = The timestamp, in ms, of the first sample.
 */
alias void function (AccelRawData* data, uint num_samples, c_ulong timestamp) AccelRawDataHandler;

/**
 * Callback type for accelerometer tap events.
 *
 * Params:
 * axis = the axis on which a tap was registered (x, y, or z)
 * direction = the direction (-1 or +1) of the tap
 */
alias void function (AccelAxisType axis, int direction) AccelTapHandler;

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
enum ACCEL_SAMPLING_10HZ = AccelSamplingRate._10hz;
///
enum ACCEL_SAMPLING_25HZ = AccelSamplingRate._25hz;
///
enum ACCEL_SAMPLING_50HZ = AccelSamplingRate._50hz;
///
enum ACCEL_SAMPLING_100HZ = AccelSamplingRate._100hz;

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
enum CompassStatusDataInvalid = CompassStatus.data_invaild;
///
enum CompassStatusCalibrating = CompassStatus.calibrating;
///
enum CompassStatusCalibrated = CompassStatus.calibrated;

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
alias void function (CompassHeadingData heading) CompassHeadingHandler;

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
enum SECOND_UNIT = TimeUnits.second;
///
enum MINUTE_UNIT = TimeUnits.minute;
///
enum HOUR_UNIT = TimeUnits.hour;
///
enum DAY_UNIT = TimeUnits.day;
///
enum MONTH_UNIT = TimeUnits.month;
///
enum YEAR_UNIT = TimeUnits.year;

/// FIXME: tm was redefined here.

/**
 * Callback type for tick timer events
 *
 * Params:
 * tick_time = the time at which the tick event was triggered
 * units_changed = which unit change triggered this tick event
 */
alias void function (tm* tick_time, TimeUnits units_changed) TickHandler;

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
enum DATA_LOGGING_BYTE_ARRAY = DataLoggingItemType.byte_array;
///
enum DATA_LOGGING_UINT = DataLoggingItemType._uint;
///
enum DATA_LOGGING_INT = DataLoggingItemType._int;

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
enum DATA_LOGGING_SUCCESS = DataLoggingResult.success;
///
enum DATA_LOGGING_BUSY = DataLoggingResult.busy;
///
enum DATA_LOGGING_FULL = DataLoggingResult.full;
///
enum DATA_LOGGING_NOT_FOUND = DataLoggingResult.not_found;
///
enum DATA_LOGGING_CLOSED = DataLoggingResult.closed;
///
enum DATA_LOGGING_INVALID_PARAMS = DataLoggingResult.invalid_params;

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
enum APP_LOG_LEVEL_ERROR = AppLogLevel.error;
///
enum APP_LOG_LEVEL_WARNING = AppLogLevel.warning;
///
enum APP_LOG_LEVEL_INFO = AppLogLevel.info;
///
enum APP_LOG_LEVEL_DEBUG = AppLogLevel._debug;
///
enum APP_LOG_LEVEL_VERBOSE = AppLogLevel.verbose;

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
extern(C) void app_log(AppLogLevel log_level, const(char)* src_filename, int src_line_number, const(char)* fmt, ...);

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
int src_line_number = __LINE__, const(char)* src_filename = __FILE__) {
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
enum DICT_OK = DictionaryResult.ok;
///
enum DICT_NOT_ENOUGH_STORAGE = DictionaryResult.not_enough_storage;
///
enum DICT_INVALID_ARGS = DictionaryResult.invalid_args;
///
enum DICT_INTERNAL_INCONSISTENCY = DictionaryResult.internal_inconsistency;
///
enum DICT_MALLOC_FAILED = DictionaryResult.malloc_failed;

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
enum TUPLE_BYTE_ARRAY = TupleType.byte_array;
///
enum TUPLE_CSTRING = TupleType.cstring;
///
enum TUPLE_UINT = TupleType._uint;
///
enum TUPLE_INT = TupleType._int;


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

/// TODO: Implement this in D.

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
extern(C) uint dict_calc_buffer_size (const ubyte tuple_count, ...);

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
extern(C) uint dict_size (const(DictionaryIterator)* iter);

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
extern(C) DictionaryResult dict_write_cstring (DictionaryIterator* iter, const uint key, const char* cstring);

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
}



/**
 * Create a Tuplet with a byte array value.
 *
 * Params:
 * key = The key
 * data = Pointer to the bytes
 * length = Length of the buffer
 */
@safe pure
Tuplet TupletBytes(uint key, const (ubyte)* data, const ushort length) {
    Tuplet tuplet = {
        .type = TUPLE_BYTE_ARRAY,
        .key = key,
        .bytes = TupletBytesType(data, length)
    };

    return tuplet;
}

/**
 * Create a Tuplet with a c-string value
 *
 * Params:
 * key = The key
 * cstring = The c-string value
 */
@safe pure
Tuplet TupletCString(uint key, const(char*) cstring) {
    Tuplet tuplet = {
        .type = TUPLE_CSTRING,
        .key = key,
        .bytes = TupleCStringType(
            data,
            data ? strlen(cstring) + 1 : 0
        )
    };

    return tuplet;
}

@safe pure
private Tuplet TupletIntegerImpl(Num)(uint key, Num integer) {
    static if (is(Num == byte) || is(Num == short) || is(Num == int)) {
        enum type = TUPLE_INT;
    } else {
        enum type = TUPLE_UINT;
    }

    Tuplet tuplet = {
        .type = type,
        .key = key,
        .width = Num.sizeof
    };

    return tuplet;
}

/**
 * Create a Tuplet with an integer value.
 *
 * Params:
 * key = The key
 * integer = The integer value
 */
@safe pure
Tuplet TupletInteger(uint key, ubyte integer) {
    return TupletIntegerImpl(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, byte integer) {
    return TupletIntegerImpl(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, ushort integer) {
    return TupletIntegerImpl(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, short integer) {
    return TupletIntegerImpl(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, uint integer) {
    return TupletIntegerImpl(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, int integer) {
    return TupletIntegerImpl(key, integer);
}


/// TODO: We got here last in our pebble adventures.

alias void function (const(ubyte)*, ushort, void*) DictionarySerializeCallback;
alias void function (uint, const(_Anonymous_19)*, const(_Anonymous_19)*, void*) DictionaryKeyUpdatedCallback;
alias _Anonymous_21 AppMessageResult;
alias void function (_Anonymous_20*, void*) AppMessageInboxReceived;
alias void function (_Anonymous_21, void*) AppMessageInboxDropped;
alias void function (_Anonymous_20*, void*) AppMessageOutboxSent;
alias void function (_Anonymous_20*, _Anonymous_21, void*) AppMessageOutboxFailed;
alias void function (uint, const(_Anonymous_19)*, const(_Anonymous_19)*, void*) AppSyncTupleChangedCallback;
alias void function (_Anonymous_17, _Anonymous_21, void*) AppSyncErrorCallback;
alias void* ResHandle;
alias _Anonymous_22 AppWorkerResult;
alias _Anonymous_23 AppWorkerMessage;
alias void function (ushort, _Anonymous_23*) AppWorkerMessageHandler;
alias _Anonymous_24 SniffInterval;
alias void function (void*) AppTimerCallback;
alias int status_t;
alias int WakeupId;
alias void function (int, int) WakeupHandler;
alias _Anonymous_25 AppLaunchReason;
alias GColor8 GColor;
alias _Anonymous_26 GCompOp;
alias _Anonymous_27 GCornerMask;
alias void* GFont;
alias _Anonymous_28 GTextOverflowMode;
alias _Anonymous_29 GTextAlignment;
alias TextLayout* GTextLayoutCacheRef;
alias void* ClickRecognizerRef;
alias void function (void*, void*) ClickHandler;
alias void function (void*) ClickConfigProvider;
alias void function (Layer*, GContext*) LayerUpdateProc;
alias void function (Window*) WindowHandler;
alias _Anonymous_30 AnimationCurve;
alias uint function (uint) AnimationCurveFunction;
alias void function (Animation*, void*) AnimationStartedHandler;
alias void function (Animation*, bool, void*) AnimationStoppedHandler;
alias void function (Animation*) AnimationSetupImplementation;
alias void function (Animation*, uint) AnimationUpdateImplementation;
alias void function (Animation*) AnimationTeardownImplementation;
alias GPoint GPointReturn;
alias GRect GRectReturn;
alias void function (void*, short) Int16Setter;
alias short function (void*) Int16Getter;
alias void function (void*, GPoint) GPointSetter;
alias GPoint function (void*) GPointGetter;
alias void function (void*, GRect) GRectSetter;
alias GRect function (void*) GRectGetter;
alias void function (void*, GColor8) GColor8Setter;
alias GColor8 function (void*) GColor8Getter;
alias void function (ScrollLayer*, void*) ScrollLayerCallback;
alias ushort function (MenuLayer*, void*) MenuLayerGetNumberOfSectionsCallback;
alias ushort function (MenuLayer*, ushort, void*) MenuLayerGetNumberOfRowsInSectionsCallback;
alias short function (MenuLayer*, MenuIndex*, void*) MenuLayerGetCellHeightCallback;
alias short function (MenuLayer*, ushort, void*) MenuLayerGetHeaderHeightCallback;
alias short function (MenuLayer*, MenuIndex*, void*) MenuLayerGetSeparatorHeightCallback;
alias void function (GContext*, const(Layer)*, MenuIndex*, void*) MenuLayerDrawRowCallback;
alias void function (GContext*, const(Layer)*, ushort, void*) MenuLayerDrawHeaderCallback;
alias void function (GContext*, const(Layer)*, MenuIndex*, void*) MenuLayerDrawSeparatorCallback;
alias void function (MenuLayer*, MenuIndex*, void*) MenuLayerSelectCallback;
alias void function (MenuLayer*, MenuIndex, MenuIndex, void*) MenuLayerSelectionChangedCallback;
alias _Anonymous_31 MenuRowAlign;
alias void function (int, void*) SimpleMenuLayerSelectCallback;
alias _Anonymous_32 SimpleMenuItem;
alias _Anonymous_33 SimpleMenuSection;
alias void function (NumberWindow*, void*) NumberWindowCallback;
alias _Anonymous_34 NumberWindowCallbacks;
alias _Anonymous_35 VibePattern;



enum _Anonymous_8
{
    ACCEL_SAMPLING_10HZ = 10,
    ACCEL_SAMPLING_25HZ = 25,
    ACCEL_SAMPLING_50HZ = 50,
    ACCEL_SAMPLING_100HZ = 100
}

enum _Anonymous_10
{
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



enum _Anonymous_21
{
    APP_MSG_OK = 0,
    APP_MSG_SEND_TIMEOUT = 2,
    APP_MSG_SEND_REJECTED = 4,
    APP_MSG_NOT_CONNECTED = 8,
    APP_MSG_APP_NOT_RUNNING = 16,
    APP_MSG_INVALID_ARGS = 32,
    APP_MSG_BUSY = 64,
    APP_MSG_BUFFER_OVERFLOW = 128,
    APP_MSG_ALREADY_RELEASED = 512,
    APP_MSG_CALLBACK_ALREADY_REGISTERED = 1024,
    APP_MSG_CALLBACK_NOT_REGISTERED = 2048,
    APP_MSG_OUT_OF_MEMORY = 4096,
    APP_MSG_CLOSED = 8192,
    APP_MSG_INTERNAL_ERROR = 16384
}

enum _Anonymous_22
{
    APP_WORKER_RESULT_SUCCESS = 0,
    APP_WORKER_RESULT_NO_WORKER = 1,
    APP_WORKER_RESULT_DIFFERENT_APP = 2,
    APP_WORKER_RESULT_NOT_RUNNING = 3,
    APP_WORKER_RESULT_ALREADY_RUNNING = 4,
    APP_WORKER_RESULT_ASKING_CONFIRMATION = 5
}

enum _Anonymous_24
{
    SNIFF_INTERVAL_NORMAL = 0,
    SNIFF_INTERVAL_REDUCED = 1
}

enum StatusCode
{
    S_SUCCESS = 0,
    E_ERROR = -1,
    E_UNKNOWN = -2,
    E_INTERNAL = -3,
    E_INVALID_ARGUMENT = -4,
    E_OUT_OF_MEMORY = -5,
    E_OUT_OF_STORAGE = -6,
    E_OUT_OF_RESOURCES = -7,
    E_RANGE = -8,
    E_DOES_NOT_EXIST = -9,
    E_INVALID_OPERATION = -10,
    E_BUSY = -11,
    S_TRUE = 1,
    S_FALSE = 0,
    S_NO_MORE_ITEMS = 2,
    S_NO_ACTION_REQUIRED = 3
}

enum _Anonymous_25
{
    APP_LAUNCH_SYSTEM = 0,
    APP_LAUNCH_USER = 1,
    APP_LAUNCH_PHONE = 2,
    APP_LAUNCH_WAKEUP = 3,
    APP_LAUNCH_WORKER = 4,
    APP_LAUNCH_QUICK_LAUNCH = 5,
    APP_LAUNCH_TIMELINE_ACTION = 6
}

enum GBitmapFormat
{
    GBitmapFormat1Bit = 0,
    GBitmapFormat8Bit = 1,
    GBitmapFormat1BitPalette = 2,
    GBitmapFormat2BitPalette = 3,
    GBitmapFormat4BitPalette = 4
}

enum GAlign
{
    GAlignCenter = 0,
    GAlignTopLeft = 1,
    GAlignTopRight = 2,
    GAlignTop = 3,
    GAlignLeft = 4,
    GAlignBottom = 5,
    GAlignRight = 6,
    GAlignBottomRight = 7,
    GAlignBottomLeft = 8
}

enum _Anonymous_26
{
    GCompOpAssign = 0,
    GCompOpAssignInverted = 1,
    GCompOpOr = 2,
    GCompOpAnd = 3,
    GCompOpClear = 4,
    GCompOpSet = 5
}

enum _Anonymous_27
{
    GCornerNone = 0,
    GCornerTopLeft = 1,
    GCornerTopRight = 2,
    GCornerBottomLeft = 4,
    GCornerBottomRight = 8,
    GCornersAll = 15,
    GCornersTop = 3,
    GCornersBottom = 12,
    GCornersLeft = 5,
    GCornersRight = 10
}

enum _Anonymous_28
{
    GTextOverflowModeWordWrap = 0,
    GTextOverflowModeTrailingEllipsis = 1,
    GTextOverflowModeFill = 2
}

enum _Anonymous_29
{
    GTextAlignmentLeft = 0,
    GTextAlignmentCenter = 1,
    GTextAlignmentRight = 2
}

enum _Anonymous_30
{
    AnimationCurveLinear = 0,
    AnimationCurveEaseIn = 1,
    AnimationCurveEaseOut = 2,
    AnimationCurveEaseInOut = 3,
    AnimationCurveDefault = 3,
    AnimationCurveCustomFunction = 4,
    AnimationCurve_Reserved1 = 5,
    AnimationCurve_Reserved2 = 6,
    AnimationCurve_Reserved3 = 7
}

enum _Anonymous_31
{
    MenuRowAlignNone = 0,
    MenuRowAlignCenter = 1,
    MenuRowAlignTop = 2,
    MenuRowAlignBottom = 3
}

struct _Anonymous_20
{
    Dictionary* dictionary;
    const(void)* end;
    Tuple* cursor;
}


struct AppSync
{
    DictionaryIterator current_iter;
    ushort buffer_size;
    struct
    {
        AppSyncTupleChangedCallback value_changed;
        AppSyncErrorCallback error;
        void* context;
    }
}

struct _Anonymous_23
{
    ushort data0;
    ushort data1;
    ushort data2;
}

struct GPoint
{
    short x;
    short y;
}

struct GSize
{
    short w;
    short h;
}

struct GRect
{
    GPoint origin;
    GSize size;
}

struct GPathInfo
{
    uint num_points;
    GPoint* points;
}

struct GPath
{
    uint num_points;
    GPoint* points;
    int rotation;
    GPoint offset;
}

struct WindowHandlers
{
    WindowHandler load;
    WindowHandler appear;
    WindowHandler disappear;
    WindowHandler unload;
}

struct AnimationHandlers
{
    AnimationStartedHandler started;
    AnimationStoppedHandler stopped;
}

struct AnimationImplementation
{
    AnimationSetupImplementation setup;
    AnimationUpdateImplementation update;
    AnimationTeardownImplementation teardown;
}

struct PropertyAnimationAccessors
{
    union
    {
        Int16Getter int16;
        GPointGetter gpoint;
        GRectGetter grect;
        GColor8Getter gcolor8;
    }
}

struct PropertyAnimationImplementation
{
    AnimationImplementation base;
    PropertyAnimationAccessors accessors;
}

struct ScrollLayerCallbacks
{
    ClickConfigProvider click_config_provider;
    ScrollLayerCallback content_offset_changed_handler;
}

struct MenuIndex
{
    ushort section;
    ushort row;
}

struct MenuCellSpan
{
    short y;
    short h;
    short sep;
    MenuIndex index;
}

struct MenuLayerCallbacks
{
    MenuLayerGetNumberOfSectionsCallback get_num_sections;
    MenuLayerGetNumberOfRowsInSectionsCallback get_num_rows;
    MenuLayerGetCellHeightCallback get_cell_height;
    MenuLayerGetHeaderHeightCallback get_header_height;
    MenuLayerDrawRowCallback draw_row;
    MenuLayerDrawHeaderCallback draw_header;
    MenuLayerSelectCallback select_click;
    MenuLayerSelectCallback select_long_click;
    MenuLayerSelectionChangedCallback selection_changed;
    MenuLayerGetSeparatorHeightCallback get_separator_height;
    MenuLayerDrawSeparatorCallback draw_separator;
}

struct _Anonymous_32
{
    const(char)* title;
    const(char)* subtitle;
    GBitmap* icon;
    SimpleMenuLayerSelectCallback callback;
}

struct _Anonymous_33
{
    const(char)* title;
    const(SimpleMenuItem)* items;
    uint num_items;
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

struct MenuLayer;


struct InverterLayer;


struct NumberWindow;


struct Animation;


struct TextLayout;


struct BitmapLayer;


struct TextLayer;


struct GBitmap;


struct ActionBarLayer;


struct Layer;


struct ScrollLayer;


struct Window;


struct RotBitmapLayer;


struct PropertyAnimation;


struct GBitmapSequence;


struct GContext;


struct SimpleMenuLayer;


struct AppTimer;


union GColor8
{
    ubyte argb;
}

DictionaryResult dict_serialize_tuplets (DictionarySerializeCallback callback, void* context, const Tuplet* tuplets, const ubyte tuplets_count);
DictionaryResult dict_serialize_tuplets_to_buffer (const Tuplet* tuplets, const ubyte tuplets_count, ubyte* buffer, uint* size_in_out);
DictionaryResult dict_serialize_tuplets_to_buffer_with_iter (DictionaryIterator* iter, const Tuplet* tuplets, const ubyte tuplets_count, ubyte* buffer, uint* size_in_out);
DictionaryResult dict_write_tuplet (DictionaryIterator* iter, const Tuplet* tuplet);
uint dict_calc_buffer_size_from_tuplets (const Tuplet* tuplets, const ubyte tuplets_count);
DictionaryResult dict_merge (DictionaryIterator* dest, uint* dest_max_size_in_out, DictionaryIterator* source, const bool update_existing_keys_only, const DictionaryKeyUpdatedCallback key_callback, void* context);
Tuple* dict_find (const(DictionaryIterator)* iter, const uint key);
AppMessageResult app_message_open (const uint size_inbound, const uint size_outbound);
void app_message_deregister_callbacks ();
void* app_message_get_context ();
void* app_message_set_context (void* context);
AppMessageInboxReceived app_message_register_inbox_received (AppMessageInboxReceived received_callback);
AppMessageInboxDropped app_message_register_inbox_dropped (AppMessageInboxDropped dropped_callback);
AppMessageOutboxSent app_message_register_outbox_sent (AppMessageOutboxSent sent_callback);
AppMessageOutboxFailed app_message_register_outbox_failed (AppMessageOutboxFailed failed_callback);
uint app_message_inbox_size_maximum ();
uint app_message_outbox_size_maximum ();
AppMessageResult app_message_outbox_begin (DictionaryIterator** iterator);
AppMessageResult app_message_outbox_send ();
void app_sync_init (AppSync* s, ubyte* buffer, const ushort buffer_size, const Tuplet* keys_and_initial_values, const ubyte count, AppSyncTupleChangedCallback tuple_changed_callback, AppSyncErrorCallback error_callback, void* context);
void app_sync_deinit (AppSync* s);
AppMessageResult app_sync_set (AppSync* s, const Tuplet* keys_and_values_to_update, const ubyte count);
const(Tuple)* app_sync_get (const(AppSync)* s, const uint key);
ResHandle resource_get_handle (uint resource_id);
size_t resource_size (ResHandle h);
size_t resource_load (ResHandle h, ubyte* buffer, size_t max_length);
size_t resource_load_byte_range (ResHandle h, uint start_offset, ubyte* buffer, size_t num_bytes);
void app_event_loop ();
bool app_worker_is_running ();
AppWorkerResult app_worker_launch ();
AppWorkerResult app_worker_kill ();
bool app_worker_message_subscribe (AppWorkerMessageHandler handler);
bool app_worker_message_unsubscribe ();
void app_worker_send_message (ubyte type, AppWorkerMessage* data);
void app_comm_set_sniff_interval (const SniffInterval interval);
SniffInterval app_comm_get_sniff_interval ();
void psleep (int millis);
AppTimer* app_timer_register (uint timeout_ms, AppTimerCallback callback, void* callback_data);
bool app_timer_reschedule (AppTimer* timer_handle, uint new_timeout_ms);
void app_timer_cancel (AppTimer* timer_handle);
size_t heap_bytes_free ();
size_t heap_bytes_used ();
bool persist_exists (const uint key);
int persist_get_size (const uint key);
bool persist_read_bool (const uint key);
int persist_read_int (const uint key);
int persist_read_data (const uint key, void* buffer, const size_t buffer_size);
int persist_read_string (const uint key, char* buffer, const size_t buffer_size);
status_t persist_write_bool (const uint key, const bool value);
status_t persist_write_int (const uint key, const int value);
int persist_write_data (const uint key, const(void)* data, const size_t size);
int persist_write_string (const uint key, const(char)* cstring);
status_t persist_delete (const uint key);
void wakeup_service_subscribe (WakeupHandler handler);
WakeupId wakeup_schedule (time_t timestamp, int cookie, bool notify_if_missed);
void wakeup_cancel (WakeupId wakeup_id);
void wakeup_cancel_all ();
bool wakeup_get_launch_event (WakeupId* wakeup_id, int* cookie);
bool wakeup_query (WakeupId wakeup_id, time_t* timestamp);
AppLaunchReason launch_reason ();
uint launch_get_args ();
bool GColorEq (GColor8 x, GColor8 y);
bool gpoint_equal (const GPoint* point_a, const GPoint* point_b);
bool gsize_equal (const(GSize)* size_a, const(GSize)* size_b);
bool grect_equal (const GRect* rect_a, const GRect* rect_b);
bool grect_is_empty (const GRect* rect);
void grect_standardize (GRect* rect);
void grect_clip (GRect* rect_to_clip, const GRect* rect_clipper);
bool grect_contains_point (const(GRect)* rect, const(GPoint)* point);
GPoint grect_center_point (const(GRect)* rect);
GRect grect_crop (GRect rect, const int crop_size_px);
ushort gbitmap_get_bytes_per_row (const(GBitmap)* bitmap);
GBitmapFormat gbitmap_get_format (const(GBitmap)* bitmap);
ubyte* gbitmap_get_data (const(GBitmap)* bitmap);
void gbitmap_set_data (GBitmap* bitmap, ubyte* data, GBitmapFormat format, ushort row_size_bytes, bool free_on_destroy);
GRect gbitmap_get_bounds (const(GBitmap)* bitmap);
void gbitmap_set_bounds (GBitmap* bitmap, GRect bounds);
GColor* gbitmap_get_palette (const(GBitmap)* bitmap);
void gbitmap_set_palette (GBitmap* bitmap, GColor* palette, bool free_on_destroy);
GBitmap* gbitmap_create_with_resource (uint resource_id);
GBitmap* gbitmap_create_with_data (const(ubyte)* data);
GBitmap* gbitmap_create_as_sub_bitmap (const(GBitmap)* base_bitmap, GRect sub_rect);
GBitmap* gbitmap_create_from_png_data (const(ubyte)* png_data, size_t png_data_size);
GBitmap* gbitmap_create_blank (GSize size, GBitmapFormat format);
GBitmap* gbitmap_create_blank_with_palette (GSize size, GBitmapFormat format, GColor* palette, bool free_on_destroy);
void gbitmap_destroy (GBitmap* bitmap);
GBitmapSequence* gbitmap_sequence_create_with_resource (uint resource_id);
bool gbitmap_sequence_update_bitmap_next_frame (GBitmapSequence* bitmap_sequence, GBitmap* bitmap, uint* delay_ms);
void gbitmap_sequence_destroy (GBitmapSequence* bitmap_sequence);
bool gbitmap_sequence_restart (GBitmapSequence* bitmap_sequence);
int gbitmap_sequence_get_current_frame_idx (GBitmapSequence* bitmap_sequence);
int gbitmap_sequence_get_total_num_frames (GBitmapSequence* bitmap_sequence);
uint gbitmap_sequence_get_loop_count (GBitmapSequence* bitmap_sequence);
void gbitmap_sequence_set_loop_count (GBitmapSequence* bitmap_sequence, uint loop_count);
GSize gbitmap_sequence_get_bitmap_size (GBitmapSequence* bitmap_sequence);
void grect_align (GRect* rect, const(GRect)* inside_rect, const GAlign alignment, const bool clip);
void graphics_context_set_stroke_color (GContext* ctx, GColor color);
void graphics_context_set_fill_color (GContext* ctx, GColor color);
void graphics_context_set_text_color (GContext* ctx, GColor color);
void graphics_context_set_compositing_mode (GContext* ctx, GCompOp mode);
void graphics_context_set_antialiased (GContext* ctx, bool enable);
void graphics_context_set_stroke_width (GContext* ctx, ubyte stroke_width);
void graphics_draw_pixel (GContext* ctx, GPoint point);
void graphics_draw_line (GContext* ctx, GPoint p0, GPoint p1);
void graphics_draw_rect (GContext* ctx, GRect rect);
void graphics_fill_rect (GContext* ctx, GRect rect, ushort corner_radius, GCornerMask corner_mask);
void graphics_draw_circle (GContext* ctx, GPoint p, ushort radius);
void graphics_fill_circle (GContext* ctx, GPoint p, ushort radius);
void graphics_draw_round_rect (GContext* ctx, GRect rect, ushort radius);
void graphics_draw_bitmap_in_rect (GContext* ctx, const(GBitmap)* bitmap, GRect rect);
GBitmap* graphics_capture_frame_buffer (GContext* ctx);
GBitmap* graphics_capture_frame_buffer_format (GContext* ctx, GBitmapFormat format);
bool graphics_release_frame_buffer (GContext* ctx, GBitmap* buffer);
bool graphics_frame_buffer_is_captured (GContext* ctx);
GPath* gpath_create (const(GPathInfo)* init);
void gpath_destroy (GPath* gpath);
void gpath_draw_filled (GContext* ctx, GPath* path);
void gpath_draw_outline (GContext* ctx, GPath* path);
void gpath_rotate_to (GPath* path, int angle);
void gpath_move_to (GPath* path, GPoint point);
GFont fonts_get_system_font (const(char)* font_key);
GFont fonts_load_custom_font (ResHandle handle);
void fonts_unload_custom_font (GFont font);
void graphics_draw_text (GContext* ctx, const(char)* text, const GFont font, const GRect box, const GTextOverflowMode overflow_mode, const GTextAlignment alignment, const GTextLayoutCacheRef layout);
GSize graphics_text_layout_get_content_size (const(char)* text, const GFont font, const GRect box, const GTextOverflowMode overflow_mode, const GTextAlignment alignment);
ubyte click_number_of_clicks_counted (ClickRecognizerRef recognizer);
ButtonId click_recognizer_get_button_id (ClickRecognizerRef recognizer);
bool click_recognizer_is_repeating (ClickRecognizerRef recognizer);
Layer* layer_create (GRect frame);
Layer* layer_create_with_data (GRect frame, size_t data_size);
void layer_destroy (Layer* layer);
void layer_mark_dirty (Layer* layer);
void layer_set_update_proc (Layer* layer, LayerUpdateProc update_proc);
void layer_set_frame (Layer* layer, GRect frame);
GRect layer_get_frame (const(Layer)* layer);
void layer_set_bounds (Layer* layer, GRect bounds);
GRect layer_get_bounds (const(Layer)* layer);
Window* layer_get_window (const(Layer)* layer);
void layer_remove_from_parent (Layer* child);
void layer_remove_child_layers (Layer* parent);
void layer_add_child (Layer* parent, Layer* child);
void layer_insert_below_sibling (Layer* layer_to_insert, Layer* below_sibling_layer);
void layer_insert_above_sibling (Layer* layer_to_insert, Layer* above_sibling_layer);
void layer_set_hidden (Layer* layer, bool hidden);
bool layer_get_hidden (const(Layer)* layer);
void layer_set_clips (Layer* layer, bool clips);
bool layer_get_clips (const(Layer)* layer);
void* layer_get_data (const(Layer)* layer);
Window* window_create ();
void window_destroy (Window* window);
void window_set_click_config_provider (Window* window, ClickConfigProvider click_config_provider);
void window_set_click_config_provider_with_context (Window* window, ClickConfigProvider click_config_provider, void* context);
ClickConfigProvider window_get_click_config_provider (const(Window)* window);
void* window_get_click_config_context (Window* window);
void window_set_window_handlers (Window* window, WindowHandlers handlers);
Layer* window_get_root_layer (const(Window)* window);
void window_set_background_color (Window* window, GColor background_color);
void window_set_fullscreen (Window* window, bool enabled);
bool window_get_fullscreen (const(Window)* window);
void window_set_status_bar_icon (Window* window, const(GBitmap)* icon);
bool window_is_loaded (Window* window);
void window_set_user_data (Window* window, void* data);
void* window_get_user_data (const(Window)* window);
void window_single_click_subscribe (ButtonId button_id, ClickHandler handler);
void window_single_repeating_click_subscribe (ButtonId button_id, ushort repeat_interval_ms, ClickHandler handler);
void window_multi_click_subscribe (ButtonId button_id, ubyte min_clicks, ubyte max_clicks, ushort timeout, bool last_click_only, ClickHandler handler);
void window_long_click_subscribe (ButtonId button_id, ushort delay_ms, ClickHandler down_handler, ClickHandler up_handler);
void window_raw_click_subscribe (ButtonId button_id, ClickHandler down_handler, ClickHandler up_handler, void* context);
void window_set_click_context (ButtonId button_id, void* context);
void window_stack_push (Window* window, bool animated);
Window* window_stack_pop (bool animated);
void window_stack_pop_all (const bool animated);
bool window_stack_remove (Window* window, bool animated);
Window* window_stack_get_top_window ();
bool window_stack_contains_window (Window* window);
Animation* animation_create ();
bool animation_destroy (Animation* animation);
Animation* animation_clone (Animation* from);
Animation* animation_sequence_create (Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);
Animation* animation_sequence_create_from_array (Animation** animation_array, uint array_len);
Animation* animation_spawn_create (Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);
Animation* animation_spawn_create_from_array (Animation** animation_array, uint array_len);
bool animation_set_position (Animation* animation, uint milliseconds);
bool animation_get_position (Animation* animation, int* position);
bool animation_set_reverse (Animation* animation, bool reverse);
bool animation_get_reverse (Animation* animation);
bool animation_set_play_count (Animation* animation, uint play_count);
uint animation_get_play_count (Animation* animation);
bool animation_set_duration (Animation* animation, uint duration_ms);
uint animation_get_duration (Animation* animation, bool include_delay, bool include_play_count);
bool animation_set_delay (Animation* animation, uint delay_ms);
uint animation_get_delay (Animation* animation);
bool animation_set_curve (Animation* animation, AnimationCurve curve);
AnimationCurve animation_get_curve (Animation* animation);
bool animation_set_custom_curve (Animation* animation, AnimationCurveFunction curve_function);
AnimationCurveFunction animation_get_custom_curve (Animation* animation);
bool animation_set_handlers (Animation* animation, AnimationHandlers callbacks, void* context);
void* animation_get_context (Animation* animation);
bool animation_schedule (Animation* animation);
bool animation_unschedule (Animation* animation);
void animation_unschedule_all ();
bool animation_is_scheduled (Animation* animation);
bool animation_set_implementation (Animation* animation, const(AnimationImplementation)* implementation);
const(AnimationImplementation)* animation_get_implementation (Animation* animation);
PropertyAnimation* property_animation_create_layer_frame (Layer* layer, GRect* from_frame, GRect* to_frame);
PropertyAnimation* property_animation_create (const(PropertyAnimationImplementation)* implementation, void* subject, void* from_value, void* to_value);
void property_animation_destroy (PropertyAnimation* property_animation);
void property_animation_update_int16 (PropertyAnimation* property_animation, const uint distance_normalized);
void property_animation_update_gpoint (PropertyAnimation* property_animation, const uint distance_normalized);
void property_animation_update_grect (PropertyAnimation* property_animation, const uint distance_normalized);
Animation* property_animation_get_animation (PropertyAnimation* property_animation);
bool property_animation_subject (PropertyAnimation* property_animation, void** subject, bool set);
bool property_animation_from (PropertyAnimation* property_animation, void* from, size_t size, bool set);
bool property_animation_to (PropertyAnimation* property_animation, void* to, size_t size, bool set);
TextLayer* text_layer_create (GRect frame);
void text_layer_destroy (TextLayer* text_layer);
Layer* text_layer_get_layer (TextLayer* text_layer);
void text_layer_set_text (TextLayer* text_layer, const(char)* text);
const(char)* text_layer_get_text (TextLayer* text_layer);
void text_layer_set_background_color (TextLayer* text_layer, GColor color);
void text_layer_set_text_color (TextLayer* text_layer, GColor color);
void text_layer_set_overflow_mode (TextLayer* text_layer, GTextOverflowMode line_mode);
void text_layer_set_font (TextLayer* text_layer, GFont font);
void text_layer_set_text_alignment (TextLayer* text_layer, GTextAlignment text_alignment);
GSize text_layer_get_content_size (TextLayer* text_layer);
void text_layer_set_size (TextLayer* text_layer, const GSize max_size);
ScrollLayer* scroll_layer_create (GRect frame);
void scroll_layer_destroy (ScrollLayer* scroll_layer);
Layer* scroll_layer_get_layer (const(ScrollLayer)* scroll_layer);
void scroll_layer_add_child (ScrollLayer* scroll_layer, Layer* child);
void scroll_layer_set_click_config_onto_window (ScrollLayer* scroll_layer, Window* window);
void scroll_layer_set_callbacks (ScrollLayer* scroll_layer, ScrollLayerCallbacks callbacks);
void scroll_layer_set_context (ScrollLayer* scroll_layer, void* context);
void scroll_layer_set_content_offset (ScrollLayer* scroll_layer, GPoint offset, bool animated);
GPoint scroll_layer_get_content_offset (ScrollLayer* scroll_layer);
void scroll_layer_set_content_size (ScrollLayer* scroll_layer, GSize size);
GSize scroll_layer_get_content_size (const(ScrollLayer)* scroll_layer);
void scroll_layer_set_frame (ScrollLayer* scroll_layer, GRect frame);
void scroll_layer_scroll_up_click_handler (ClickRecognizerRef recognizer, void* context);
void scroll_layer_scroll_down_click_handler (ClickRecognizerRef recognizer, void* context);
void scroll_layer_set_shadow_hidden (ScrollLayer* scroll_layer, bool hidden);
bool scroll_layer_get_shadow_hidden (const(ScrollLayer)* scroll_layer);
InverterLayer* inverter_layer_create (GRect frame);
void inverter_layer_destroy (InverterLayer* inverter_layer);
Layer* inverter_layer_get_layer (InverterLayer* inverter_layer);
void menu_cell_basic_draw (GContext* ctx, const(Layer)* cell_layer, const(char)* title, const(char)* subtitle, GBitmap* icon);
void menu_cell_title_draw (GContext* ctx, const(Layer)* cell_layer, const(char)* title);
void menu_cell_basic_header_draw (GContext* ctx, const(Layer)* cell_layer, const(char)* title);
short menu_index_compare (MenuIndex* a, MenuIndex* b);
MenuLayer* menu_layer_create (GRect frame);
void menu_layer_destroy (MenuLayer* menu_layer);
Layer* menu_layer_get_layer (const(MenuLayer)* menu_layer);
ScrollLayer* menu_layer_get_scroll_layer (const(MenuLayer)* menu_layer);
void menu_layer_set_callbacks (MenuLayer* menu_layer, void* callback_context, MenuLayerCallbacks callbacks);
void menu_layer_set_click_config_onto_window (MenuLayer* menu_layer, Window* window);
void menu_layer_set_selected_next (MenuLayer* menu_layer, bool up, MenuRowAlign scroll_align, bool animated);
void menu_layer_set_selected_index (MenuLayer* menu_layer, MenuIndex index, MenuRowAlign scroll_align, bool animated);
MenuIndex menu_layer_get_selected_index (const(MenuLayer)* menu_layer);
void menu_layer_reload_data (MenuLayer* menu_layer);
void menu_layer_shadow_enable (MenuLayer* menu_layer, bool enable);
SimpleMenuLayer* simple_menu_layer_create (GRect frame, Window* window, const(SimpleMenuSection)* sections, int num_sections, void* callback_context);
void simple_menu_layer_destroy (SimpleMenuLayer* menu_layer);
Layer* simple_menu_layer_get_layer (const(SimpleMenuLayer)* simple_menu);
int simple_menu_layer_get_selected_index (const(SimpleMenuLayer)* simple_menu);
void simple_menu_layer_set_selected_index (SimpleMenuLayer* simple_menu, int index, bool animated);
MenuLayer* simple_menu_layer_get_menu_layer (SimpleMenuLayer* simple_menu);
ActionBarLayer* action_bar_layer_create ();
void action_bar_layer_destroy (ActionBarLayer* action_bar_layer);
Layer* action_bar_layer_get_layer (ActionBarLayer* action_bar_layer);
void action_bar_layer_set_context (ActionBarLayer* action_bar, void* context);
void action_bar_layer_set_click_config_provider (ActionBarLayer* action_bar, ClickConfigProvider click_config_provider);
void action_bar_layer_set_icon (ActionBarLayer* action_bar, ButtonId button_id, const(GBitmap)* icon);
void action_bar_layer_clear_icon (ActionBarLayer* action_bar, ButtonId button_id);
void action_bar_layer_add_to_window (ActionBarLayer* action_bar, Window* window);
void action_bar_layer_remove_from_window (ActionBarLayer* action_bar);
void action_bar_layer_set_background_color (ActionBarLayer* action_bar, GColor background_color);
BitmapLayer* bitmap_layer_create (GRect frame);
void bitmap_layer_destroy (BitmapLayer* bitmap_layer);
Layer* bitmap_layer_get_layer (const(BitmapLayer)* bitmap_layer);
const(GBitmap)* bitmap_layer_get_bitmap (BitmapLayer* bitmap_layer);
void bitmap_layer_set_bitmap (BitmapLayer* bitmap_layer, const(GBitmap)* bitmap);
void bitmap_layer_set_alignment (BitmapLayer* bitmap_layer, GAlign alignment);
void bitmap_layer_set_background_color (BitmapLayer* bitmap_layer, GColor color);
void bitmap_layer_set_compositing_mode (BitmapLayer* bitmap_layer, GCompOp mode);
RotBitmapLayer* rot_bitmap_layer_create (GBitmap* bitmap);
void rot_bitmap_layer_destroy (RotBitmapLayer* bitmap);
void rot_bitmap_layer_set_corner_clip_color (RotBitmapLayer* bitmap, GColor color);
void rot_bitmap_layer_set_angle (RotBitmapLayer* bitmap, int angle);
void rot_bitmap_layer_increment_angle (RotBitmapLayer* bitmap, int angle_change);
void rot_bitmap_set_src_ic (RotBitmapLayer* bitmap, GPoint ic);
void rot_bitmap_set_compositing_mode (RotBitmapLayer* bitmap, GCompOp mode);
NumberWindow* number_window_create (const(char)* label, NumberWindowCallbacks callbacks, void* callback_context);
void number_window_destroy (NumberWindow* number_window);
void number_window_set_label (NumberWindow* numberwindow, const(char)* label);
void number_window_set_max (NumberWindow* numberwindow, int max);
void number_window_set_min (NumberWindow* numberwindow, int min);
void number_window_set_value (NumberWindow* numberwindow, int value);
void number_window_set_step_size (NumberWindow* numberwindow, int step);
int number_window_get_value (const(NumberWindow)* numberwindow);
Window* number_window_get_window (NumberWindow* numberwindow);
void vibes_cancel ();
void vibes_short_pulse ();
void vibes_long_pulse ();
void vibes_double_pulse ();
void vibes_enqueue_custom_pattern (VibePattern pattern);
void light_enable_interaction ();
void light_enable (bool enable);
tm* localtime (const(time_t)* timep);
tm* gmtime (const(time_t)* timep);
time_t mktime (tm* tb);
time_t time (time_t* tloc);
ushort time_ms (time_t* tloc, ushort* out_ms);
