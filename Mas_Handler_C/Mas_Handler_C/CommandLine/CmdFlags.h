#pragma once

#include "stdbool.h"

#include "TBF_CAssist.h"

typedef struct CmdFlags_Def CmdFlags;

typedef FuncRef(void, InitializeFlags, Ptr(CmdFlags));
typedef FuncRef(void, ClearFlags     , Ptr(CmdFlags));


         Func(void) InitializeFlags(Ptr(CmdFlags) _FlagsInstance);
SPrivate Func(void) ClearFlags     (Ptr(CmdFlags) _FlagsInstance);


struct CmdFlags_Def
{
	bool Help        ;
	bool Quit        ;
	bool Console     ;
	bool IPC         ;
	bool WebFramework;

	FPtr_InitializeFlags Initialize;
	FPtr_ClearFlags     Clear      ;
};