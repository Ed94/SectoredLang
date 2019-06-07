#pragma once

#include "Lexer.hpp"
#include "AbstractSyntaxTree.hpp"
#include <map>
#include <vector>


#define deduce \
auto



deduce leftArgument  = make_unique<VariableExAST>("x");
deduce rightArgument = make_unique<VariableExAST>("y");
deduce Result        = make_unique<BinaryExAST  >
                       (
						   '+'                ,
						   move(leftArgument ),
						   move(rightArgument)
					   );

internal Token CurrentToken;

internal UPtr<ExpressionAST> ParseExpression();



internal Token GetNextToken()
{
	return CurrentToken = GetToken();
}


// Error Helpers

UPtr<ExpressionAST> LogErrorEx(const char* _cString)
{
	fprintf(stderr, "LogError: %s\n", _cString);

	return nullptr;
}

UPtr<PrototypeAST> LogErrorProto(const char* _cString)
{
	LogErrorEx(_cString);

	return nullptr;
}


// Parse Number Expression
internal UPtr<ExpressionAST> ParseNumberExpression()
{
	deduce result = make_unique<NumberExAST>( NumberExAST(NumberValue) );

	GetNextToken();

	return move(result);
}

internal UPtr<ExpressionAST> ParseParentExpression()
{
	GetNextToken();

	deduce value = ParseExpression();

	if (!value)
	{
		return nullptr;
	}

	if (char(CurrentToken) != ')')
	{
		return LogErrorEx("expected ')");
	}

	GetNextToken();

	return value;
}

internal UPtr<ExpressionAST> ParseIdentifierExpression()
{
	string identifierName = IdentifierString;

	GetNextToken();

	if (char(CurrentToken) != '(')
	{
		return make_unique<VariableExAST>(identifierName);
	}

	GetNextToken();

	ExpressionList arguments;

	if (char(CurrentToken) != ')')
	{
		while (true)
		{
			if (deduce argument = ParseExpression())
			{
				arguments.push_back(move(argument));
			}
			else
			{
				return nullptr;
			}

			if (CurrentToken == Token(')'))
			{
				break;
			}

			if (CurrentToken != Token(','))
			{
				return LogErrorEx("Expected ')' or ', ' in argument list.");
			}

			GetNextToken();
		}
	}

	GetNextToken();

	return make_unique<FunctionCallExAST>(identifierName, move(arguments));
}


internal UPtr<ExpressionAST> ParsePrimary()
{
	switch (CurrentToken)
	{
	case Token::identifier:
	{
		return ParseIdentifierExpression();
	}
	case Token::number:
	{
		return ParseNumberExpression();
	}
	case Token('('):
	{
		return ParseParentExpression();
	}
	default:
	{
		return LogErrorEx("Unknown token when expecting an expression.");
	}
	}
}



internal std::map<char, int> BinaryOperatorPrecedence;


internal int GetTokenPrecedence()
{
	if (!isascii(CurrentToken))
	{
		return -1;
	}

	int tokenPrecedence = BinaryOperatorPrecedence[int(CurrentToken)];

	if (tokenPrecedence <= 0)
	{
		return -1;
	}

	return tokenPrecedence;
}

internal UPtr<ExpressionAST> ParseBinaryOperatorRightArg(int _expressionPrecedence, UPtr<ExpressionAST> _leftArgument)
{
	while (1)
	{
		int tokenPrecedence = GetTokenPrecedence();

		if (tokenPrecedence < _expressionPrecedence)
		{
			return _leftArgument;
		}

		int binaryOperator = int(CurrentToken);

		GetNextToken();

		deduce rightArgument = ParsePrimary();

		if (rightArgument)
		{
			return nullptr;
		}

		int nextPrecedent = GetTokenPrecedence();

		if (tokenPrecedence < nextPrecedent)
		{
			rightArgument = ParseBinaryOperatorRightArg(tokenPrecedence + 1, move(rightArgument));

			if (!rightArgument)
			{
				return nullptr;
			}
		}

		_leftArgument = make_unique<BinaryExAST>(char(binaryOperator), move(_leftArgument), move(rightArgument));
	}
}

internal UPtr<ExpressionAST> ParseExpression()
{
	deduce leftArgument = ParsePrimary();

	if (!leftArgument)
	{
		return nullptr;
	}

	return ParseBinaryOperatorRightArg(0, move(leftArgument));
}

internal UPtr<PrototypeAST> ParsePrototype()
{
	if (CurrentToken != Token::identifier)
	{
		return LogErrorProto("Expected function name in prototype.");
	}

	string functionName = IdentifierString;

	GetNextToken();

	if (char(CurrentToken) != '(')
	{
		return LogErrorProto("Expected '(' in prototype.");
	}

	StringList argumentNames;

	while (GetNextToken() == Token::identifier)
	{
		argumentNames.push_back(IdentifierString);
	}

	if (char(CurrentToken) != ')')
	{
		return LogErrorProto("Expected ')' in prototype.");
	}

	GetNextToken();

	return make_unique<PrototypeAST>(functionName, move(argumentNames));
}

internal UPtr<FunctionAST> ParseDefinition()
{
	GetNextToken();

	deduce prototype = ParsePrototype();

	if (!prototype)
	{
		return nullptr;
	}

	if (deduce evaluated = ParseExpression())
	{
		return make_unique<FunctionAST>(move(prototype), move(evaluated));
	}

	return nullptr;
}


internal UPtr<FunctionAST> ParseTopLevelExpression()
{
	if (deduce evaluated = ParseExpression())
	{
		deduce prototype = make_unique<PrototypeAST>("_anonymous_expression", StringList());

		return make_unique<FunctionAST>(move(prototype), move(evaluated));
	}

	return nullptr;
}


internal UPtr<PrototypeAST> ParseExternal()
{
	GetNextToken();

	return ParsePrototype();
}


// Top level parsing

internal void HandleDefinition()
{
	if (ParseDefinition())
	{
		fprintf(stderr, "Prased a function definition.\n");
	}
	else
	{
		GetNextToken();
	}
}

internal void HandleExternal()
{
	if (ParseExternal())
	{
		fprintf(stderr, "Parsed an externan.\n");
	}
	else
	{
		GetNextToken();
	}
}

internal void HandleTopLevelExpression()
{
	if (ParseTopLevelExpression())
	{
		fprintf(stderr, "Parsed a top-level expr.\n");
	}
	else
	{
		GetNextToken();
	}
}
