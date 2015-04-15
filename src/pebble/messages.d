/**
 * This module defines Pebble message functionality.
 */
module pebble.messages;

@nogc:
nothrow:

import pebble.tuple;
import pebble.dictionary;

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

