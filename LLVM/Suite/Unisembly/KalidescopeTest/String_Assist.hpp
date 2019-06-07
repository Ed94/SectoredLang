#pragma once
#include <cctype>
#include <string>

using std::string;

// Aliases

bool IsAscii(int _character)
{
	return isascii(_character);
}

bool IsAlphabetic(int _character)
{
	return isalpha(_character);
}

bool IsAlphanumeric(int _character)
{
	return isalnum(_character);
}

bool IsDigit(int _character)
{
	return isdigit(_character);
}

bool IsWhiteSpace(int _character)
{
	return isspace(_character);
}

double StringToDigit(const char* _cString, char** _endPointer)
{
	return strtod(_cString, _endPointer);
}
