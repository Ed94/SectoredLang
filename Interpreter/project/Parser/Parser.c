#include "Parser.h"


NoLink 
struct Parser
ParserObj = { nullptr }
;

#define CurrentScope    ParserObj.CurrentScope
#define CurrentToken    ParserObj.CurrentToken
#define LastNode        ParserObj.LastNode


void Parser_Init()
{
	CurrentToken = Lexer_NextToken();	
}

ast_Node* Parse_SpecUnit()
{
	Log("Parsing SpecUnit");

	ast_Node* node = ast_Node_Make(ASTnode_Unit_Spec);
	
#define specUnit node->SpecUnit
	while (CurrentToken->Type != Tok_Comp_EOF)
	{
		ast_Node* nextStatement = Parse_Stmt_SpecUnit();
		
		ast_SectorBody_Add(sectorBody, nextStatement);
	}
#undef specUnit
	
	return node;
}

ast_Node* Parse_Stmt_SpecUnit()
{
	switch(CurrentToken-.Type)
	{
		case Sym_Identifer :
			return Parse_Sector_Identifier():
		break;
		
		case Sec_Static :
			return Parse_Sector_Static();
		break;
	}
}

ast_Node* Parse_Sector_Identifier()
{
}

ast_Node* Parse_Sector_Static()
{
	Parser_EatToken(Sec_Static);
	
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Static);
	
	switch (CurrentToken.Type)
	{
		case Def_Start :
			Parser_EatToken(Def_Start);
			
			node = Parse_SectorBody_Static();
		break;
		
		case Sym_Identifer :
			node = Parse_Static_Identifier();
			// Sector definition is complete.
		break;

		case Def_End :
			Parser_EatToken(Def_End);
			// Sector definition is complete.
		break;
	}

	return node;
}

ast_Node* Parse_SectorBody_Static()
{
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Body);
	
	while (CurrentToken.Type != Def_End)
	{
		switch (CurrentToken.Type)
		{
			case Sym_Identifier :
				ast_SectorBody_Add(node->sectorBody, Parse_Static_Identifier());			
			break;
		}
	}
}

ast_Node* Parse_Static_Identifier()
{
	ast_Node* node = ast_Node_Make(ASTnode_Identifier);
	
	// Eaten: "static :" or "static"
	node->Identifier->Name = CurrentToken->Value;
	
	return node;
}

void Parser_EatToken(enum TokenType _type)
{
#define type    CurrentToken->Type
#define value   CurrentToken->Value
	
	if (type == _type)
	{
		CurrentToken = Lexer_NextToken();
	}

	LogF("Token: %s of Type: %s\n", value, TokenTo[type].Str)
	Fatal_Throw("Was unexpected...");
	
#undef type
#undef value
}

ast_Node* Parse(enum FileScopeType _type)
{
	switch (_type)
	{
		case CUT_Specification :
			return Parse_SpecUnit();
		break;
	}
}

ast_Node* Parse_Identifier()
{

}

ast_Node* Parse_Stmt()
{
	switch (CurrentToken->Type)
	{
		case Sym_Identifer :
			// return Parse_
		break;
		
		case Sec_Static :
			return Prase_Identifer();
		break;
	}
}

ast_Node* Parse_Stmts()
{
	ast_Node* node      = ast_Node_Make(ASTnode_Sector_Body);
	ast_Node* statement = Parse_Stmt();

#define sectorBody node->SectorBody
		sectorBody.Nodes[0] = statement;
		sectorBody.size     = 1;
	
	while (CurrentToken->Type == Def_End)
	{
		Parser_EatToken(Def_End);

		ast_Node* nextStatement = Parse_Stmt();
		
		sectorBody.Size++;
		sectorBody.Value = Mem_GlobalRealloc(AST_Node*, sectorBody.Node, sectorBody.Size);
	if (sectorBody.Value == nullptr)
		{
			Fatal_Throw("Failed to reallocate sector body.");
			return nullptr;
		}

	#define Next (sectorBody.Size -1)	

		sectorBody.Nodes[Next] = nextStatement;
		
	#undef Next
	}
	
#undef sectorBody
	
	return node;
}

ast_Node* Parse_AL_Expr();
ast_Node* Parse_Term_Addi();
ast_Node* Parse_Term_Mult();

ast_Node* Parse_Op_CallProc();

ast_Node* Parse_Symbol();
ast_Node* Parse_Literal_String();
 