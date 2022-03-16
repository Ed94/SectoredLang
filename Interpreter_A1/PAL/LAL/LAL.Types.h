#ifndef LAL_Types__Def
#define LAL_Types__Def

#include "Config.LAL.h"
#include "TPAL.h"


// Data

typedef int8_t
  byte,
* bytePtr;

typedef int16_t
  byte16,
* byte16Ptr;

typedef int32_t
  byte32,
* byte32Ptr;

typedef int64_t
  byte64,
* byte64Ptr;

// Data model defined addressing sizes.

typedef	size_t      uw;
typedef	ptrdiff_t   sw;

static_assert(sizeof(uw) == sizeof(sw), "sizeof(uw) != sizeof(sw)");

// Pointer Compatiable Width Integers

typedef    intptr_t     sIntPtr;
typedef    uintptr_t    uIntPtr;

static_assert(sizeof(uIntPtr) == sizeof(sIntPtr), "sizeof(uIntPtr) != sizeof(sIntPtr)");

// Characters

typedef unsigned char     c8;
typedef signed   char     sc8;
typedef          char16_t c16;
typedef          char32_t c32;

// Integers

// Flexible

typedef    unsigned int    ui32;
typedef    signed   int    si32;

static_assert(sizeof(ui32)  == sizeof(si32), "sizeof(ui32) != sizeof(si32)");

// Strict

// Signed

typedef    int8_t   s8;
typedef    int16_t  s16;
typedef    int32_t  s32;
typedef    int64_t  s64;

// Unsigned

typedef    uint8_t      u8;
typedef    uint16_t     u16;
typedef    uint32_t     u32;
typedef    uint64_t     u64;

static_assert(sizeof(s8)  == sizeof(s8) , "sizeof(u8)  != sizeof(s8)");
static_assert(sizeof(u16) == sizeof(s16), "sizeof(u16) != sizeof(s16)");
static_assert(sizeof(u32) == sizeof(s32), "sizeof(u32) != sizeof(s32)");
static_assert(sizeof(u64) == sizeof(s64), "sizeof(u64) != sizeof(s64)");

static_assert(sizeof(u8)  == 1, "sizeof(u8)  != 1");
static_assert(sizeof(u16) == 2, "sizeof(u16) != 2");
static_assert(sizeof(u32) == 4, "sizeof(u32) != 4");
static_assert(sizeof(u64) == 8, "sizeof(u64) != 8");

// Floats

#ifdef LAL_Float_16
typedef         half        f16;
#endif

typedef         float       f32;
typedef         double      f64;

// Errors

typedef errno_t
ErrorType;

// IO

#define     IO_StdIn    (IO_Std*)zpl_file_get_standard(ZPL_FILE_STANDARD_INPUT)
#define     IO_StdOut   (IO_Std*)zpl_file_get_standard(ZPL_FILE_STANDARD_OUTPUT)
#define     IO_StdError (IO_Std*)zpl_file_get_standard(ZPL_FILE_STANDARD_ERROR)

typedef zpl_file
            IO_File, 
*           IO_FilePtr,
*restrict   IO_FileRPtr,
		    IO_Std;


#endif // LAL_Types__Def
