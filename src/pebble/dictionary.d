/**
 * This module defines Pebble's Dictionary types, and operations on them.
 */
module pebble.dictionary;

import pebble.tuple;

@nogc:
nothrow:

/// Return values for dictionary write/conversion functions.
enum DictionaryResult {
    /// The operation returned successfully
    ok = 0,
    /// There was not enough backing storage to complete the operation.
    not_enough_storage = 2,
    /// One or more arguments were invalid or uninitialized
    invalid_args= 4,
    /// The lengths and/or count of the dictionary its tuples are inconsistent
    internal_inconsistency = 8,
    /// A requested operation required additional memory to be allocated, but
    /// the allocation failed, likely due to insufficient remaining heap
    /// memory.
    malloc_failed = 16
}

///
alias DICT_OK = DictionaryResult.ok;
///
alias DICT_NOT_ENOUGH_STORAGE = DictionaryResult.not_enough_storage;
///
alias DICT_INVALID_ARGS = DictionaryResult.invalid_args;
///
alias DICT_INTERNAL_INCONSISTENCY = DictionaryResult.internal_inconsistency;
///
alias DICT_MALLOC_FAILED = DictionaryResult.malloc_failed;


extern(C) struct Dictionary {};

/**
 * An iterator can be used to iterate over the key/value tuples in an existing
 * dictionary, using dict_read_begin_from_buffer(), dict_read_first()
 * dict_read_next().
 *
 * An iterator can also be used to append key/value tuples to a dictionary,
 * for example using \ref dict_write_data() or \ref dict_write_cstring().
 */
struct DictionaryIterator {
    /// The dictionary being iterated.
    Dictionary* dictionary;
    /// Points to the first memory address after the last byte
    /// of the dictionary.
    const(void)* end;
    /**
     * Points to the next Tuple in the dictionary. Given the end of the
     * Dictionary has not yet been reached: when writing, the next key/value
     * pair will be written at the cursor. When reading, the next call
     * dict_read_next() will return the cursor.
     */
    Tuple* cursor;
}

/**
 * Calculates the number of bytes that a dictionary will occupy, given
 * one or more value lengths that need to be stored in the dictionary.
 *
 * Note: The formula to calculate the size of a Dictionary in bytes is:
 * 1 + (n * 7) + D1 + ... + Dn
 *
 * Where `n` is the number of Tuples in the Dictionary and `Dx` are the sizes
 * of the values in the Tuples. The size of the Dictionary header is 1 byte.
 * The size of the header for each Tuple is 7 bytes.
 *
 * Params:
 * tuple_count = The total number of key/value pairs in the dictionary.
 * ... = The sizes of each of the values that need to be
 *     stored in the dictionary.
 *
 * Returns: The total number of bytes of storage needed.
 */
@trusted pure
extern(C) uint dict_calc_buffer_size(const ubyte tuple_count, ...);

/**
 * Calculates the size of data that has been written to the dictionary.
 *
 * AKA, the "dictionary size". Note that this is most likely different
 * than the size of the backing storage/backing buffer.
 *
 * Params:
 * iter = The dictionary iterator
 *
 * Returns: The total number of bytes which have been written
 * to the dictionary.
 */
@trusted pure
extern(C) uint dict_size(const(DictionaryIterator)* iter);

/**
 * Initializes the dictionary iterator with a given buffer and size,
 * resets and empties it, in preparation of writing key/value tuples.
 *
 * Params:
 * iter = The dictionary iterator.
 * buffer = The storage of the dictionary.
 * size = The storage size of the dictionary.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 *
 * See_Also: dict_calc_buffer_size
 * See_Also: dict_write_end
 */
extern(C) DictionaryResult dict_write_begin
(DictionaryIterator* iter, ubyte* buffer, const ushort size);

/**
 * Adds a key with a byte array value pair to the dictionary.
 *
 * Note: The data will be copied into the backing storage of the dictionary.
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * data = Pointer to the byte array.
 * size = Length of the byte array.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_write_data(DictionaryIterator* iter,
const uint key, const ubyte* data, const ushort size);

/**
 * Adds a key with a C string value pair to the dictionary.
 *
 * Note: The string will be copied into the backing storage of the dictionary.
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * cstring = Pointer to the zero-terminated C string.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_cstring
(DictionaryIterator* iter, const uint key, const char* cstring);

/**
 * Adds a key with an integer value pair to the dictionary.
 *
 * Note: There is _no_ checking for duplicate keys. dict_write_int() is only
 * for serializing a single integer. width_bytes can only be 1, 2, or 4.
 *
 * Params:
 * iter = The dictionary iterator.
 * key = The key.
 * integer = Pointer to the integer value.
 * width_bytes = The width of the integer value.
 * is_signed = Whether the integer's type is signed or not.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_write_int(DictionaryIterator* iter,
const uint key, const(void)* integer, const ubyte width_bytes,
const bool is_signed);

/**
 * Add a key-value pair to the dictionary.
 *
 * Note: There is _no_ checking for duplicate keys.
 *
 * Params:
 * iter = The dictionary iterator
 * key = The key
 * value = The value;
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_uint8
(DictionaryIterator* iter, const uint key, const ubyte value);
/// ditto
extern(C) DictionaryResult dict_write_uint16
(DictionaryIterator* iter, const uint key, const ushort value);
/// ditto
extern(C) DictionaryResult dict_write_uint32
(DictionaryIterator* iter, const uint key, const uint value);
/// ditto
extern(C) DictionaryResult dict_write_int8
(DictionaryIterator* iter, const uint key, const byte value);
/// ditto
extern(C) DictionaryResult dict_write_int16
(DictionaryIterator* iter, const uint key, const short value);
/// ditto
extern(C) DictionaryResult dict_write_int32
(DictionaryIterator* iter, const uint key, const int value);

/**
 * End a series of writing operations to a dictionary.
 *
 * This must be called before reading back from the dictionary.
 *
 * Params:
 * iter = The dictionary iterator
 *
 * Returns: The size in bytes of the finalized dictionary, or 0 if the
 * parameters were invalid.
 */
extern(C) uint dict_write_end (DictionaryIterator* iter);

private void checkDictionaryResult(DictionaryResult result) {
    switch (result) {
    case DICT_NOT_ENOUGH_STORAGE:
        assert(false, "Not enough storage for a dictionary!");
    case DICT_INVALID_ARGS:
        assert(false, "Invalid arguments for dict_write!");
    default:
        assert(false, "This should never be reached.");
    }
}

// TODO: Write 'dict_write' as a wrapper with assertions.

/// A wrapper function for conveniently writing to a dictionary iterator.
void write(DictionaryIterator* iter, const uint key,
const ubyte* data, const ushort size) {
    checkDictionaryResult(dict_write_data(iter, key, data, size));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ubyte[] data) {
    checkDictionaryResult(dict_write_data(iter, key, data.ptr, cast(ushort) data.length));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const char* cstring) {
    checkDictionaryResult(dict_write_cstring(iter, key, cstring));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ubyte value) {
    checkDictionaryResult(dict_write_uint8(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const ushort value) {
    checkDictionaryResult(dict_write_uint16(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const uint value) {
    checkDictionaryResult(dict_write_uint32(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const byte value) {
    checkDictionaryResult(dict_write_int8(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const short value) {
    checkDictionaryResult(dict_write_int16(iter, key, value));
}

/// ditto
void write(DictionaryIterator* iter, const uint key, const int value) {
    checkDictionaryResult(dict_write_int32(iter, key, value));
}


/**
 * Initializes the dictionary iterator with a given buffer and size,
 * in preparation of reading key/value tuples.
 *
 * Params:
 * iter = The dictionary iterator
 * buffer = The storage of the dictionary
 * size = The storage size of the dictionary
 *
 * Returns: The first tuple in the dictionary, or NULL in case the
 * dictionary was empty or if there was a parsing error.
 */
extern(C) Tuple* dict_read_begin_from_buffer
(DictionaryIterator* iter, const ubyte* buffer, const ushort size);

/**
 * Progresses the iterator to the next key/value pair.
 *
 * Params:
 * iter The dictionary iterator
 *
 * Returns: The next tuple in the dictionary, or NULL in case the end has
 * been reached or if there was a parsing error.
 */
extern(C) Tuple* dict_read_next(DictionaryIterator* iter);

/**
 * Resets the iterator back to the same state as a call to
 * dict_read_begin_from_buffer() would do.
 *
 * Params:
 * iter = The dictionary iterator.
 *
 * Returns: The first tuple in the dictionary, or NULL in case the dictionary
 * was empty or if there was a parsing error.
 */
extern(C) Tuple* dict_read_first(DictionaryIterator* iter);


/**
 * Callback for \ref dict_serialize_tuplets() utility.
 *
 * Params:
 * data = The data of the serialized dictionary
 * size = The size of data
 * context = The context pointer as passed in to dict_serialize_tuplets()
 *
 * See_Also: dict_serialize_tuplets
 */
alias extern(C) void function (const(ubyte)* data, ushort size, void* context)
DictionarySerializeCallback;

/**
 * Utility function that takes a list of Tuplets from which a dictionary
 * will be serialized, ready to transmit or store.
 *
 * Note: The callback will be called before the function returns, so
 * the data the that `context` points to, can be stack allocated.
 *
 * Params:
 * callback = The callback that will be called with the serialized data of the
 *     generated dictionary.
 * context = Pointer to any application specific data that gets passed into
 *     the callback.
 * tuplets = An array of Tuplets that need to be serialized into the
 *     dictionary.
 * tuplets_count = The number of tuplets that follow.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS.
 */
extern(C) DictionaryResult dict_serialize_tuplets
(DictionarySerializeCallback callback, void* context, const Tuplet* tuplets,
const ubyte tuplets_count);

/**
 * Utility function that takes an array of Tuplets and serializes them into
 * a dictionary with a given buffer and size.
 *
 * Params:
 * tuplets = The array of tuplets
 * tuplets_count = The number of tuplets in the array
 * buffer = The buffer in which to write the serialized dictionary
 * size_in_out = The buffer size in bytes will be taken here, and the value
 *     given here will be set to the number of bytes written.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_serialize_tuplets_to_buffer
(const Tuplet* tuplets, const ubyte tuplets_count, ubyte* buffer,
uint* size_in_out);

/**
 * Serializes an array of Tuplets into a dictionary with a given buffer and
 * size.
 *
 * Params:
 * iter = The dictionary iterator.
 * tuplets = The array of tuplets.
 * tuplets_count = The number of tuplets in the array.
 * buffer = The buffer in which to write the serialized dictionary.
 * size_in_out = The buffer size in bytes will be taken here, and the value
 *     given here will be set to the number of bytes written.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_serialize_tuplets_to_buffer_with_iter
(DictionaryIterator* iter, const Tuplet* tuplets, const ubyte tuplets_count,
ubyte* buffer, uint* size_in_out);

/**
 * Serializes a Tuplet and writes the resulting Tuple into a dictionary.
 *
 * Params:
 * iter = The dictionary iterator.
 * tuplet = The Tuplet describing the key/value pair to write.
 *
 * Returns: DICT_OK, DICT_NOT_ENOUGH_STORAGE or DICT_INVALID_ARGS
 */
extern(C) DictionaryResult dict_write_tuplet
(DictionaryIterator* iter, const Tuplet* tuplet);

/**
 * Calculates the number of bytes that a dictionary will occupy, given
 * one or more Tuplets that need to be stored in the dictionary.
 *
 * Note: See dict_calc_buffer_size() for the formula for the calculation.
 *
 * Params:
 * tuplets = An array of Tuplets that need to be stored in the dictionary.
 * tuplets_count = The total number of Tuplets that follow.
 *
 * Returns: The total number of bytes of storage needed.
 * See_Also: Tuplet
 */
extern(C) uint dict_calc_buffer_size_from_tuplets
(const Tuplet* tuplets, const ubyte tuplets_count);

/**
 * Type of the callback used in dict_merge().
 *
 * Params:
 * key = The key that is being updated.
 * new_tuple = The new tuple. The tuple points to the actual,
 *     updated destination dictionary or NULL_TUPLE in case there was an
 *     error (e.g. backing buffer was too small).  Therefore the Tuple can be
 *     used after the callback returns, until the destination dictionary
 *     storage is free'd (by the application itself).
 * old_tuple = The values that will be replaced with `new_tuple`.
 *     The key, value and type will be equal to the previous tuple in the
 *     old destination dictionary, however the `old_tuple points to a
 *     stack-allocated copy of the old data.
 * context = Pointer to application specific data. The storage backing
 *     `old_tuple` can only be used during the callback and will no longer be
 *     valid after the callback returns.
 *
 * See_Also: dict_merge
 */
alias extern(C) void function
(uint key, const(Tuple)* new_tuple, const(Tuple)* old_tuple, void* context)
DictionaryKeyUpdatedCallback;

/**
 * Merges entries from another "source" dictionary into a "destination"
 * dictionary.
 *
 * All Tuples from the source are written into the destination dictionary,
 * while updating the exsting Tuples with matching keys.
 *
 * Params:
 * dest = The destination dictionary to update
 * dest_max_size_in_out = In: the maximum size of buffer backing `dest`.
 *     Out: the final size of the updated dictionary.
 * source = The source dictionary of which its Tuples will be used to
 *     update dest.
 * update_existing_keys_only = Specify True if only the existing keys in
 *     `dest` should be updated.
 * key_callback = The callback that will be called for each Tuple in the
 *     merged destination dictionary.
 * context = Pointer to app specific data that will get passed in when
 *     `update_key_callback` is called.
 *
 * Returns: DICT_OK, DICT_INVALID_ARGS, DICT_NOT_ENOUGH_STORAGE
 */
extern(C) DictionaryResult dict_merge(DictionaryIterator* dest,
uint* dest_max_size_in_out, DictionaryIterator* source,
const bool update_existing_keys_only,
const DictionaryKeyUpdatedCallback key_callback, void* context);

/**
 * Tries to find a Tuple with specified key in a dictionary.
 *
 * Params:
 * iter = Iterator to the dictionary to search in.
 * key = The key for which to find a Tuple.
 *
 * Returns: Pointer to a found Tuple, or NULL if there was no Tuple with
 *     the specified key.
 */
extern(C) Tuple* dict_find(const(DictionaryIterator)* iter, const uint key);

