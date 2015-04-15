/**
 * Data structures for animations and operations for animations on Pebble
 * watches.
 *
 * Animations are only available on basalt watches.
 */
module pebble.animations;

import pebble.versions;

import pebble.gpoint;
import pebble.grect;
import pebble.gsize;
import pebble.gcolor;
import pebble.layer;

@nogc:
nothrow:

struct Animation {}

/// Values that are used to indicate the different animation curves,
/// which determine the speed at which the animated value(s) change(s).
enum AnimationCurve {
    /// Linear curve: the velocity is constant.
    linear = 0,
    /// Bicubic ease-in: accelerate from zero velocity.
    easeIn = 1,
    /// Bicubic ease-in: decelerate to zero velocity.
    easeOut = 2,
    /// Bicubic ease-in-out: accelerate from zero velocity,
    /// decelerate to zero velocity
    easeInOut = 3,
    /// The default animation. (easeInOut)
    _default = easeInOut,
    /// Custom (user-provided) animation curve
    custom = 4,
    reserved1 = 5,
    reserved2 = 6,
    reserved3 = 7
}

///
alias AnimationCurveLinear = AnimationCurve.linear;
///
alias AnimationCurveEaseIn = AnimationCurve.easeIn;
///
alias AnimationCurveEaseOut = AnimationCurve.easeOut;
///
alias AnimationCurveEaseInOut = AnimationCurve.easeInOut;
///
alias AnimationCurveDefault = AnimationCurve._default;
///
alias AnimationCurveCustomFunction = AnimationCurve.custom;

/**
 * Creates a new Animation on the heap and initalizes it with the default
 * values.
 *
 * * Duration: 250ms,
 * * Curve: \ref AnimationCurveEaseInOut (ease-in-out),
 * * Delay: 0ms,
 * * Handlers: `{NULL, NULL}` (none),
 * * Context: `NULL` (none),
 * * Implementation: `NULL` (no implementation),
 * * Scheduled: no
 *
 * Returns: A pointer to the animation. `NULL` if the animation could not
 *     be created.
 */
extern(C) Animation* animation_create();

/**
 * Destroys an Animation previously created by animation_create.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_destroy(Animation* animation);

/**
 * Constant to indicate "infinite" duration.
 *
 * This can be used with \ref animation_set_duration() to indicate that the
 * animation should run indefinitely. This is useful when implementing for
 * example a frame-by-frame simulation that does not have a clear ending
 * (e.g. a game).
 *
 * Note: Note that `distance_normalized` parameter that is passed
 * into the `.update` implementation is meaningless in when an infinite
 * duration is used.
 *
 * Note: This can be returned by animation_get_duration (if the play count is
 * infinite)
 */
enum uint ANIMATION_DURATION_INFINITE = uint.max;

/// The normalized distance at the start of the animation.
enum uint ANIMATION_NORMALIZED_MIN = 0;

/// The normalized distance at the end of the animation.
enum uint ANIMATION_NORMALIZED_MAX = 65535;

/**
 * Copy an animation.
 *
 * Params:
 * from = The animation to copy.
 *
 * Returns: New animation.
 */
version(PEBBLE_BASALT)
extern(C) Animation* animation_clone(Animation* from);

/**
 * Create a new sequence animation from a list of 2 or more other animations.
 * The returned animation owns the animations that were provided as arguments
 * and no further write operations on those handles are allowed. The variable
 * length argument list must be terminated with a null pointer.
 *
 * Note: The maximum number of animations that can be supplied to this method
 * is 20.
 *
 * Params:
 * animation_a = The first required component animation.
 * animation_b = The second required component animation.
 * animation_c = Either the third component, or null if only adding 2
 *     components.
 *
 * Returns: The newly created sequence animation.
 */
version(PEBBLE_BASALT)
extern(C) Animation* animation_sequence_create
(Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);

/**
 * An alternate form of animation_sequence_create() that accepts an array of
 * other animations.
 *
 * Note: The maximum number of elements allowed in animation_array is 256.
 *
 * Params:
 * animation_array = An array of component animations to include.
 * array_len = The number of elements in the animation_array.
 *
 * Returns: The newly created sequence animation.
 */
version(PEBBLE_BASALT)
extern(C) Animation* animation_sequence_create_from_array
(Animation** animation_array, uint array_len);

/**
 * Create a new spawn animation from a list of 2 or more other animations.
 * The returned animation owns the animations that were provided as arguments
 * and no further write operations on those handles are allowed. The variable
 * length argument list must be terminated with a null pointer.
 *
 * Note: The maximum number of animations that can be supplied to this method
 * is 20.
 *
 * Params:
 * animation_a = The first required component animation.
 * animation_b = The second required component animation.
 * animation_c = Either the third component, or null if only adding 2
 *     components.
 *
 * Returns: The newly created spawn animation or NULL on failure.
 */
version(PEBBLE_BASALT)
extern(C) Animation* animation_spawn_create
(Animation* animation_a, Animation* animation_b, Animation* animation_c, ...);

/**
 * An alternate form of animation_spawn_create() that accepts an array of other
 * animations.
 *
 * Note: The maximum number of elements allowed in animation_array is 256
 *
 * Params:
 * animation_array = An array of component animations to include.
 * array_len = The number of elements in the animation_array.
 *
 * Returns: The newly created spawn animation or NULL on failure.
 */
version(PEBBLE_BASALT)
extern(C) Animation* animation_spawn_create_from_array
(Animation** animation_array, uint array_len);

/**
 * Seek to a specific location in the animation. Only forward seeking is
 * allowed. Returns true if successful, false if the passed in seek location
 * is invalid.
 *
 * Params:
 * animation = The animation for which to set the position.
 * milliseconds = The new location.
 *
 * Returns: true if successful, false if the requested position is invalid.
 */
version(PEBBLE_BASALT)
extern(C) bool animation_set_position(Animation* animation, uint milliseconds);

/**
 * Get the current location in the animation.
 *
 * Note: The animation must be scheduled to get the position. If it is not
 * schedule, this method will return false.
 *
 * Params:
 * animation = The animation for which to fetch the position.
 * position = Pointer to variable that will contain the position.
 *
 * Returns: true if successful, false on failure.
 */
version(PEBBLE_BASALT)
extern(C) bool animation_get_position(Animation* animation, int* position);

/**
 * Set an animation to run in reverse (or forward).
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation to operate on.
 * reverse = Set to true to run in reverse, false to run forward.
 *
 * Returns: true if successful, false on failure.
 */
version(PEBBLE_BASALT)
extern(C) bool animation_set_reverse(Animation* animation, bool reverse);

/**
 * Get the reverse setting of an animation.
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: the reverse setting.
 */
version(PEBBLE_BASALT)
extern(C) bool animation_get_reverse(Animation* animation);

/**
 * Set an animation to play N times. The default is 1.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation to set the play count of.
 * play_count = Number of times to play this animation.
 *     Set to ANIMATION_PLAY_COUNT_INFINITE to make an animation repeat
 *     indefinitely.
 *
 * Returns: true if successful, false on failure.
 */
version(PEBBLE_BASALT)
extern(C) bool animation_set_play_count(Animation* animation, uint play_count);

/**
 * Get the play count of an animation
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: The play count.
 */
version(PEBBLE_BASALT)
extern(C) uint animation_get_play_count (Animation* animation);

/**
 * Sets the time in milliseconds that an animation takes from start to finish.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the duration.
 * duration_ms = The duration in milliseconds of the animation. This excludes
 *     any optional delay as set using animation_set_delay().
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_duration
(Animation* animation, uint duration_ms);

/**
 * Get the static duration of an animation from start to end (ignoring how
 * much has already played, if any).
 *
 * animation = The animation for which to get the duration.
 * include_delay = If true, include the delay time.
 * include_play_count = If true, incorporate the play_count.
 *
 * Returns: The duration, in milliseconds. This includes any optional delay a
 * set using animation_set_delay.
 */
version(PEBBLE_BASALT)
extern(C) uint animation_get_duration
(Animation* animation, bool include_delay, bool include_play_count);

/**
 * Sets an optional delay for the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the delay.
 * delay_ms = The delay in milliseconds that the animation system should
 *     wait from the moment the animation is scheduled to starting the
 *     animation.
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_set_delay(Animation* animation, uint delay_ms);

/**
 * Get the delay of an animation in milliseconds.
 *
 * Params:
 * animation = The animation for which to get the setting.
 *
 * Returns: The delay in milliseconds.
 */
version(PEBBLE_BASALT)
extern(C) uint animation_get_delay (Animation* animation);

/**
 * Sets the animation curve for the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the curve.
 * curve = The type of curve.
 *
 * Returns: true if successful, false on failure.
 * See_Also: AnimationCurve
 */
extern(C) bool animation_set_curve(Animation* animation, AnimationCurve curve);

/**
 * Gets the animation curve for the animation.
 *
 * Params:
 * animation = The animation for which to get the curve.
 *
 * Returns: The type of curve.
 */
version(PEBBLE_BASALT)
extern(C) AnimationCurve animation_get_curve(Animation* animation);

/**
 * The function pointer type of a custom animation curve.
 *
 * Params:
 * linear_distance = The linear normalized animation distance to be curved.
 *
 * See_Also: animation_set_custom_curve
 */
alias extern(C) uint function(uint linear_distance) AnimationCurveFunction;

/**
 * Sets a custom animation curve function.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the curve.
 * curve_function = The custom animation curve function.
 *
 * Returns: true if successful, false on failure.
 * See_Also: AnimationCurveFunction
 */
extern(C) bool animation_set_custom_curve
(Animation* animation, AnimationCurveFunction curve_function);

/**
 * Gets the custom animation curve function for the animation.
 *
 * Params:
 * animation = The animation for which to get the curve.
 *
 * Returns: The custom animation curve function for the given animation.
 *     null if not set.
 */
version(PEBBLE_BASALT)
extern(C) AnimationCurveFunction animation_get_custom_curve
(Animation* animation);

/**
 * The function pointer type of the handler that will be called when an
 * animation is started, just before updating the first frame of the animation.
 *
 * Note: This is called after any optional delay as set by
 *     animation_set_delay() has expired.
 *
 * Params:
 * animation = The animation that was started.
 * context = The pointer to custom, application specific data, as set using
 *     animation_set_handlers()
 *
 * See_Also: animation_set_handlers
 */
alias extern(C) void function
(Animation* animation, void* context)
AnimationStartedHandler;

/**
 * The function pointer type of the handler that will be called when the
 * animation is stopped.
 *
 * Params:
 * animation = The animation that was stopped.
 * finished = true if the animation was stopped because it was finished
 *     normally, or false if the animation was stopped prematurely, because it
 *     was unscheduled before finishing.
 * context = The pointer to custom, application specific data, as set using
 *     animation_set_handlers()
 *
 * See_Also: animation_set_handlers
 */
alias extern(C) void function
(Animation* animation, bool finished, void* context)
AnimationStoppedHandler;

/**
 * The handlers that will get called when an animation starts and stops.
 * See documentation with the function pointer types for more information.
 *
 * See_Also: animation_set_handlers
 */
struct AnimationHandlers {
    /// The handler that will be called when an animation is started.
    AnimationStartedHandler started;
    /// The handler that will be called when an animation is stopped.
    AnimationStoppedHandler stopped;
}

/**
 * Sets the callbacks for the animation.
 *
 * Often an application needs to run code at the start or at the end of an
 * animation. Using this function is possible to register callback functions
 * with an animation, that will get called at the start and end of the
 * animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will
 * return false (failure). An animation is immutable once it has been added to
 * a sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set up the callbacks.
 * callbacks = The callbacks.
 * context = A pointer to application specific data, that will be passed as an
 *     argument by the animation subsystem when a callback is called.
 *
 * Returns: true if successful, false on failure
 */
extern(C) bool animation_set_handlers
(Animation* animation, AnimationHandlers callbacks, void* context);

/**
 * Gets the application-specific callback context of the animation.
 *
 * This `void` pointer is passed as an argument when the animation system
 * calls AnimationHandlers callbacks. The context pointer can be set to point
 * to any application specific data using animation_set_handlers().
 *
 * Params: animation The animation.
 *
 * See_Also: animation_set_handlers
 */
extern(C) void* animation_get_context(Animation* animation);

/**
 * Schedules the animation. Call this once after configuring an animation to
 * get it to start running.
 *
 *
 * If the animation's implementation has a `.setup` callback it will get
 * called before this function returns.
 *
 * Note: If the animation was already scheduled, it will first unschedule it
 * and then re-schedule it again.
 *
 * Note that in that case, the animation's `.stopped` handler, the
 * implementation's `.teardown` and `.setup` will get called, due to the
 * unscheduling and scheduling.
 *
 * Params:
 * animation = The animation to schedule.
 *
 * Returns: true if successful, false on failure
 *
 * See_Also: animation_unschedule()
 */
extern(C) bool animation_schedule(Animation* animation);

/**
 * Unschedules the animation, which in effect stops the animation.
 *
 * Note: If the animation was not yet finished, unscheduling it will
 * cause its `.stopped` handler to get called, with the "finished" argument
 * set to false.
 *
 * Note: If the animation is not scheduled or null, calling this routine is
 * effectively a no-op.
 *
 * Params:
 * animation = The animation to unschedule.
 *
 * See_Also: animation_schedule()
 *
 * Returns: true if successful, false on failure.
 */
extern(C) bool animation_unschedule(Animation* animation);

/**
 * Unschedules all animations of the application.
 *
 * See_Also: animation_unschedule
 */
extern(C) void animation_unschedule_all();

/**
 * Note: An animation will be scheduled when it is running and not finished
 * yet. An animation that has finished is automatically unscheduled.
 * For convenience, passing in a NULL animation argument will simply return
 * false.
 *
 * Params:
 * animation = The animation for which to get its scheduled state.
 *
 * Returns: true if the animation was scheduled, or false if it was not.
 *
 * See_Also: animation_schedule
 * See_Also: animation_unschedule
 */
extern(C) bool animation_is_scheduled(Animation* animation);

/**
 * Pointer to function that (optionally) prepares the animation for running.
 * This callback is called when the animation is added to the scheduler.
 *
 * Params:
 * animation = The animation that needs to be set up.
 *
 * See_Also: animation_schedule
 * See_Also: AnimationTeardownImplementation
 */
alias extern(C) void function
(Animation* animation)
AnimationSetupImplementation;

/**
 * Pointer to function that updates the animation according to the given
 * normalized distance.
 *
 * This callback will be called repeatedly by the animation scheduler
 * whenever the animation needs to be updated.
 *
 * This is a value between ANIMATION_NORMALIZED_MIN and
 * ANIMATION_NORMALIZED_MAX.
 *
 * At the start of the animation, the value will be ANIMATION_NORMALIZED_MIN.
 * At the end of the animation, the value will be ANIMATION_NORMALIZED_MAX.
 *
 * For each frame during the animation, the value will be the distance along
 * the animation path, mapped between ANIMATION_NORMALIZED_MIN and
 * ANIMATION_NORMALIZED_MAX based on the animation duration and the
 * AnimationCurve set.
 *
 * For example, say an animation was scheduled at t = 1.0s, has a delay of
 * 1.0s, a duration of 2.0s and a curve of AnimationCurveLinear.
 *
 * Then the .update callback will get called on t = 2.0s with
 * distance_normalized = ANIMATION_NORMALIZED_MIN. For each frame
 * thereafter until t = 4.0s, the update callback will get called where
 * distance_normalized is
 * (ANIMATION_NORMALIZED_MIN +
 * (((ANIMATION_NORMALIZED_MAX - ANIMATION_NORMALIZED_MIN) * t) / duration)).
 *
 * Other animation curves will result in a non-linear relation between
 * distance_normalized and time.
 *
 * Params:
 * animation = The animation that needs to update; gets passed in by the
 *     animation framework.
 * distance_normalized = The current normalized distance; gets passed in
 *     by the animation framework for each animation frame.
 */
alias extern(C) void function
(Animation* animation, uint distance_normalized)
AnimationUpdateImplementation;

/**
 * Pointer to function that (optionally) cleans up the animation.
 * This callback is called when the animation is removed from the scheduler.
 * In case the `.setup` implementation allocated any memory, this is a good
 * place to release that memory again.
 *
 * Params:
 * animation = The animation that needs to be teared down.
 *
 * See_Also: animation_unschedule
 * See_Also: AnimationSetupImplementation
 */
alias extern(C) void function(Animation*) AnimationTeardownImplementation;


/**
 * The 3 callbacks that implement a custom animation.
 *
 * Only the `.update` callback is mandatory, `.setup` and `.teardown` are
 * optional. See the documentation with the function pointer typedefs for more
 * information.
 *
 * Note: The `.setup` callback is called immediately after scheduling the
 * animation, regardless if there is a delay set for that animation using
 * animation_set_delay().
 *
 * The diagram below illustrates the order in which callbacks can be expected
 * to get called over the life cycle of an animation. It also illustrates where
 * the implementation of different animation callbacks are intended to be
 * “living”.  ![](animations.png)
 *
 * See_Also: AnimationSetupImplementation
 * See_Also: AnimationUpdateImplementation
 * See_Also: AnimationTeardownImplementation
 */
struct AnimationImplementation {
    /**
     * Called by the animation system when an animation is scheduled, to
     * prepare it for running. This callback is optional and can be left
     * null when not needed.
     */
    AnimationSetupImplementation setup;
    /**
     * Called by the animation system when the animation needs to calculate
     * the next animation frame. This callback is mandatory and should not be
     * left null.
     */
    AnimationUpdateImplementation update;
    /**
     * Called by the animation system when an animation is unscheduled, to
     * clean up after it has run. This callback is optional and can be left
     * null when not needed.
     */
    AnimationTeardownImplementation teardown;
}

/**
 * Sets the implementation of the custom animation.
 *
 * When implementing custom animations, use this function to specify what
 * functions need to be called to for the setup, frame update and teardown of
 * the animation.
 *
 * Note: Trying to set an attribute when an animation is immutable will return
 * false (failure). An animation is immutable once it has been added to a
 * sequence or spawn animation or has been scheduled.
 *
 * Params:
 * animation = The animation for which to set the implementation.
 * implementation = The structure with function pointers to the implementation
 *     of the setup, update and teardown functions.
 *
 * Returns: true if successful, false on failure.
 *
 * See_Also: AnimationImplementation
 */
extern(C) bool animation_set_implementation
(Animation* animation, const(AnimationImplementation)* implementation);

/**
 * Gets the implementation of the custom animation.
 *
 * Params:
 * animation = The animation for which to get the implementation.
 *
 * See_Also: AnimationImplementation
 *
 * Returns: null if animation implementation has not been setup.
 */
version(PEBBLE_BASALT)
extern(C) const(AnimationImplementation)*
animation_get_implementation(Animation* animation);

/**
 * Function signature of a getter function to get the current property of type
 * short of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) short function(void*) Int16Getter;

/**
 * Function signature of a setter function to set a property of type
 * short onto the subject.
 *
 * See_Also: property_animation_update_int16()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, short int16) Int16Setter;

/**
 * Function signature of a setter function to set a property of type GPoint
 * onto the subject.
 *
 * See_Also: property_animation_update_gpoint()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GPoint gpoint) GPointSetter;

/**
 * Function signature of a getter function to get the current property of type
 * GPoint of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GPoint function(void* subject) GPointGetter;

/**
 * Function signature of a setter function to set a property of type
 * GRect onto the subject.
 *
 * See_Also: property_animation_update_grect()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GRect grect) GRectSetter;

/**
 * Function signature of a getter function to get the current property of type
 * GRect of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GRect function(void* subject) GRectGetter;

/**
 * Function signature of a setter function to set a property of type GColor8
 * onto the subject.
 *
 * See_Also: property_animation_update_gcolor8()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) void function(void* subject, GColor8 gcolor) GColor8Setter;

/**
 * Function signature of a getter function to get the current property of type
 * GColor8 of the subject.
 *
 * See_Also: property_animation_create()
 * See_Also: PropertyAnimationAccessors
 */
alias extern(C) GColor8 function(void* subject) GColor8Getter;

/// The setter types for setting a animation properties.
union PropertyAnimationSetters {
    /// Use if the property to animate is a short.
    Int16Setter int16;
    /// Use if the property to animate is a GPoint.
    GPointSetter gpoint;
    /// Use if the property to animate is a GRect.
    GRectSetter grect;
    /// Use if the property to animate is a GColor8.
    GColor8Setter gcolor8;
}

/// The getter types for getting animation properties.
union PropertyAnimationGetters {
    /// Use if the property to animate is a short.
    Int16Getter int16;
    /// Use if the property to animate is a GPoint.
    GPointGetter gpoint;
    /// Use if the property to animate is a GRect.
    GRectGetter grect;
    /// Use if the property to animate is a GColor8.
    GColor8Getter gcolor8;
}

/**
 * Data structure containing the setter and getter function pointers that the
 * property animation should use.
 *
 * The specified setter function will be used by the animation's update
 * callback.
 *
 * Based on the type of the property (int16_t, GPoint or GRect), the
 * accompanying update callback should be used.
 *
 * The getter function is used when the animation is initialized, to assign
 * the current value of the subject's property as "from" or "to" value.
 *
 * See_Also: property_animation_update_int16(),
 * See_Also: property_animation_update_gpoint()
 * See_Also: property_animation_update_grect()
 * See_Also: property_animation_create().
 */
struct PropertyAnimationAccessors {
    PropertyAnimationSetters setter;
    PropertyAnimationGetters getter;
}

/**
 * Data structure containing a collection of function pointers that form the
 * implementation of the property animation.
 */
struct PropertyAnimationImplementation {
    /// The "inherited" fields from the Animation "base class".
    AnimationImplementation base;
    /// The accessors to set/get the property to be animated.
    PropertyAnimationAccessors accessors;
}

struct PropertyAnimation {}

/**
 * Convenience function to create and initialize a property animation that
 * animates the frame of a Layer. It sets up the PropertyAnimation to use
 * layer_set_frame() and layer_get_frame() as accessors and uses the `layer`
 * parameter as the subject for the animation.
 *
 * The same defaults are used as with animation_create().
 *
 * Note: Pass in null as one of the frame arguments to have it set
 * automatically to the layer's current frame. This will result in a call to
 * layer_get_frame() to get the current frame of the layer.
 *
 * Params:
 * layer = The layer that will be animated.
 * from_frame = The frame that the layer should animate from.
 * to_frame = The frame that the layer should animate to.
 *
 * Returns: A handle to the property animation.
 *     null if animation could not be created
 */
extern(C) PropertyAnimation* property_animation_create_layer_frame
(Layer* layer, GRect* from_frame, GRect* to_frame);

/**
 * Creates a new PropertyAnimation on the heap and and initializes it with the
 * specified values.
 *
 * The same defaults are used as with animation_create().
 *
 * If the from_value or the to_value is null, the getter accessor will be
 * called to get the current value of the property and be used instead.
 *
 * Params:
 * implementation = Pointer to the implementation of the animation. In most
 *     cases, it makes sense to pass in a `static const` struct pointer.
 * subject = Pointer to the "subject" being animated. This will be passed in
 *     when the getter/setter accessors are called,
 *     The value of this pointer will be copied into the `.subject` field of
 *     the PropertyAnimation struct.
 * from_value = Pointer to the value that the subject should animate from.
 * to_value = Pointer to the value that the subject should animate to.
 *
 * Note: Pass in null as one of the value arguments to have it set
 * automatically to the subject's current property value, as returned by the
 * getter function. Also note that passing in null for both from_value and
 * to_value, will result in the animation having the same from- and to- values,
 * effectively not doing anything.
 *
 * Returns: A handle to the property animation. null if animation could not be
 *     created.
 *
 * See_Also: PropertyAnimationAccessors
 * See_Also: GPointSetter
 */
extern(C) PropertyAnimation* property_animation_create
(const(PropertyAnimationImplementation)* implementation,
void* subject, void* from_value, void* to_value);

/**
 * Destroy a property animation allocated by property_animation_create() or
 * relatives.
 *
 * Params:
 * property_animation = The return value from property_animation_create.
 */
extern(C) void property_animation_destroy
(PropertyAnimation* property_animation);

/**
 * Default update callback for a property animations to update a property of
 * type int16_t.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types Int16Getter and Int16Setter.
 *
 * The implementation of this function will calculate the next value of the
 * animation and call the setter to set the new value upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation
 */
extern(C) void property_animation_update_int16
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Default update callback for a property animations to update a property of
 * type GPoint.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types GPointGetter and GPointSetter.
 *
 * The implementation of this function will calculate the next point of the
 * animation and call the setter to set the new point upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation.
 */
extern(C) void property_animation_update_gpoint
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Default update callback for a property animations to update a property of
 * type GRect.
 *
 * Assign this function to the `.base.update` callback field of your
 * PropertyAnimationImplementation, in combination with a `.getter` and
 * `.setter` accessors of types GRectGetter and GRectSetter. The implementation
 * of this function will calculate the next rectangle of the animation and
 * call the setter to set the new rectangle upon the subject.
 *
 * Note: This function is not supposed to be called "manually", but will be
 * called automatically when the animation is being run.
 *
 * Params:
 * property_animation = The property animation for which the update is
 *     requested.
 * distance_normalized = The current normalized distance. See
 *     AnimationUpdateImplementation
 */
extern(C) void property_animation_update_grect
(PropertyAnimation* property_animation, const uint distance_normalized);

/**
 * Convenience function to retrieve an animation instance from a property
 * animation instance.
 *
 * Params:
 * property_animation = The property animation.
 *
 * Returns: The Animation within this PropertyAnimation.
 */
version(PEBBLE_BASALT)
extern(C) Animation* property_animation_get_animation
(PropertyAnimation* property_animation);


/**
 * Convenience function to clone a property animation instance
 *
 * Params:
 * from = The property animation
 *
 * Returns: A clone of the original Animation.
 */
PropertyAnimation* property_animation_clone(PropertyAnimation* from) {
    return cast(PropertyAnimation*) animation_clone(cast(Animation*) from);
}

// All of these animation properties are only available on basalt.
version(PEBBLE_BASALT) {
    /**
     * Helper function used by the property_animation_get|set_subject macros.
     *
     * Params:
     * property_animation = Handle to the property animation.
     * subject = The subject to get or set.
     * set = true to set new subject, false to retrieve existing value.
     *
     * Returns: true if successful, false on failure
     *    (usually a bad animation_h)
     */
    pure
    extern(C) bool property_animation_subject
    (PropertyAnimation* property_animation, void** subject, bool set);

    /**
     * Helper function used by the property_animation_get|set_from_.* macros.
     *
     * Params:
     * property_animation = Handle to the property animation.
     * from = Pointer to the value.
     * size = Size of the from value.
     * set = true to set new value, false to retrieve existing one.
     *
     * Returns: true if successful, false on failure
     *     (usually a bad animation_h)
     */
    pure
    version(PEBBLE_BASALT)
    extern(C) bool property_animation_from
    (PropertyAnimation* property_animation, void* from, size_t size, bool set);


    /**
     * Helper function used by the property_animation_get|set_to_.* macros
     *
     * Params:
     * property_animation = Handle to the property animation.
     * to = Pointer to the value.
     * size = Size of the to value.
     * set = true to set new value, false to retrieve existing one.
     *
     * Returns: true if successful, false on failure
     *    (usually a bad animation_h)
     */
    pure
    version(PEBBLE_BASALT)
    extern(C) bool property_animation_to
    (PropertyAnimation* property_animation, void* to, size_t size, bool set);

    /**
     * Convenience function to retrieve the 'from' GRect value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure
     */
    deprecated("Use animation.from_grect instead of this function")
    pure
    bool property_animation_get_from_grect
    (PropertyAnimation* property_animation, GRect* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, GRect.sizeof, false);
    }

    /// Get a 'from' GRect in a safe way.
    /// An AssertionError will be thrown if getting the rect fails.
    @trusted pure
    @property GRect from_grect(const(PropertyAnimation)* property_animation) {
        GRect rect;

        auto returnValue = property_animation_from(
            cast(PropertyAnimation*) property_animation,
            &rect,
            GRect.sizeof,
            false
        );

        assert(returnValue, "Getting a GRect failed!");

        return rect;
    }

    /**
     * Convenience function to set the 'from' GRect value of property animation
     * handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.from = rect; instead of this function")
    pure
    bool property_animation_set_from_grect
    (PropertyAnimation* property_animation, GRect* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, GRect.sizeof, true);
    }

    /// Set a 'from' GRect in a safe way.
    /// An AssertionError will be thrown if setting the rect fails.
    @trusted pure
    @property void from
    (PropertyAnimation* property_animation, GRect rect) {
        auto returnValue = property_animation_from(
            property_animation, &rect, GRect.sizeof, true);

        assert(returnValue, "Setting a GRect failed!");
    }

    /**
     * Convenience function to retrieve the 'from' GPoint value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure
     */
    deprecated("Use animation.from_gpoint instead of this function")
    pure
    bool property_animation_get_from_gpoint
    (PropertyAnimation* property_animation, GPoint* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, GPoint.sizeof, false);
    }

    /// Get a 'from' GPoint in a safe way.
    /// An AssertionError will be thrown if getting the point fails.
    @trusted pure
    @property GPoint from_gpoint
    (const(PropertyAnimation)* property_animation) {
        GPoint point;

        auto returnValue = property_animation_from(
            cast(PropertyAnimation*) property_animation,
            &point,
            GPoint.sizeof,
            false
        );

        assert(returnValue, "Getting a GPoint failed!");

        return point;
    }

    /**
     * Convenience function to set the 'from' GPoint value of property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure
     */
    deprecated("Use animation.from = point; instead of this function")
    pure
    bool property_animation_set_from_gpoint
    (PropertyAnimation* property_animation, GPoint* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, GPoint.sizeof, true);
    }

    /// Set a 'from' GPoint in a safe way.
    /// An AssertionError will be thrown if setting the point fails.
    @trusted pure
    @property void from
    (PropertyAnimation* property_animation, GPoint point) {
        auto returnValue = property_animation_from(
            property_animation, &point, GPoint.sizeof, true);

        assert(returnValue, "Setting a GPoint failed!");
    }

    /**
     * Convenience function to retrieve the 'from' int16_t value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.from_int16; instead of this function")
    pure
    bool property_animation_get_from_int16
    (PropertyAnimation* property_animation, short* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, short.sizeof, false);
    }

    /// Get a 'from' short in a safe way.
    /// An AssertionError will be thrown if getting the short fails.
    @trusted pure
    @property short from_int16(const(PropertyAnimation)* property_animation) {
        short value;

        auto returnValue = property_animation_from(
            cast(PropertyAnimation*) property_animation,
            &value,
            short.sizeof,
            false
        );

        assert(returnValue, "Getting a GPoint failed!");

        return value;
    }

    /**
     * Convenience function to set the 'from' int16_t value of property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure
     */
    deprecated("Use animation.from = value; instead of this function")
    pure
    bool property_animation_set_from_int16
    (PropertyAnimation* property_animation, short* value_ptr) {
        return property_animation_from(
            property_animation, value_ptr, short.sizeof, true);
    }

    /// Set a 'from' short in a safe way.
    /// An AssertionError will be thrown if setting the short fails.
    @trusted pure
    @property void from
    (PropertyAnimation* property_animation, short value) {
        auto returnValue = property_animation_from(
            property_animation, &value, short.sizeof, true);

        assert(returnValue, "Setting a short failed!");
    }

    /**
     * Convenience function to retrieve the 'to' GRect value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.to_grect instead of this function")
    pure
    bool property_animation_get_to_grect
    (PropertyAnimation* property_animation, GRect* value_ptr) {
        return property_animation_to(
            property_animation, value_ptr, GRect.sizeof, false);
    }

    /// Get a 'to' GRect in a safe way.
    /// An AssertionError will be thrown if getting the rect fails.
    @trusted pure
    @property GRect to_grect(const(PropertyAnimation)* property_animation) {
        GRect rect;

        auto returnValue = property_animation_to(
            cast(PropertyAnimation*) property_animation,
            &rect,
            GRect.sizeof,
            false
        );

        assert(returnValue, "Getting a GRect failed!");

        return rect;
    }

    /**
     * Convenience function to set the 'to' GRect value of property animation
     * handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.to = rect; instead of this function")
    pure
    bool property_animation_set_to_grect
    (PropertyAnimation* property_animation, GRect* value_ptr) {
        return property_animation_to(
            property_animation, value_ptr, GRect.sizeof, true);
    }

    /// Set a 'to' GRect in a safe way.
    /// An AssertionError will be thrown if setting the rect fails.
    @trusted pure
    @property void to
    (PropertyAnimation* property_animation, GRect rect) {
        auto returnValue = property_animation_to(
            property_animation, &rect, GRect.sizeof, true);

        assert(returnValue, "Setting a GRect failed!");
    }

    /**
     * Convenience function to retrieve the 'to' GPoint value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure
     */
    deprecated("Use animation.to_gpoint instead of this function")
    pure
    bool property_animation_get_to_gpoint
    (PropertyAnimation* property_animation, GPoint* value_ptr) {
        return property_animation_to(
            property_animation, value_ptr, GPoint.sizeof, false);
    }

    /// Get a 'to' GPoint in a safe way.
    /// An AssertionError will be thrown if getting the point fails.
    @trusted pure
    @property GPoint to_gpoint(const(PropertyAnimation)* property_animation) {
        GPoint point;

        auto returnValue = property_animation_to(
            cast(PropertyAnimation*) property_animation,
            &point,
            GPoint.sizeof,
            false
        );

        assert(returnValue, "Getting a GPoint failed!");

        return point;
    }

    /**
     * Convenience function to set the 'to' GPoint value of property animation
     * handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.to = point; instead of this function")
    pure
    bool property_animation_set_to_gpoint
    (PropertyAnimation* property_animation, GPoint* value_ptr) {
        return property_animation_to
            (property_animation, value_ptr, GPoint.sizeof, true);
    }

    /// Set a 'to' GPoint in a safe way.
    /// An AssertionError will be thrown if setting the point fails.
    @trusted pure
    @property void to
    (PropertyAnimation* property_animation, GPoint point) {
        auto returnValue = property_animation_to(
            property_animation, &point, GPoint.sizeof, true);

        assert(returnValue, "Setting a GPoint failed!");
    }

    /**
     * Convenience function to retrieve the 'to' int16_t value from property
     * animation handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = The value will be retrieved into this pointer.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.to_int16 instead of this function")
    pure
    bool property_animation_get_to_int16
    (PropertyAnimation* property_animation, short* value_ptr) {
        return property_animation_to
            (property_animation, value_ptr, short.sizeof, false);
    }

    /// Get a 'to' short in a safe way.
    /// An AssertionError will be thrown if getting the short fails.
    @trusted pure
    @property short to_int16(const(PropertyAnimation)* property_animation) {
        short value;

        auto returnValue = property_animation_to(
            cast(PropertyAnimation*) property_animation,
            &value,
            short.sizeof,
            false
        );

        assert(returnValue, "Getting a short failed!");

        return value;
    }

    /**
     * Convenience function to set the 'to' int16_t value of property animation
     * handle.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new value.
     *
     * Returns: true on success, false on failure.
     */
    deprecated("Use animation.to = value; instead of this function")
    pure
    bool property_animation_set_to_int16
    (PropertyAnimation* property_animation, short* value_ptr) {
        return property_animation_to
            (property_animation, value_ptr, short.sizeof, true);
    }

    /// Set a 'to' short in a safe way.
    /// An AssertionError will be thrown if setting the short fails.
    @trusted pure
    @property void to
    (PropertyAnimation* property_animation, short value) {
        auto returnValue = property_animation_to(
            property_animation, &value, short.sizeof, true);

        assert(returnValue, "Setting a short failed!");
    }

    /**
     * Retrieve the subject of a property animation
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer used to store the subject of this property
     *     animation.
     *
     * Returns: The subject of this PropertyAnimation.
     */
    deprecated("Use animation.subject instead of this function")
    pure
    bool property_animation_get_subject
    (PropertyAnimation* property_animation, void** value_ptr) {
        return property_animation_subject(
            property_animation,
            value_ptr,
            false
        );
    }

    /// Get a 'subject' in a safe way.
    /// An AssertionError will be thrown if getting the subject fails.
    @trusted pure
    @property void* subject(const(PropertyAnimation)* property_animation) {
        void* subject;

        auto returnValue = property_animation_subject(
            cast(PropertyAnimation*) property_animation,
            &subject,
            false
        );

        assert(returnValue, "Getting the subject failed!");

        return subject;
    }

    /**
     * Set the subject of a property animation.
     *
     * Params:
     * property_animation = The PropertyAnimation to be accessed.
     * value_ptr = Pointer to the new subject value.
     */
    deprecated("Use animation.subject = subject; instead of this function")
    pure
    bool property_animation_set_subject
    (PropertyAnimation* property_animation, void** value_ptr) {
        return property_animation_subject(property_animation, value_ptr, true);
    }

    /// Get a 'subject' in a safe way.
    /// An AssertionError will be thrown if getting the short fails.
    @trusted pure
    @property void subject
    (PropertyAnimation* property_animation, void* subject) {
        auto returnValue = property_animation_subject(
            property_animation, &subject, true);

        assert(returnValue, "Getting the subject failed!");
    }
}

