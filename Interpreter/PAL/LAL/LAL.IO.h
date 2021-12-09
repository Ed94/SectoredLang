/*
Note:  This current implementation is heavily reliant on zpl.
*/

#ifndef LAL_IO__Def
#define LAL_IO__Def

#include "TPAL.h"
#include "Config.LAL.h"
#include "LAL.Declarations.h"
#include "LAL.String.h"
#include "LAL.Types.h"


enum IO_AccessMode
{
	IO_AccessMode_Read      = ZPL_FILE_MODE_READ,
	IO_AccessMode_Write     = ZPL_FILE_MODE_WRITE,
	IO_AccessMode_Append    = ZPL_FILE_MODE_APPEND,
	IO_AccessMode_ReadWrite = ZPL_FILE_MODE_RW
};

enum IO_Constants
{
	// Codes
	IO_EndOfFile = EOF,

	// Limits

	IO_MinBufferSize    = BUFSIZ,
	IO_MaxFileNameChars = FILENAME_MAX,
	IO_MaxOpenStreams   = FOPEN_MAX,
	
	// Buffer Types
	
	IO_FullyBuffered  = _IOFBF,
	IO_LineBuffered   = _IOLBF,
	IO_Unbuffered     = _IONBF
};

enum IO_CharMode
{
	Narrow = 0,
	Wide   = 1
};

enum IO_FileError
{
	IO_FileError_None               = ZPL_FILE_ERROR_NONE,
	IO_FileError_Invalid            = ZPL_FILE_ERROR_INVALID,
	IO_FileError_InvalidName        = ZPL_FILE_ERROR_INVALID_FILENAME,
	IO_FileError_Exists             = ZPL_FILE_ERROR_EXISTS,
	IO_FileError_NotExist           = ZPL_FILE_ERROR_NOT_EXISTS,
	IO_FileError_Permission         = ZPL_FILE_ERROR_PERMISSION,
	IO_FileError_TruncationFailure  = ZPL_FILE_ERROR_TRUNCATION_FAILURE,
	IO_FileError_NotEmpty           = ZPL_FILE_ERROR_NOT_EMPTY,
	IO_FileError_NameTooLong        = ZPL_FILE_ERROR_NAME_TOO_LONG,
	IO_FileError_Unknown            = ZPL_FILE_ERROR_UNKNOWN,
};


typedef struct IO_FileContent
IO_FileContent;


struct IO_FileContent
{
	zpl_allocator _Allocator;
	byte*         Data;
	sDM           Size;
};


#pragma region Functions

IO_FileContent  IO_File_ReadContent (ro_str _path, bool _addNullTermination);
byte32          IO_File_WriteContent(ro_str restrict _path, const void* restrict _buffer, sDM _size);
				// MFR : Mark For Removal
void            IO_File_ContentMFR  (IO_FileContent _content);

s32       IO_File_Close         (IO_File* _file_in);
s64       IO_File_Cursor        (IO_File* _file_in);
s64       IO_File_IsEOF         (IO_File* _file_in);
byte      IO_File_GetByte       (IO_File* _file_in);
ErrorType IO_File_Open          (IO_File* restrict _file_out, ro_str restrict _path, enum IO_AccessMode _accessMode);
uDM       IO_File_Read          (IO_File* restrict _file_in, const void* restrict _buffer_out, sDM _size);
uDM       IO_File_Write         (IO_File* restrict _file_in, const void* restrict _buffer_in, sDM _size);

s32 IO_StdWrite  (IO_Std* restrict _file_in, ro_str restrict _format, ...);
s32 IO_StdWriteV (IO_Std* restrict _file_in, ro_str restrict _format, va_list _argList);

#pragma endregion Functions

#pragma region Generics
#pragma endregion Generics


ForceInline
s32 IO_StdWrite(IO_Std* restrict _file_in, ro_str restrict _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = str_StdWriteV(_file_in, _format, argList);
	va_end(argList);
		
	return result;
}

ForceInline
s32 IO_StdWriteV(IO_Std* restrict _file_in, ro_str restrict _format, va_list _argList)
{
	return str_StdWriteV(_file_in, _format, _argList);
}


// TPAL
#include "TPAL.IO..h"


#endif // LAL_IO__Def
