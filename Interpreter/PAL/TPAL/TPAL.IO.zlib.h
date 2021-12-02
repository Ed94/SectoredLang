#ifndef TPAL_IO_zlib__Def

#include "LAL.IO.h"


ForceInline 
s32 IO_Close(IO_Stream* _stream_in)
{
	return gzclose((gzFile)_stream_in);
}

ForceInline 
s32 IO_IsEndOfFile(IO_Stream* _stream_in)
{
	return gzeof((gzFile)_stream_in);
}

ForceInline
ErrorType IO_Error(IO_Stream* restrict _stream_in, ro_str* restrict _message)
{
	ErrorType error;

	dref(_message) = gzerror((gzFile)_stream_in, ptrof(error));
	
	return error;
}

ForceInline
void IO_ErrorClear(IO_Stream* _stream_in)
{
	gzclearerr(_stream_in);
}

// Flush method only needs specification if using zlib.
ForceInline
s32 IO_Flush(IO_Stream* _stream_in, enum IO_Flush_Method _method)
{
	return gzflush(_stream_in, _method);
}

ForceInline 
ErrorType IO_Open(IO_Stream_RPtr* restrict _stream_out, const String* restrict _path, enum IO_AccessMode _accessMode)
{
	ro_nstr accessModeString = LAL_IO_getAccessModeString()[_accessMode];

	dref(_stream_out) = gzopen(String_ro_str(_path), accessModeString);
	
	if (_stream_out)
	{
			return 0;
	}
	
	return Exception_GetLastError();
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
	return (uDM)gzread(_stream_in, (void*)_buffer_out, (u32)_size * (u32)_count);
}

ErrorType IO_ReadLine(IO_Stream* restrict _stream_in, str* restrict _line_out, uDM* _length_out);

ForceInline
nstr IO_Read_str(IO_Stream* restrict _stream_in, str restrict _string, s32 _count)
{
	return gzgets(_stream_in, _string, _count);
}

ForceInline
uDM IO_Write(IO_Stream* restrict _stream_in, void* restrict _buffer_in, uDM _size, uDM _count)
{
	return (uDM)gzwrite(_stream_in, _buffer_in, (u32)_count * (u32)_size);
}

ForceInline
s32 IO_Write_CStr(IO_Stream* restrict _stream_in, ro_str restrict _string)
{
	return gzputs(_stream_in, _string);
}


#define TPAL_IO_zlib__Def
#endif
