#pragma once

#include "stdbool.h"

#include "FundamentalTypes.h"

#include "TBF_CAssist.h"


typedef Ptr(char) CharArray;   //This is a pointer. Treat it as such.

typedef struct CString_Def CString;

typedef FuncRef(void, CString_Init, Ptr(CString) _CStringInst);

typedef FuncRef(bool, ContainsCString, Ptr(CString) _CStringInstance, Ptr(CString) _Substring);

typedef FuncRef(void, CreateFromLiteral,           Ptr(CString) _CStringInstance, Immutable Ptr(char) _stringLiteral );
typedef FuncRef(void, ClearCString     , Immutable Ptr(CString) _CStringInstance                                     );
typedef FuncRef(void, SetCString       ,           Ptr(CString) _CStringInstance, Immutable CharArray _rawStringToSet);


Func(void) CString_Init(Ptr(CString) _CStringInst);

Func(bool) ContainsCString(Ptr(CString) _CStringInstance, Ptr(CString) _SubString);

Func(void) AllocateCharArray(Ptr(CharArray)  _CharArrayInstance, uInt64              _numOfChars);

SPrivate Func(void) CreateFromLiteral(          Ptr(CString  ) _CStringInstance  , Immutable Ptr(char) _stringLiteral );
SPrivate Func(void) ClearCString     (Immutable Ptr(CString  ) _CStringInstance                                       );
SPrivate Func(void) SetCString       (          Ptr(CString  ) _CStringInstance  , Immutable CharArray _rawStringToSet);


struct CString_Def
{
	FPtr_CString_Init Initialize;

	bool Allocated;

	uInt64 length;

	CharArray RawStr;

	FPtr_ContainsCString  Contains;

	FPtr_CreateFromLiteral CreateFromLiteral;
	FPtr_ClearCString      Clear            ;
	FPtr_SetCString        Set              ;
};