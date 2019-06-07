/*
Entry point for Handler is defined here.
*/

//Standard Library
#include "stdio.h"

#include "CmdInput.h"

//Trial By Fire
#include "TBF_CAssist.h"
#include "TBF_ConsoleIO.h"


ResultCode EntryPoint()
{
	CmdInput cmdInputInst;

	CmdInput_Initalize(Ref(cmdInputInst));

	PaddedConsoleOut("MAS Handler");

	PaddedConsoleOut("Please select an interfacing option. (Console, IPC, WebFramework");

	MemberFunc(Ref(cmdInputInst), Refresh, Input_Stdin, Option_Line);

	if (MemberFunc(Ref(cmdInputInst), Check, ID_Console))
	{
		printf("It worked");
	}
}