#if defined(TPAL_zpl) \
&& !defined(TPAL_IO_zpl__Def)
#   define  TPAL_IO_zpl__Def


ForceInline 
s32 IO_File_Close(IO_File* _file_in)
{
	return zpl_file_close(_file_in);
}

ForceInline
byte IO_File_GetByte(IO_File* _file_in)
{
	zpl_i64 cur_offset = IO_File_Cursor(_file_in);
	byte    buffer;
	// zpl_b32 result = 
	zpl_file_read_at(_file_in, ptrof buffer, 1, cur_offset);

	zpl_file_seek(_file_in, cur_offset + 1);
	
	return buffer;
}

ForceInline
s64 IO_File_Cursor(IO_File* _file_in)
{
	return zpl_file_tell(_file_in);
}

ForceInline 
ErrorType IO_File_Open(IO_File* restrict _file_out, ro_str restrict _path, enum IO_AccessMode _accessMode)
{
	return (ErrorType)zpl_file_open_mode(_file_out, _accessMode, _path);
}

ForceInline 
uDM IO_File_Read(IO_File* restrict _file_in, const void* restrict _buffer_out, sDM _size)
{
	return zpl_file_read(_file_in, _buffer_out, _size);
}

ForceInline
uDM IO_File_Write(IO_File* restrict _file_in, const void* restrict _buffer_in, sDM _size)
{
	return zpl_file_write(_file_in, _buffer_in, _size);
}


#endif  // TPAL_IO_zpl__Def
