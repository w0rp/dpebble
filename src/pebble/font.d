/**
 * This module defines Pebble fonts and operations on fonts.
 */
module pebble.font;

import pebble.gsize;
import pebble.grect;
import pebble.resource;

@nogc:
nothrow:

struct GFontType{}

/**
 * Pointer to opaque font data structure.
 *
 * See_Also: fonts_load_custom_font()
 * See_Also: text_layer_set_font()
 * See_Also: graphics_draw_text()
 */
alias GFontType* GFont;

/**
 * Loads a system font corresponding to the specified font key.
 *
 * Note: This may load a font from the flash peripheral into RAM.
 *
 * Params:
 * font_key = The string key of the font to load. See `pebble_fonts.h`
 * for a list of system fonts.
 *
 * Returns:
 * An opaque pointer to the loaded font, or, a pointer to the default
 * (fallback) font if the specified font cannot be loaded.
 */
extern(C) GFont fonts_get_system_font(const(char)* font_key);

/**
 * Loads a custom font.
 *
 * Note: This may load a font from the flash peripheral into RAM.
 *
 * Params:
 * handle = The resource handle of the font to load. See resource_ids.auto.h
 *     for a list of resource IDs, and use resource_get_handle() to obtain
 *     the resource handle.
 *
 * Returns: An opaque pointer to the loaded font, or a pointer to the default
 *     (fallback) font if the specified font cannot be loaded.
 *
 * See_Also: Read the App Resources guide on how to embed a font into your app.
 */
extern(C) GFont fonts_load_custom_font(ResourceHandle* handle);

/**
 * Unloads the specified custom font and frees the memory that is occupied by
 * it.
 *
 * Params: font = The font to unload.
 *
 * Note: When an application exits, the system automatically unloads all fonts
 * that have been loaded.
 */
extern(C) void fonts_unload_custom_font(GFont font);

/**
 * Text overflow mode controls the way text overflows when the string
 * that is drawn does not fit inside the area constraint.
 *
 * See_Also: graphics_draw_text
 * See_Also: text_layer_set_overflow_mode
 */
enum GTextOverflowMode {
    /// On overflow, wrap words to a new line below the current one.
    /// Once vertical space is consumed, the last line may be clipped.
    wordWrap = 0,
    /// On overflow, wrap words to a new line below the current one.
    /// Once vertical space is consumed, truncate as needed to fit a trailing
    /// ellipsis (...). Clipping may occur if the vertical space cannot
    /// accommodate the first line of text.
    ellipsis = 1,
    /// Acts like 'ellipsis', plus trims leading and
    /// trailing newlines, while treating all other newlines as spaces.
    fill = 2
}

///
alias GTextOverflowModeWordWrap = GTextOverflowMode.wordWrap;
///
alias GTextOverflowModeTrailingEllipsis = GTextOverflowMode.ellipsis;
///
alias GTextOverflowModeFill = GTextOverflowMode.fill;

/**
 * Text aligment controls the way the text is aligned inside the box the
 * text is drawn into.
 *
 * See_Also: graphics_draw_text
 * See_Also: text_layer_set_text_alignment
 */
enum GTextAlignment {
    /// Aligns the text to the left of the drawing box.
    left = 0,
    /// Aligns the text centered inside the drawing box.
    center = 1,
    /// Aligns the text to the right of the drawing box.
    right = 2
}

///
alias GTextAlignmentLeft = GTextAlignment.left;
///
alias GTextAlignmentCenter = GTextAlignment.center;
///
alias GTextAlignmentRight = GTextAlignment.right;

/// An opaque struct for text layout data.
struct TextLayout {}

deprecated("Use TextLayout* instead.")
alias TextLayout* GTextLayoutCacheRef;

deprecated("Use void* instead.")
alias void* ClickRecognizerRef;

/**
 * Obtain the maximum size that a text with given font, overflow mode and
 * alignment occupies within a given rectangular constraint.
 *
 * Params:
 * text = The zero terminated UTF-8 string for which to calculate the size.
 * font = The font in which the text should be set while calculating the size.
 * box = The bounding box in which the text should be constrained.
 * overflow_mode = The overflow behavior, in case the text is larger than what
 *     fits inside the box.
 * alignment = The horizontal alignment of the text.
 *
 * Returns: The maximum size occupied by the text.
 */
extern(C) GSize graphics_text_layout_get_content_size
(const(char)* text, const GFont font, const GRect box,
const GTextOverflowMode overflow_mode, const GTextAlignment alignment);
