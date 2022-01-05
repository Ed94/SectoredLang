#include "LAL.Memory.h"

#include "LAL.Exception.h"


// Later
// static 
// byte    Static_Memory
// [_64K];

static AllocTable 
Heap_GlobalMemory =
{ 0U, nullptr };


// Memory Allocation Array

#define LastEntry _memoryArray->Length -1

NoLink 
MemBlock* AllocTable_Add(AllocTable* _memoryArray)
{
	if (_memoryArray->Array == nullptr)
	{
		_memoryArray->Length = 1;
		_memoryArray->Array  = Mem_Alloc(MemBlock*, 1);
	}
	else
	{
		MemBlockPtr* resizeIntermediary = Mem_Resize
		(MemBlock*, 
			_memoryArray->Array, 
			_memoryArray->Length,
			(_memoryArray->Length + 1) 
		);
		
		if (resizeIntermediary != nullptr)
		{
			_memoryArray->Array = resizeIntermediary;
			_memoryArray->Length++;
		}
		else
		{
			Fatal_Throw("Failed to reallocate the global memory array. Exiting...");
		}
	}
	
	_memoryArray->Array[LastEntry] = Mem_Alloc(MemBlock, 1);

	return _memoryArray->Array[LastEntry];
}

// NoLink
// MemBlock* AllocTable_LastEntry(AllocTable* _memoryArray)
// {
// 	return _memoryArray->Array[LastEntry];
// }

// Memory Management

void* Internal_ScopedAlloc(AllocTable* _scopedMemory, uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(_scopedMemory);

	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_Alloc(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to scope allocate memory.");
		return nullptr;
	}
}

void* Internal_ScopedAllocClear(AllocTable* _scopedMemory, uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(_scopedMemory);

	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_AllocClear(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to scope allocate memory.");
		return nullptr;
	}
}

void ScopedDealloc(AllocTable* _scopedMemory)
{
	for (uDM index = 0; index < _scopedMemory->Length; index++)
	{
		Mem_Dealloc(_scopedMemory->Array[index]->Location);
		Mem_Dealloc(_scopedMemory->Array[index]);
	}

	Mem_Dealloc(_scopedMemory->Array);

	return;
}

void* Internal_Mem_GlobalAlloc(uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(ptrof Heap_GlobalMemory);
		
	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_Alloc(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to globally allocate memory.");
		return nullptr;
	}
}

void* Internal_Mem_GlobalAllocClear(uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(ptrof Heap_GlobalMemory);
		
	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_AllocClear(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to globally allocate memory.");
		return nullptr;
	}
}

void* Internal_Mem_GlobalRealloc(void* _location, uDM _sizeForReallocation)
{
	for (uDM index = 0; index < Heap_GlobalMemory.Length; index++)
	{
		if (Heap_GlobalMemory.Array[index]->Location == _location)
		{
			void* resizeIntermediary = Mem_Resize
			(byte, 
				_location, 
				Heap_GlobalMemory.Array[index]->Size,
				_sizeForReallocation
			);

			if (resizeIntermediary != NULL)
			{
				Heap_GlobalMemory.Array[index]->Location = resizeIntermediary;

				return Heap_GlobalMemory.Array[index]->Location;
			}
			else
			{
				return NULL;
			}
		}
	}

	return NULL;
}

void Mem_GlobalDealloc(void)
{
	for (uDM index = 0; index < Heap_GlobalMemory.Length; index++)
	{
		Mem_Dealloc(Heap_GlobalMemory.Array[index]->Location);

		Mem_Dealloc(Heap_GlobalMemory.Array[index]);
	}

	Mem_Dealloc(Heap_GlobalMemory.Array);

	return;
}

#undef Reallocate
#undef LastEntry
