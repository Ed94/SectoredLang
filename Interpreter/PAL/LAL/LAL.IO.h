#ifndef LAL_IO__DEF
#define LAL_IO__DEF

#include "LAL.C_STL.h"
#include "LAL.Declarations.h"
#include "LAL.Exception.h"
#include "LAL.Memory.h"
#include "LAL.String.h"
#include "LAL.Types.h"


#define IO_StdIn    (IO_StdStream*)stdin
#define IO_StdOut   (IO_StdStream*)stdout
#define IO_StdError (IO_StdStream*)stderr


#ifdef  LAL_zlib
typedef struct gzFile_s Internal_IO_Stream;

#elif   false && defined (LAL_zpl)
typedef zpl_file        Internal_IO_Stream;

#else
typedef FILE            Internal_IO_Stream;
#endif

typedef Internal_IO_Stream
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


s32       IO_Close      (IO_Stream* _stream_in);
	      // Will only return a message if using zlib.
ErrorType IO_Error      (IO_Stream* restrict _stream_in, ro_str* restrict _message);
void      IO_ErrorClear (IO_Stream* _stream_in);
s32       IO_Flush      (IO_Stream* _stream_in, enum IO_Flush_Method _method);
s32       IO_IsEndOfFile(IO_Stream* _stream_in);

ErrorType IO_Open(IO_Stream_RPtr* restrict _stream_out, const String* restrict _path, enum IO_AccessMode _accessMode);
ErrorType IO_OpenZ
(
	IO_Stream_RPtr* restrict _stream_out,
	const String*   restrict _path,
	enum IO_AccessMode       _accessMode,
	u8                       _compressLevel,
	enum IO_CompressStrat    _strategy
);

uDM       IO_Read    (IO_Stream* restrict _stream_in, void* restrict _buffer_out, uDM _size, uDM _count);
ErrorType IO_ReadLine(IO_Stream* restrict _stream_in, str* restrict _line_out, uDM* _length_out);
nstr      IO_Read_str(IO_Stream* restrict _stream_in, str restrict _string, s32 _count);

#ifdef LAL_zlib
	#define IO_SetCharMode(_stream_in, _mode)
#else
	s32 IO_SetCharMode(IO_Stream* _stream_in, enum IO_CharMode _mode);
#endif

s32 IO_StdWrite  (IO_StdStream* restrict _stream_in, ro_str restrict _format, ...);
s32 IO_StdWriteV (IO_StdStream* restrict _stream_in, ro_str restrict _format, va_list _argList);
uDM IO_Write     (IO_Stream* restrict _stream_in, void* restrict _buffer_in, uDM _size, uDM _count);
s32 IO_Write_CStr(IO_Stream* restrict _stream_in, ro_str restrict _string);

#pragma endregion Functions

#pragma region Generics
#pragma endregion Generics

// Implementation

#if     defined(LAL_zlib)
#       include "TPAL.IO.zlib.h"

#elif   false && defined(LAL_zpl)
// Not Ready yet, zpl has a different structure to its interface,
// will take time to adapt.
#       include "TPAL.IO.zpl.h"

#else   // Use STL
#       include "TPAL.IO.stl.h"
#endif

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
s32 IO_StdWriteV(IO_StdStream* restrict _stream_in, ro_str restrict _format, va_list _argList)
{
	return str_StdWriteV(_stream_in, _format, _argList);
}


#endif // LAL_IO__Def
