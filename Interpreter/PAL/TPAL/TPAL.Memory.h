#if defined(TPAL_zpl)             \
&& !defined(TPAL_Memory_zpl__Def)
#   define  TPAL_Memory_zpl__Def

zpl_allocator Mem_GlobalAllocator(void);
ZPL_ALLOCATOR_PROC(Mem_GlobalAllocator_proc);

ForceInline
zpl_allocator Mem_GlobalAllocator(void)
{
	zpl_allocator allocator;

	allocator.proc = Mem_GlobalAllocator_proc;
	allocator.data = nullptr;

	return allocator;
}

ForceInline 
void* Internal_Mem_Alloc(uDM _amount)
{
	return zpl_malloc(_amount);
}

ForceInline
void* Internal_Mem_AllocClear(uDM _num, uDM _amount)
{
	void* allocation = zpl_malloc(_num * _amount);
	
	if (allocation)
	{
		Internal_Mem_FormatByFill(allocation, 0, _num * _amount);
		
		return allocation;
	}
	
	return nullptr;
}

ForceInline
void* Internal_Mem_Resize(void* _memoryAddress, sDM _oldSize, sDM _newSize)
{
	return zpl_resize(zpl_heap(), _memoryAddress, _oldSize, _newSize);
}

ForceInline
void Mem_Dealloc(void* _memoryToDeallocate)
{
	zpl_free(zpl_heap(), _memoryToDeallocate);
}

ForceInline 
void* Internal_Mem_FormatByFill(void* _memoryAddress, s32  _fillValue, uDM _sizeOfData)
{
	return zpl_memset(_memoryAddress, _fillValue, _sizeOfData);
}

ForceInline
void* Internal_Mem_FormatWithData(void* _memoryAddress, const void* _dataSource, uDM _sizeOfData)
{
	return zpl_memcopy(_memoryAddress, _dataSource, _sizeOfData);
}


#endif // TPAL_Memory_zpl__Def
