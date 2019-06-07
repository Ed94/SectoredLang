//Parent Header
#include "TBF_CAssist.h"


Func(void) Allocate
(
	Ptr(Ptr(void)) _instanceToAllocate,
	uInt64    _numOfObjects      ,
	size_t    _sizeOfObject      ,
	int       _shouldInitalize
)
{
	if (_shouldInitalize == 0)
	{
		Dref(_instanceToAllocate) = malloc(_sizeOfObject * _numOfObjects);
	}
	else
	{
		Dref(_instanceToAllocate) = calloc(_numOfObjects, _sizeOfObject);
	}

	return;
}

Func(void) Deallocate(Ptr(void) _instanceToDeallocate)
{
	if (_instanceToDeallocate != NULL)
	{
		free(_instanceToDeallocate);
	}
}