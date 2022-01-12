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
	uw   Length;
	void* Ptr;
};

typedef void* 
FatPtr[2];

#define FatPtrT(__TYPE) \
struct FatPtr##__TYPE   \
{                       \
	uw      Length;     \
	__TYPE* Ptr;        \
}

// Addressing Constants

#define    nullptr    (void*)0
#define    null       { nullptr }


#pragma region      Formmating

void* Internal_Mem_FormatByFill  (void* _memoryAddress, s32         _fillValue,  uw _sizeOfData);
void* Internal_Mem_FormatWithData(void* _memoryAddress, const void* _dataSource, uw _sizeOfData);

#define              Mem_FormatByFill(_type, _memoryAddress, _fillValue, _sizeOfAllocation) \
cast(_type*)Internal_Mem_FormatByFill(_memoryAddress, _fillValue, sizeof(_type) * (_sizeOfAllocation))

#define              Mem_FormatWithData(_type, _memoryAddress, _dataSource, _numberToAllocate) \
cast(_type*)Internal_Mem_FormatWithData(_memoryAddress, _dataSource, sizeof(_type) * (_numberToAllocate))

#pragma endregion   Formmating

#pragma endregion   WIP Allocator

#pragma region Manual Management

void* Internal_Mem_Alloc     (uw _amount);
void* Internal_Mem_AllocClear(uw _num, uw _amount);
void* Internal_Mem_Resize    (void* _memoryAddress, sw _oldSize, sw _newSize);
void           Mem_Dealloc   (void* _memoryToDeallocate);

#define              Mem_Alloc(_type, _numberToAllocate) \
cast(_type*)Internal_Mem_Alloc(sizeof(_type) * (_numberToAllocate))

#define              Mem_AllocClear(_type, _numberToAllocate) \
cast(_type*)Internal_Mem_AllocClear(_numberToAllocate, sizeof(_type));

#define              Mem_Resize(_type, _memoryAddress, _currentNumber, _numberDesired) \
cast(_type*)Internal_Mem_Resize(_memoryAddress, sizeof(_type) * (_currentNumber), sizeof(_type) * (_numberDesired));

#pragma endregion Manual Management

#pragma region  WIP_Allocator

// #define Mem_Default_Alignment           (2 * sizeof(void*))
// #define Mem_Default_Allocator_Flags     (Mem_Allocator_Flag_Zerod)

// enum Mem_Allocator_Flag
// {
// 	Mem_Allocator_Flag_Zeroed = bit(0)
// };

// enum Mem_AllocatorType
// {
// 	Mem_Allocation_Alloc,
// 	Mem_Allocation_Dealloc,
// 	Mem_Allocation_DeallocAll,
// 	Mem_Allocation_Resize
// };

// typedef u32
// Mem_AllocatorType;

// typedef struct Mem_Allocator Mem_Allocator;
// typedef void fnPtr(Internal_Mem_AllocatorPtr)
// (Mem_AllocatorType _type, void* _data, uw _size, uw _alignment, void* _oldMem, uw _oldSize, uw _flags);

// void Internal_Mem_Allocator(Mem_AllocatorType _type, void* _data, uw _size, uw _alignment, void* _oldMem, uw _oldSize, uw _flags);

// struct Mem_Allocator
// {
// 	Internal_Mem_AllocatorPtr* Callback;
// 	void*                      Data;
// };

#define Mem_Define_Allocator_API(__Name)                                                         \
void*   Internal_##__Name##_Alloc        (uw _size);                                             \
void*   Internal_##__Name##_AllocAligned (uw _size, uw _alignment);                              \
void    Internal_##__Name##_Dealloc      (void* _ptr);                                           \
void    Internal_##__Name##_DeallocAll   ();                                                     \
void*   Internal_##__Name##_Resize       (void* _data, uw _oldSize, uw _newSize);                \
void*   Internal_##__Name##_ResizeAligned(void* _data, uw _oldSize, uw _newSize, uw _alignment); \


// #ifndef Mem_Default_Allocator
// #define Mem_Default_Allocator   Mem_Allocator
// #endif


// #ifndef Mem_Alloc
// #       define        Mem_Alloc(_Allocator, _Type, _Num) 
// 		cast(_Type*) Internal_##_Allocator##_Alloc(sizeof(_Type) * _Num)
// #endif
// #ifndef Mem_AllocAligned
// #       define       Mem_AllocAligned(_Allocator, _Type, _Num, _Alignment)) 
// 		cast(_Type*) Internal_##_Allocator##_Alloc(sizeof(_Type) * _Num, _Alignment)
// #endif
// #ifndef Mem_Dealloc
// #       define       Mem_Dealloc(_Allocator, ) 
// 		void         Internal_##_Allocator##_Dealloc()
// #endif
// #ifndef Mem_DeallocAll
// #       define       Mem_DeallocAll(_Allocator) 
// 		void         Internal_##_Allocator##_DeallocAll()
// #endif
// #ifndef Mem_Resize
// #       define Mem_Resize
// #endif
// #ifndef Mem_ResizeAligned
// #       define MemResizeAligned
// #endif

#pragma endregion  WIP_Mem_Alloc

#pragma region      Static Management
// 

// #define Def_StaticMemory()


#pragma endregion   Static Management

#pragma region      Basic Manager

// This memory manager does continous allocation throughout program lifetime,
// Never frees global allocation until application closes. 
// Only should be used with small programs that do not need a better solution.

#ifdef LAL_Use_BasicMemoryManager
struct MemBlock
{
	uw     Size;
	void*   Location;
};

typedef struct MemBlock
MemBlock,
*   MemBlockPtr,
**  MemBlockArray
;

struct AllocTable
{
	uw             Length;
	MemBlockArray   Array;
};

typedef struct AllocTable
AllocTable;


void* Internal_Mem_ScopedAlloc     (struct AllocTable* _scopedAllocations,           uw _sizeOfAllocation);
void* Internal_Mem_ScopedAllocClear(struct AllocTable* _scopedAllocations, uw _num, uw _sizeOfAllocation);
void  Mem_ScopedDeallocate         (struct AllocTable* _scopedAllocations);

void* Internal_Mem_GlobalAlloc     (                 uw _sizeOfAllocation   );
void* Internal_Mem_GlobalAllocClear(                 uw _sizeOfAllocation   );
void* Internal_Mem_GlobalRealloc   (void* _location, uw _sizeForReallocation);
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
Mem_ScopedDealloc(ptrof(scopedMemory));     \
}												\
return _value;                                  \
}

#endif // LAL_Use_BasicMemoryManager
#pragma endregion       Basic Manager


// TPAL Implementation
#include "TPAL.Memory.h"

#define LAL_Memory__Def
#endif
