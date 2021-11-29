#include "Shell.h"


void RunShell(void)
{
	Log("\nRunning shell...\n");
	Log("MAS Interpreter Shell");
	LogF(">");
	
	String  line    = {};
	uDM     length  = 0;
	
#define linePtr ptrof(line)
	IO_ReadLine(IO_StdIn, String_str(linePtr), ptrof(length)); 

	String_SetLength(ptrof(line), length);
	
	Log(StringTo_str(linePtr));
#undef linePtr
}

