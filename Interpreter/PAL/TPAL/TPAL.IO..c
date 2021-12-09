#include "Config.TPAL.h"
#if defined(TPAL_zpl) \
&& !defined(TPAL_IO_zpl__Def)
#   define  TPAL_IO_zpl__Def

#include "LAL.IO.h"


IO_FileContent IO_File_ReadContent(ro_str _path, bool _addNullTermination)
{
	zpl_file_contents result = zpl_file_read_contents(zpl_heap(), _addNullTermination, _path);
	
	return ocast(IO_FileContent, result);
}

s64 IO_File_IsEOF(IO_File* _file_in)
{
	bool result = false;
	
	zpl_i64
	currentPos, endPos;

	currentPos = zpl_file_tell(_file_in);

	zpl_file_seek_to_end(_file_in);

	endPos = zpl_file_tell(_file_in);

	if (currentPos == endPos )
	{
		result = true;
	}
	
	zpl_file_seek(_file_in, currentPos);	
	
	return result;
}

#endif
