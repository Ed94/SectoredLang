#include "LAL.h"
#include "OSAL.h"
// Core
#include "Dev_Log.h"
// Shell
// #include "Shell/Shell.h"


#pragma region StaticData

static const 
struct OS_EnvArgsArray* 
EnvArgsArray = nullptr;

#pragma endregion StaticData


void Console_PrintTitle       (void);
void Console_PrintEnvArguments(void);
void ProcessFile              (void);
void RunShell                 (void);


void Console_PrintTitle(void)
{
	Log(sl"MAS Interpreter\n"); 
	Log(sl"Type: C");

	Log(sl"\n\n");

	Log(sl"App Env Arguments:\n");
}

void Console_PrintEnvArguments(void)
{
	for (uDM index = 0; index < EnvArgsArray->Count; index++)
	{
		LogF(sl"%lld : %s\n", index, EnvArgsArray->Arguments[index]);
	}

	Log(sl"\n");
}

void ProcessFile(void)
{
	String* filePath = strTo_String(EnvArgsArray->Arguments[1]);

	LogF(sl"Opening File: %s\n", filePath);
	
	IO_Stream* FileStream = nullptr;
	
	ErrorType ResultCode = IO_Open(getPtr(FileStream), filePath, IO_AccessMode_Read);

	if (! ResultCode)
	{
		Exception_Throw(sl"Failed to open the file.\n\n");
		
		return;
	}
	
	Log(sl"File successfuly opened\n");	
}

void RunShell(void)
{
	Log("Running shell...");
	
	Log(sl"\n\n");
	
	Log("MAS Interpreter Shell\n");
	
	Log(">");
	
	String line;
	uDM length;
#define linePtr getPtr(line)
	IO_ReadLine(IO_StdIn, String_str(linePtr), getPtr(length)); 

	String_SetLength(getPtr(line), length);
	
	Log(StringTo_str(linePtr));
#undef linePtr
}

OS_ExitVal 
OSAL_EntryPoint()
{
	Console_PrintTitle();

	EnvArgsArray = OSAL_GetEnvArgs();
	
	Console_PrintEnvArguments();

	if (EnvArgsArray->Count < 2)
	{
		Log(sl"No context file (<NameOfFile>.context>) was not provided.\n");
		Log(sl"\n\n");
	}
	else
	{
		Log("Checking first argument for file.\n");
	
		ProcessFile();
	}
	
	RunShell();

	Log(sl"\nPress enter to exit.\n");
	getchar();
	
	Mem_GlobalDealloc();
	
	return OS_ExitCode_Success;
}
