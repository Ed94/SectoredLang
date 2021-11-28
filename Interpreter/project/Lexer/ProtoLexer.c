#include "ProtoLexer.h"


struct Lexer
LexerObj = {};


#define NullTerminator  '\0'
#define Whitespace      ' '


#define Index       LexerObj.Index
#define Contents    LexerObj.Contents
#define ContentSize LexerObj.ContentSize
#define CurrentChar LexerObj.CurrentChar

NoLink ForceInline
bool IsEndOfContent()
{
	return CurrentChar != NullTerminator && Index < ContentSize;
}

NoLink ForceInline
bool IsSymbol()
{
	return CurrentChar == '_' || schar_IsAlpha(CurrentChar);
}

NoLink ForceInline 
bool IsWhitespace()
{
	return CurrentChar != Whitespace || CurrentChar == 10;
}

#pragma region Public

void
Lexer_Init(str _contents)
{
	Contents    = _contents;
	Index       = 0;
	CurrentChar = Contents[Index];
	ContentSize = str_Length(Contents);
}

void 
Lexer_Advance()
{
	if (! IsEndOfContent())
	{
		Index++;
		CurrentChar = Contents[Index];
	}
}

void 
Lexer_SkipWS()
{
	while (IsWhitespace())
	{
		Lexer_Advance();
	}
}

Token* 
Lexer_NextToken()
{
	while (! IsEndOfContent())
	{
		if (IsWhitespace())
			Lexer_SkipWS();
			
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
	
	Fatal_NoEntry("Lexer_NextToken");
	return nullptr;
}

Token*
Lexer_AdvWithToken(Token* _token)
{
	Lexer_Advance();
	
	return _token;
}

Token* Lexer_CollectStr()
{
	Lexer_Advance();
	
	uDM collectLength   = str_Length(ptrof(Contents[Index]));
	str collectedStr    = Mem_GlobalAllocClear(schar, collectLength);
	
	str_Copy(collectedStr, collectLength, ptrof(Contents[Index]));
	
	return Token_Init(Literal_String, collectedStr);
}

Token* Lexer_CollectSymbol()
{
	Lexer_Advance();
	
	uDM collectLength = 0;
	
	while (CurrentChar == '_' || schar_IsAlphaNumeric(CurrentChar))
	{
		collectLength++;
	}
	
	if (collectLength)
	{
		str collectedStr = Mem_GlobalAllocClear(schar, collectLength);
		
		str_Copy(collectedStr, collectLength, ptrof(Contents[Index]));
		
		Lexer_Advance();
		
		return Token_Init(Literal_String, collectedStr);	
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
