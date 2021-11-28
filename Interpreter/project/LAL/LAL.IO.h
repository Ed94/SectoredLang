#ifndef LAL_IO__DEF

#include "LAL.C_STL.h"
#include "LAL.Declarations.h"
#include "LAL.FundamentalTypes.h"
#include "LAL.Exception.h"
#include "LAL.Memory.h"
#include "LAL.String.h"
#include "LAL.Types.h"


#define IO_StdIn    (IO_StdStream*)stdin
#define IO_StdOut   (IO_StdStream*)stdout
#define IO_StdError (IO_StdStream*)stderr


#ifdef LAL_zlib
typedef struct gzFile_s
#else
typedef FILE 
#endif
          IO_Stream, 
*         IO_StreamPtr,
*restrict IO_Stream_RPtr;

typedef FILE
IO_StdStream;


enum IO_AccessMode
{
	IO_AccessMode_Read   = 0,
	IO_AccessMode_Write  = 1,
	IO_AccessMode_Append = 2,

#ifdef LAL_zlib
	IO_AccessMode_ReadExtended   = IO_AccessMode_Read,
	IO_AccessMode_WriteExtended  = IO_AccessMode_Write,
	IO_AccessMode_AppendExtended = IO_AccessMode_Append,
#else
	IO_AccessMode_ReadExtended   = 3,
	IO_AccessMode_WriteExtended  = 4,
	IO_AccessMode_AppendExtended = 5,	
#endif
};

enum IO_CompressStrat
{
	IO_CompressStrat_Filtered,
	IO_CompressStrat_Huffman,
	IO_CompressStrat_RLE,
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

enum IO_Flush_Method
{
#ifdef LAL_zlib
	IO_Flush_None   = Z_NO_FLUSH,
	IO_Flush_Sync   = Z_SYNC_FLUSH,
	IO_Flush_Finish = Z_FINISH
#else
	IO_Flush_None,
	IO_Flush_Sync,
	IO_Flush_Finish
#endif
};


#pragma region Functions

#pragma region Private
ForceInline
ro_str* LAL_IO_getAccessModeString(void)
{
	static ro_str _AccessModeStrings[] =
	{
		"r",
		"w",
		"a",
		"r+",
		"w+",
		"a+"
	};
	
	return _AccessModeStrings;
}

ForceInline
ro_str* LAL_IO_getStrategyString(void)
{
	static ro_str _StrategyModeStrings[] =
	{
		"f",
		"h",
		"R"
	};
	
	return _StrategyModeStrings;
}

#pragma endregion 

ForceInline 
s32 IO_Close(IO_Stream* _stream_in)
{
#ifdef LAL_zlib
	return gzclose((gzFile)_stream_in);
#else
	return fclose(_stream_in);
#endif
}

ForceInline 
s32 IO_IsEndOfFile(IO_Stream* _stream_in)
{
#ifdef LAL_zlib
	return gzeof((gzFile)_stream_in);
#else
	return feof(_stream_in);
#endif
}

// Will only return a message if using zlib.
ForceInline
ErrorType IO_Error(IO_Stream* restrict _stream_in, ro_str* restrict _message)
{
#ifdef LAL_zlib
	ErrorType error;

	dref(_message) = gzerror((gzFile)_stream_in, ptrof(error));
	
	return error;
#else
	_message = nullptr;

	return ferror(_stream_in);
#endif
}

ForceInline
void IO_ErrorClear(IO_Stream* _stream_in)
{
#ifdef LAL_zlib
	gzclearerr(_stream_in);
#else
	clearerr(_stream_in);
#endif
}

// Flush method only needs specification if using zlib.
ForceInline
s32 IO_Flush(IO_Stream* _stream_in, enum IO_Flush_Method _method)
{
#ifdef LAL_zlib
	return gzflush(_stream_in, _method);
#else
	return fflush(_stream_in);
#endif
}

ForceInline 
ErrorType IO_Open(IO_Stream_RPtr* restrict _stream_out, const String* restrict _path, enum IO_AccessMode _accessMode)
{
	ro_nstr accessModeString = LAL_IO_getAccessModeString()[_accessMode];
	
#ifdef LAL_zlib
	dref(_stream_out) = gzopen(String_ro_str(_path), accessModeString);
	
	if (_stream_out)
	{
			return 0;
	}
	
	return Exception_GetLastError();
		
// Use OS_Vendor STL
#else
	return (ErrorType)fopen_s(_stream_out, StringTo_ro_str(_path), accessModeString);
#endif
}

ErrorType
IO_OpenZ
(
	IO_Stream_RPtr* restrict _stream_out,
	const String*   restrict _path,
	enum IO_AccessMode       _accessMode,
	u8                       _compressLevel,
	enum IO_CompressStrat    _strategy
);

ForceInline 
uDM IO_Read(IO_Stream* restrict _stream_in, void* restrict _buffer_out, uDM _size, uDM _count)
{
#ifdef LAL_zlib
	return (uDM)gzread(_stream_in, (void*)_buffer_out, (u32)_size * (u32)_count);
#else
	return fread((void*)_buffer_out, _size, _count, _stream_in);
#endif
}

ErrorType IO_ReadLine(IO_Stream* restrict _stream_in, str* restrict _line_out, uDM* _length_out);

ForceInline
nstr IO_Read_str(IO_Stream* restrict _stream_in, str restrict _string, s32 _count)
{
#ifdef LAL_zlib
		return gzgets(_stream_in, _string, _count);
#else
	#ifdef LAL_CharWidth_Narrow
		return fgets(_string, _count, _stream_in);

	#else // Wide
		return fgetwc(_string, _count, _stream_in);
	#endif
#endif
}

#ifdef LAL_zlib
	#define IO_SetCharMode(_stream_in, _mode) 
#else
ForceInline
	s32 IO_SetCharMode(IO_Stream* _stream_in, enum IO_CharMode _mode)
	{
		return fwide(_stream_in, (int)_mode);
	}
#endif

ForceInline
s32 IO_StdWriteV(IO_StdStream* restrict _stream_in, ro_str restrict _format, va_list _argList)
{
	return str_StdWriteV(_stream_in, _format, _argList);
}

ForceInline
s32 IO_StdWrite(IO_StdStream* restrict _stream_in, ro_str restrict _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = str_StdWriteV(_stream_in, _format, argList);
	va_end(argList);
		
	return result;
}

ForceInline
uDM IO_Write(IO_Stream* restrict _stream_in, void* restrict _buffer_in, uDM _size, uDM _count)
{
#ifdef LAL_zlib
	return (uDM)gzwrite(_stream_in, _buffer_in, (u32)_count * (u32)_size);
#else
	return fwrite(_buffer_in, _size, _count, _stream_in);
#endif
}

ForceInline
s32 IO_Write_CStr(IO_Stream* restrict _stream_in, ro_str restrict _string)
{
#ifdef LAL_zlib
	return gzputs(_stream_in, _string);
#else
	return fputs(_string, _stream_in);
#endif
}

#pragma endregion Functions


#pragma region Generics

#define T_IO_Read(TYPE__)\
ForceInline\
uDM TYPE__##_IO_Write \
(IO_StreamPtr restrict* _stream_in, Ptr(TYPE__) restrict _buffer_out, uDM _count)\
{\
	return IO_Read((void*)_buffer_out, sizeof(TYPE__), _count, _stream_in);\
}

#define T_IO_Write(TYPE__)\
ForceInline\
uDM TYPE__##_IO_Read\
(IO_StreamPtr restrict* _stream_in, TYPE__ restrict* _buffer_in, uDM _count)\
{\
	return IO_Write((void*)_buffer_in, sizeof(TYPE__), _count, _stream_in);\
}

#pragma endregion Generics

#define LAL_IO__DEF
#endif

