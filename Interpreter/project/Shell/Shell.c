#include "Shell.h"


void RunShell(void)
{
	Log("\nRunning shell...\n");
	Log("MAS Interpreter Shell");
	LogF(">");
	
	String  line    = { 0, nullptr };
	uDM     length  = 0;
	
#define linePtr ptrof(line)
	// IO_File_ReadLine(IO_StdIn, linePtr.Data, ptrof(length)); 
	// line.Length = length;
	
	// Log(line.Data);
#undef linePtr
}

