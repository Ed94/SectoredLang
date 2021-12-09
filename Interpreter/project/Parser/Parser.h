#ifndef Parser__Def

#include "AST.h"
#include "Lexer.h"


enum CodeUnitType
{
	CUT_AllInOne,
	CUT_Context,
	CUT_Blueprint,
	CUT_Specification,
};


typedef struct Parser
Parser;


struct Parser
{
	enum ScopeType  CurrentScope;
	Token*          CurrentToken;
	ast_Node*       LastNode;
};


void Parser_Init();

void Parser_EatToken(enum TokenType _type);

ast_Node* Parse(enum FileScopeType _type);

ast_Node* Parse_SpecUnit();

ast_Node* Parse_Stmt_SpecUnit();
ast_Node* Parse_Stmt();
ast_Node* Parse_Stmts();


ast_Node* Parse_Sector_Identifier();
ast_Node* Parse_Sector_Static();

ast_Node* Parse_SectorBody_Static();
ast_Node* Parse_Static_Identifier();

ast_Node* Parse_Identifier();

ast_Node* Parse_AL_Expr();
ast_Node* Parse_Term_Addi();
ast_Node* Parse_Term_Mult();

ast_Node* Parse_Op_CallProc();

ast_Node* Parse_Literal_String();
ast_Node* Parse_Symbol();


#define Parser__Def
#endif
