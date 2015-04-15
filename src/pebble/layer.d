/**
 * This module defines layers for displaying on Pebble watches.
 */
module pebble.layer;

import pebble.versions;

import pebble.gpoint;
import pebble.gsize;
import pebble.grect;
import pebble.gcolor;
import pebble.font;
import pebble.gbitmap;
import pebble.gcontext;
// This is a cyclical import.
import pebble.window;

@nogc:
nothrow:

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

struct ScrollLayer {}

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
version(PEBBLE_BASALT)
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

/**
 * Creates a new bitmap layer on the heap and initalizes it the default values.
 *
 * Bitmap: null (none)
 * Background color: GColorClear
 * Compositing mode: GCompOpAssign
 * Clips: true
 *
 * Returns: A pointer to the BitmapLayer. null if the BitmapLayer could not
 *     be created.
 */
extern(C) BitmapLayer* bitmap_layer_create(GRect frame);

/// Destroys a window previously created by bitmap_layer_create.
extern(C) void bitmap_layer_destroy(BitmapLayer* bitmap_layer);

/**
 * Gets the "root" Layer of the bitmap layer, which is the parent for the
 * sub-layers used for its implementation.
 *
 * Params:
 * bitmap_layer = Pointer to the BitmapLayer for which to get the "root" Layer.
 *
 * Returns: The "root" Layer of the bitmap layer.
 */
extern(C) Layer* bitmap_layer_get_layer(const(BitmapLayer)* bitmap_layer);

/**
 * Gets the pointer to the bitmap image that the BitmapLayer is using.
 *
 * Params:
 * bitmap_layer = The BitmapLayer for which to get the bitmap image.
 *
 * Returns: A pointer to the bitmap image that the BitmapLayer is using.
 */
extern(C) const(GBitmap)* bitmap_layer_get_bitmap(BitmapLayer* bitmap_layer);

/**
 * Sets the bitmap onto the BitmapLayer. The bitmap is set by reference
 * (no deep copy), thus the caller of this function has to make sure the
 * bitmap is kept in memory.
 *
 * The bitmap layer is automatically marked dirty after this operation.
 *
 * Params:
 * bitmap_layer = The BitmapLayer for which to set the bitmap image.
 * bitmap = The new GBitmap to set onto the BitmapLayer.
 */
extern(C) void bitmap_layer_set_bitmap
(BitmapLayer* bitmap_layer, const(GBitmap)* bitmap);

/**
 * Sets the alignment of the image to draw with in frame of the BitmapLayer.
 * The aligment parameter specifies which edges of the bitmap should overlap
 * with the frame of the BitmapLayer.
 *
 * If the bitmap is smaller than the frame of the BitmapLayer, the background
 * is filled with the background color.
 *
 * The bitmap layer is automatically marked dirty after this operation.
 *
 * Params:
 * bitmap_layer = The BitmapLayer for which to set the alignment.
 * alignment = The new alignment for the image inside the BitmapLayer.
 */
extern(C) void bitmap_layer_set_alignment
(BitmapLayer* bitmap_layer, GAlign alignment);

/**
 * Sets the background color of bounding box that will be drawn behind the
 * image of the BitmapLayer.
 *
 * The bitmap layer is automatically marked dirty after this operation.
 *
 * Params:
 * bitmap_layer = The BitmapLayer for which to set the background color.
 * color = The new GColor to set the background to.
 */
extern(C) void bitmap_layer_set_background_color
(BitmapLayer* bitmap_layer, GColor color);

/**
 * Sets the compositing mode of how the bitmap image is composited onto the
 * BitmapLayer's background plane, or how it is composited onto what has been
 * drawn beneath the BitmapLayer in case the background color is set to
 * GColorClear.
 *
 * The compositing mode only affects the drawing of the bitmap and not the
 * drawing of the background color.
 *
 * When drawing color PNGs, GCompOpSet will be required to apply any
 * transparency.
 *
 * The bitmap layer is automatically marked dirty after this operation.
 *
 * Params:
 * bitmap_layer = The BitmapLayer for which to set the compositing mode.
 * mode = The compositing mode to set.
 *
 * See_Also: See GCompOp for visual examples of the different compositing
 * modes.
 */
extern(C) void bitmap_layer_set_compositing_mode
(BitmapLayer* bitmap_layer, GCompOp mode);

/**
 * Layer that displays a rotated bitmap image.
 *
 * A RotBitmapLayer is like a BitmapLayer but has the ability to be
 * rotated (by default, around its center). The amount of rotation
 * is specified using rot_bitmap_layer_set_angle() or
 * rot_bitmap_layer_increment_angle(). The rotation argument to those
 * functions is specified as an amount of clockwise rotation, where the value
 * 0x10000 represents a full 360 degree rotation and 0 represent no rotation,
 * and it scales linearly between those values, just like sin_lookup.
 *
 * The center of rotation in the source bitmap is always placed at the
 * center of the RotBitmapLayer and the size of the RotBitmapLayer is
 * automatically calculated so that the entire Bitmap can fit in at all
 * rotation angles.
 *
 * For example, if the image is 10px wide and high, the RotBitmapLayer will be
 * 14px wide ( sqrt(10^2+10^2) ).
 *
 * By default, the center of rotation in the source bitmap is the center of
 * the bitmap but you can call \ref rot_bitmap_set_src_ic() to change the
 * center of rotation.
 */
struct RotBitmapLayer {}

/**
 * Creates a new RotBitmapLayer on the heap and initializes it with the
 * default values:
 *
 * Angle: 0
 * Compositing mode: GCompOpAssign
 * Corner clip color: GColorClear
 *
 * Params:
 * bitmap = The bitmap to display in this RotBitmapLayer.
 *
 * Returns: A pointer to the RotBitmapLayer. null if the RotBitmapLayer could
 *     not be created.
 */
extern(C) RotBitmapLayer* rot_bitmap_layer_create(GBitmap* bitmap);

/**
 * Destroys a RotBitmapLayer and frees all associated memory.
 *
 * Note: It is the developer responsibility to free the GBitmap.
 *
 * Params:
 * bitmap = The RotBitmapLayer to destroy.
 */
extern(C) void rot_bitmap_layer_destroy(RotBitmapLayer* bitmap);

/**
 * Defines what color to use in areas that are not covered by the source
 * bitmap.
 *
 * By default this is GColorClear.
 *
 * Params:
 * bitmap = The RotBitmapLayer on which to change the corner clip color.
 * color = The corner clip color.
 */
extern(C) void rot_bitmap_layer_set_corner_clip_color
(RotBitmapLayer* bitmap, GColor color);

/**
 * Sets the rotation angle of this RotBitmapLayer.
 *
 * Params:
 * bitmap = The RotBitmapLayer on which to change the rotation.
 * angle = Rotation is an integer between 0 (no rotation) and 0x10000
 *     (360 degree rotation).
 *
 * See_Also: sin_lookup()
 */
extern(C) void rot_bitmap_layer_set_angle(RotBitmapLayer* bitmap, int angle);

/**
 * Change the rotation angle of this RotBitmapLayer.
 *
 * Params:
 * bitmap = The RotBitmapLayer on which to change the rotation.
 * angle_change = The rotation angle change.
 */
extern(C) void rot_bitmap_layer_increment_angle
(RotBitmapLayer* bitmap, int angle_change);

/**
 * Defines the only point that will not be affected by the rotation in the
 * source bitmap.
 *
 * For example, if you pass GPoint(0, 0), the image will rotate around the
 * top-left corner.
 *
 * This point is always projected at the center of the RotBitmapLayer.
 * Calling this function automatically adjusts the width and height of the
 * RotBitmapLayer so that the entire bitmap can fit inside the layer at all
 * rotation angles.
 *
 * Params:
 * bitmap = The RotBitmapLayer on which to change the rotation.
 * ic = The only point in the original image that will not be affected by the
 * rotation.
 */
extern(C) void rot_bitmap_set_src_ic(RotBitmapLayer* bitmap, GPoint ic);

/**
 * Sets the compositing mode of how the bitmap image is composited onto
 * what has been drawn beneath the RotBitmapLayer.
 *
 * By default this is GCompOpAssign.
 *
 * The RotBitmapLayer is automatically marked dirty after this operation.
 *
 * Params:
 * bitmap = The RotBitmapLayer on which to change the rotation.
 * mode = The compositing mode to set.
 *
 * See_Also: GCompOp for visual examples of the different compositing modes.
 */
extern(C) void rot_bitmap_set_compositing_mode
(RotBitmapLayer* bitmap, GCompOp mode);
