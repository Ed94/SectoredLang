#include "Lexer.h"


struct Lexer
LexerObj = 
{ 
	0, 
	nullptr,
	0, 
	0, 
	
	{ 0, 0, nullptr },  // TokenArray
	nullptr,
	nullptr		
};


#define Index           LexerObj.Index
#define Contents        LexerObj.Contents
#define ContentSize     LexerObj.ContentSize
#define CurrentChar     LexerObj.CurrentChar
#define NextChar        Contents[Index + 1]
#define Tokens          LexerObj.Tokens
#define PreviousToken   LexerObj.PreviousToken
#define CurrentToken    LexerObj.CurrentToken

NoLink ForceInline
void Tokens_Append()
{
	Tokens.Nodes[Tokens.Num] = CurrentToken;
	Tokens.Num++;
}

NoLink ForceInline
bool IsComment()
{
	return
		CurrentChar == '/'
	&&  CurrentChar == NextChar
	;
}

NoLink ForceInline
bool IsCommentBlock()
{
	return 
		CurrentChar == '/'
	&&  NextChar == '-'
	;
}

NoLink ForceInline
bool IsEndOfContent()
{
	return 
	   CurrentChar == Tok_Comp_EOF 
	|| CurrentChar == Tok_Comp_Null
	|| Index >= ContentSize
	;
}

NoLink ForceInline
bool IsDigit()
{
	return schar_IsDigit(CurrentChar);
}

NoLink ForceInline
bool IsSymbol()
{
	return 
	   CurrentChar == Tok_Comp_UnderS 
	|| schar_IsAlpha(CurrentChar)
	;
}

NoLink ForceInline 
bool IsFormmatting() 
{
	return 
	    CurrentChar == Tok_Comp_WS
	// ||  CurrentChar == Tok_Comp_Null
	||  CurrentChar == Tok_Fmt_Tab
	||  CurrentChar == Tok_Fmt_CR
	||  CurrentChar == Tok_Fmt_NL
	||  CurrentChar == Tok_Fmt_OB
	||  CurrentChar == Tok_Fmt_CB
	;
}

#pragma region Public

void
Lexer_Init(const String* _contents)
{
	Log("Lexer_Init");

	Contents    = _contents->Data;
	Index       = 0;
	CurrentChar = Contents[Index];
	ContentSize = str_Length(Contents);

	Tokens.Nodes    = Mem_GlobalAllocClear(Token*, _1K);
	Tokens.Capacity = _1K;
	Tokens.Num      = 0;
}

void
Lexer_Tokenize()
{
	
}

void 
Lexer_Advance()
{
	if (! IsEndOfContent())
	{
		Index++;
		CurrentChar = Contents[Index];

		// LogF("Lexer Advance: %c\n", CurrentChar);
	}

}

void
Lexer_Jump(uDM _num)
{   
	for (uDM index = 0; index < _num || IsEndOfContent(); index++)
	{
		Index++; 
		CurrentChar = Contents[Index];
	}
}

void 
Lexer_SkipFormmating()
{
	while (IsFormmatting() && !IsEndOfContent())
	{
		// LogF("Formmatting: %c\n", CurrentChar);
		Lexer_Advance();
	}
}

Token* Lexer_NextToken()
{
	PreviousToken = CurrentToken;
	
	loop
	{
		if (IsFormmatting())
		{
			Lexer_SkipFormmating();
			continue;
		}
		
		if (IsEndOfContent())
		{
			Log("\nReached EOF");

			CurrentToken = Token_EOF;
			break;
		}
		
		if (IsComment())
		{
			// CurrentToken = Lexer_Collect_Comment();
			Lexer_Collect_Comment();
			continue;
		}
		
		if (IsCommentBlock())
		{
			// CurrentToken =  Lexer_Collect_CommentBlock();
			Lexer_Collect_CommentBlock();
			continue;
		}
	
		if (IsDigit())
		{
			CurrentToken = Lexer_Collect_Decimal();
			break;
		}
		
		if (IsSymbol())
		{
			CurrentToken = Lexer_Collect_Symbol();
			break;
		}
			
		enum TokenType
		Type = Token_Invalid;
			
		switch (CurrentChar)
		{
		// Universal
			case Tok_Params_PStart:
				Type = Params_PStart;
			break;
			
			case Tok_Params_PEnd:
				Type = Params_PEnd;
			break;
			
			case Tok_Params_SBStart:
				Type = Params_SBStart;
			break;
			
			case Tok_Params_SBEnd:
				Type = Params_SBEnd;
			break;
			
			case Tok_OP_SMA:
				Type = OP_SMA;
			break;

			case Tok_Def_Start:
				Type = Def_Start;
			break;

			case Tok_Def_End:
				Type = Def_End;
			break;
			
			case Tok_Def_CD:
				Type = Def_CD;
			break;

		// Level 0
			case Tok_OP_Assign:
				Type = OP_Assign;
			break;
	
			case Tok_Literal_String_DLim:
				CurrentToken = Lexer_Collect_Str();
				Tokens_Append();
				return CurrentToken;
			break;
		}
		
		// Known value  tokens
		CurrentToken = Lexer_AdvWithToken(Token_Init(Type, scharTo_String(CurrentChar)));

		Tokens_Append();
		return CurrentToken;
	}
	
	Tokens_Append();
	return CurrentToken;
}

Token* Lexer_AdvWithToken(Token* _token)
{
	Lexer_Advance();
	
	return _token;
}

Token* Lexer_Collect_Comment()
{
	uDM
	collectLength = 0,
	collectIndex  = Index + 2;
	
	schar collectChar = Contents[collectIndex];
	
	while (collectChar != Tok_Fmt_NL)
	{
		collectChar = Contents[collectIndex ++];
		collectLength++;
	}
	
	if (collectLength)
	{
		String* collectedCmt = String_MakeReserve(collectLength);
		
		if (! collectedCmt)
		{
			Fatal_Throw("failed to reserve comment string.");
			return nullptr;
		}
		
		collectedCmt->Data = Mem_FormatWithData
		(schar,
			collectedCmt->Data,
			ptrof Contents[Index],
			collectLength
		);
		
		collectedCmt->Data[collectLength] = Tok_Comp_Null;
		
		if (! collectedCmt)
		{
			Fatal_Throw("Failed to collect comment, something went wrong with allocation or formmatting.");
			return nullptr;
		}

		Lexer_Jump(collectLength + 1);
		
		// return Token_Init(Cmt_Body, collectedCmt);	
		return nullptr;
	}
	else
	{
		return Token_CmtEmpty;
	}
}

Token* Lexer_Collect_CommentBlock()
{
	uDM
	collectLength = 0,
	collectIndex  = Index + 2;
	
	schar collectChar = Contents[collectIndex];
	
	while (collectChar != '-' && Contents[collectIndex + 1] != '/')
	{
		collectChar = Contents[collectIndex ++];
		collectLength++;
	}
	
	// For -/
	collectLength += 2;
	
	if (collectLength)
	{
		String* collectedCmt = String_MakeReserve(collectLength);
		
		if (! collectedCmt)
		{
			Fatal_Throw("failed to reserve comment string.");
			return nullptr;
		}
		
		collectedCmt->Data = Mem_FormatWithData
		(schar,
			collectedCmt->Data,
			ptrof Contents[Index],
			collectLength
		);
		
		collectedCmt->Data[collectLength - 2] = '-';
		collectedCmt->Data[collectLength - 1] = '/';
		collectedCmt->Data[collectLength    ] = Tok_Comp_Null;
		
		collectedCmt->Length = collectLength;
		
		if (! collectedCmt)
		{
			Fatal_Throw("Failed to collect comment, something went wrong with allocation or formmatting.");
			return nullptr;
		}

		Lexer_Jump(collectLength + 2);
		
		// return Token_Init(Cmt_Body, collectedCmt);	
		return nullptr;
	}
	else
	{
		Fatal_Throw("Failed to collect comment, something went wrong with collection.");
		return nullptr;
	}
}

Token* Lexer_Collect_Decimal()
{
	uDM
	collectLength = 1,
	collectIndex  = Index;
	
	schar collectChar = Contents[collectIndex];
	
	while (collectChar == IsDigit())
	{
		collectChar = Contents[collectIndex ++];
		collectLength++;
	}
	
	if (collectLength)
	{
		String* collectedDigits = String_MakeReserve(collectLength);
		
		if (! collectedDigits)
		{
			Fatal_Throw("Failed to reserve string.");
			return nullptr;
		}
		
		collectedDigits->Data = Mem_FormatWithData
		(schar, 
			collectedDigits->Data, 
			ptrof Contents[Index], 
			collectLength
		);
		
		collectedDigits->Data[collectLength] = Tok_Comp_Null;
		collectedDigits->Length              = collectLength;
		
		if (! collectedDigits)
		{
			Fatal_Throw("Failed to collect decimal literal, something went wrong with allocation or formmatting.");
			return nullptr;
		}
		
		Lexer_Jump(collectLength);
		
		return Token_Init(Literal_Digit, collectedDigits);
	}
	else
	{
		Fatal_Throw("Could not collect valid decimal literal...");
		return nullptr;
	}
}

Token* Lexer_Collect_Str()
{
	uDM 
	collectLength = 0, 
	collectIndex  = Index + 1;
	
	schar collectChar = Contents[collectIndex];
	
	while (collectChar != '"')
	{
		collectChar = Contents[collectIndex ++];
		collectLength++;
	}
	
	if (collectLength)
	{
		str 
		collectedStr = Mem_GlobalAllocClear(schar, collectLength);
		collectedStr = Mem_FormatWithData(schar, collectedStr, ptrof Contents[Index + 1], collectLength -1);

		collectedStr[collectLength] = Tok_Comp_Null;
		
		if (! collectedStr)
		{
			Fatal_Throw("Failed to collect string literal, something went wrong with allocation or formmatting.");
			return nullptr;
		}

		Lexer_Jump(collectLength + 1);
		
		return Token_Init(Literal_String, String_Make(collectedStr, collectLength));	
	}
	else
	{
		Fatal_Throw("Could not collect valid string literal, string length was null");
		return nullptr;
	}
}

Token* Lexer_Collect_Symbol()
{
	uDM 
	collectLength = 0, 
	collectIndex  = Index;
	
	schar collectChar = Contents[collectIndex];
	
	while (collectChar == '_' || schar_IsAlphaNumeric(collectChar))
	{
		collectChar = Contents[collectIndex ++];
		collectLength++;
	}
	
	if (collectLength)
	{
		str 
		collectedStr = Mem_GlobalAllocClear(schar, collectLength);
		collectedStr = Mem_FormatWithData(schar, collectedStr, ptrof Contents[Index], collectLength -1);
		collectedStr[collectLength] = Tok_Comp_Null;
		
		if (! collectedStr)
		{
			Fatal_Throw("Failed to collect symbol, something went wrong with allocation or formmatting.");
			return nullptr;
		}
		
		Lexer_Jump(collectLength - 1);
		
		switch (ToToken(collectedStr))
		{
		#define InitIf(_token)  \
		case _token :           \
			return Token_Init(_token, String_Make(collectedStr, collectLength));
			
			// Unversal

				InitIf(Sym_TType)

			// Layer 0

				InitIf(Sec_Stack)
				InitIf(Sec_Static)
				InitIf(Sec_Proc)
				
				InitIf(Sym_Ptr)
				InitIf(Sym_Byte)
					
		#undef Initif
		
			default :
				break;
		}
		
		return Token_Init(Sym_Identifier, String_Make(collectedStr, collectLength));	
	}
	else
	{
		Fatal_Throw("Could not collect valid identifier, string length was null");
		return nullptr;
	}
}

#pragma endregion Public


#undef Contents
#undef CurrentChar
#undef ContentsSize
#undef Index
#undef NextChar
#undef TokenArray
#undef PreviousToken
#undef CurrentToken
