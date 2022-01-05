#ifndef LAL_Memory__Def

#include "Config.LAL.h"
#include "TPAL.h"
#include "LAL.Declarations.h"
#include "LAL.Types.h"


#ifdef obj
#   undef obj
#endif

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

#define ro(__TYPE)      __TYPE const
#define ptr(__TYPE)     __TYPE*
#define ro_ptr(__TYPE)  __TYPE* const
#define dref            *
#define ptrof           &
// #define obj(__PTR)      (*__PTR)

// Addressing Type

typedef    void*             Void_Ptr;
typedef    void* restrict    Void_RPtr;

#define    fnPtr(__NAME)   (*__NAME)

struct FatPtr
{
	uDM   Length;
	void* Ptr;
};

typedef void* 
FatPtr[2];

#define FatPtrT(__TYPE) \
struct FatPtr##__TYPE   \
{                       \
	uDM     Length;     \
	__TYPE* Ptr;        \
}

// Addressing Constants

#define    nullptr    (void*)0
#define    null       { nullptr }


#pragma region      Formmating

#define              Mem_FormatByFill(_type, _memoryAddress, _fillValue, _sizeOfAllocation) \
cast(_type*)Internal_Mem_FormatByFill(_memoryAddress, _fillValue, sizeof(_type) * (_sizeOfAllocation))

#define              Mem_FormatWithData(_type, _memoryAddress, _dataSource, _numberToAllocate) \
cast(_type*)Internal_Mem_FormatWithData(_memoryAddress, _dataSource, sizeof(_type) * (_numberToAllocate))

#pragma endregion   Formmating

#pragma region Manual Management

void* Internal_Mem_Alloc     (uDM _amount);
void* Internal_Mem_AllocClear(uDM _num, uDM _amount);
void* Internal_Mem_Resize    (void* _memoryAddress, sDM _oldSize, sDM _newSize);
void           Mem_Dealloc   (void* _memoryToDeallocate);

void* Internal_Mem_FormatByFill  (void* _memoryAddress, s32         _fillValue,  uDM _sizeOfData);
void* Internal_Mem_FormatWithData(void* _memoryAddress, const void* _dataSource, uDM _sizeOfData);

#define              Mem_Alloc(_type, _numberToAllocate) \
cast(_type*)Internal_Mem_Alloc(sizeof(_type) * (_numberToAllocate))

#define              Mem_AllocClear(_type, _numberToAllocate) \
cast(_type*)Internal_Mem_AllocClear(_numberToAllocate, sizeof(_type));

#define              Mem_Resize(_type, _memoryAddress, _currentNumber, _numberDesired) \
cast(_type*)Internal_Mem_Resize(_memoryAddress, sizeof(_type) * (_currentNumber), sizeof(_type) * (_numberDesired));

#pragma endregion Manual Management

#pragma region      Static Management
// 

#define Def_StaticMemory()


#pragma endregion   Static Management

#pragma region      Basic Manager

// This memory manager does continous allocation throughout program lifetime,
// Never frees global allocation until application closes. 
// Only should be used with small programs that do not need a better solution.

#ifdef LAL_Use_BasicMemoryManager
struct MemBlock
{
	uDM     Size;
	void*   Location;
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
void  Mem_GlobalDealloc            (void);


#define              Mem_GlobalAlloc(_type,          _numberToAllocate) \
cast(_type*)Internal_Mem_GlobalAlloc(sizeof(_type) * (_numberToAllocate))

#define              Mem_GlobalAllocClear(_type,          _numberToAllocate) \
cast(_type*)Internal_Mem_GlobalAllocClear(sizeof(_type) * (_numberToAllocate))

#define              Mem_GlobalRealloc(_type, _address, _numberToReallocate) \
cast(_type*)Internal_Mem_GlobalRealloc(_address, sizeof(_type) * (_numberToReallocate))


// Smart memory via scope wrapping

#define smart_scope                 \
{					                \
	AllocTable scopedMemory =       \
	{ nullptr, 0U };
	
#define              Mem_ScopedAlloc(_type, _numberToAllocate)  \
cast(_type*)Internal_Mem_ScopedAlloc(ptrof(scopedMemory), sizeof(_type) * (_numberToAllocate))

#define              Mem_ScopedAllocClear(_type, _numberToAllocate) \
cast(_type*)Internal_Mem_ScopedAllocClear(ptrof(scopedMemory), sizeof(_type) * (_numberToAllocate))

#define smart_return(_value) \
                                                    \
	if (scopedMemory.Array != nullptr)              \
	{								                \
		Mem_ScopedDealloc(ptrof(scopedMemory));         \
	}												\
	return _value;                                  \
}

#endif // LAL_Use_BasicMemoryManager
#pragma endregion       Basic Manager


// TPAL Implementation
#include "TPAL.Memory.h"

#define LAL_Memory__Def
#endif
