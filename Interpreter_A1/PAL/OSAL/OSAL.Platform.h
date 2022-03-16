/*
Operating System Abstraction Layer: Platform Definitions
*/

#ifndef OSAL_Platform__Def

#ifdef LAL_Def
					static_assert("Must not have LAL defined yet.")
#endif

#ifdef _WIN32
					#include "OSAL.API_Windows.h"
#endif
#ifdef __MACH__
#endif
#ifdef __linux__
#endif 


#include "LAL.h"


enum EOS
{
 	    EOS_Windows = 1,
#define M_OS_Windows  1

	    EOS_Mac     = 2,
#define M_OS_Mac      2

	    EOS_Linux   = 3 
#define M_OS_Linux    3
};


// OS Definition
#ifdef _WIN32
#       define  OS      EOS_Windows
#       define  M_OS    M_OS_Windows
#endif
#ifdef __MACH__
#       define  OS      EOS_Mac
#       define  M_OS    M_OS_Mac
#endif
#ifdef __linux__
#       define  OS      EOS_Linux
#       define  M_OS    M_OS_Linux
#endif 

#define IsWindows	M_OS == M_OS_Windows
#define IsMac		M_OS == M_OS_Mac
#define IsLinux		M_OS == M_OS_Linux

#if IsWindows

typedef     HINSTANCE   OS_AppHandle;
typedef     HANDLE      OS_Handle;
typedef     HWND        OS_WindowHandle;
typedef     LPSTR       OS_CStr;
typedef     LPCSTR      OS_RoCStr;

#define OS_InvalidHandle    INVALID_HANDLE_VALUE

typedef int 
OS_ExitVal;

#endif

#if IsMac

typedef int OS_HANDLE;

#endif

#if IsLinux

#endif


#pragma region Platform_API

// void 
// Load_Platform();

// const StringPtr 
// Get_OSName();


#pragma region OS_Version

struct OS_Version
{
	u32 Major;
	u32 Minor;
	u32 Patch;

	u32 Build;
};

typedef struct OS_Version*
OS_VersionPtr;


// StringPtr OS_Version_Str(OS_VersionPtr _osVersion);

const struct OS_Version*
Get_OS_Version(void);

#pragma endregion OS_Version

#pragma endregion Platform_API


#define OSAL_Platform__Def
#endif
