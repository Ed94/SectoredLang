#include "Lexer.h"


struct Lexer
LexerObj = 
{ 
	0, 
	nullptr,
	0, 
	0, 
	
	{ nullptr, nullptr },
	nullptr,
	nullptr		
};


#define Index           LexerObj.Index
#define Contents        LexerObj.Contents
#define ContentSize     LexerObj.ContentSize
#define CurrentChar     LexerObj.CurrentChar
#define NextChar        Contents[Index + 1]
#define Tokens          LexerObj.TokensArray
#define Tokens_Num		(dref LexerObj.TokensArray.Length)
#define PreviousToken   LexerObj.PreviousToken
#define CurrentToken    LexerObj.CurrentToken


Token* Lexer_MakeToken(ETokenType _type, const String* _value);


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
	&&  NextChar    == '-'
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
	// ||  CurrentChar == Tok_Fmt_OB
	// ||  CurrentChar == Tok_Fmt_CB
	;
}

void
Lexer_Init(const String* _contents)
{
	Log("Lexer_Init");

	Contents    = _contents->Data;
	Index       = 0;
	CurrentChar = Contents[Index];
	ContentSize = str_Length(Contents);

	if (Tokens.Data != nullptr)
		darray_Clear(ptrof Tokens);

	PreviousToken = nullptr;
	CurrentToken  = nullptr;
}

Token* 
Lexer_MakeToken(ETokenType _type, const String* _value)
{
	static bool _DoneOnce = false;
	if (! _DoneOnce)
	{
		_DoneOnce = true;

		darray_Init(ptrof Tokens);
	}

	Token newToken;

	newToken.Type  = _type;
	newToken.Value = _value;

	darray_Append(ptrof Tokens, newToken);

	// I need to make my own array container...
	zpl_array_header* header = ZPL_ARRAY_HEADER(Tokens.Data);

	LexerObj.TokensArray.Length = ptrof header->count;

	return ptrof Tokens.Data[Tokens_Num - 1];
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
Lexer_Jump(uw _num)
{   
	for (uw index = 0; index < _num || IsEndOfContent(); index++)
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

Token* Lexer_AdvWithToken(Token* _token)
{
	Lexer_Advance();
	
	return _token;
}

Token* Lexer_Collect_Comment()
{
	uw
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
		
		// return Lexer_MakeToken(Cmt_Body, collectedCmt);	
		return nullptr;
	}
	else
	{
		return Token_CmtEmpty;
	}
}

Token* Lexer_Collect_CommentBlock()
{
	uw
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
		
		// return Lexer_MakeToken(Cmt_Body, collectedCmt);	
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
	uw
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
		
		return Lexer_MakeToken(Literal_Digit, collectedDigits);
	}
	else
	{
		Fatal_Throw("Could not collect valid decimal literal...");
		return nullptr;
	}
}

Token* Lexer_Collect_Str()
{
	uw 
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
		
		return Lexer_MakeToken(Literal_String, String_Make(collectedStr, collectLength));	
	}
	else
	{
		Fatal_Throw("Could not collect valid string literal, string length was null");
		return nullptr;
	}
}

Token* Lexer_Collect_Symbol()
{
	uw 
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
			return Lexer_MakeToken(_token, String_Make(collectedStr, collectLength));
			
			// Unversal

				InitIf(Sec_Sym_Type)

			// Layer 0

				InitIf(OP_Sym_Ptr)

				InitIf(Sec_Stack)
				InitIf(Sec_Static)
				InitIf(Sec_Proc)
				
				InitIf(Sym_Byte)
					
		#undef Initif
		
			default :
				break;
		}
		
		return Lexer_MakeToken(Sym_Identifier, String_Make(collectedStr, collectLength));	
	}
	else
	{
		Fatal_Throw("Could not collect valid identifier, string length was null");
		return nullptr;
	}
}


#pragma region Public

void
Lexer_Tokenize(const String* _contents)
{
	Lexer_Init(_contents);

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

			LogF("\nType : %-15s, Value: %s", TokenTo[CurrentToken->Type].Str, CurrentToken->Value->Data);
			continue;
		}
		
		if (IsSymbol())
		{
			CurrentToken = Lexer_Collect_Symbol();

			LogF("\nType : %-15s, Value: %s", TokenTo[CurrentToken->Type].Str, CurrentToken->Value->Data);
			continue;
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

			case Tok_Params_ABStart:
				Type = Params_ABStart;
			break;

			case Tok_Params_ABEnd:
				Type = Params_ABEnd;
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

			case Tok_Def_StartB:
				Type = Def_Start;
			break;

			case Tok_Def_EndB:
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

				LogF("\nType : %-15s, Value: %s", TokenTo[CurrentToken->Type].Str, CurrentToken->Value->Data);
				continue;

			default:
			break;
		}

		CurrentToken = Lexer_MakeToken(Type, scharTo_String(CurrentChar));

		LogF("\nType : %-15s, Value: %s", TokenTo[CurrentToken->Type].Str, CurrentToken->Value->Data);
		
		// Known value tokens
		Lexer_AdvWithToken(CurrentToken);
	}

	if (dref (Tokens.Length) > 0)
	{
		Index = 0;
		CurrentToken = ptrof Tokens.Data[Index];
	}

	Log("Tokenized content..");
}

const Token*
Lexer_Next()
{
	switch (Index)
	{
		case 0:
			PreviousToken = nullptr;
			Index++;
			return CurrentToken;

		default :
			if (Index < Tokens_Num)
			{
				PreviousToken = CurrentToken;
				return CurrentToken = ptrof Tokens.Data[Index++];
			}
			else
			{
				PreviousToken = CurrentToken;

				return Token_EOF;
			}
	}
}

const Token*
Lexer_Previous()
{
	return PreviousToken;
}

const Token*
Lexer_TokenAt(uw _index)
{
	if (_index < Tokens_Num)
	{
		return ptrof Tokens.Data[_index];
	}

	return nullptr;
}

const Token*
Lexer_TokenRelative(sw _index)
{
	if (((Index + _index ) > 0)  && ((Index + _index) < Tokens_Num))
	{
		return ptrof Tokens.Data[Index + _index];
	}
	
	return nullptr;
}

void
Lexer_Reset()
{
	if (dref (Tokens.Length) > 0)
	{
		Index = 0;
		CurrentToken = ptrof Tokens.Data[Index];
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
