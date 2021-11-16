#include "LAL_Memory.h"

#include "LAL_Exception.h"


NoLink  GlobalMemory =
{ NULL, 0U };


// Memory Allocation Array

NoLink
void* Internal_Reallocate(void* _memoryToReallocate, size_t _sizeDesired)
{
	return realloc(_memoryToReallocate, _sizeDesired);
}

#define Reallocate(_type, _memoryToReallocate, _numberDesired) \
(_type*)Internal_Reallocate(_memoryToReallocate, _numberDesired * sizeof(_type))

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
		MemBlockPtr* resizeIntermediary = Reallocate
		(
			struct MemBlock*, 
			_memoryArray->Array, 
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
	
	_memoryArray->Array[LastEntry] = Mem_Alloc(MemBlock*, 1);

	return _memoryArray->Array[LastEntry];
}

NoLink
MemBlock* AllocTable_LastEntry(AllocTable* _memoryArray)
{
	return _memoryArray->Array[LastEntry];
}

// Memory Management

void* Internal_ScopedAlloc(AllocTable* _scopedMemory, uDM _sizeOfAllocation)
{
	MemBlock* newBlock = MemoryBlockArray_Add(_scopedMemory);

	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_Alloc(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throws("Failed to scope allocate memory.");
	}
}

void* Internal_ScopedAllocClear(AllocTable* _scopedMemory, uDM _sizeOfAllocation)
{
	MemBlock* newBlock = MemoryBlockArray_Add(_scopedMemory);

	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_AllocClear(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throws("Failed to scope allocate memory.");
	}
}


void ScopedDealloc(AllocTable* _scopedMemory)
{
	for (uDM index = 0; index < _scopedMemory->Length; index++)
	{
		Deallocate(_scopedMemory->Array[index]->Location);
		Deallocate(_scopedMemory->Array[index]);
	}

	Deallocate(_scopedMemory->Array);

	return;
}

void* Internal_GlobalAlloc(uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(getPtr(GlobalMemory));
		
	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_Alloc(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to globally allocate memory.");
	}
}

void* Internal_GlobalAllocClear(uDM _sizeOfAllocation)
{
	MemBlock* newBlock = AllocTable_Add(getPtr(GlobalMemory));
		
	newBlock->Size     = _sizeOfAllocation;
	newBlock->Location = Mem_AllocClear(byte, _sizeOfAllocation);

	if (newBlock->Location != NULL)
	{
		return newBlock->Location;
	}
	else
	{
		Fatal_Throw("Failed to globally allocate memory.");
	}
}

void* Internal_GlobalRealloc(void* _location, uDM _sizeForReallocation)
{
	for (uDM index = 0; index < GlobalMemory.Length; index++)
	{
		if (GlobalMemory.Array[index]->Location == _location)
		{
			void* resizeIntermediary = Reallocate(byte, _location, _sizeForReallocation);

			if (resizeIntermediary != NULL)
			{
				GlobalMemory.Array[index]->Location = resizeIntermediary;

				return GlobalMemory.Array[index]->Location;
			}
			else
			{
				return NULL;
			}
		}
	}

	return NULL;
}

void GlobalDealloc(void)
{
	for (size_t index = 0; index < GlobalMemory.Length; index++)
	{
		Mem_Dealloc(GlobalMemory.Array[index]->Location);

		Mem_Dealloc(GlobalMemory.Array[index]);
	}

	Mem_Dealloc(GlobalMemory.Array);

	return;
}


#undef Reallocate
