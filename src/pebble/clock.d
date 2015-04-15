/**
 * Clock control for the Pebble.
 */
module pebble.clock;

public import core.stdc.time;

import pebble.versions;

@nogc:
nothrow:

// basalt redefines C standard library time functions to support a GMT offset
// and a timezone in the time structures.
version(PEBBLE_BASALT) {
    ///
    enum TZ_LEN = 6;

    // The type for the time, with a timezone.
    struct tm {
      /// Seconds. [0-60] (1 leap second)
      int tm_sec;
      /// Minutes. [0-59]
      int tm_min;
      /// Hours.  [0-23]
      int tm_hour;
      // Day. [1-31]
      int tm_mday = 1;
      /// Month. [0-11]
      int tm_mon;
      /// Years since 1900
      int tm_year;
      /// Day of week. [0-6]
      int tm_wday;
      /// Days in year.[0-365]
      int tm_yday;
      /// DST. [-1/0/1]
      int tm_isdst;
      /// Seconds east of UTC.
      int tm_gmtoff;
      /// Timezone abbreviation.
      char* tm_zone;
    };

    /**
     * convert the time value pointed at by clock to a struct tm which
     * contains the time adjusted for the local timezone
     *
     * Params:
     * timep = A pointer to an object of type time_t that contains a time value.
     *
     * Returns: A pointer to a struct tm containing the broken out time value
     * adjusted for the local timezone.
     */
    extern(C) tm* localtime(const(time_t)* timep);

    /**
     * convert the time value pointed at by clock to a struct tm which contains
     * the time expressed in Coordinated Universal Time (UTC).
     *
     * Params:
     * timep = A pointer to an object of type time_t that contains a time value.
     *
     * Returns: A pointer to a struct tm containing Coordinated Universal Time.
     *     (UTC)
     */
    extern(C) tm* gmtime(const(time_t)* timep);

    /**
     * Convert the broken-down time structure to a timestamp expressed in
     * Coordinated Universal Time (UTC).
     *
     * Params:
     * tb = A pointer to an object of type tm that contains broken-down time.
     *
     * Returns: The number of seconds since epoch, January 1st 1970.
     */
    extern(C) time_t mktime(tm* tb);

    /**
     * Obtain the number of seconds since epoch.
     *
     * Note that the epoch is adjusted for Timezones and Daylight Savings.
     *
     * Params:
     * tloc = Optionally points to an address of a time_t variable to store the
     *     time in.
     *
     * If you only want to use the return value, you may pass null into tloc
     * instead.
     *
     * Returns: The number of seconds since epoch, January 1st 1970.
     */
    extern(C) time_t time(time_t* tloc);
}


/**
 * Obtain the number of seconds and milliseconds part since the epoch.
 *
 * This is a non-standard C function provided for convenience.
 *
 * Params:
 * tloc = Optionally points to an address of a time_t variable to store the
 *     time in. You may pass null into tloc if you don't need a time_t
 *     variable to be set with the seconds since the epoch
 *
 * Params:
 * out_ms = Optionally points to an address of a uint16_t variable to store
 *     the number of milliseconds since the last second in. If you only want
 *     to use the return value, you may pass null into out_ms instead.
 *
 * Returns: The number of milliseconds since the last second.
 */
extern(C) ushort time_ms(time_t* tloc, ushort* out_ms);

/**
 * Get the ISO locale name for the language currently set on the watch.
 *
 * Note: It is possible for the locale to change while your app is running.
 * And thus, two calls to i18n_get_system_locale may return different values.
 *
 * Returns: A string containing the ISO locale name (e.g. "fr", "en_US", ...)
 */
extern(C) const(char)* i18n_get_system_locale();

/// Weekday values
enum WeekDay {
    /// Today
    today = 0,
    /// Sunday
    sunday = 1,
    /// Monday
    monday = 2,
    /// Tuesday
    tuesday = 3,
    /// Wednesday
    wednesday = 4,
    /// Thursday
    thursday = 5,
    /// Friday
    friday = 6,
    /// Saturday
    saturday = 7
}

///
alias TODAY = WeekDay.today;
///
alias SUNDAY = WeekDay.sunday;
///
alias MONDAY = WeekDay.monday;
///
alias TUESDAY = WeekDay.tuesday;
///
alias WEDNESDAY = WeekDay.wednesday;
///
alias THURSDAY = WeekDay.thursday;
///
alias FRIDAY = WeekDay.friday;
///
alias SATURDAY = WeekDay.saturday;

/**
 * Copies a time string into the buffer, formatted according to the user's
 * time display preferences (such as 12h/24h time).
 *
 * Example results: "7:30" or "15:00".
 * Note: AM/PM are also outputted with the time if the user's preference is
 * 12h time.
 *
 * Params:
 * buffer = A pointer to the buffer to copy the time string into
 * size = The maximum size of buffer
 */
extern(C) void clock_copy_time_string(char* buffer, ubyte size);

/**
 * Gets the user's 12/24h clock style preference.
 *
 * Returns: true if the user prefers 24h-style time display or false
 * if the user prefers 12h-style time display.
 */
extern(C) bool clock_is_24h_style();

/**
 * Converts a (day, hour, minute) specification to a UTC timestamp
 * occurring in the future
 *
 * Always returns a timestamp for the next occurring instance,
 *
 * example: specifying TODAY@14:30 when it is 14:40 will return a timestamp for 7 days from
 * now at 14:30
 *
 * Note: This function does not support Daylight Saving Time (DST) changes,
 * events scheduled during a DST change will be off by an hour.
 *
 * Params:
 * day = Day of week including support for specifying TODAY.
 * hour = hour specified in 24-hour format [0-23]
 * minute = minute [0-59]
 */
extern(C) time_t clock_to_timestamp(WeekDay day, int hour, int minute);

/**
 * Checks if timezone is currently set, otherwise gmtime == localtime.
 *
 * Returns: true if timezone has been set, false otherwise.
 */
extern(C) bool clock_is_timezone_set();

/// Undocumented...
version(PEBBLE_BASALT)
extern(C) void clock_get_timezone(char *buf);

/**
 * Time unit flags that can be used to create a bitmask for use in
 * tick_timer_service_subscribe().This will also be passed to \ref TickHandler.
 */
enum TimeUnits {
    /// Flag to represent the "seconds" time unit.
    second = 1,
    /// Flag to represent the "minutes" time unit.
    minute = 2,
    /// Flag to represent the "hours" time unit.
    hour = 4,
    /// Flag to represent the "days" time unit.
    day = 8,
    /// Flag to represent the "months" time unit.
    month = 16,
    /// Flag to represent the "years" time unit.
    year = 32
}

///
alias SECOND_UNIT = TimeUnits.second;
///
alias MINUTE_UNIT = TimeUnits.minute;
///
alias HOUR_UNIT = TimeUnits.hour;
///
alias DAY_UNIT = TimeUnits.day;
///
alias MONTH_UNIT = TimeUnits.month;
///
alias YEAR_UNIT = TimeUnits.year;

/**
 * Callback type for tick timer events
 *
 * Params:
 * tick_time = the time at which the tick event was triggered
 * units_changed = which unit change triggered this tick event
 */
alias extern(C) void function (tm* tick_time, TimeUnits units_changed) TickHandler;

/**
 * Subscribe to the tick timer event service. Once subscribed, the
 * handler gets called on every requested unit change.
 *
 * Calling this function multiple times will override the units and
 * handler (i.e., only the last tick_units and handler passed will be used).
 *
 * Params:
 * tick_units = A bitmask of all the units that have changed
 * handler = The callback to be executed on tick events
 */
extern(C) void tick_timer_service_subscribe
(TimeUnits tick_units, TickHandler handler);

/**
 * Unsubscribe from the tick timer event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void tick_timer_service_unsubscribe();

/// The identifier for a wakeup event.
alias int WakeupId;

/**
 * The type of function which can be called when a wakeup event occurs.
 *
 * Params:
 * wakeup_id = The id of the wakeup event that occurred.
 * cookie = The scheduled cookie provided to wakeup_schedule.
 */
alias extern(C) void function(WakeupId wakeup_id, int cookie) WakeupHandler;

/**
 * Registers a WakeupHandler to be called when wakeup events occur.
 *
 * Params:
 * handler = The callback that gets called when the wakeup event occurs.
 */
extern(C) void wakeup_service_subscribe(WakeupHandler handler);

/**
 * Registers a wakeup event that triggers a callback at the specified time.
 *
 * Applications may only schedule up to 8 wakeup events.
 * Wakeup events are given a 1 minute duration window,
 * in that no application may schedule a wakeup event with 1 minute of a
 * currently scheduled wakeup event.
 *
 * Params:
 * timestamp = The requested time (UTC) for the wakeup event to occur
 * cookie = The application specific reason for the wakeup event.
 * notify_if_missed = On powering on Pebble, will alert user when
 *     notifications were missed due to Pebble being off.
 *
 * Returns: negative values indicate errors (StatusCode).
 *     E_RANGE if the event cannot be scheduled due to another event in
 *     that period.
 *     E_INVALID_ARGUMENT if the time requested is in the past.
 *     E_OUT_OF_RESOURCES if the application has already scheduled all
 *     8 wakeup events.
 *     E_INTERNAL if a system error occurred during scheduling.
 */
extern(C) WakeupId wakeup_schedule
(time_t timestamp, int cookie, bool notify_if_missed);

/**
 * Cancels a wakeup event.
 *
 * Params:
 * wakeup_id = Wakeup event to cancel
 */
extern(C) void wakeup_cancel(WakeupId wakeup_id);

/// Cancels all wakeup events for the app.
extern(C) void wakeup_cancel_all();

/**
 * Retrieves the wakeup event info for an app that was launched
 * by a wakeup_event (ie. launch_reason() === APP_LAUNCH_WAKEUP)
 * so that an app may display information regarding the wakeup event
 *
 * Params:
 * wakeup_id = WakeupId for the wakeup event that caused the app to wakeup.
 * cookie = App provided reason for the wakeup event.
 *
 * Returns: true if app was launched due to a wakeup event, false otherwise.
 */
extern(C) bool wakeup_get_launch_event(WakeupId* wakeup_id, int* cookie);

/**
 * Checks if the current WakeupId is still scheduled and therefore valid.
 *
 * Params:
 * wakeup_id = Wakeup event to query for validity and scheduled time.
 * timestamp = Optionally points to an address of a time_t variable to
 *     store the time that the wakeup event is scheduled to occur.
 *     (The time is in UTC, but local time when clock_is_timezone_set
 *     returns false).
 *     You may pass NULL instead if you do not need it.
 *
 * Returns: true if WakeupId is still scheduled, false if it doesn't exist or
 *     has already occurred
 */
extern(C) bool wakeup_query(WakeupId wakeup_id, time_t* timestamp);
