/**
 * Pebble launch data and functions.
 */
module pebble.launch;

import pebble.versions;

@nogc:
nothrow:

/**
 * AppLaunchReason is used to inform the application about how it was launched
 *
 * Note: New launch reasons may be added in the future.
 * As a best practice, it is recommended to only handle the cases that
 * the app needs to know about, rather than trying to handle all
 * possible launch reasons.
 */
enum AppLaunchReason {
    /// App launched by the system
    system = 0,
    /// App launched by user selection in launcher menu.
    user = 1,
    /// App launched by mobile or companion app.
    phone = 2,
    /// App launched by wakeup event.
    wakeup = 3,
    /// App launched by worker calling worker_launch_app().
    worker = 4,
    /// App launched by user using quick launch.
    quickLaunch = 5,
    /// App launched by user opening it from a pin.
    timelineAction = 6
}

///
alias APP_LAUNCH_SYSTEM = AppLaunchReason.system;
///
alias APP_LAUNCH_USER = AppLaunchReason.user;
///
alias APP_LAUNCH_PHONE = AppLaunchReason.phone;
///
alias APP_LAUNCH_WAKEUP = AppLaunchReason.wakeup;
///
alias APP_LAUNCH_WORKER = AppLaunchReason.worker;
///
alias APP_LAUNCH_QUICK_LAUNCH = AppLaunchReason.quickLaunch;
///
alias APP_LAUNCH_TIMELINE_ACTION = AppLaunchReason.timelineAction;

/**
 * Provides the method used to launch the current application.
 *
 * Returns: The method or reason the current application was launched.
 */
extern(C) AppLaunchReason launch_reason();

/**
 * Get the argument passed to the app when it was launched.
 *
 * Note: Currently the only way to pass arguments to apps is by using an
 * openWatchApp action on a pin.
 *
 * Returns: The argument passed to the app, or 0 if the app wasn't launched
 *     from a Launch App action.
 */
version(PEBBLE_BASALT)
extern(C) uint launch_get_args();

// TODO: Define launch_get_args for aplite too?

