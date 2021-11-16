/*
*/

#ifndef OSAL_EntryPoint__Def

#include "OSAL_Platform.h"


enum EOS_ExitCode
{
	OS_ExitCode_Success = EXIT_SUCCESS,
	OS_ExitCode_Failure = EXIT_FAILURE
};


typedef nStr     
  OS_EnvArg,
* OS_EnvArgPtr
;

typedef const nStr
  OS_ro_EnvArg,
* OS_ro_EnvArgPtr
;


struct OS_EnvArgsArray
{
	u32	       Count;
	OS_EnvArg* Arguments;
};


// Get Application's Environmental Arguments.
const struct 
OS_EnvArgsArray* 
OSAL_GetEnvArgs(void);

// Application entry point.
OS_ExitVal OSAL_EntryPoint(void);


#define OSAL_Entrypoint__Def
#endif
