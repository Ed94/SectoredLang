// Parent Header
#include "Windows_Platform.h"



// Includes

#include "Execution.h"



// Macros

#define STANDARD_INPUT  stdin
#define STANDARD_OUTPUT stdout
#define STANDARD_ERROR  stderr



// Static Data

CTS_CString SConsole_In   = "CONIN$";
CTS_CString SConsole_Out  = "CONOUT$";
CTS_CString SConsole_Null = "NUL:";

CTS_CString SReadCode  = "r";
CTS_CString SWriteCode = "w";



// Functions


// Public

bool Bind_IOBufferTo_Console(void)
{
	FILE* dummyFile = NULL;


	freopen_s(&dummyFile, SConsole_In , SReadCode , STANDARD_INPUT );
	freopen_s(&dummyFile, SConsole_Out, SWriteCode, STANDARD_OUTPUT);
	freopen_s(&dummyFile, SConsole_Out, SWriteCode, STANDARD_ERROR );

	// Redirect STDIN if the console has an input handle	
	if (GetStdHandle(STD_INPUT_HANDLE) != INVALID_HANDLE_VALUE)
	{
		if (freopen_s(&dummyFile, SConsole_In , SReadCode , STANDARD_INPUT) != 0)
		{
			return false;
		}
		else
		{
			setvbuf(STANDARD_INPUT, NULL, _IONBF, 0);
		}
	}

	// Redirect STDOUT if the console has an output handle
	if (GetStdHandle(STD_OUTPUT_HANDLE) != INVALID_HANDLE_VALUE)
	{
		if (freopen_s(&dummyFile, SConsole_Out, SWriteCode, STANDARD_OUTPUT) != 0)
		{
			return false;
		}
		else
		{
			setvbuf(STANDARD_OUTPUT, NULL, _IONBF, 0);
		}
	}

	// Redirect STDERR if the console has an error handle
	if (GetStdHandle(STD_ERROR_HANDLE) != INVALID_HANDLE_VALUE)
	{
		if (freopen_s(&dummyFile, SConsole_Out, SWriteCode, STANDARD_ERROR) != 0)
		{
			return false;
		}
		else
		{
			setvbuf(STANDARD_ERROR, NULL, _IONBF, 0);
		}
	}

	return true;
}

bool RequestConsole(void)
{
	return AllocConsole();
}

bool Unbind_IOBufferTo_Console(void)
{
	FILE* dummyFile;


	// Just to be safe, redirect standard IO to NUL before releasing.

	// Redirect STDIN to NUL
	if (freopen_s(&dummyFile, SConsole_Null, SReadCode, STANDARD_INPUT) != 0)
	{
		return false;
	}
	else
	{
		setvbuf(STANDARD_INPUT, NULL, _IONBF, 0);
	}

	// Redirect STDOUT to NUL
	if (freopen_s(&dummyFile, SConsole_Null, SWriteCode, STANDARD_OUTPUT) != 0)
	{
		return false;
	}
	else
	{
		setvbuf(STANDARD_OUTPUT, NULL, _IONBF, 0);
	}

	// Redirect STDERR to NUL
	if (freopen_s(&dummyFile, SConsole_Null, SWriteCode, STANDARD_ERROR) != 0)
	{
		return false;
	}
	else
	{
		setvbuf(STANDARD_ERROR, NULL, _IONBF, 0);
	}

	return true;
}

bool GetKeySignal(EKeyCode _key)
{
	if (GetAsyncKeyState(_key) & 0x8000)
	{
		return true;
	}
	else
	{
		return false;
	}
}



// Private

INT WinMain()
{	
	EntryPoint();

	return 0;
}

