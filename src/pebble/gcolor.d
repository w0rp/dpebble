/**
 * Pebble color data structures, and operations on them.
 */
module pebble.gcolor;

import pebble.versions;

@nogc:
@safe:
pure:
nothrow:

/// A color for aplite Pebble watches, which have only 2 colors.
enum GColorMonoChrome {
  /// Represents "clear" or transparent.
  clear = ~0,
  /// Represents black.
  black = 0,
  /// Represents white.
  white = 1,
}


/**
 * A 8-bit color value with an alpha channel.
 *
 * These colors are only available on the basalt pebble watches.
 */
struct GColor8 {
@nogc:
@safe:
pure:
nothrow:
    /**
     * The color data represented with the bits 0 and 1 as blue,
     * bits 2 and 3 as green, bits 4 and 5 as red,
     * and bits 6 and 7 as an alpha channel, ranging from the least
     * significant bit to the most significant. (right to left)
     */
    ubyte argb;

    /**
     * Create an 8-bit color from one unsigned byte holding all the color values.
     */
    this(ubyte argb) {
        this.argb = argb;
    }

    /**
     * Create an 8-bit color from 24-bit RGBA values.
     */
    this(ubyte red, ubyte green, ubyte blue, ubyte alpha) {
        this.r = red >> 6;
        this.g = green >> 6;
        this.b = blue >> 6;
        this.a = alpha >> 6;
    }

    /**
     * Create an 8-bit color from 24-bit RGB values.
     */
    this(ubyte red, ubyte green, ubyte blue) {
        this.r = red >> 6;
        this.g = green >> 6;
        this.b = blue >> 6;
        this.a = 0b11;
    }

    /**
     * The alpha value.
     *
     * 3 = 100% opaque,
     * 2 = 66% opaque,
     * 1 = 33% opaque,
     * 0 = transparent.
     */
    @property ubyte a() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return argb >> 6;
    }

    /// Set the alpha value.
    @property void a(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b00_11_11_11;
        argb |= value << 6;
    }

    /// Red
    @property ubyte r() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return (argb & 0b00_11_00_00) >> 4;
    }

    /// Set the red value.
    @property void r(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_00_11_11;
        argb |= value << 4;
    }

    /// Green
    @property ubyte g() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return (argb & 0b00_00_11_00) >> 2;
    }

    /// Set the green value.
    @property void g(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_11_00_11;
        argb |= value << 2;
    }

    /// Blue
    @property ubyte b() const
    out(value) {
        assert(value >= 0 && value <= 3);
    } body {
        return argb & 0b00_00_00_11;
    }

    /// Set the blue value.
    @property void b(ubyte value)
    in {
        assert(value >= 0 && value <= 3);
    } body {
        argb &= 0b11_11_11_00;
        argb |= value;
    }

}

// Test that all of the bitmasks are done properly.
unittest {
    GColor8 color;

    color.a = 1;

    assert(color.argb == 0b01_00_00_00);
    assert(color.a == 1);

    color.a = 0;
    color.r = 1;

    assert(color.argb == 0b00_01_00_00);
    assert(color.r == 1);

    color.r = 0;
    color.g = 1;

    assert(color.argb == 0b00_00_01_00);
    assert(color.g == 1);

    color.g = 0;
    color.b = 1;

    assert(color.argb == 0b00_00_00_01);
    assert(color.b == 1);
}

deprecated("Use GColor8(r, g, b, a) instead of GColorFromRGBA(r, g, b, a)")
GColor8 GColorFromRGBA(ubyte red, ubyte green, ubyte blue, ubyte alpha) {
    return GColor8(red, green, blue, alpha);
}

deprecated("Use GColor8(r, g, b) instead of GColorFromRGB(r, g, b)")
GColor8 GColorFromRGB(ubyte red, ubyte green, ubyte blue) {
    return GColor8(red, green, blue);
}

/**
 * Convert a hex integer to a GColor8.
 *
 * Params:
 * v = Integer hex value (e.g. 0x64ff46)
 *
 * Returns: A color created from the hex value.
 */
GColor8 GColorFromHEX(uint v) {
    return GColor8(v >> 16 & 0xff, v >> 8 & 0xff, v & 0xff);
}

/**
 * Comparison function for GColors.
 *
 * This simply returns x == y in D, so it is not recommended and exists only
 * for helping port code to D.
 */
deprecated("Use x == y instead of GColorEq(x, y)")
bool GColorEq(GColor8 x, GColor8 y) {
    return x == y;
}

// Define the colour values.

///
enum ubyte GColorBlackARGB8                 = 0b11000000;
///
enum ubyte GColorOxfordBlueARGB8            = 0b11000001;
///
enum ubyte GColorDukeBlueARGB8              = 0b11000010;
///
enum ubyte GColorBlueARGB8                  = 0b11000011;
///
enum ubyte GColorDarkGreenARGB8             = 0b11000100;
///
enum ubyte GColorMidnightGreenARGB8         = 0b11000101;
///
enum ubyte GColorCobaltBlueARGB8            = 0b11000110;
///
enum ubyte GColorBlueMoonARGB8              = 0b11000111;
///
enum ubyte GColorIslamicGreenARGB8          = 0b11001000;
///
enum ubyte GColorJaegerGreenARGB8           = 0b11001001;
///
enum ubyte GColorTiffanyBlueARGB8           = 0b11001010;
///
enum ubyte GColorVividCeruleanARGB8         = 0b11001011;
///
enum ubyte GColorGreenARGB8                 = 0b11001100;
///
enum ubyte GColorMalachiteARGB8             = 0b11001101;
///
enum ubyte GColorMediumSpringGreenARGB8     = 0b11001110;
///
enum ubyte GColorCyanARGB8                  = 0b11001111;
///
enum ubyte GColorBulgarianRoseARGB8         = 0b11010000;
///
enum ubyte GColorImperialPurpleARGB8        = 0b11010001;
///
enum ubyte GColorIndigoARGB8                = 0b11010010;
///
enum ubyte GColorElectricUltramarineARGB8   = 0b11010011;
///
enum ubyte GColorArmyGreenARGB8             = 0b11010100;
///
enum ubyte GColorDarkGrayARGB8              = 0b11010101;
///
enum ubyte GColorLibertyARGB8               = 0b11010110;
///
enum ubyte GColorVeryLightBlueARGB8         = 0b11010111;
///
enum ubyte GColorKellyGreenARGB8            = 0b11011000;
///
enum ubyte GColorMayGreenARGB8              = 0b11011001;
///
enum ubyte GColorCadetBlueARGB8             = 0b11011010;
///
enum ubyte GColorPictonBlueARGB8            = 0b11011011;
///
enum ubyte GColorBrightGreenARGB8           = 0b11011100;
///
enum ubyte GColorScreaminGreenARGB8         = 0b11011101;
///
enum ubyte GColorMediumAquamarineARGB8      = 0b11011110;
///
enum ubyte GColorElectricBlueARGB8          = 0b11011111;
///
enum ubyte GColorDarkCandyAppleRedARGB8     = 0b11100000;
///
enum ubyte GColorJazzberryJamARGB8          = 0b11100001;
///
enum ubyte GColorPurpleARGB8                = 0b11100010;
///
enum ubyte GColorVividVioletARGB8           = 0b11100011;
///
enum ubyte GColorWindsorTanARGB8            = 0b11100100;
///
enum ubyte GColorRoseValeARGB8              = 0b11100101;
///
enum ubyte GColorPurpureusARGB8             = 0b11100110;
///
enum ubyte GColorLavenderIndigoARGB8        = 0b11100111;
///
enum ubyte GColorLimerickARGB8              = 0b11101000;
///
enum ubyte GColorBrassARGB8                 = 0b11101001;
///
enum ubyte GColorLightGrayARGB8             = 0b11101010;
///
enum ubyte GColorBabyBlueEyesARGB8          = 0b11101011;
///
enum ubyte GColorSpringBudARGB8             = 0b11101100;
///
enum ubyte GColorInchwormARGB8              = 0b11101101;
///
enum ubyte GColorMintGreenARGB8             = 0b11101110;
///
enum ubyte GColorCelesteARGB8               = 0b11101111;
///
enum ubyte GColorRedARGB8                   = 0b11110000;
///
enum ubyte GColorFollyARGB8                 = 0b11110001;
///
enum ubyte GColorFashionMagentaARGB8        = 0b11110010;
///
enum ubyte GColorMagentaARGB8               = 0b11110011;
///
enum ubyte GColorOrangeARGB8                = 0b11110100;
///
enum ubyte GColorSunsetOrangeARGB8          = 0b11110101;
///
enum ubyte GColorBrilliantRoseARGB8         = 0b11110110;
///
enum ubyte GColorShockingPinkARGB8          = 0b11110111;
///
enum ubyte GColorChromeYellowARGB8          = 0b11111000;
///
enum ubyte GColorRajahARGB8                 = 0b11111001;
///
enum ubyte GColorMelonARGB8                 = 0b11111010;
///
enum ubyte GColorRichBrilliantLavenderARGB8 = 0b11111011;
///
enum ubyte GColorYellowARGB8                = 0b11111100;
///
enum ubyte GColorIcterineARGB8              = 0b11111101;
///
enum ubyte GColorPastelYellowARGB8          = 0b11111110;
///
enum ubyte GColorWhiteARGB8                 = 0b11111111;
///
enum ubyte GColorClearARGB8 = 0;

///
enum GColorOxfordBlue            = GColor8(GColorOxfordBlueARGB8);
///
enum GColorDukeBlue              = GColor8(GColorDukeBlueARGB8);
///
enum GColorBlue                  = GColor8(GColorBlueARGB8);
///
enum GColorDarkGreen             = GColor8(GColorDarkGreenARGB8);
///
enum GColorMidnightGreen         = GColor8(GColorMidnightGreenARGB8);
///
enum GColorCobaltBlue            = GColor8(GColorCobaltBlueARGB8);
///
enum GColorBlueMoon              = GColor8(GColorBlueMoonARGB8);
///
enum GColorIslamicGreen          = GColor8(GColorIslamicGreenARGB8);
///
enum GColorJaegerGreen           = GColor8(GColorJaegerGreenARGB8);
///
enum GColorTiffanyBlue           = GColor8(GColorTiffanyBlueARGB8);
///
enum GColorVividCerulean         = GColor8(GColorVividCeruleanARGB8);
///
enum GColorGreen                 = GColor8(GColorGreenARGB8);
///
enum GColorMalachite             = GColor8(GColorMalachiteARGB8);
///
enum GColorMediumSpringGreen     = GColor8(GColorMediumSpringGreenARGB8);
///
enum GColorCyan                  = GColor8(GColorCyanARGB8);
///
enum GColorBulgarianRose         = GColor8(GColorBulgarianRoseARGB8);
///
enum GColorImperialPurple        = GColor8(GColorImperialPurpleARGB8);
///
enum GColorIndigo                = GColor8(GColorIndigoARGB8);
///
enum GColorElectricUltramarine   = GColor8(GColorElectricUltramarineARGB8);
///
enum GColorArmyGreen             = GColor8(GColorArmyGreenARGB8);
///
enum GColorDarkGray              = GColor8(GColorDarkGrayARGB8);
///
enum GColorLiberty               = GColor8(GColorLibertyARGB8);
///
enum GColorVeryLightBlue         = GColor8(GColorVeryLightBlueARGB8);
///
enum GColorKellyGreen            = GColor8(GColorKellyGreenARGB8);
///
enum GColorMayGreen              = GColor8(GColorMayGreenARGB8);
///
enum GColorCadetBlue             = GColor8(GColorCadetBlueARGB8);
///
enum GColorPictonBlue            = GColor8(GColorPictonBlueARGB8);
///
enum GColorBrightGreen           = GColor8(GColorBrightGreenARGB8);
///
enum GColorScreaminGreen         = GColor8(GColorScreaminGreenARGB8);
///
enum GColorMediumAquamarine      = GColor8(GColorMediumAquamarineARGB8);
///
enum GColorElectricBlue          = GColor8(GColorElectricBlueARGB8);
///
enum GColorDarkCandyAppleRed     = GColor8(GColorDarkCandyAppleRedARGB8);
///
enum GColorJazzberryJam          = GColor8(GColorJazzberryJamARGB8);
///
enum GColorPurple                = GColor8(GColorPurpleARGB8);
///
enum GColorVividViolet           = GColor8(GColorVividVioletARGB8);
///
enum GColorWindsorTan            = GColor8(GColorWindsorTanARGB8);
///
enum GColorRoseVale              = GColor8(GColorRoseValeARGB8);
///
enum GColorPurpureus             = GColor8(GColorPurpureusARGB8);
///
enum GColorLavenderIndigo        = GColor8(GColorLavenderIndigoARGB8);
///
enum GColorLimerick              = GColor8(GColorLimerickARGB8);
///
enum GColorBrass                 = GColor8(GColorBrassARGB8);
///
enum GColorLightGray             = GColor8(GColorLightGrayARGB8);
///
enum GColorBabyBlueEyes          = GColor8(GColorBabyBlueEyesARGB8);
///
enum GColorSpringBud             = GColor8(GColorSpringBudARGB8);
///
enum GColorInchworm              = GColor8(GColorInchwormARGB8);
///
enum GColorMintGreen             = GColor8(GColorMintGreenARGB8);
///
enum GColorCeleste               = GColor8(GColorCelesteARGB8);
///
enum GColorRed                   = GColor8(GColorRedARGB8);
///
enum GColorFolly                 = GColor8(GColorFollyARGB8);
///
enum GColorFashionMagenta        = GColor8(GColorFashionMagentaARGB8);
///
enum GColorMagenta               = GColor8(GColorMagentaARGB8);
///
enum GColorOrange                = GColor8(GColorOrangeARGB8);
///
enum GColorSunsetOrange          = GColor8(GColorSunsetOrangeARGB8);
///
enum GColorBrilliantRose         = GColor8(GColorBrilliantRoseARGB8);
///
enum GColorShockingPink          = GColor8(GColorShockingPinkARGB8);
///
enum GColorChromeYellow          = GColor8(GColorChromeYellowARGB8);
///
enum GColorRajah                 = GColor8(GColorRajahARGB8);
///
enum GColorMelon                 = GColor8(GColorMelonARGB8);
///
enum GColorRichBrilliantLavender = GColor8(GColorRichBrilliantLavenderARGB8);
///
enum GColorYellow                = GColor8(GColorYellowARGB8);
///
enum GColorIcterine              = GColor8(GColorIcterineARGB8);
///
enum GColorPastelYellow          = GColor8(GColorPastelYellowARGB8);

///
enum GColor8Clear = GColor.init;
///
enum GColor8Black = GColor8(GColorBlackARGB8);
///
enum GColor8White = GColor8(GColorWhiteARGB8);

version(PEBBLE_APLITE) {
    ///
    alias GColor = GColorMonoCrome;

    ///
    alias GColorClear = GColorMonoChrome.clear;
    ///
    alias GColorBlack = GColorMonoChrome.black;
    ///
    alias GColorWhite = GColorMonoChrome.white;
} else {
    ///
    alias GColor = GColor8;

    ///
    alias GColorClear = GColor8Clear;
    ///
    alias GColorBlack = GColor8Black;
    ///
    alias GColorWhite = GColor8White;
}

/**
 * This function simply returns one of the two arguments given to it, depending
 * on the platform, for falling back from a more complex color
 * to a black and white color on watches with less colours.
 *
 * This is to replicate the effects of a macro defined in the official Pebble
 * SDK headers.
 *
 * Because this function simply returns one of its arguments, a good D
 * compiler should able to inline this function and reduce it to just one
 * of the arguments itself with no runtime cost.
 */
auto COLOR_FALLBACK(GColor8 color, GColorMonoChrome bw) {
    version(PEBBLE_APLITE) {
        return bw;
    } else {
        return color;
    }
}
