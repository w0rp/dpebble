/**
 * This module defines battery information functions.
 */
module pebble.battery;

@nogc:
nothrow:

/// Structure for retrieval of the battery charge state.
extern(C) struct BatteryChargeState {
    /// A percentage (0-100) of how full the battery is.
    ubyte charge_percent;
    /// true if the battery is currently being charged. false if not.
    bool is_charging;
    /// true if the charger cable is connected. false if not.
    bool is_plugged;
}

/**
 * Callback type for battery state change events
 *
 * Params:
 * charge = The state of the battery.
 */
alias extern(C) void function(BatteryChargeState charge) BatteryStateHandler;

/**
 * Subscribe to the battery state event service. Once subscribed,
 * the handler gets called on every battery state change.
 *
 * Params:
 * handler = A callback to be executed on battery state change event
 */
extern(C) void battery_state_service_subscribe(BatteryStateHandler handler);

/**
 * Unsubscribe from the battery state event service. Once unsubscribed,
 * the previously registered handler will no longer be called.
 */
extern(C) void battery_state_service_unsubscribe();

/**
 * Peek at the last known battery state.
 *
 * Returns: A BatteryChargeState containing the last known data.
 */
extern(C) BatteryChargeState battery_state_service_peek();

