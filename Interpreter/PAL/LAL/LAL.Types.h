#ifndef LAL_Types__Def
#define LAL_Types__Def

#include "LAL.C_STL.h"


// Data

typedef int8_t
  byte,
* bytePtr,
* byteArray;

typedef int16_t
  byte16,
* byte16Ptr,
* byte16Array;

// Data model defined addressing sizes.

typedef	size_t      uDM;
typedef	ptrdiff_t   sDM;

static_assert(sizeof(uDM) == sizeof(sDM), "sizeof(uDM) != sizeof(sDM)");

// Pointer Compatiable Width Integers

typedef    intptr_t     sIntPtr;
typedef    uintptr_t    uIntPtr;

static_assert(sizeof(uIntPtr) == sizeof(sIntPtr), "sizeof(uIntPtr) != sizeof(sIntPtr)");

// Integers

// Flexible

typedef    unsigned int    ui32;
typedef    signed   int    si32;

typedef    unsigned long   uLong;
typedef    long            sLong;

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

static_assert(sizeof(s8)  == sizeof(s8) , "sizeof(u8)  != sizeof(zpl_s8)");
static_assert(sizeof(u16) == sizeof(s16), "sizeof(u16) != sizeof(zpl_s16)");
static_assert(sizeof(u32) == sizeof(s32), "sizeof(u32) != sizeof(zpl_s32)");
static_assert(sizeof(u64) == sizeof(s64), "sizeof(u64) != sizeof(zpl_s64)");

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


#endif // LAL_Types__Def
