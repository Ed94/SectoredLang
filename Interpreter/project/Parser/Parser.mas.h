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

typedef u32 
ECodeUnitType,
EScopeType;

typedef struct Parser
Parser;


struct Parser
{
	EScopeType  CurrentScope;
	Token*      CurrentToken;
	ast_Node*   LastNode;
};


void Parser_Init();

void Parser_EatToken(enum TokenType _type);

ast_Node* Parse(ECodeUnitType _type);

ast_Node* Parse_UnitSpec();

ast_Node* Parse_Stmt_UnitSpec();
ast_Node* Parse_Stmt();
ast_Node* Parse_Stmts();

ast_Node* Parse_Sector_Identifier();
ast_Node* Parse_Sector_Stack();
ast_Node* Parse_Sector_Static();
ast_Node* Parse_Sector_Proc();

ast_Node* Parse_SectorBody_Stack();
ast_Node* Parse_SectorBody_Static();
ast_Node* Parse_SectorBody_Proc();

ast_Node* Parse_Stack_Identifier();
ast_Node* Parse_Static_Identifier();
ast_Node* Parse_Proc_Identifier();

ast_Node* Parse_DataDef();
ast_Node* Parse_Proc_Body();

ast_Node* Parse_Identifier();

ast_Node* Parse_AL_Expr();
ast_Node* Parse_Term_Addi();
ast_Node* Parse_Term_Mult();

ast_Node* Parse_Op_Assign(ContextType _context, uw _depth);
ast_Node* Parse_Op_ProcCall(ContextType _context, uw _depth);

ast_Node* Parse_Literal_String();
ast_Node* Parse_Symbol();


#define Parser__Def
#endif
