/**
 * This module types and functions for getting watch information.
 */
module pebble.watchinfo;

@nogc:
nothrow:

enum WatchInfoModel {
    /// Unknown model
    unknown = 0,
    /// Original Pebble
    original = 1,
    /// Pebble Steel
    steel = 2,
    /// Pebble Time
    time = 3
}

///
alias WATCH_INFO_MODEL_UNKNOWN = WatchInfoModel.unknown;
///
alias WATCH_INFO_MODEL_PEBBLE_ORIGINAL = WatchInfoModel.original;
///
alias WATCH_INFO_MODEL_PEBBLE_STEEL = WatchInfoModel.steel;
///
alias WATCH_INFO_MODEL_PEBBLE_TIME = WatchInfoModel.time;

/// The different watch colors.
enum WatchInfoColor {
    /// Unknown color
    unknown = 0,
    /// Black
    black = 1,
    /// White
    white = 2,
    /// Red
    red = 3,
    /// Orange
    orange = 4,
    /// Grey
    grey = 5,
    /// Stainless Steel
    stainless_steel = 6,
    /// Matte Black
    matte_black = 7,
    /// Blue
    blue = 8,
    /// Green
    green = 9,
    /// Pink
    pink = 10,
    /// White
    time_white = 11,
    /// Black
    time_black = 12,
    /// Red
    time_red = 13
}

///
alias WATCH_INFO_COLOR_UNKNOWN = WatchInfoColor.unknown;
///
alias WATCH_INFO_COLOR_BLACK = WatchInfoColor.black;
///
alias WATCH_INFO_COLOR_WHITE = WatchInfoColor.white;
///
alias WATCH_INFO_COLOR_RED = WatchInfoColor.red;
///
alias WATCH_INFO_COLOR_ORANGE = WatchInfoColor.orange;
///
alias WATCH_INFO_COLOR_GREY = WatchInfoColor.grey;
///
alias WATCH_INFO_COLOR_STAINLESS_STEEL = WatchInfoColor.stainless_steel;
///
alias WATCH_INFO_COLOR_MATTE_BLACK = WatchInfoColor.matte_black;
///
alias WATCH_INFO_COLOR_BLUE = WatchInfoColor.blue;
///
alias WATCH_INFO_COLOR_GREEN = WatchInfoColor.green;
///
alias WATCH_INFO_COLOR_PINK = WatchInfoColor.pink;
///
alias WATCH_INFO_COLOR_TIME_WHITE = WatchInfoColor.time_white;
///
alias WATCH_INFO_COLOR_TIME_BLACK = WatchInfoColor.time_black;
///
alias WATCH_INFO_COLOR_TIME_RED = WatchInfoColor.time_red;

/**
 * Data structure containing the version of the firmware running on the watch.
 *
 * The version of the firmware has the form X.[X.[X]].
 * If a version number is not present it will be 0.
 *
 * For example: the version numbers of 2.4.1 are 2, 4, and 1.
 * The version numbers of 2.4 are 2, 4, and 0.
 */
extern(C) struct WatchInfoVersion {
  /// Major version number
  ubyte major;
  /// Minor version number
  ubyte minor;
  /// Patch version number
  ubyte patch;
}

/**
 * Provides the model of the watch.
 * Returns: A WatchInfoModel representing the model of the watch.
 */
extern(C) WatchInfoModel watch_info_get_model();

/**
 * Provides the version of the firmware running on the watch.
 *
 * Returns: A WatchInfoVersion representing the version of the firmware running on the watch.
 */
extern(C) WatchInfoVersion watch_info_get_firmware_version();

/**
 * Provides the color of the watch.
 *
 * Returns: A WatchInfoColor representing the color of the watch.
 */
extern(C) WatchInfoColor watch_info_get_color();

