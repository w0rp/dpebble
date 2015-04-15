/**
 * This module defines Pebble syncing functionality.
 */
module pebble.sync;

@nogc:
nothrow:

import pebble.tuple;
import pebble.dictionary;
import pebble.messages;

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

