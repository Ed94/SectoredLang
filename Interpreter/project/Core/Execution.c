#include "OSAL.h"
#include "LAL.h"
// Core
#include "Dev.Log.h"
// Shell
#include "Shell.h"


#pragma region StaticData

static const 
OS_EnvArgs* 
EnvArgsArray = nullptr;

#pragma endregion StaticData


void Console_PrintTitle       (void);
void Console_PrintEnvArguments(void);
void ProcessFile              (void);
void RunShell                 (void);


void Console_PrintTitle(void)
{
	Log(sl"MAS Interpreter"); 
	Log(sl"Type: C");
	Log(sl"");

	Log(sl"App Env Arguments:");
}

void Console_PrintEnvArguments(void)
{
	for (uDM index = 0; index < EnvArgsArray->Count; index++)
	{
		LogF(sl"%lld : %s", index, EnvArgsArray->Arguments[index]);
	}

	Log(sl"");
}

void ProcessFile(void)
{
	String* 
	filePath = strTo_String(EnvArgsArray->Arguments[1]);

	LogF(sl"Opening File: %s\n", dref String_str(filePath));
	
	IO_Stream* 
	FileStream = nullptr;
	
	ErrorType 
	ResultCode = IO_Open(ptrof FileStream, filePath, IO_AccessMode_Read);

	if (ResultCode != 0)
	{
		Exception_Throw(sl"Failed to open the file.\n");
		return;
	}
	
	Log(sl"File successfuly opened\n");	
	
	String 
		streamBuffer    = {}, 
	ptr streamBufferPtr = ptrof streamBuffer;
	
	bool 
	result = String_Reserve(ptrof streamBuffer, _4K);
	
	if (! result)
	{
		Exception_Throw("Not able to reserve string.\n");
		return;
	}
	
	str rawBuffer = dref String_str(streamBufferPtr);
	
	IO_Read(FileStream, rawBuffer, 1, 128);

	Log(sl"Contents:\n");
	LogF("%s\n", rawBuffer);
}

OS_ExitVal 
OSAL_EntryPoint()
{
	Console_PrintTitle();

	EnvArgsArray = OSAL_GetEnvArgs();
	
	Console_PrintEnvArguments();

	if (EnvArgsArray->Count < 2)
	{
		Log(sl"No context file (<NameOfFile>.context>) was not provided.");
		Log(sl"\n");
	}
	else
	{
		Log("Checking first argument for file.");
	
		ProcessFile();
		
		Log("Finished processing file...");
	}
	
	RunShell();

	Log(sl"Press enter to exit.");
	getchar();
	
	Mem_GlobalDealloc();
	
	return OS_ExitCode_Success;
}
