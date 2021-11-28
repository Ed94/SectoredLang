#ifndef LAL_Memory__Def

#include "LAL.Declarations.h"
#include "LAL.FundamentalTypes.h"
#include "LAL.Types.h"

// Memory Sizes
#define _1K     1024
#define _2K     2048
#define _4K     4096
#define _8K     8192
#define _16K    16384
#define _32K    32768 
#define _64K    65536 
#define _128K   131072 
#define _256K   262144 
#define _512K   524288  
#define _1MB    1048576  

// Addressing Operation Wrappers

#define dref    *
#define ptr     *
#define ptrof   &

// Addressing Type

typedef    void*             Void_Ptr;
typedef    void* restrict    Void_RPtr;

#define    fnPtr(__NAME)   (*__NAME)

// Addressing Constants

#define    nullptr    (void*)0


#pragma region ManualManagement

ForceInline 
void* Internal_Mem_Alloc(uDM _amount)
{
	return malloc(_amount);
}

ForceInline
void* Internal_Mem_AllocClear(uDM _num, uDM _amount)
{
	return calloc(_num, _amount);
}

ForceInline
void Mem_Dealloc(void* _memoryToDeallocate)
{
	free(_memoryToDeallocate);
}

ForceInline 
void* Internal_Mem_FormatByFill(void* _memoryAddress, s32  _fillValue, uDM _sizeOfData)
{
	return memset(_memoryAddress, _fillValue, _sizeOfData);
}

ForceInline
void* Internal_Mem_FormatWithData(void* _memoryAddress, const void* _dataSource, uDM _sizeOfData)
{
	return memcpy(_memoryAddress, _dataSource, _sizeOfData);
}

#define Mem_Alloc(_type, _numberToAllocate) \
(_type*)Internal_Mem_Alloc(_numberToAllocate * sizeof(_type))

#define Mem_AllocClear(_type, _numberToAllocate) \
(_type*)Internal_Mem_AllocClear(_numberToAllocate, sizeof(_type));

#define Mem_FormatByFill(_type, _memoryAddress, _fillValue, _sizeOfAllocation) \
(_type*)Internal_Mem_FormatByFill(_memoryAddress, _fillValue, sizeof(_type) * _sizeOfAllocation)

#define Mem_FormatWithData(_type, _memoryAddress, _dataSource, _numberToAllocate) \
(_type*)Internal_Mem_FormatWithData(_memoryAddress, _dataSource, _numberToAllocate * sizeof(_type))

#pragma endregion ManualManagement


#pragma region Rudimentary MemoryManagement

struct MemBlock
{
	void*   Location;
	uDM     Size;
};

typedef struct MemBlock
	MemBlock,
*   MemBlockPtr,
**  MemBlockArray
;

struct AllocTable
{
	uDM             Length;
	MemBlockArray   Array;
};

typedef struct AllocTable
AllocTable;

void* Internal_Mem_ScopedAlloc     (struct AllocTable* _scopedAllocations,           uDM _sizeOfAllocation);
void* Internal_Mem_ScopedAllocClear(struct AllocTable* _scopedAllocations, uDM _num, uDM _sizeOfAllocation);
void  Mem_ScopedDeallocate         (struct AllocTable* _scopedAllocations);

void* Internal_Mem_GlobalAlloc     (                 uDM _sizeOfAllocation   );
void* Internal_Mem_GlobalAllocClear(                 uDM _sizeOfAllocation   );
void* Internal_Mem_GlobalRealloc   (void* _location, uDM _sizeForReallocation);
void  Mem_GlobalDealloc        (void);

#define Mem_GlobalAlloc(_type, _numberToAllocate) \
(_type*)Internal_Mem_GlobalAlloc(sizeof(_type) * _numberToAllocate)

#define Mem_GlobalAllocClear(_type, _numberToAllocate) \
(_type*)Internal_Mem_GlobalAllocClear(_numberToAllocate * sizeof(_type))

#define Mem_GlobalRealloc(_type, _address, _numberToReallocate) \
(_type*)Internal_Mem_GlobalRealloc(_address, sizeof(_type) * _numberToReallocate)

#define Mem_ScopedAlloc(_type, _numberToAllocate)  \
(_type*)Internal_ScopedAlloc(ptrof(scopedMemory), sizeof(_type) * _numberToAllocate)

#define Mem_ScopedAllocClear(_type, _numberToAllocate)  \
(_type*)Internal_ScopedAllocClear(ptrof(scopedMemory), _numberToAllocate * sizeof(_type))

#define SmartScope                  \
{					                \
	AllocTable scopedMemory =       \
	{ NULL, 0U };

#define SmartScope_End                              \
	if (scopedMemory.Array != NULL)                 \
	{								                \
		ScopedDealloc(ptrof(scopedMemory));     \
	}												\
}

#pragma endregion Rudimentary MemoryManagement


#define LAL_Memory__Def
#endif
