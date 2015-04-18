/**
 * This module mirrors the basalt and aplite Pebble headers with color
 * definitions, etc.
 *
 * C standard library functions will also be publicly imported.
 *
 * The following standard library functions are not supported on Pebble
 * watches:
 *
 * fopen, fclose, fread, fwrite, fseek, ftell, fsetpos, fscanf, fgetc
 * fgets, fputc, fputs
 *
 * fprintf, sprintf, vfprintf, vsprintf, vsnprinf
 *
 * open, close, creat, read, write, stat
 *
 * alloca, mmap, brk, sbrk
 */
module pebble;

// Import all of the supported C standard library functions.
// The functions which aren't supported on the watch will be excluded.
public import core.stdc.locale;
public import core.stdc.stdlib;
public import core.stdc.string;

public import pebble.versions;

public import pebble.math;
public import pebble.watchinfo;
// This module will publicly import C standard library symbols.
public import pebble.clock;
public import pebble.uuid;
public import pebble.logging;
public import pebble.tuple;
public import pebble.dictionary;
public import pebble.persistence;
public import pebble.gpoint;
public import pebble.grect;
public import pebble.gsize;
public import pebble.gcolor;
public import pebble.resource;
public import pebble.messages;
public import pebble.workers;
public import pebble.timers;
public import pebble.sync;
public import pebble.window;
public import pebble.number_window;
public import pebble.layer;
public import pebble.font;
public import pebble.gcontext;
public import pebble.gbitmap;
public import pebble.animations;
public import pebble.battery;
public import pebble.bluetooth;
public import pebble.magnometer;
public import pebble.accelerometer;
public import pebble.compass;
public import pebble.vibration;
public import pebble.light;
public import pebble.launch;
public import pebble.misc;

