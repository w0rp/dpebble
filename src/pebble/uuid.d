/**
 * This module defines UUID types for Pebble watches.
 */
module pebble.uuid;

@nogc:
nothrow:

/**
 * A type used for UUID values.
 */
extern(C) struct Uuid {
align(1):
    ubyte byte0;
    ubyte byte1;
    ubyte byte2;
    ubyte byte3;
    ubyte byte4;
    ubyte byte5;
    ubyte byte6;
    ubyte byte7;
    ubyte byte8;
    ubyte byte9;
    ubyte byte10;
    ubyte byte11;
    ubyte byte12;
    ubyte byte13;
    ubyte byte14;
    ubyte byte15;
}

/// The size of UUIDs.
enum UUID_SIZE = 16;

/// This function mirrors a macro in the C header.
@safe pure
Uuid UuidMake
(ubyte p0, ubyte p1, ubyte p2, ubyte p3, ubyte p4, ubyte p5, ubyte p6,
ubyte p7, ubyte p8, ubyte p9, ubyte p10, ubyte p11, ubyte p12, ubyte p13,
ubyte p14, ubyte p15) {
    return Uuid(
        p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15
    );
}

/**
 * Creates a Uuid from an array of bytes with 16 bytes in Big Endian order.
 *
 * Returns: The created Uuid
 */
@safe pure
Uuid UuidMakeFromBEBytes(ubyte[16] b) {
    return Uuid(
        b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10],
        b[11], b[12], b[13], b[14], b[15]
    );
}

/**
 * Creates a Uuid from an array of bytes with 16 bytes in Little Endian order.
 *
 * Returns: The created Uuid.
 */
@safe pure
Uuid UuidMakeFromLEBytes(ubyte[16] b) {
    return Uuid(
        b[15], b[14], b[13], b[12], b[11], b[10], b[9], b[8],
        b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0]
    );
}

@safe pure
deprecated("Use uu1 == uu2 instead of uuid_equal(&uu1, &uu2)")
bool uuid_equal(const(Uuid)* uu1, const(Uuid)* uu2) {
    if (uu1 is null) {
        return uu2 is null;
    } else if (uu2 is null) {
        return false;
    }

    return *uu1 == *uu2;
}

/**
 * Writes UUID in a string form into buffer that looks like the following...
 * {12345678-1234-5678-1234-567812345678}
 *
 * Params:
 * uuid = The Uuid to write into the buffer as human-readable string
 * buffer = Memory to write the string to. Must be at least
 * UUID_STRING_BUFFER_LENGTH bytes long.
 */
extern(C) void uuid_to_string(const(Uuid)* uuid, char* buffer);

/// The minimum required length of a string used to hold a uuid
// (including null).
enum UUID_STRING_BUFFER_LENGTH = 32 + 4 + 2 + 1;

