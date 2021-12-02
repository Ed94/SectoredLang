#ifndef TPAL_IO_zpl__Def
#define TPAL_IO_zpl__Def

#include "LAL.IO.h"


ForceInline 
s32 IO_Close(IO_Stream* _stream_in)
{
	return zpl_file_close(_stream_in);
}

ForceInline 
s32 IO_IsEndOfFile(IO_Stream* _stream_in)
{
	return feof(_stream_in);
}

// Will only return a message if using zlib.
ForceInline
ErrorType IO_Error(IO_Stream* restrict _stream_in, ro_str* restrict _message)
{
	_message = nullptr;

	return ferror(_stream_in);
}

ForceInline
void IO_ErrorClear(IO_Stream* _stream_in)
{
	clearerr(_stream_in);
}

// Flush method only needs specification if using zlib.
ForceInline
s32 IO_Flush(IO_Stream* _stream_in, enum IO_Flush_Method _method)
{
	return fflush(_stream_in);
}

ForceInline 
ErrorType IO_Open(IO_Stream_RPtr* restrict _stream_out, const String* restrict _path, enum IO_AccessMode _accessMode)
{
	ro_nstr accessModeString = LAL_IO_getAccessModeString()[_accessMode];
	
	return (ErrorType)fopen_s(_stream_out, _path->Data, accessModeString);
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
	return fread((void*)_buffer_out, _size, _count, _stream_in);
}

ErrorType IO_ReadLine(IO_Stream* restrict _stream_in, str* restrict _line_out, uDM* _length_out);

ForceInline
nstr IO_Read_str(IO_Stream* restrict _stream_in, str restrict _string, s32 _count)
{
#ifdef LAL_CharWidth_Narrow
	return fgets(_string, _count, _stream_in);

#else // Wide
	return fgetwc(_string, _count, _stream_in);
#endif
}

ForceInline
s32 IO_SetCharMode(IO_Stream* _stream_in, enum IO_CharMode _mode)
{
	return fwide(_stream_in, (int)_mode);
}

ForceInline
uDM IO_Write(IO_Stream* restrict _stream_in, void* restrict _buffer_in, uDM _size, uDM _count)
{
	return fwrite(_buffer_in, _size, _count, _stream_in);
}

ForceInline
s32 IO_Write_CStr(IO_Stream* restrict _stream_in, ro_str restrict _string)
{
	return fputs(_string, _stream_in);
}


#endif  // TPAL_IO_zpl__Def
