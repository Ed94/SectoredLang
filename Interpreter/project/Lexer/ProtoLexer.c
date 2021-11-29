#include "ProtoLexer.h"


struct Lexer
LexerObj = {};


#define Index       LexerObj.Index
#define Contents    LexerObj.Contents
#define ContentSize LexerObj.ContentSize
#define CurrentChar LexerObj.CurrentChar

NoLink ForceInline
bool IsEndOfContent()
{
	return 
	   CurrentChar == Tok_Comp_EOF 
	|| Index >= ContentSize
	;
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
	||	CurrentChar == Tok_Comp_Null
	||  CurrentChar == Tok_Fmt_Tab
	||  CurrentChar == Tok_Fmt_CR
	||  CurrentChar == Tok_Fmt_NL
	||  CurrentChar == Tok_Fmt_OB
	||  CurrentChar == Tok_Fmt_CB
	;
}

#pragma region Public

void
Lexer_Init(str _contents)
{
	Log("Lexer_Init");

	Contents    = _contents;
	Index       = 0;
	CurrentChar = Contents[Index];
	ContentSize = str_Length(Contents);

	// LogF("\n I have no idea why... %s\n", TokenTo[0].Str);
	TokenTo[0].Str;
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
		Lexer_Advance();
	}
}

Token* Lexer_NextToken()
{
	while (! IsEndOfContent()) 
	{
		if (IsFormmatting())
		{
			Lexer_SkipFormmating();
		}
		
		if (IsEndOfContent())
		{
			Log("\nReached EOF");
			return nullptr;
		}
		
		enum TokenType
		Type = EToken_Invalid;
		
		if (IsSymbol())
		{
			return Lexer_CollectSymbol();
		}
			
		switch (CurrentChar)
		{
			case Tok_Params_PStart:
				Type = Params_PStart;
			break;
			
			case Tok_Params_PEnd:
				Type = Params_PEnd;
			break;

			case Tok_OP_Assign:
				Type = OP_Assign;
			break;
	
			case Tok_Def_Start:
				Type = Def_Start;
			break;

			case Tok_Def_End:
				Type = Def_End;
			break;

			case Tok_Literal_String_DLim:
				return Lexer_CollectStr();
			break;
		}
		
		// Single symbol tokens handling
		return Lexer_AdvWithToken(Token_Init(Type, scharTo_str(CurrentChar)));
	}
	
	Log("\nReached EOF");
	
	// Fatal_NoEntry("Lexer_NextToken");
	return nullptr;
}

Token* Lexer_AdvWithToken(Token* _token)
{
	Lexer_Advance();
	
	return _token;
}

Token* Lexer_CollectStr()
{
	uDM 
	collectLength = 1, 
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
		collectedStr = Mem_GlobalAllocClear(schar, collectLength -1 );
		collectedStr = Mem_FormatWithData(schar, collectedStr, ptrof Contents[Index + 1], collectLength -2);

		collectedStr[collectLength -1] = Tok_Comp_Null;
		
		if (! collectedStr)
		{
			Fatal_Throw("Failed to collect string literal, something went wrong with allocation or formmatting.");
			return nullptr;
		}

		Lexer_Jump(collectLength + 1);
		
		return Token_Init(Literal_String, collectedStr);	
	}
	else
	{
		Fatal_Throw("Could not collect valid string literal, string length was null");
		return nullptr;
	}
}

Token* Lexer_CollectSymbol()
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
			return Token_Init(_token, collectedStr);
			
			// Unversal

				InitIf(Sym_TType)

			// Layer 0

				InitIf(Sec_Static)
				
				InitIf(Sym_Ptr)
				InitIf(Sym_Byte)
					
		#undef Initif
		
			default :
				break;
		}
		
		return Token_Init(Sym_User, collectedStr);	
	}
	else
	{
		Fatal_Throw("Could not collect valid identifier, string length was null");
		return nullptr;
	}
}

#pragma endregion Public

#undef Index
#undef Contents
#undef ContentsSize
#undef CurrentChar
