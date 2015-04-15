/**
 * This module defines Pebble timer functionality for Pebble watches.
 */
module pebble.timers;

@nogc:
nothrow:

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

