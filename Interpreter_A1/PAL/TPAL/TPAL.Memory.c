#include "Config.TPAL.h"
#if defined(TPAL_zpl) \
&& !defined(TPAL_Memory_zpl__Def)
#   define  TPAL_Memory_zpl__Def

#include "LAL.Memory.h"


void* 
Mem_GlobalAllocator_proc(
	void*          _allocator_data, 
	zpl_alloc_type _type, 
	zpl_isize      _size, 
	zpl_isize      _alignment, 
	void*          _old_memory,
    zpl_isize      _old_size, 
    zpl_u64        _flags
)
{
	void* ptr = nullptr;
	
	if (! _alignment)
		_alignment = ZPL_DEFAULT_MEMORY_ALIGNMENT;
		
	switch (_type)
	{
		case ZPL_ALLOCATION_ALLOC :
			ptr = Internal_Mem_GlobalAlloc(_size);
		break;
		
		case ZPL_ALLOCATION_FREE :
			// Free occurs at app exit.
		break;
		
		case ZPL_ALLOCATION_RESIZE :
			ptr = Internal_Mem_GlobalRealloc(_old_memory, _size);
		break;
		
		case ZPL_ALLOCATION_FREE_ALL :
			// Free occurs at app exit.
		break;
	}
	
	return ptr;
}

#endif
