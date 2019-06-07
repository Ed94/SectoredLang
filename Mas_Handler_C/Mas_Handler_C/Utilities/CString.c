//Parent Header
#include "CString.h"

#include "stdbool.h"
#include "string.h"

#include "TBF_CAssist.h"


Func(void) CString_Init(Ptr(CString) _CStringInst)
{
	_CStringInst->Initialize = Ref(CString_Init);

	_CStringInst->Contains = Ref(ContainsCString);

	_CStringInst->CreateFromLiteral = Ref(CreateFromLiteral);

	_CStringInst->Clear = Ref(ClearCString);

	_CStringInst->Set = Ref(SetCString);

	_CStringInst->Allocated = false;

	_CStringInst->length = 0;

	_CStringInst->RawStr = NULL;
}

Func(bool) ContainsCString(Ptr(CString) _CStringInstance, Ptr(CString) _substring)
{
	if (strstr(_CStringInstance->RawStr, _substring->RawStr) != NULL)
	{
		return true;
	}
	else
	{
		return false;
	}
}

Func(void) AllocateCharArray(Ptr(CharArray) _CharArrayInstance, uInt64 _numOfChars)
{
	//Ptr(void) charArrayRawPointer = (Ptr(void))_CharArrayInstance;

	Allocate(_CharArrayInstance, _numOfChars, sizeof(char), false);
}

Func(void) ClearCString(Immutable Ptr(CString) _CStringInstance)
{
	if (_CStringInstance->Allocated)
	{
		Deallocate(_CStringInstance->RawStr);
	}
}

Func(void) CreateFromLiteral(Ptr(CString) _CStringInstance, Immutable Ptr(char) _stringLiteral)
{
	size_t stringLength = 0;

	stringLength = strlen(_stringLiteral) + 1;

	AllocateCharArray(Ref(_CStringInstance->RawStr), stringLength);

	_CStringInstance->length = stringLength;

	strcpy_s(_CStringInstance->RawStr, _CStringInstance->length, _stringLiteral);

	_CStringInstance->Allocated = true;
}

Func(void) SetCString(Ptr(CString) _CStringInstance, Immutable CharArray _rawStringToSet)
{
	if (_CStringInstance->Allocated)
	{
		MemberFunc(_CStringInstance, Clear);
	}
	else
	{
		size_t stringLength = 0;

		stringLength = strlen(_rawStringToSet) + 1;

		AllocateCharArray(Ref(_CStringInstance->RawStr), stringLength);

		_CStringInstance->length = stringLength;
	}

	//strcpy_s(_rawStringToSet, _CStringInstance->length, _CStringInstance->RawStr);

	strcpy_s(_CStringInstance->RawStr, _CStringInstance->length, _rawStringToSet);

	_CStringInstance->Allocated = true;
}