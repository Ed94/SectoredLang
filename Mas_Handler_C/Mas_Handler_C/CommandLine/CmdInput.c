//Parent Header
#include "CmdInput.h"

#include "stdio.h"

#include "CString.h"

#include "Cmd.h"


Func(bool) CheckInput(Ptr(CmdInput) _cmdInputInstance, CmdID _IdToCheck)
{
	switch (_IdToCheck)
	{
	case ID_Help:
	{
		if (_cmdInputInstance->cmdBank.Help == FoundCmd)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	case ID_Quit:
	{
		if (_cmdInputInstance->cmdBank.Quit == FoundCmd)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	case ID_Console:
	{
		if (_cmdInputInstance->cmdBank.Console == FoundCmd)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	case ID_IPC:
	{
		if (_cmdInputInstance->cmdBank.IPC == FoundCmd)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	case ID_WebFramework:
	{
		if (_cmdInputInstance->cmdBank.WebFramework == FoundCmd)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	default:
		return false;
	}
}

Func(void) ClearBank(Ptr(CmdInput) _cmdInputInstance)
{
	MemberFunc(Ref(_cmdInputInstance->cmdBank), Clear);
}

Func(void) CmdInput_Initalize(Ptr(CmdInput) _cmdInputInstance)
{
	_cmdInputInstance->Initialize = Ref(CmdInput_Initalize);

	_cmdInputInstance->Check     = Ref(CheckInput   );
	_cmdInputInstance->ClearBank = Ref(ClearBank    );
	_cmdInputInstance->Parse     = Ref(ParseCmdInput);
	_cmdInputInstance->Poll      = Ref(PollCmdInput );
	_cmdInputInstance->Refresh   = Ref(RefreshInput );

	CString_Init(Ref(_cmdInputInstance->userInput));

	InitializeFlags(Ref(_cmdInputInstance->cmdBank));

	CmdKeywords_Init(Ref(_cmdInputInstance->cmdKeywords));
}

Func(void) ParseCmdInput(Ptr(CmdInput) _cmdInputInstance)
{
	_cmdInputInstance->cmdBank.Help         = (&_cmdInputInstance->userInput)->Contains(Ref(_cmdInputInstance->userInput), Ref(_cmdInputInstance->cmdKeywords.KWord_Help));
	_cmdInputInstance->cmdBank.Quit         = MemberFunc(Ref(_cmdInputInstance->userInput), Contains, Ref(_cmdInputInstance->cmdKeywords.KWord_Quit        ));
	_cmdInputInstance->cmdBank.Console      = MemberFunc(Ref(_cmdInputInstance->userInput), Contains, Ref(_cmdInputInstance->cmdKeywords.KWord_Console     ));
	_cmdInputInstance->cmdBank.IPC          = MemberFunc(Ref(_cmdInputInstance->userInput), Contains, Ref(_cmdInputInstance->cmdKeywords.KWord_IPC         ));
	_cmdInputInstance->cmdBank.WebFramework = MemberFunc(Ref(_cmdInputInstance->userInput), Contains, Ref(_cmdInputInstance->cmdKeywords.KWord_WebFramework));
}

Func(void) PollCmdInput(Ptr(CmdInput) _cmdInputInstance, PollOption _pollToComplete)
{
	switch (_pollToComplete)
	{
	case Option_Line:
	{
		bool inputResult = false;  char stdinTemp[32]; unsigned int numChars = 32U;

		//inputResult = getline(Ref(stdinTemp), numChars, stdin);

		//AllocateCharArray(stdinTemp, 32U);

		inputResult = scanf_s("%s", Ref(stdinTemp), _countof(stdinTemp));

		if (inputResult == true)
		{
			MemberFunc(Ref(_cmdInputInstance->userInput), Set, stdinTemp);
		}

		//Deallocate(stdinTemp);

		return;
	}
	}
}

Func(void) RefreshInput(Ptr(CmdInput) _cmdInputInstance, InputOption _inputToUse, PollOption _pollToComplete)
{
	switch (_inputToUse)
	{
	case Input_Stdin:
	{
		MemberFunc(_cmdInputInstance, Poll, _pollToComplete);

		MemberFunc(_cmdInputInstance, Parse);

		return;
	}
	default:
		return;
	}
}