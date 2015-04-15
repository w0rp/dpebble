/**
 * This module defines Pebble's Tuple types.
 *
 * The Tuple types for Pebble watches are key-value pairs.
 */
module pebble.tuple;

import core.stdc.string : strlen;

@nogc:
nothrow:

/// Values representing the type of data that the `value` field of a
/// Tuple contains.
enum TupleType: ubyte {
    /// The value is an array of bytes.
    byte_array = 0,
    /// The value is a zero-terminated, UTF-8 C-string.
    cstring = 1,
    /// The value is an unsigned integer. The tuple's `.length` field is
    /// used to determine the size of the integer (1, 2, or 4 bytes).
    _uint = 2,
    /// The value is a signed integer. The tuple's `.length` field is used to
    /// determine the size of the integer (1, 2, or 4 bytes).
    _int = 3
}

///
alias TUPLE_BYTE_ARRAY = TupleType.byte_array;
///
alias TUPLE_CSTRING = TupleType.cstring;
///
alias TUPLE_UINT = TupleType._uint;
///
alias TUPLE_INT = TupleType._int;

/**
 * The value itself.
 * The different union fields are provided for convenience,
 * avoiding the need for manual casts.
 *
 * Note: The array length is of incomplete length on purpose, to
 * facilitate variable length data and because a data length of
 * zero is valid.
 *
 * Note: __Important: The integers are little endian!__
 */
union TupleValue {
    /// The byte array value. Valid when `.type` is TUPLE_BYTE_ARRAY.
    uint* data;
    /// The C-string value. Valid when `.type` is TUPLE_CSTRING.
    char* cstring;
    /**
     * The 16-bit unsigned integer value. Valid when `.type` is TUPLE_UINT
     * and `.length` is 2 byte.
     */
    uint uint8;
    ushort uint16;
    /**
     * The 32-bit unsigned integer value. Valid when `.type` is TUPLE_UINT
     * and `.length` is 4 byte.
     */
    uint uint32;
    /**
     * The 8-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 1 byte.
     */
    byte int8;
    /**
     * The 16-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 2 byte.
     */
    short int16;
    /**
     * The 32-bit signed integer value. Valid when `.type` is TUPLE_INT
     * and `.length` is 4 byte.
     */
    int int32;
}


/**
 * Data structure for one serialized key/value tuple
 *
 * Note: The structure is variable length! The length depends on the
 * value data that the tuple contains.
 */
extern(C) struct Tuple {
align(1):
    /// The key
    uint key;
    /// The type of data that the `.value` fields contains.
    TupleType type;
    /// The length of `.value` in bytes.
    ushort length;
    /// The value itself.
    TupleValue value;
}

///
struct TupletBytesType {
    /// Pointer to the data
    const (ubyte)* data;
    /// Length of the data
    const ushort length;

    /**
     * Return a slice using the length in the struct.
     *
     * Returns: A slice of the memory.
     */
    @system pure
    const(ubyte)[] slice() const {
        return data[0 .. (length - 1)];
    }
}

///
struct TupletCStringType {
    /// Pointer to the c-string data.
    const (char)* data;
    /// Length of the c-string, including terminating zero.
    const ushort length;

    /**
     * Return the C-string value from this tuplet as a slice of memory,
     * using the length in the struct.
     *
     * Returns: A slice of the character memory.
     */
    @system pure
    const(char)[] slice() const {
        return data[0 .. (length - 1)];
    }
}

///
struct TupletIntType {
    /// Actual storage of the integer.
    /// The signedness can be derived from the `.type` value.
    uint storage;
    /// Width of the integer.
    const ushort width;
}

/**
 * Non-serialized, template data structure for a key/value pair.
 *
 * For strings and byte arrays, it only has a pointer to the actual data.
 * For integers, it provides storage for integers up to 32-bits wide.
 * The Tuplet data structure is useful when creating dictionaries from values
 * that are already stored in arbitrary buffers.
 *
 * See_Also: Tuple, which is the header of a serialized key/value pair.
 */
extern(C) struct Tuplet {
    /**
     * The type of the Tuplet. This determines which of the struct
     * fields in the anonymous union are valid.
     */
    TupleType type;
    /// The key.
    uint key;

    /**
     * Anonymous union containing the reference to the Tuplet's value, being
     * either a byte array, c-string or integer. See documentation of `.bytes`,
     * `.cstring` and `.integer` fields.
     */
    union {
        /// Valid when `.type.` is TUPLE_BYTE_ARRAY.
        TupletBytesType bytes;
        /// Valid when `.type.` is TUPLE_CSTRING.
        TupletCStringType cstring;
        /// Valid when `.type.` is TUPLE_INT or TUPLE_UINT
        TupletIntType integer;
    }

    /**
     * Create a Tuplet with a byte array value.
     *
     * Params:
     * key = The key
     * data = Pointer to the bytes
     * length = Length of the buffer
     */
    @nogc @safe pure nothrow
    this(uint key, const(ubyte)* data, const ushort length) {
        this.type = TUPLE_BYTE_ARRAY;
        this.key = key;
        this.bytes = TupletBytesType(data, length);
    }

    /**
     * Create a Tuplet with a byte array slice.
     *
     * Params:
     * key = The key
     * data = A slice of bytes.
     */
    @nogc @safe pure nothrow
    this(uint key, const(ubyte)[] data) {
        this(key, data.ptr, cast(ushort) data.length);
    }

    /**
     * Create a Tuplet with a c-string value
     *
     * Params:
     * key = The key
     * cstring = The c-string value
     */
    @nogc @trusted pure nothrow
    this(uint key, const (char)* cstring) {
        this.type = TUPLE_CSTRING;
        this.key = key;

        if (cstring !is null) {
            this.cstring = TupletCStringType(
                cstring,
                cast(ushort)(strlen(cstring) + 1)
            );
        } else {
            this.cstring = TupletCStringType(null, 0);
        }
    }

    /**
     * Create a Tuplet with an integer value.
     *
     * Params:
     * key = The key
     * integer = The integer value
     */
    @nogc @trusted pure nothrow
    this(uint key, ubyte integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, ubyte.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, byte integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, byte.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, ushort integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, ushort.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, short integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, short.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, uint integer) {
        this.type = TUPLE_UINT;
        this.key = key;
        this.integer = TupletIntType(integer, uint.sizeof);
    }

    /// ditto
    @nogc @trusted pure nothrow
    this(uint key, int integer) {
        this.type = TUPLE_INT;
        this.key = key;
        this.integer = TupletIntType(integer, int.sizeof);
    }
}



/**
 * Create a Tuplet with a byte array value.
 *
 * Params:
 * key = The key
 * data = Pointer to the bytes
 * length = Length of the buffer
 */
deprecated("Use the matching constructor for Tuplet instead.")
@safe pure
Tuplet TupletBytes(uint key, const (ubyte)* data, const ushort length) {
    return Tuplet(key, data, length);
}

/**
 * Create a Tuplet with a c-string value
 *
 * Params:
 * key = The key
 * cstring = The c-string value
 */
@trusted pure
deprecated("Use the matching constructor for Tuplet instead.")
Tuplet TupletCString(uint key, const(char*) cstring) {
    return Tuplet(key, cstring);
}

/**
 * Create a Tuplet with an integer value.
 *
 * Params:
 * key = The key
 * integer = The integer value
 */
@safe pure
deprecated("Use the matching constructor for Tuplet instead.")
Tuplet TupletInteger(uint key, ubyte integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, byte integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, ushort integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, short integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, uint integer) {
    return Tuplet(key, integer);
}

/// ditto
@safe pure
Tuplet TupletInteger(uint key, int integer) {
    return Tuplet(key, integer);
}

