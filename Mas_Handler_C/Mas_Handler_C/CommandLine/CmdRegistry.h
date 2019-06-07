#pragma once

//Includes
#include "CString.h"


//Macros

#define Default_KWord_Help \
"help"

#define Default_KWord_Quit \
"quit"

#define Default_KWord_Console \
"console"

#define Default_KWord_IPC \
"IPC"

#define Default_KWord_WebFramework \
"web framework"


//Alias

typedef enum CmdID_Def CmdID;

typedef struct CmdKeywords_Def CmdKeywords;

typedef FuncRef(void, CmdKeywords_Init, Ptr(CmdKeywords) _cmdKeywordsInst);

typedef \
FuncRef
(
	void                                           ,
	DefineKeywords                                 ,
	         Ptr(CmdKeywords) _CmdKeywordsInstance ,
	Immutable Ptr(char       ) _HelpKeyword        ,
	Immutable Ptr(char       ) _QuitKeyword        ,
	Immutable Ptr(char       ) _ConsoleKeyword     ,
	Immutable Ptr(char       ) _IPCKeyword         ,
	Immutable Ptr(char       ) _WebFrameworkKeyword
);

typedef FuncRef(void, DestructCmdKeywords, Immutable Ptr(CmdKeywords) _CmdKeywordsInstance);

typedef FuncRef(void, UseDefaultKeywords, Ptr(CmdKeywords) _CmdKeywordsInstance);


//Enums

enum CmdID_Def
{
	ID_Help        ,
	ID_Quit        ,
	ID_Console     ,
	ID_IPC         ,
	ID_WebFramework
};


//Functions

Func(void) CmdKeywords_Init(Ptr(CmdKeywords) _cmdKeywordsInst);

SPrivate Func(void) DefineKeywords
(
	          Ptr(CmdKeywords) _CmdKeywordsInstance,
	Immutable Ptr(char       ) _HelpKeyword        ,
	Immutable Ptr(char       ) _QuitKeyword        ,
	Immutable Ptr(char       ) _ConsoleKeyword     ,
	Immutable Ptr(char       ) _IPCKeyword         ,
	Immutable Ptr(char       ) _WebFrameworkKeyword
);

SPrivate Func(void) DestructCmdKeywords(Immutable Ptr(CmdKeywords) _CmdKeywordsInstance);
SPrivate Func(void) UseDefaultKeywords (          Ptr(CmdKeywords) _CmdKeywordInstance );


struct CmdKeywords_Def
{
	FPtr_CmdKeywords_Init    Initalize;
	FPtr_DestructCmdKeywords Destruct ;

	FPtr_DefineKeywords      DefineKeywords    ;
	FPtr_UseDefaultKeywords  UseDefaultKeywords;

	CString KWord_Help        ;
	CString KWord_Quit        ;
	CString KWord_Console     ;
	CString KWord_IPC         ;
	CString KWord_WebFramework;
};
