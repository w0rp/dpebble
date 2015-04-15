/**
 * This module defines operations on graphics contexts.
 */
module pebble.gcontext;

import pebble.versions;

import pebble.gpoint;
import pebble.grect;
import pebble.gcolor;
import pebble.font;
import pebble.gbitmap;

@nogc:
nothrow:

/**
 * Values to specify how the source image should be composited onto the
 * destination image.
 *
 * There is no notion of "transparency" in the graphics system. However, the
 * effect of transparency can be created by masking and using compositing
 * modes.
 *
 * Contrived example of how the different compositing modes affect drawing.
 * Often, the "destination image" is the render buffer and thus contains the
 * image of what has been drawn before or "underneath".
 *
 * See_Also: bitmap_layer_set_compositing_mode()
 * See_Also: graphics_context_set_compositing_mode()
 * See_Also: graphics_draw_bitmap_in_rect()
 */
enum GCompOp {
    /// Assign the pixel values of the source image to the destination pixels,
    /// effectively replacing the previous values for those pixels.
    assign = 0,
    /// Assign the **inverted** pixel values of the source image to the
    /// destination pixels, effectively replacing the previous values for
    /// those pixels.
    inverted = 1,
    /// Use the boolean operator `OR` to composite the source and destination
    /// pixels. The visual result of this compositing mode is the source's
    /// white pixels are painted onto the destination and the source's black
    /// pixels are treated as clear.
    or = 2,
    /// Use the boolean operator `AND` to composite the source and destination
    /// pixels. The visual result of this compositing mode is the source's
    /// black pixels are painted onto the destination and the source's white
    /// pixels are treated as clear.
    and = 3,
    /// Clears the bits in the destination image, using the source image as i
    /// mask. The visual result of this compositing mode is that for the parts
    /// where the source image is white, the destination image will be painted
    /// black. Other parts will be left untouched.
    clear = 4,
    /// Sets the bits in the destination image, using the source image as mask.
    /// The visual result of this compositing mode is that for the parts where
    /// the source image is black, the destination image will be painted white.
    /// Other parts will be left untouched. When drawing color PNGs, this mode
    /// will be required to apply any transparency.
    set = 5
}

///
alias GCompOpAssign = GCompOp.assign;
///
alias GCompOpAssignInverted = GCompOp.inverted;
///
alias GCompOpOr = GCompOp.or;
///
alias GCompOpAnd = GCompOp.and;
///
alias GCompOpClear = GCompOp.clear;
///
alias GCompOpSet = GCompOp.set;

/// An opaque structure for a graphics context.
struct GContext {}

/**
 * Sets the current stroke color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the stroke color.
 * color = The new stroke color.
 */
extern(C) void graphics_context_set_stroke_color(GContext* ctx, GColor color);

/**
 * Sets the current fill color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the fill color.
 * color = The new fill color.
 */
extern(C) void graphics_context_set_fill_color(GContext* ctx, GColor color);

/**
 * Sets the current text color of the graphics context.
 *
 * Params:
 * ctx = The graphics context onto which to set the text color.
 * color = The new text color.
 */
extern(C) void graphics_context_set_text_color(GContext* ctx, GColor color);

/**
 * Sets the current bitmap compositing mode of the graphics context.
 *
 * Note: At the moment, this only affects the bitmaps drawing operations
 * graphics_draw_bitmap_in_rect() and anything that uses that --, but it
 * currently does not affect the filling or stroking operations.
 *
 * Params:
 * ctx = The graphics context onto which to set the compositing mode.
 * mode = The new compositing mode.
 *
 * See_Also: GCompOp
 * See_Also: bitmap_layer_set_compositing_mode()
 */
extern(C) void graphics_context_set_compositing_mode
(GContext* ctx, GCompOp mode);

/**
 * Sets whether antialiasing is applied to stroke drawing.
 *
 * Note: Default value is true.
 *
 * Params:
 * ctx = The graphics context onto which to set the antialiasing.
 * enable = enable or disable anti-aliasing.
 */
version(PEBBLE_BASALT)
extern(C) void graphics_context_set_antialiased(GContext* ctx, bool enable);

/**
 * Sets the width of the stroke for drawing routines
 *
 * Note: If stroke width of zero is passed, it will be ignored and will not
 * change the value stored in GContext. Currently, only odd stroke_width
 * values are supported. If an even value is passed in, the value will be
 * stored as is, but the drawing routines will round down to the
 * previous integral value when drawing. Default value is 1.
 *
 * Params:
 * ctx = The graphics context onto which to set the stroke width.
 * stroke_width = Width in pixels of the stroke.
 */
version(PEBBLE_BASALT)
extern(C) void graphics_context_set_stroke_width
(GContext* ctx, ubyte stroke_width);

/**
 * Bit mask values to specify the corners of a rectangle.
 * The values can be combines using binary OR (`|`),
 *
 * For example: the mask to indicate top left and bottom right corners can:
 * be created as follows: GCornerTopLeft | GCornerBottomRight
 */
enum GCornerMask {
    /// No corners
    none = 0,
    /// Top-Left corner
    topLeft = 1,
    /// Top-Right corner
    topRight = 2,
    /// Bottom-Left corner
    bottomLeft = 4,
    /// Bottom-Right corner
    bottomRight = 8,
    /// All corners
    all = 15,
    /// Top corners
    top = 3,
    /// Bottom corners
    bottom = 12,
    /// Left corners
    left = 5,
    /// Right corners
    right = 10
}

///
alias GCornerNone = GCornerMask.none;
///
alias GCornerTopLeft = GCornerMask.topLeft;
///
alias GCornerTopRight = GCornerMask.topRight;
///
alias GCornerBottomRight = GCornerMask.bottomRight;
///
alias GCornersAll = GCornerMask.all;
///
alias GCornersTop = GCornerMask.top;
///
alias GCornersBottom = GCornerMask.bottom;
///
alias GCornersLeft = GCornerMask.left;
///
alias GCornersRight = GCornerMask.right;

/**
 * Draws a pixel at given point in the current stroke color
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * point = The point at which to draw the pixel.
 */
extern(C) void graphics_draw_pixel(GContext* ctx, GPoint point);

/**
 * Draws line in the current stroke color, current stroke width and AA flag.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * p0 = The starting point of the line
 * p1 = The ending point of the line
 */
extern(C) void graphics_draw_line(GContext* ctx, GPoint p0, GPoint p1);

/**
 * Draws a 1-pixel wide rectangle outline in the current stroke color.
 *
 * Params:
 * ctx = The destination graphics context in which to draw
 * rect = The rectangle for which to draw the outline.
 */
extern(C) void graphics_draw_rect(GContext* ctx, GRect rect);

/**
 * Fills a retangle with the current fill color, optionally rounding all or
 * a selection of its corners.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * rect = The rectangle to fill.
 * corner_radius = The rounding radius of the corners in pixels
 *     (maximum is 8 pixels)
 * corner_mask = Bitmask of the corners that need to be rounded.
 *
 * See_Also: GCornerMask
 */
extern(C) void graphics_fill_rect
(GContext* ctx, GRect rect, ushort corner_radius, GCornerMask corner_mask);

/**
 * Draws the outline of a circle in the current stroke color
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * p = The center point of the circle
 * radius = The radius in pixels.
 */
extern(C) void graphics_draw_circle(GContext* ctx, GPoint p, ushort radius);

/**
 * Fills a circle in the current fill color
 *
 * Params:
 * ctx = The destination graphics context in which to draw
 * p = The center point of the circle
 * radius = The radius in pixels
 */
extern(C) void graphics_fill_circle(GContext* ctx, GPoint p, ushort radius);

/**
 * Draws the outline of a rounded rectangle in the current stroke color.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * rect = The rectangle defining the dimensions of the rounded rectangle
 *     to draw.
 * radius = The corner radius in pixels.
 */
extern(C) void graphics_draw_round_rect
(GContext* ctx, GRect rect, ushort radius);

/**
 * Draws a bitmap into the graphics context, inside the specified rectangle
 *
 * Params:
 * ctx = The destination graphics context in which to draw the bitmap.
 * bitmap = The bitmap to draw.
 * rect = The rectangle in which to draw the bitmap.
 *
 * Note: If the size of `rect` is smaller than the size of the bitmap,
 * the bitmap will be clipped on right and bottom edges. If the size of `rect`
 * is larger than the size of the bitmap, the bitmap will be tiled
 * automatically in both horizontal and vertical directions, effectively
 * drawing a repeating pattern.
 *
 * See_Also: GBitmap
 * See_Also: GContext
 */
extern(C) void graphics_draw_bitmap_in_rect
(GContext* ctx, const(GBitmap)* bitmap, GRect rect);

/**
 * A shortcut to capture the framebuffer in the native format of the watch.
 *
 * See_Also: graphics_capture_frame_buffer_format
 */
extern(C) GBitmap* graphics_capture_frame_buffer(GContext* ctx);

/**
 * Captures the frame buffer for direct access, using the given format.
 * Graphics functions will not affect the frame buffer while it is captured.
 * The frame buffer is released when graphics_release_frame_buffer
 * is called.
 *
 * The frame buffer must be released before the end of a layer's
 * `.update_proc` for the layer to be drawn properly.
 *
 * While the frame buffer is captured calling graphics_capture_frame_buffer
 * will fail and return `NULL`.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 * format = The format in which the framebuffer should be captured.
 *     Supported formats are GBitmapFormat1Bit and GBitmapFormat8Bit.
 *
 * Returns: A pointer to the frame buffer. `NULL` if failed.
 *
 * See_Also: GBitmap
 * See_Also: GBitmapFormat
 */
version(PEBBLE_BASALT)
extern(C) GBitmap* graphics_capture_frame_buffer_format
(GContext* ctx, GBitmapFormat format);

/**
 * Releases the frame buffer.
 * Must be called before the end of a layer's `.update_proc` for the layer
 * to be drawn properly.
 *
 * If `buffer` does not point to the address previously returned by
 * graphics_capture_frame_buffer the frame buffer will not be released.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 * buffer = The pointer to frame buffer.
 *
 * Returns: true if the frame buffer was released successfully.
 */
extern(C) bool graphics_release_frame_buffer
(GContext* ctx, GBitmap* buffer);

/**
 * Draw text into the current graphics context, using the context's
 * current text color.
 *
 * The text will be drawn inside a box with the specified dimensions and
 * configuration, with clipping occuring automatically.
 *
 * Params:
 * ctx = The destination graphics context in which to draw.
 * text = The zero terminated UTF-8 string to draw.
 * font = The font in which the text should be set.
 * box = The bounding box in which to draw the text. The first line of text
 *     will be drawn against the top of the box.
 * overflow_mode = The overflow behavior, in case the text is larger than
 *     what fits inside the box.
 * alignment = The horizontal alignment of the text
 * layout = Optional layout cache data. Supply `NULL` to ignore the layout
 *     caching mechanism.
 */
extern(C) void graphics_draw_text
(GContext* ctx, const(char)* text, const GFont font, const GRect box,
const GTextOverflowMode overflow_mode, const GTextAlignment alignment,
const(TextLayout)* layout);

/**
 * Whether or not the frame buffer has been captured by
 * graphics_capture_frame_buffer.
 *
 * Graphics functions will not affect the frame buffer until it has been
 * released by
 *
 * graphics_release_frame_buffer.
 *
 * Params:
 * ctx = The graphics context providing the frame buffer.
 *
 * Returns: true if the frame buffer has been captured.
 */
extern(C) bool graphics_frame_buffer_is_captured(GContext* ctx);

/**
 * Data structure describing a naked path
 *
 * Note: Note that this data structure only refers to an array of points;
 * the points are not stored inside this data structure itself.
 *
 * In most cases, one cannot use a stack-allocated array of GPoints.
 * Instead one often needs to provide longer-lived (static or "global")
 * storage for the points.
 */
struct GPathInfo {
    /// The number of points in the `points` array.
    uint num_points;
    /// Pointer to an array of points.
    GPoint* points;
}

/**
 * Data structure describing a path, plus its rotation and translation.
 *
 * Note: See the remark with GPathInfo
 */
struct GPath {
    /// The number of points in the `points` array.
    uint num_points;
    /// Pointer to an array of points.
    GPoint* points;
    /// The rotation that will be used when drawing the path with
    /// gpath_draw_filled() or gpath_draw_outline()
    int rotation;
    /// The translation that will to be used when drawing the path with
    /// gpath_draw_filled() or gpath_draw_outline()
    GPoint offset;
}

/**
 * Creates a new GPath on the heap based on a series of points described by
 * a GPathInfo.
 *
 * Values after initialization:
 * `num_points` and `points` pointer: copied from the GPathInfo.
 * `rotation`: 0
 * `offset`: (0, 0)
 *
 * Returns: A pointer to the GPath. `NULL` if the GPath could not be created.
 */
extern(C) GPath* gpath_create(const(GPathInfo)* init);

/// Free a dynamically allocated gpath created with gpath_create().
extern(C) void gpath_destroy(GPath* gpath);

/**
 * Draws the fill of a path into a graphics context, using the current
 * fill color, relative to the drawing area as set up by the layering system.
 *
 * Params:
 * ctx = The graphics context to draw into.
 * path = The path to fill.
 *
 * See_Also: graphics_context_set_fill_color()
 */
extern(C) void gpath_draw_filled(GContext* ctx, GPath* path);

/**
 * Draws the outline of a path into a graphics context, using the
 * current stroke color, relative to the drawing area as set up by the
 * layering system.
 *
 * Params:
 * ctx = The graphics context to draw into.
 * path = The path to fill.
 *
 * See_Also: graphics_context_set_stroke_color()
 */
extern(C) void gpath_draw_outline(GContext* ctx, GPath* path);

/**
 * Sets the absolute rotation of the path.
 * The current rotation will be replaced by the specified angle.
 *
 * Note: Setting a rotation does not affect the points in the path directly.
 * The rotation is applied on-the-fly during drawing, either using
 * gpath_draw_filled() or gpath_draw_outline().
 *
 * Params:
 * path = The path onto which to set the rotation
 * angle = The absolute angle of the rotation. The angle is represented
 * in the same way that is used with sin_lookup(). See TRIG_MAX_ANGLE
 * for more information.
 */
extern(C) void gpath_rotate_to(GPath* path, int angle);

/**
 * Sets the absolute offset of the path. The current translation will be
 * replaced by the specified offset.
 *
 * Params:
 * path = The path onto which to set the translation.
 * point = The point which is used as the vector for the translation.
 *
 * Note: Setting a translation does not affect the points in the path directly.
 * The translation is applied on-the-fly during drawing, either using
 * gpath_draw_filled() or gpath_draw_outline().
 */
extern(C) void gpath_move_to(GPath* path, GPoint point);

