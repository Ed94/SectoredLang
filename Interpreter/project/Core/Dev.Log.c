#include "Dev.Log.h"


void Log(ro_str _message)
{
	IO_StdWrite(IO_StdOut, "%s\n", _message);
}

void LogF(ro_str _message, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _message);
		IO_StdWriteV(IO_StdOut, _message, argList);
	va_end(argList);
}
