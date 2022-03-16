#ifndef LAL_Containers_Def

#include "Config.LAL.h"
#include "LAL.Memory.h"
#include "LAL.Types.h"


#                                                                    pragma region      DynamicArray
// Using the zpl implementation.

// TODO : Make your own dynamic array container
typedef 	struct zpl_array_header
			// {
			// 	zpl_allocator allocator;
			// 	zpl_isize	  capacity;
			// 	zpl_isize	  count;
			// 	char*         data;
			// }
DArray_Header;

#           define Def_DArray(_Type)        \
typedef     struct DArray_##_Type           \
			{                               \
				const sw*	Length;         \
				_Type* 		Data;           \
			}                               \
DArray_##_Type; 

#ifdef LAL_Use_BasicMemoryManager
#   define darray_Init(_array)                              					\
do 																				\
{ 																				\
	zpl_array_init((_array)->Data, Mem_GlobalAllocator());    					\
																				\
	zpl_array_header* header = (cast(zpl_array_header *)((_array)->Data) - 1); 	\
	(_array)->Length = &header->count; 											\
} while(0)
#else
#   define darray_Init(_array) \
	zpl_array_init(_array->Data, zpl_heap())
#endif

#define darray_InitWithAllocator(_array, _allocator) \
zpl_array_init((_array)->Data, _allocator);

#define darray_Append(_array, _obj) \
zpl_array_append((_array)->Data, _obj)

#define darray_AppendAt(_array, _obj, _index) \
zpl_array_append_at((_array)->Data, _obj, _index)

#define darray_CopyAndInit(_arrayDest, _arraySrc) \
zpl_array_copy_init((_array)->Data, (_arraySrc)->Data)

#define darray_Clear(_array) \
zpl_array_clear((_array)->Data)

#define darray_Fill(_array, _begin, _end, _value) \
zpl_array_fill((_array)->Data, _begin, _end, _value)

#define darray_Free(_array) \
zpl_array_free((_array)->Data)

#define darray_Grow(_array, _minCapacity) \
zpl_array_grow((_array)->Data, _minCapacity)

#define darray_Pop(_array) \
zpl_array_pop((_array)->Data)

#define darray_RemoveAt(_array, _index) \
zpl_array_remove_at((_array)->Data, _index)

#define darray_Reserve(_array, _capacity) \
zpl_array_reserve((_array)->Data, _capacity)

#define darray_Resize(_array, _newCount) \
zpl_array_resize((_array)->Data, _newCount)

#define darray_SetCapacity(_array, _newCapacity) \
zpl_array_set_capacity((_array)->Data, _newCapacity)

#                                                                    pragma endregion   DynamicArray


#                                                                     pragma region      StaticArray
#               define Def_SArray(_Type, _Length)   \
typedef         struct  SArray##_Length##_Type      \
				{                                   \
					uw   Num;                       \
					_Type Data[_Length];            \
				};                                  \
													\
SArray##_Length##_Type;                             \

#define sarray_Append(_array, _obj)                                     \
do                                                                      \
{                                                                       \
	if (_array->Num == sizeof(_array->Data))                            \
	{                                                                   \
		Fatal_Throw("sarray_Append: Entry number reached max length");  \
	}                                                                   \
																		\
	_array->Data[Num++] = _obj;                                         \
} while (0)

#define sarray_AppendAt(_array, _obj, _index) \
Fatal_NotImplemented()

#define sarray_Clear(_array)    \
do                              \
{                               \
	_array->Num = 0;            \
} while(0)                      

#define sarray_Fill(_array, _begin, _end, _value)                                                           \
do                                                                                                          \
{                                                                                                           \
	if ((_begin) < 0 || (_end) > sizeof(_array->Data))                                                      \
		Fatal_Throw("sarray_Fill: Range is not valid");                                                     \
																											\
	if (sizeof(_value) != sizeof(_array->Data[0]))                                                          \
		Fatal_Throw("sarray_Fill: Value is not valid.");                                                    \
                                                                                                            \
	Internal_Mem_FormatWithData(_array->Data[_begin], _value, sizeof(_array->Data[0]) * _end - _begin);     \
} while(0)

#define sarray_RemoveAt(_array, _index)\
Fatal_NotImplemented()

#define sarray_Pop(_array)                                          \
do                                                                  \
{                                                                   \
	if (_array->Num == 0)                                           \
		Fatal_Throw("sarray_Pop: Cannot pop from empty array");     \
																	\
	_array->Num--;                                                  \
} while (0);


#                                                                     pragma endregion   StaticArray


// https://github.com/attractivechaos/klib/blob/master/kvec.h
#                                                                         pragma region      K_Array
#define kArray_RoundUp32(x)     \
(                               \
	--(x),                      \
	  (x) |= (x) >> 1,          \
	  (x) |= (x) >> 2,          \
	  (x) |= (x) >> 4,          \
	  (x) |= (x) >> 8,          \
	  (x) |= (x) >> 16,         \
	++(x)                       \
)               

#define kArray_Pop(_array) \
((_array).Data[--(_array).Num])

#pragma region      Memory Management Dependent

/*
Functions Defined

kArray_Add
kArray_Copy
kArray_Destroy
kArray_Push
kArray_PushP (IDK)
*/

#ifdef LAL_Use_BasicMemoryManager


#       define karray_Destroy(_array)       \
		do                                  \
		{                                   \
			(_array).Capacity = 0;          \
			(_array).Num      = 0;          \
			(_array).Data     = nullptr;    \
		} while (0)
		
#       define karray_Resize(__Type, _array, _newSize)                              \
		do                                                                          \
		{                                                                           \
			(_array).Data     = Mem_GlobalRealloc(__Type, (_array).Data, _newSize); \
			(_array).Capacity = _newSize;                                           \
		} while (0)

#       define karray_Copy(__Type, _arrayDest, v0)                                              \
		do                                                                                      \
		{							                                                            \
			if ( (_arrayDest).Capacity < (_arraySrc).Num )                                      \
			{                                                                                   \
				karray_Resize(__Type, _arrayDest, (_arraySrc).Num);                             \
			}                                                                                   \
																								\
			(_arrayDest).Num = (_arraySrc).Num;                                                 \
																								\
			Mem_FormatWithData((__Type, (_arrayDest).Data, (_arraySrc).Data, (_arraySrc).Num);  \
		} while (0)	

#       define karray_Push(__Type, _array, _obj)                                                    \
		do                                                                                          \
		{									                                                        \
			if ((_array).Num == (_array).Capacity)                                                  \
			{										                                                \
				(_array).Capacity = (_array).Capacity ? (_array).Capacity << 1 : 2;                 \
				(_array).Data     = Mem_GlobalRealloc(__Type, (_array).Data, (_array).Capacity);	\
			}															                            \
																									\
			(_array).Data[(_array).Num++] = (_obj);                                                 \
		} while (0)

#       define karray_PushP(__Type, _array)                                                         \
		(                                                                                           \
			((_array).Num == (_array).Capacity) ?                                                   \
				(                                                                                   \
					(_array).Capacity = ((_array).Capacity ? (_array).Capacity << 1 : 2),           \
					(_array).Data = Mem_GlobalRealloc(__Type, (_array).Data, (_array).Capacity),    \
					0                                                                               \
				)                                                                                   \
				: 0                                                                                 \
		),                                                                                          \
		((_array).Data + ((_array).Num++) )

#       define karray_Add(__Type, _array, _index)                                                                   \
		(                                                                                                           \
			(                                                                                                       \
				(_array).Capacity <= (uw)(_index) ?                                                                 \
						(                                                                                           \
							(_array).Capacity = (_array).Num = (_index) + 1, karray_RoundUp32((_array).Capacity),   \
							(_array).Data     = Mem_GlobalRealloc(__Type, (_array).Data, (_array).Capacity), 0      \
																													\
						)                                                                                           \
						: (_array).Num <= (uDm)(_index)? (_array).Num = (_index) + 1                                \
				: 0                                                                                                 \
			),                                                                                                      \
			(_array).Data[(_index)]                                                                                 \
		)

#else   // Use Manaul Memory Management

#       define kArray_Destory(_array)   \
		do                              \
		{                               \
			_array.Capacity = 0;        \
			_array.Num      = 0;        \
			Mem_Dealloc(_array,Data);   \
		} while (0)
		
#       define kArray_Resize(__Type, _array, _newSize)                                      \
		do                                                                                  \
		{                                                                                   \
			_array.Data     = Mem_Resize(__Type, _array.Data, _array.Capacity, _newSize);   \
			_array.Capacity = _newSize;                                                     \
		} while (0);
		

#endif
#pragma endregion      Memory Management Dependent

#                           define kArray(_Type)   \
struct kArray_##_Type   \
{                       \
	uw    Capacity;    \
	uw    Num,         \
	_Type* Data;        \
}
#                                                                     pragma endregion       K_Array

#define LAL_Containers_Def
#endif
