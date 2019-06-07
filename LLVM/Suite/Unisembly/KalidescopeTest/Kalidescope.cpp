#include "Parser.hpp"
#include "../llvm/include/llvm/IR/LLVMContext.h"

internal void Interpreter()
{
	while (true)
	{
		fprintf(stderr, "read> ");

		switch (CurrentToken)
		{
		case Token::endOfFile:
		{
			return;
		}
		case Token(';') :   // Ignore top-level semicolons.
		{
			GetNextToken();

			break;
		}
		case Token::define:
		{
			HandleDefinition();

			break;
		}
		case Token::external:
		{
			HandleExternal();

			break;
		}
		default:
		{
			HandleTopLevelExpression();

			break;
		}
		}
	}
}

using llvm::LLVMContext;

static LLVMContext TheContext;




int main()
{
	BinaryOperatorPrecedence['<'] = 10;
	BinaryOperatorPrecedence['+'] = 20;
	BinaryOperatorPrecedence['-'] = 20;
	BinaryOperatorPrecedence['*'] = 40;

	fprintf(stderr, "ready> ");

	GetNextToken();

	Interpreter();

	return 0;
}