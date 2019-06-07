//Parent Header
#include "CmdRegistry.h"


Func(void) CmdKeywords_Init(Ptr(CmdKeywords) _cmdKeywordsInst)
{
	_cmdKeywordsInst->Initalize          = Ref(CmdKeywords_Init   );
	_cmdKeywordsInst->Destruct           = Ref(DestructCmdKeywords);

	_cmdKeywordsInst->DefineKeywords     = Ref(DefineKeywords    );
	_cmdKeywordsInst->UseDefaultKeywords = Ref(UseDefaultKeywords);

	CString_Init(Ref(_cmdKeywordsInst->KWord_Help        ));
	CString_Init(Ref(_cmdKeywordsInst->KWord_Quit        ));
	CString_Init(Ref(_cmdKeywordsInst->KWord_Console     ));
	CString_Init(Ref(_cmdKeywordsInst->KWord_IPC         ));
	CString_Init(Ref(_cmdKeywordsInst->KWord_WebFramework));


	MemberFunc(_cmdKeywordsInst, UseDefaultKeywords);
}

Func(void) DefineKeywords
(
	          Ptr(CmdKeywords) _CmdKeywordsInstance,
	Immutable Ptr(char) _HelpKeyword               ,
	Immutable Ptr(char) _QuitKeyword               ,
	Immutable Ptr(char) _ConsoleKeyword            ,
	Immutable Ptr(char) _IPCKeyword                ,
	Immutable Ptr(char) _WebFrameworkKeyword
)
{
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Help        ), CreateFromLiteral, _HelpKeyword        );
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Quit        ), CreateFromLiteral, _QuitKeyword        );
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Console     ), CreateFromLiteral, _ConsoleKeyword     );
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_IPC         ), CreateFromLiteral, _IPCKeyword         );
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_WebFramework), CreateFromLiteral, _WebFrameworkKeyword);
}

Func(void) DestructCmdKeywords(Immutable Ptr(CmdKeywords) _CmdKeywordsInstance)
{
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Help        ), Clear);
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Quit        ), Clear);
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_Console     ), Clear);
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_IPC         ), Clear);
	MemberFunc(Ref(_CmdKeywordsInstance->KWord_WebFramework), Clear);
}

Func(void) UseDefaultKeywords(Ptr(CmdKeywords) _CmdKeywordInstance)
{
	MemberFunc
	(
		_CmdKeywordInstance       , 
		DefineKeywords            , 
		Default_KWord_Help        , 
		Default_KWord_Quit        , 
		Default_KWord_Console     , 
		Default_KWord_IPC         , 
		Default_KWord_WebFramework
	);
}