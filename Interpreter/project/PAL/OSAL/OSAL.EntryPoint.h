/*
*/

#ifndef OSAL_EntryPoint__Def

#include "OSAL.Platform.h"


enum EOS_ExitCode
{
	OS_ExitCode_Success = EXIT_SUCCESS,
	OS_ExitCode_Failure = EXIT_FAILURE
};


typedef str   
  OS_EnvArg,
* OS_EnvArgPtr
;

typedef const str
  OS_ro_EnvArg,
* OS_ro_EnvArgPtr
;


struct OS_EnvArgs
{
	u32	       Count;
	OS_EnvArg* Arguments;
};

typedef struct OS_EnvArgs
OS_EnvArgs;


// Get Application's Environmental Arguments.
const OS_EnvArgs* 
OSAL_GetEnvArgs(void);

// Application entry point.
OS_ExitVal OSAL_EntryPoint(void);


#define OSAL_Entrypoint__Def
#endif
