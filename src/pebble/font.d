/**
 * This module defines Pebble fonts and operations on fonts.
 */
module pebble.font;

import pebble.gsize;
import pebble.grect;
import pebble.resource;

import pebble.versions;

@nogc:
nothrow:

// Font names common to all versions.

///
enum const(char)* FONT_KEY_GOTHIC_14 = "RESOURCE_ID_GOTHIC_14";
///
enum const(char)* FONT_KEY_GOTHIC_14_BOLD = "RESOURCE_ID_GOTHIC_14_BOLD";
///
enum const(char)* FONT_KEY_GOTHIC_18 = "RESOURCE_ID_GOTHIC_18";
///
enum const(char)* FONT_KEY_GOTHIC_18_BOLD = "RESOURCE_ID_GOTHIC_18_BOLD";
///
enum const(char)* FONT_KEY_GOTHIC_24 = "RESOURCE_ID_GOTHIC_24";
///
enum const(char)* FONT_KEY_GOTHIC_28 = "RESOURCE_ID_GOTHIC_28";
///
enum const(char)* FONT_KEY_GOTHIC_28_BOLD = "RESOURCE_ID_GOTHIC_28_BOLD";
///
enum const(char)* FONT_KEY_GOTHIC_24_BOLD = "RESOURCE_ID_GOTHIC_24_BOLD";

///
enum const(char)* FONT_KEY_BITHAM_18_LIGHT_SUBSET =
    "RESOURCE_ID_BITHAM_18_LIGHT_SUBSET";
///
enum const(char)* FONT_KEY_BITHAM_30_BLACK =
    "RESOURCE_ID_BITHAM_30_BLACK";
///
enum const(char)* FONT_KEY_BITHAM_34_MEDIUM_NUMBERS =
    "RESOURCE_ID_BITHAM_34_MEDIUM_NUMBERS";
///
enum const(char)* FONT_KEY_BITHAM_34_LIGHT_SUBSET =
    "RESOURCE_ID_BITHAM_34_LIGHT_SUBSET";
///
enum const(char)* FONT_KEY_BITHAM_42_LIGHT = "RESOURCE_ID_BITHAM_42_LIGHT";
///
enum const(char)* FONT_KEY_BITHAM_42_BOLD = "RESOURCE_ID_BITHAM_42_BOLD";
///
enum const(char)* FONT_KEY_BITHAM_42_MEDIUM_NUMBERS =
    "RESOURCE_ID_BITHAM_42_MEDIUM_NUMBERS";

///
enum const(char)* FONT_KEY_ROBOTO_CONDENSED_21 =
    "RESOURCE_ID_ROBOTO_CONDENSED_21";
///
enum const(char)* FONT_KEY_ROBOTO_BOLD_SUBSET_49 =
    "RESOURCE_ID_ROBOTO_BOLD_SUBSET_49";

///
enum const(char)* FONT_KEY_DROID_SERIF_28_BOLD =
    "RESOURCE_ID_DROID_SERIF_28_BOLD";

///
enum const(char)* FONT_KEY_FONT_FALLBACK = FONT_KEY_GOTHIC_14;

version(PEBBLE_BASALT) {
    ///
    enum const(char)* FONT_KEY_GOTHIC_09 = "RESOURCE_ID_GOTHIC_09";

    ///
    enum const(char)* FONT_KEY_LECO_20_BOLD_NUMBERS =
        "RESOURCE_ID_LECO_20_BOLD_NUMBERS";
    ///
    enum const(char)* FONT_KEY_LECO_32_BOLD_NUMBERS =
        "RESOURCE_ID_LECO_32_BOLD_NUMBERS";
    ///
    enum const(char)* FONT_KEY_LECO_36_BOLD_NUMBERS =
        "RESOURCE_ID_LECO_36_BOLD_NUMBERS";
    ///
    enum const(char)* FONT_KEY_LECO_38_BOLD_NUMBERS =
        "RESOURCE_ID_LECO_38_BOLD_NUMBERS";
    ///
    enum const(char)* FONT_KEY_LECO_28_LIGHT_NUMBERS =
        "RESOURCE_ID_LECO_28_LIGHT_NUMBERS";

    ///
    enum const(char)* FONT_KEY_FONT_FALLBACK_INTERNAL =
        "RESOURCE_ID_FONT_FALLBACK_INTERNAL";
}

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
