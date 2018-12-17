# pony-struct [![CircleCI](https://circleci.com/gh/nisanharamati/pony-struct.svg?style=shield)](https://circleci.com/gh/nisanharamati/pony-struct)

This package performs conversions between Pony values and C structs represented
as Pony ByteSeq objects. This can be used in handling binary data stored in
files or from network connections, among other sources. It uses Format Strings
as compact descriptions of the layout of the C structs and the intended
conversion to/from Pony values.

It is inspired by the [Python struct module](https://docs.python.org/3.7/library/struct.html).

## Usage

### Struct.pack
Pack an `Array[(Bool | Number | String | Array[U8] val)]` according to a format
string:

```pony
let byte_seqs = Struct.pack(">Iqd5ss5p",
  [ 1024
    1544924117813084
    3.141592653589793
    "hello"
    "!"
    recover [as U8: 1;2;3;4;5] end
    ] )?
```

### Struct.unpack
Unpack a bytestream (a buffered Reader) into an
`Array[(Bool | Number | String | Array[U8] val)]` according to a format string:

```pony
let unpacked = Struct.unpack(">Iq5s", consume reader)?
let length: U32 = unpacked(0)?
let nanosecond_offset = unpacked(1)? as I64
let message: String = unpacked(2)?
```

## Byte Order
Byte order can be optionally specified with the first character in the format
string. If left out, Big Endian is used as the default.

| Byte order | character |
|     -      |     -     |
| Big Endian | >         |
| Little Endian | <      |


The format conversion specification is described in the table below.

| Format | C Type             | Pony type | Standard size |
|   -    |    -               |      -    |        -      |
| x	     | pad byte           |	no value  | 1             |
| c      | char               |	String    |	1	            |
| b      | signed char        | I8        | 1             |
| B	     | unsigned char      | U8        | 1             |
| ?      | _Bool              | Bool      | 1             |
| h      | short              | I16       | 2             |
| H      | unsigned short     | U16       | 2             |
| i      | int                | I32       | 4             |
| I      | unsigned int       | U32       | 4	            |
| l      | long               | I32       | 4             |
| L      | unsigned long      | U32       | 4             |
| q      | long long          | I64       | 8             |
| Q      | unsigned long long | U64       | 8             |
| u      | unsigned bigint    | U128      | 16            |
| f      | float              | f32       | 4             |
| d      | double             | f64       | 8             |
| s      | char[]             | String    |               |
| p      | char[]             | Array[U8] |               |


Each type may be preceded with an integer representing its length (in the case
of String and Array[U8]) or number repetitions (all other types).

All types passed to `pack` must have a reference capability of val.
