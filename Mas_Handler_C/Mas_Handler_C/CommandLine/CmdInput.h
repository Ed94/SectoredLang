#pragma once

//Includes
#include "stdbool.h"

#include "CmdFlags.h"
#include "CmdRegistry.h"


//Typedefs

typedef enum InputOption_Def InputOption;
typedef enum PollOption_Def  PollOption ;

typedef struct CmdInput_Def CmdInput;

typedef FuncRef(bool, CheckInput        , Ptr(CmdInput) _CmdInputInstance, CmdID _IdToCheck);
typedef FuncRef(void, ClearBank         , Ptr(CmdInput) _CmdInputInstance                  );
typedef FuncRef(void, CmdInput_Initalize, Ptr(CmdInput) _CmdInputInstance                  );
typedef FuncRef(void, ParseCmdInput     , Ptr(CmdInput) _CmdInputInstance                  );
typedef FuncRef(void, PollCmdInput      , Ptr(CmdInput) _CmdInputInstance, PollOption _pollToComplete                            );
typedef FuncRef(void, RefreshInput      , Ptr(CmdInput) _CmdInputInstance, InputOption _inputToUse   , PollOption _pollToComplete);


//Enums

enum InputOption_Def
{
	Input_Stdin,
};

enum PollOption_Def
{
	Option_Line,
};


//Functions

SPrivate Func(bool) CheckInput(Ptr(CmdInput) _CmdInputInstance, CmdID _IdToCheck);

SPrivate Func(void) ClearBank         (Ptr(CmdInput) _CmdInputInstance                                                         );
         Func(void) CmdInput_Initalize(Ptr(CmdInput) _CmdInputInstance                                                         );
SPrivate Func(void) ParseCmdInput     (Ptr(CmdInput) _CmdInputInstance                                                         );
SPrivate Func(void) PollCmdInput      (Ptr(CmdInput) _CmdInputInstance, PollOption  _pollToComplete                            );
SPrivate Func(void) RefreshInput      (Ptr(CmdInput) _CmdINputInstance, InputOption _inputToUse    , PollOption _pollToComplete);


//Struct

struct CmdInput_Def
{
	//Constructors

	FPtr_CmdInput_Initalize Initialize;

	//Public Functions

	FPtr_CheckInput        Check     ;
	FPtr_ClearBank         ClearBank ;
	FPtr_ParseCmdInput     Parse     ;
	FPtr_PollCmdInput      Poll      ;
	FPtr_RefreshInput      Refresh   ;

	//Declares

	CmdFlags    cmdBank    ;
	CmdKeywords cmdKeywords;

	CString userInput;
};