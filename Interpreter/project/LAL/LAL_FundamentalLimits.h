/*
C Fundamental Limits
*/

#pragma once

#include "LAL_C_STL.h"
#include "LAL_FundamentalTypes.h"


typedef intmax_t
IntMaxType;

#define S8Min    INT8_MIN
#define S8Max    INT8_MAX

#define S16Min   INT16_MIN
#define S16Max   INT16_MAX

#define	S32Min   INT32_MIN
#define S32Max   INT32_MAX

#define S64Min   INT64_MIN
#define S64Max   INT64_MAX

#define U8Max    UINT8_MAX
#define U16Max   UINT16_MAX
#define U32Max   UINT32_MAX
#define U64Max   UINT64_MAX 

#define F32_Min         FLT_MIN
#define F32_MinNeg      FLT_MIN * -1.0f
#define F32_Max         FLT_MAX
#define F32_MaxNeg      FLT_MAX * -1.0f
#define F32_Epsilon     FLT_EPSILON
#define F32_Infinity    (float)INFINITY

// NOT IMPLEMENTED
#define F32_QNaN        assert(false)
#define F32_SNaN        assert(false)

#define F32_HighAccuracy    0.00001F;
#define F32_LowAccuracy     0.001F;

#define	F64_Min         DBL_MIN
#define	F64_MinNeg      DBL_MIN * -1.0
#define	F64_Max         DBL_MAX
#define	F64_MaxNeg      DBL_MAX * -1.0
#define F64_Epsilon     DBL_EPSILON
#define	F64_Infinity    (double)INFINITY

// NOT IMPLEMENTED
#define F64_QNaN    assert(false)
#define F64_SNaN    assert(false)

#define F64_NanoAccuracy    0.000000001F;
#define F64_HighAccuracy    0.00001F    ;
#define F64_LowAccuracy     0.001F      ;


