#include "OSAL_EntryPoint.h"


#include "OSAL_Platform.h"


#pragma region StaticData

static
OS_AppHandle 
AppInstance;

static struct 
OS_EnvArgsArray
OS_EnvArgs;

#pragma endregion StaticData


#pragma region Public

const struct 
OS_EnvArgsArray* 
OSAL_GetEnvArgs(void)
{
	return 	
		(const struct OS_EnvArgsArray*)(getPtr(OS_EnvArgs))
	;
}

#pragma endregion Public



#pragma region Platform_Specific

#if IsWindows

#ifdef _WINDOWS
#ifdef WIN32

int 
WINAPI WinMain(HINSTANCE hInstance, HINSTANCE /* hPrevInstance */, LPSTR /* lpCmdLine */, int /* nShowCmd */)
{
	// OSAL_Record_EntryPoint_StartExecution();

	AppInstance = hInstance;

	int result = OSAL_EntryPoint();

	return result;
}
#define Entrypoint_Implemented

#endif
#endif
#endif



#if IsMac

#endif



#if IsLinux

#endif

#pragma endregion Platform_Specific


// If platform specifc entrypoint was not used, implement the standard.
#ifndef Entrypoint_Implemented

#ifdef LAL_CharWidth_Narrow

int 
main(int argc, char *argv[])
{
	AppInstance = nullptr;

	OS_EnvArgs.Count     = (u32)argc;
	OS_EnvArgs.Arguments = (OS_EnvArg*)argv;

	int result = OSAL_EntryPoint();

	return result;
}

#endif

#ifdef LAL_CharWidth_Wide

int
wmain(int argc, wchar_t *argv[])
{
	
	return 0;
}

#endif

#endif
