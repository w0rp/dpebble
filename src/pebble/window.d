/**
 * This module defines windows in the Pebble UI.
 */
module pebble.window;

import pebble.gcolor;
import pebble.gbitmap;
// This is a cyclical import.
import pebble.layer;

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

