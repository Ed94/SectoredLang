
//Parent Header
#include "CmdFlags.h"


void ClearFlags(Ptr(CmdFlags) _FlagsInstance)
{
	_FlagsInstance->Help         = false;
	_FlagsInstance->Quit         = false;
	_FlagsInstance->Console      = false;
	_FlagsInstance->IPC          = false;
	_FlagsInstance->WebFramework = false;
}

void InitializeFlags(Ptr(CmdFlags) _FlagsInstance)
{
	_FlagsInstance->Initialize = Ref(InitializeFlags);
	_FlagsInstance->Clear      = Ref(ClearFlags    );

	MemberFunc(_FlagsInstance, Clear);
}