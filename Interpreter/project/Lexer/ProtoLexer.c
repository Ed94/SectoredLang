#include "ProtoLexer.h"


struct Lexer
Lexer = {};


#define NullTerminator  '\0'
#define Whitespace      ' '


#define Index Lexer.Index
#define Contents Lexer.Contents
#define ContentSize Lexer.ContentSize
#define CurrentChar Lexer.CurrentChar

NoLink ForceInline
bool IsEndOfContent()
{
	return CurrentChar != NullTerminator && Index < ContentSize;
}

NoLink ForceInline
bool IsSymbol()
{
	return CurrentChar == '_' || sChar_IsAlpha(CurrentChar);
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
		
		if (IsSymbol(CurrentChar))
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
				return Lexer_CollectStr;
			break;
		}

		// Single symbol tokens handling
		return Lexer_AdvWithToken(Token_Init(Type, sCharTo_str(CurrentChar)));
	}
}

Token*
Lexer_AdvWithToken(Token* _token)
{
	Lexer_Advance();
	
	return _token;
}

Token* Lexer_CollectSymbol()
{
	Lexer_Advance();
	
	uDM collectLength = 0;
	
	while (CurrentChar == '_' || sChar_IsAlphaNumeric(CurrentChar))
	{
		collectLength++;
	}
	
	if (collectLength)
	{
		str collectedStr = GlobalAllocClear(sChar, collectLength);
		
		str_Copy(collectedStr, collectLength, Contents[Index], collectLength);
		
		Lexer_Advance();
		
		return Token_Init(Literal_String, collectedStr);	
	}
	else
	{
		Fatal_Throw("Could not collect valid identifier, string length was null");
		return nullptr;
	}
}

Token* Lexer_CollectStr()
{
	Lexer_Advance();
	
	uDM collectLength = str_Length(Contents[Index]);
	str collectedStr = GlobalAllocClear(sChar, collectLength);
	
	str_Copy(collectedStr, collectLength, Contents[Index], collectLength);
	
	return Token_Init(Literal_String, collectedStr);
}

#pragma endregion Public

#undef Index
#undef Contents
#undef ContentsSize
#undef CurrentChar
