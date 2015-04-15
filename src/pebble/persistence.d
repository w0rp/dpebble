/**
 * This module defines functions for accessing Pebble persistent storage.
 */
module pebble.persistence;

@nogc:
nothrow:

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
deprecated("Use StatusCode instead of status_t")
alias status_t = StatusCode;

/// The maximum size of a persist value in bytes.
enum size_t PERSIST_DATA_MAX_LENGTH = 256;

/// The maximum size of a persist string in bytes including the
/// NULL terminator.
enum size_t PERSIST_STRING_MAX_LENGTH = PERSIST_DATA_MAX_LENGTH;

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
extern(C) StatusCode persist_write_bool(const uint key, const bool value);

/**
 * Writes an int value for a given key into persistent storage.
 *
 * Note: The int is a signed 32-bit integer.
 *
 * Params:
 * key = The key of the field to write to.
 * value = The int value to write.
 */
extern(C) StatusCode persist_write_int(const uint key, const int value);

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
extern(C) StatusCode persist_delete(const uint key);

