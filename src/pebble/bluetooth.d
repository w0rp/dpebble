/**
 * This module defines control over Bluetooth on Pebble watches.
 */
module pebble.bluetooth;

@nogc:
nothrow:

/**
 * Callback type for bluetooth connection events
 *
 * Params:
 * connected = true on bluetooth connection, false on disconnection.
 */
alias extern(C) void function(bool connected) BluetoothConnectionHandler;

/**
 * Query the bluetooth connection service for the current connection status.
 *
 * Returns: true if connected, false otherwise.
 */
extern(C) bool bluetooth_connection_service_peek();

/**
 * Subscribe to the bluetooth event service. Once subscribed,
 * the handler gets called on every bluetooth connection event.
 *
 * Params:
 * handler = A callback to be executed on connection event.
 */
extern(C) void bluetooth_connection_service_subscribe
(BluetoothConnectionHandler handler);

/**
 * Unsubscribe from the bluetooth event service
 * Once unsubscribed, the previously registered
 * handler will no longer be called.
 */
extern(C) void bluetooth_connection_service_unsubscribe();

/**
 * Intervals during which the Bluetooth module may enter a low power mode.
 * The sniff interval defines the period during which the Bluetooth module may
 * not exchange (ACL) packets. The longer the sniff interval, the more time the
 * Bluetooth module may spend in a low power mode.
 *
 * It may be necessary to reduce the sniff interval if an app requires reduced
 * latency when sending messages.
 *
 * Note: These settings have a dramatic effect on the Pebble's energy
 * consumption. Use the normal sniff interval whenever possible.
 * Note, however, that switching between modes increases power consumption
 * during the process. Frequent switching between modes is thus
 * discouraged. Ensure you do not drop to normal frequently.
 * The Bluetooth module is a major consumer of the Pebble's energy.
 */
enum SniffInterval {
    ///
    normal = 0,
    ///
    reduced = 1
}

///
alias SNIFF_INTERVAL_NORMAL = SniffInterval.normal;
///
alias SNIFF_INTERVAL_REDUCED = SniffInterval.reduced;

/**
 * Set the Bluetooth module's sniff interval.
 *
 * The sniff interval will be restored to normal by the OS after the app's
 * de-init handler is called. Set the sniff interval to normal whenever
 * possible.
 */
extern(C) void app_comm_set_sniff_interval(const SniffInterval interval);

/**
 * Get the Bluetooth module's sniff interval.
 *
 * Returns: The SniffInterval value corresponding to the current interval.
 */
extern(C) SniffInterval app_comm_get_sniff_interval();

