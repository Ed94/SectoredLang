#include "LAL.IO.h"

#include "LAL.String.h"
#include "Dev.Log.h"


ErrorType 
IO_ReadLine(IO_Stream* restrict _stream_in, str* restrict _line_out, uDM* _length_out)
{
	#define line            dref(_line_out)
	#define length          dref(_length_out)
    #define line_bytebuffer (cast(byte*)(dref(_line_out)))
	
	uDM pos;
    u32 currentChar;

    if (_line_out == nullptr || _stream_in == nullptr || _length_out == nullptr) 
    {
        Exception_Throw("IO_ReadLine: Invalid reference");
        return EINVAL;
    }

    currentChar = getc(_stream_in);
    
    if (currentChar == EOF) 
    {
        Exception_Throw("IO_ReadLine: Hit EOF");
        return -1;
    }

    if (line == nullptr) 
    {
        line = Mem_GlobalAlloc(schar, 128);

        if (line == nullptr) 
        {
            Exception_Throw("IO_ReadLine: line is nullptr");
            return -1;
        }

        length = 128;
    }

    pos = 0;

    while (currentChar != EOF) 
    {
        if (pos + 1 >= length) 
        {
            uDM newSize = length + (length >> 2);
            
            if (newSize < 128) 
                newSize = 128;

            str newLine = Mem_GlobalRealloc(schar, line, newSize);

            if (newLine == nullptr)
            {
                Exception_Throw("IO_ReadLine: newLine is nullptr");
                return -1;
            }

            length = newSize;
            line   = newLine;
        }

        line_bytebuffer[pos ++] = currentChar;

        if (currentChar == '\n')
            break;

        currentChar = getc(_stream_in);
    }
    
    line_bytebuffer[pos] = currentChar;
    
    return 0;
    
	#undef line_bytebuffer
    #undef line
	#undef length
}

ErrorType
IO_OpenZ
(
	IO_Stream_RPtr* restrict _stream_out,
	const String*   restrict _path,
	enum IO_AccessMode       _accessMode,
	u8                       _compressLevel,
	enum IO_CompressStrat    _strategy
)
{
		schar  accessMode[8];
		ro_str accessModeBase = LAL_IO_getAccessModeString()[_accessMode];
		ro_str strategyStr    = LAL_IO_getStrategyString  ()[_strategy];
		
		str_Format(accessMode, sizeof(accessMode), "%s%o%s", accessModeBase, _compressLevel, strategyStr);
		
#ifdef LAL_zlib
		dref(_stream_out) = gzopen(StringTo_ro_str(_path), accessMode);
		
		if (_stream_out)
		{
			return 0;
		}
		
		return Exception_GetLastError();	
#endif
        return -1;
}
