/**
 * This module defines a NumberWindow type, for making an easy window for
 * picking numbers.
 */
module pebble.number_window;

@nogc:
nothrow:

import pebble.window;

/// A ready-made Window prompting the user to pick a number.
struct NumberWindow {}

/// Function signature for NumberWindow callbacks.
alias extern(C) void function(NumberWindow* number_window, void* context)
NumberWindowCallback;

/// Data structure containing all the callbacks for a NumberWindow.
struct NumberWindowCallbacks {
    /// Callback that gets called as the value is incremented.
    /// Optional, leave null if unused.
    NumberWindowCallback incremented;
    /// Callback that gets called as the value is decremented.
    /// Optional, leave null if unused.
    NumberWindowCallback decremented;
    /// Callback that gets called as the value is confirmed, in other words the
    /// SELECT button is clicked.
    /// Optional, leave null if unused.
    NumberWindowCallback selected;
}

/**
 * Creates a new NumberWindow on the heap and initalizes it with the default
 * values.
 *
 * Note: The number window is not pushed to the window stack. Use
 * window_stack_push() to do this.
 *
 * Params:
 * label = The title or prompt to display in the NumberWindow. Must be
 *     long-lived and cannot be stack-allocated.
 * callbacks = The callbacks.
 * callback_context = Pointer to application specific data that is passed.
 *
 * Returns: A pointer to the NumberWindow. null if the NumberWindow could not
 *     be created.
 */
extern(C) NumberWindow* number_window_create
(const(char)* label, NumberWindowCallbacks callbacks, void* callback_context);

/// Destroys a NumberWindow previously created by number_window_create.
extern(C) void number_window_destroy(NumberWindow* number_window);

/**
 * Sets the text of the title or prompt label.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to set the label text.
 * label = The new label text. Must be long-lived and cannot be
 *     stack-allocated.
 */
extern(C) void number_window_set_label
(NumberWindow* numberwindow, const(char)* label);

/**
 * Sets the maximum value this field can hold
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to set the maximum
 *     value
 * max = The maximum value.
 */
extern(C) void number_window_set_max
(NumberWindow* numberwindow, int max);

/**
 * Sets the minimum value this field can hold.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to set the minimum
 *     value.
 * min = The minimum value.
 */
extern(C) void number_window_set_min
(NumberWindow* numberwindow, int min);

/**
 * Sets the current value of the field.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to set the current
 *     value.
 * value = The new current value.
 */
extern(C) void number_window_set_value(NumberWindow* numberwindow, int value);

/**
 * Sets the amount by which to increment/decrement by on a button click.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to set the step
 *     increment.
 * step = The new step increment.
 */
extern(C) void number_window_set_step_size
(NumberWindow* numberwindow, int step);

/**
 * Gets the current value.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to get the current
 *     value.
 *
 * Returns: The current value.
 */
extern(C) int number_window_get_value(const(NumberWindow)* numberwindow);

/**
 * Gets the "root" Window of the number window.
 *
 * Params:
 * numberwindow = Pointer to the NumberWindow for which to get the "root"
 *     Window.
 *
 * Returns: The "root" Window of the number window.
 */
extern(C) Window* number_window_get_window(NumberWindow* numberwindow);

