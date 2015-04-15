/**
 * This module defines logging functions for Pebble watches.
 */
module pebble.logging;

@nogc:
nothrow:

/// An opaque type for data logging.
struct DataLoggingSession {}

/// A reference to a data logging session on Pebble OS.
deprecated("Use DataLoggingSession* instead of DataLoggingSessionRef")
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
extern(C) DataLoggingSession* data_logging_create
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
extern(C) void data_logging_finish(DataLoggingSession* logging_session);

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
(DataLoggingSession* logging_session, const(void)* data, uint num_items);

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

