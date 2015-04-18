/**
 * This module defines bitmaps for Pebble watches.
 */
module pebble.gbitmap;

import pebble.versions;

import pebble.gsize;
import pebble.grect;
import pebble.gcolor;

// TODO: Add properties for bitmaps and so on, appropriately versioned.

/// The format of a GBitmap can either be 1-bit or 8-bit.
enum GBitmapFormat {
    /// 1-bit black and white. 0 = black, 1 = white.
    _1bit = 0,
    /// 6-bit color + 2 bit alpha channel. See \ref GColor8 for pixel format.
    _8bit = 1,
    _1bitPalette = 2,
    _2bitPalette = 3,
    _4bitPalette = 4,
}

///
alias GBitmapFormat1Bit = GBitmapFormat._1bit;
///
alias GBitmapFormat8Bit = GBitmapFormat._8bit;
///
alias GBitmapFormat1BitPalette = GBitmapFormat._1bitPalette;
///
alias GBitmapFormat2BitPalette = GBitmapFormat._2bitPalette;
///
alias GBitmapFormat4BitPalette = GBitmapFormat._4bitPalette;

version(PEBBLE_APLITE) {
    /**
     * Structure containing the metadata of a bitmap image.
     *
     * Note that this structure does NOT contain any pixel data; it only has
     * a pointer to a buffer containing the pixels (the `addr` field).
     *
     * The metadata describes how long each row of pixels is in the buffer
     * (the stride).
     *
     * Each row must be a multiple of 32 pixels (4 bytes).
     * Using the `bounds` field, the area that is actually relevant can be
     * specified.
     *
     * For example, when the image is 29 by 5 pixels (width by height)
     * and the first bit of image data is the pixel at (0, 0), then the
     * bounds.size would be `GSize(29, 5)` and bounds.origin would be
     * `GPoint(0, 0)`.
     *
     * See_Also: BitmapLayer
     * See_Also: graphics_draw_bitmap_in_rect
     * See_Also: Resources
     */
    struct GBitmap {
    align(1):
        /// Pointer to the address where the image data lives.
        ubyte* addr;
        /**
         * Note: The number of bytes per row should be a multiple of 4.
         *
         * Also, the following should (naturally) be true:
         * `(row_size_bytes * 8 >= bounds.w)`
         */
        ushort row_size_bytes;

        ushort info_flags;

        /**
         * The box of bits that the `addr` field is pointing to, that contains
         * the actual image data to use. Note that this may be a subsection
         * of the data with padding on all sides.
         */
        GRect bounds;

        /// Is .addr heap allocated? Do we need to free .addr in
        /// gbitmap_deinit?
        @nogc @safe pure nothrow
        @property bool is_heap_allocated() const {
            return info_flags >> 16;
        }

        /// Version of bitmap structure and image data.
        @nogc @safe pure nothrow
        @property ushort _version() const {
            return info_flags & 0b1111;
        }
    }
} else {
    /// A opaque struct for a bitmap.
    struct GBitmap {}
}

/// A opaque struct for a sequence of bitmaps.
struct GBitmapSequence {}

/**
 * Get the number of bytes per row in the bitmap data for the given GBitmap.
 * This can be used as a safe way of iterating over the rows in the bitmap,
 * since bytes per row should be set according to format.
 */
version(PEBBLE_BASALT)
@safe pure
extern(C) ushort gbitmap_get_bytes_per_row(const(GBitmap)* bitmap);

/// ditto
version(PEBBLE_APLITE)
@safe pure
ushort gbitmap_get_bytes_per_row(const(GBitmap)* bitmap) {
    return bitmap.row_size_bytes;
}

/**
 * Returns: The format of the given GBitmap.
 */
version(PEBBLE_BASALT)
extern(C) GBitmapFormat gbitmap_get_format(const(GBitmap)* bitmap);

/**
 * Get a pointer to the data section of the given GBitmap.
 *
 * See_Also: gbitmap_get_bytes_per_row
 */
version(PEBBLE_BASALT)
@safe pure
extern(C) ubyte* gbitmap_get_data(const(GBitmap)* bitmap);

version(PEBBLE_APLITE)
@safe pure
ubyte* gbitmap_get_data(const(GBitmap)* bitmap) {
    return bitmap.addr;
}

/**
 * Set the bitmap data for the given GBitmap.
 *
 * Params:
 * bitmap = A pointer to the GBitmap to set data to.
 * data = A pointer to the bitmap data.
 * format = The format of the bitmap data. If this is a palettized format,
 *     make sure that there is an accompanying call to gbitmap_set_palette.
 * row_size_bytes = How many bytes a single row takes. For example, bitmap
 *     data of format GBitmapFormat1Bit must have a row size as a multiple
 *     of 4 bytes.
 * free_on_destroy = Set whether the data should be freed when the GBitmap
 *     is destroyed.
 *
 * See_Also: gbitmap_destroy
 */
version(PEBBLE_BASALT)
extern(C) void gbitmap_set_data(GBitmap* bitmap, ubyte* data,
GBitmapFormat format, ushort row_size_bytes, bool free_on_destroy);

/// ditto
version(PEBBLE_APLITE)
@safe pure
extern(C) void gbitmap_set_data(GBitmap* bitmap, ubyte* data,
GBitmapFormat format, ushort row_size_bytes, bool free_on_destroy) {
    bitmap.addr = data;
}

/// See_Also: gbitmap_set_bounds
version(PEBBLE_BASALT)
@safe pure
extern(C) GRect gbitmap_get_bounds(const(GBitmap)* bitmap);

/// ditto
version(PEBBLE_APLITE)
@safe pure
ref GRect gbitmap_get_bounds(const(GBitmap)* bitmap) {
    return bitmap.bounds;
}

/**
 * Set the bounds of the given GBitmap.
 *
 * See_Also: gbitmap_get_bounds
 */
version(PEBBLE_BASALT)
@safe pure
extern(C) void gbitmap_set_bounds(GBitmap* bitmap, GRect bounds);

/// ditto
version(PEBBLE_APLITE)
@safe pure
void gbitmap_set_bounds(GBitmap* bitmap, GRect bounds) {
    bitmap.bounds = bounds;
}

/// See_Also: gbitmap_set_palette
version(PEBBLE_BASALT)
extern(C) GColor* gbitmap_get_palette(const(GBitmap)* bitmap);

/**
 * Set the palette for the given GBitmap.
 *
 * Params:
 * bitmap = A pointer to the GBitmap to set the palette to.
 * palette = The palette to be used. Make sure that the palette is large
 *     enough for the bitmap's format.
 * free_on_destroy = Set whether the palette data should be freed when the
 *     GBitmap is destroyed.
 *
 * See_Also: gbitmap_get_format
 * See_Also: gbitmap_destroy
 * See_Also: gbitmap_get_palette
 */
version(PEBBLE_BASALT)
extern(C) void gbitmap_set_palette
(GBitmap* bitmap, GColor* palette, bool free_on_destroy);

// TODO: Wrap these in an RAII type.

/**
 * Creates a new GBitmap on the heap using a Pebble image file stored
 * as a resource.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * resource_id = The ID of the bitmap resource to load.
 *
 * Returns: A pointer to the \ref GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
extern(C) GBitmap* gbitmap_create_with_resource(uint resource_id);

/**
 * Creates a new GBitmap on the heap initialized with the provided
 * Pebble image data.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy() but the
 * image data will not be freed automatically. The developer is
 * responsible for keeping the image data in memory as long as the bitmap
 * is used and releasing it after the bitmap is destroyed.
 *
 * Note: One way to generate Pebble image data is to use bitmapgen.py in
 * the Pebble SDK to generate a .pbi file.
 *
 * Params: data = The Pebble image data. Must not be NULL. The function
 *     assumes the data to be correct; there are no sanity checks performed
 *     on the data. The data will not be copied and the pointer must remain
 *     valid for the lifetime of this GBitmap.
 *
 * Returns: A pointer to the GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
extern(C) GBitmap* gbitmap_create_with_data(const(ubyte)* data);

/**
 * Create a new GBitmap on the heap as a sub-bitmap of a 'base'
 * GBitmap, using a GRect to indicate what portion of the base to use. The
 * sub-bitmap will just reference the image data and palette of the base
 * bitmap.
 *
 * No deep-copying occurs as a result of calling this function, thus the caller
 * is responsible for making sure the base bitmap and palette will
 * remain available when using the sub-bitmap. Note that you should not
 * destroy the parent bitmap until the sub_bitmap has been destroyed.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * base_bitmap = The bitmap that the sub-bitmap of which the image data
 *     will be used by the sub-bitmap
 * sub_rect = The rectangle within the image data of the base bitmap. The
 *     bounds of the base bitmap will be used to clip `sub_rect`.
 *
 * Returns: A pointer to the GBitmap. `NULL` if the GBitmap could not
 *     be created.
 */
extern(C) GBitmap* gbitmap_create_as_sub_bitmap
(const(GBitmap)* base_bitmap, GRect sub_rect);

/**
 * The resulting \ref GBitmap must be destroyed using gbitmap_destroy().
 *
 * The developer is responsible for freeing png_data following this call.
 *
 * Note: PNG decoding currently supports 1,2,4 and 8 bit palettized
 *     and grayscale images.
 *
 * Params:
 * png_data = PNG image data.
 * png_data_size = PNG image size in bytes.
 *
 * Returns: A pointer to the \ref GBitmap. `NULL` if the GBitmap could not
 * be created.
 */
version(PEBBLE_BASALT)
extern(C) GBitmap* gbitmap_create_from_png_data
(const(ubyte)* png_data, size_t png_data_size);

/**
 * Creates a new blank GBitmap on the heap initialized to zeroes.
 * In the case that the format indicates a palettized bitmap,
 * a palette of appropriate size will also be allocated on the heap.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * size = The Pebble image dimensions as a GSize.
 * format = The GBitmapFormat the created image should be in.
 *
 * Returns: A pointer to the GBitmap. null if the GBitmap could not
 * be created
 */
version(PEBBLE_BASALT)
extern(C) GBitmap* gbitmap_create_blank(GSize size, GBitmapFormat format);

/**
 * Creates a new blank GBitmap on the heap initialized to zeroes.
 *
 * The resulting GBitmap must be destroyed using gbitmap_destroy().
 *
 * Params:
 * size = The Pebble image dimensions as a GSize.
 *
 * Returns: A pointer to the GBitmap. null if the GBitmap could not
 * be created
 */
version(PEBBLE_APLITE)
extern(C) GBitmap* gbitmap_create_blank(GSize size);

/**
 * Creates a new blank GBitmap on the heap, initialized to zeroes, and assigns
 * it the given palette.
 *
 * No deep-copying of the palette occurs, so the caller is responsible for
 * making sure the palette remains available when using the resulting bitmap.
 * Management of that memory can be handed off to the system with the
 * free_on_destroy argument.
 *
 * Params:
 * size = The Pebble image dimensions as a GSize.
 * format = The GBitmapFormat the created image and palette should be in.
 * palette = A pointer to a palette that is to be used for this GBitmap.
 *     The palette should be large enough to hold enough colors for the
 *     specified format. For example, GBitmapFormat2BitPalette should have
 *     4 colors, since 2^2 = 4.
 * free_on_destroy = Set whether the palette data should be freed along with
 *     the bitmap data when the GBitmap is destroyed.
 *
 * Returns: A Pointer to the GBitmap. `NULL` if the GBitmap could not be
 *     created.
 */
version(PEBBLE_BASALT)
extern(C) GBitmap* gbitmap_create_blank_with_palette
(GSize size, GBitmapFormat format, GColor* palette, bool free_on_destroy);

/**
 * Destroy a GBitmap.
 * This must be called for every bitmap that's been created with
 * gbitmap_create_*
 *
 * This function will also free the memory of the bitmap data (bitmap->addr)
 * if the bitmap was created with gbitmap_create_blank()
 * or gbitmap_create_with_resource().
 *
 * If the GBitmap was created with gbitmap_create_with_data(),
 * you must release the memory after calling gbitmap_destroy().
 */
extern(C) void gbitmap_destroy(GBitmap* bitmap);

/**
 * Loading the apng from resource, initializes header,
 * duration and frame count only (IHDR, acTL, alTL chunks)
 */
version(PEBBLE_BASALT)
extern(C) GBitmapSequence* gbitmap_sequence_create_with_resource
(uint resource_id);

/**
 * Updates the contents of the bitmap sequence to the next frame
 * and returns the delay in milliseconds until the next frame.
 *
 * Note: GBitmap must be large enough to accommodate the bitmap_sequence image
 * gbitmap_sequence_get_bitmap_size
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 * bitmap = Pointer to the initialized GBitmap in which to render the bitmap
 *     sequence.
 *
 * Returns: True if frame was rendered. False if all frames (and loops) have
 *     been rendered for the sequence. Will also return false if frame could
 *     not be rendered (includes out of memory errors).
 */
version(PEBBLE_BASALT)
extern(C) bool gbitmap_sequence_update_bitmap_next_frame
(GBitmapSequence* bitmap_sequence, GBitmap* bitmap, uint* delay_ms);

/**
 * Deletes the GBitmapSequence structure and frees any allocated
 * memory/decoder_data
 */
version(PEBBLE_BASALT)
extern(C) void gbitmap_sequence_destroy(GBitmapSequence* bitmap_sequence);

/**
 * Restarts the GBitmapSequence by positioning the read_cursor at the
 * first frame
 */
version(PEBBLE_BASALT)
extern(C) bool gbitmap_sequence_restart(GBitmapSequence* bitmap_sequence);

/**
 * This function gets the current frame number for the bitmap sequence.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: index of current frame in the current loop of the bitmap sequence.
 */
version(PEBBLE_BASALT)
extern(C) int gbitmap_sequence_get_current_frame_idx
(GBitmapSequence* bitmap_sequence);

/**
 * This function sets the total number of frames for the bitmap sequence
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: number of frames contained in a single loop of the bitmap sequence.
 */
version(PEBBLE_BASALT)
extern(C) int gbitmap_sequence_get_total_num_frames
(GBitmapSequence* bitmap_sequence);

/**
 * This function gets the loop count (number of times to repeat) the bitmap
 * sequence.
 *
 * Note: This value is initialized by the bitmap sequence data, and is modified
 * by gbitmap_sequence_set_loop_count.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: Loop count of bitmap sequence, 0 for infinite.
 */
version(PEBBLE_BASALT)
extern(C) uint gbitmap_sequence_get_loop_count
(GBitmapSequence* bitmap_sequence);

/**
 * This function sets the loop count (number of times to repeat) the bitmap
 * sequence.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 * loop_count = Number of times to repeat the bitmap sequence.
 */
version(PEBBLE_BASALT)
extern(C) void gbitmap_sequence_set_loop_count
(GBitmapSequence* bitmap_sequence, uint loop_count);

/**
 * This function gets the minimum required size (dimensions) necessary
 * to render the bitmap sequence to a GBitmap using the
 * gbitmap_sequence_update_bitmap_next_frame.
 *
 * Params:
 * bitmap_sequence = Pointer to loaded bitmap sequence.
 *
 * Returns: Dimensions required to render the bitmap sequence to a GBitmap.
 */
version(PEBBLE_BASALT)
extern(C) GSize gbitmap_sequence_get_bitmap_size
(GBitmapSequence* bitmap_sequence);

