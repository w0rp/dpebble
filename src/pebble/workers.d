/**
 * This module defines Pebble syncing functionality for apps.
 */
module pebble.workers;

@nogc:
nothrow:

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

