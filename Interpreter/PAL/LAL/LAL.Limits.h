#ifndef LAL_Limits__Def

#include "LAL.C_STL.h"
#include "LAL.Types.h"


// Integers

typedef intmax_t
IntMaxType;

#define S8Min    (-0x7f - 1)
#define S8Max    0x7f
#define U8Max    0xffu

#define S16Min   (-0x7fff - 1)
#define S16Max   0x7fff
#define U16Max   0xffffu

#define	S32Min   (-0x7fffffff - 1)
#define S32Max   0x7fffffff
#define U32Max   0xffffffffu

#define S64Min   (-0x7fffffffffffffffll - 1)
#define S64Max   0x7fffffffffffffffll
#define U64Max   0xffffffffffffffffull 

// Floating-Point

#define F32_Min         1.17549435e-38f
#define F32_MinNeg      FLT_MIN * -1.0f
#define F32_Max         3.40282347e+38f
#define F32_MaxNeg      FLT_MAX * -1.0f
#define F32_Epsilon     1.192092896e-07F
#define F32_Infinity    (float)INFINITY

// NOT IMPLEMENTED
#define F32_QNaN        assert(false)
#define F32_SNaN        assert(false)

#define F32_DeciAccuracy    0.1F;
#define F32_CentiAccuracy   0.01F;
#define F32_MilliAccuracy   0.001F;
#define F32_MicroAccuracy   0.00001F;

#define	F64_Min         2.2250738585072014e-308
#define	F64_MinNeg      DBL_MIN * -1.0
#define	F64_Max         1.7976931348623157e+308
#define	F64_MaxNeg      DBL_MAX * -1.0
#define F64_Epsilon     2.2204460492503131e-01
#define	F64_Infinity    (double)INFINITY

// NOT IMPLEMENTED
#define F64_QNaN    assert(false)
#define F64_SNaN    assert(false)

#define F64_DeciAccuracy    0.1F;
#define F64_CentiAccuracy   0.01F;
#define F64_MilliAccuracy   0.001F;
#define F64_MicroAccuracy   0.00001F;
#define F64_NanoAccuracy    0.00000001F;


#define LAL_Limits__Def
#endif
