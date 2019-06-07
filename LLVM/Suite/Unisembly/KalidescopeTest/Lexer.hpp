#include "Cpp_Assist.hpp"
#include "String_Assist.hpp"



// Token Enum

enum class Token
{
	// Ignored

	comment = 0,
	

	// Parsing Related.
	endOfFile = -1,


	// Alpha-Numerics

	define     = -2,
	external   = -3,
	identifier = -4,


	// Data

	number = -5,
};



// Data

internal string IdentifierString;   // Filled in if identifier token found.
internal double NumberValue     ;   // Filled in if number     token found.



// Functions

internal Token ProcessAlphaNumeric(char& _lastCharacter)
{
	IdentifierString = _lastCharacter;

	_lastCharacter = getchar();

	while (IsAlphanumeric(_lastCharacter))   // Identifier can be: [a-zA-Z][a-zA-Z0-9]*	
	{
		IdentifierString += _lastCharacter;

		_lastCharacter = getchar();
	}

	if (IdentifierString == "define")
	{
		return Token::define;
	}

	if (IdentifierString == "external")
	{
		return Token::external;
	}

	else
	{
		return Token::identifier;
	}
}

internal void ProcessComment(char& _lastCharacter)
{
	do
	{
		_lastCharacter = getchar();
	}
	while 
	(
		_lastCharacter != EOF  && 
		_lastCharacter != '\n' &&
		_lastCharacter != 'r'
	);

	return;
}

internal Token ProcessDigit(char& _lastCharacter)
{
	std::string NumberString;

	do
	{
		NumberString += _lastCharacter;

		_lastCharacter = getchar();
	} 
	while (IsDigit(_lastCharacter) || _lastCharacter == '.');

	NumberValue = StringToDigit(NumberString.c_str(), 0);

	return Token::number;
}

internal Token GetToken();

internal Token ProcessToken(char& _lastCharacter)
{
	if (IsAlphabetic(_lastCharacter))
	{
		return ProcessAlphaNumeric(_lastCharacter);
	}

	if (IsDigit(_lastCharacter))
	{
		return ProcessDigit(_lastCharacter);
	}

	if (_lastCharacter == '#')
	{
		ProcessComment(_lastCharacter);

		if (_lastCharacter != EOF)
		{
			return GetToken();   // If we got here, that means that the last one was a comment,
								 // so we need to see if another token is available.
		}
		
		return Token::comment;
	}

	if (_lastCharacter == EOF)
	{
		return Token::endOfFile;
	}

	int ThisChar = _lastCharacter;

	_lastCharacter = getchar();

	return Token(ThisChar);
}

internal Token GetToken()
{
	static char lastCharacter = ' ';

	while (IsWhiteSpace(lastCharacter))
	{
		lastCharacter = char(getchar());	
	}

	return ProcessToken(lastCharacter);
}
