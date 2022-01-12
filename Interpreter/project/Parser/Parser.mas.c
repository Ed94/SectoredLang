#include "Parser.mas.h"


NoLink 
struct Parser
ParserObj = { 0, nullptr, nullptr }
;

#define CurrentScope    ParserObj.CurrentScope
#define CurrentToken    ParserObj.CurrentToken
#define LastNode        ParserObj.LastNode


void Parser_Init()
{
	Log("Parser Init");
	CurrentToken = Lexer_Next();	
}

ast_Node* Parse_UnitSpec()
{
	Log("Parsing SpecUnit");

	ast_Node* node = ast_Node_Make(ASTnode_Unit_Spec);
	
#define specUnit                    node->UnitSpec
#define specUnit_Add(__Statement)   ast_UnitSpec_Add(ptrof specUnit, __Statement)
	while (CurrentToken->Type != Tok_Comp_EOF)
	{
		ast_Node* nextStatement = Parse_Stmt_UnitSpec();
		
		specUnit_Add(nextStatement);
	}
#undef specUnit_Add
#undef specUnit
	
	return node;
}

ast_Node* Parse_Stmt_UnitSpec()
{
	switch(CurrentToken->Type)
	{
		case Cmt_Body :
			Log("Parse: Comment Body");
			Parser_EatToken(Cmt_Body);
			return Parse_Stmt_UnitSpec();
		break;

		case Sym_Identifier :
			return Parse_Sector_Identifier();
		break;
		
		case Sec_Static :
			return Parse_Sector_Static();
		break;
		
		case Sec_Proc :
			return Parse_Sector_Proc();	
		break;
	}
	
	CurrentToken = Token_EOF;
	
	return nullptr;
}

ast_Node* Parse_Sector_Identifier()
{
	return nullptr;
}

ast_Node* Parse_Sector_Stack()
{
	Log("Prase: Sector Stack");
	Parser_EatToken(Sec_Stack);
	
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Stack);
	
	switch (CurrentToken->Type)
	{
		case Def_Start :
			Parser_EatToken(Def_Start);
			
			node->Sector.DefType    = SecDef_Body;
			node->Sector.Definition = Parse_SectorBody_Stack();
		break;
		
		case Sym_Identifier :
			node->Sector.DefType    = SecDef_Single;
			node->Sector.Definition = Parse_Static_Identifier();
			// Sector definition is complete.
		break;

		case Def_End :
			Parser_EatToken(Def_End);
			// Sector definition is complete.
		break;
	}

	return node;
}

ast_Node* Parse_Sector_Static()
{
	Log("Prase: Sector Static");
	Parser_EatToken(Sec_Static);
	
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Static);
	
	switch (CurrentToken->Type)
	{
		case Def_Start :
			Parser_EatToken(Def_Start);
			
			node->Sector.DefType    = SecDef_Single;
			node->Sector.Definition = Parse_SectorBody_Static();
		break;
		
		case Sym_Identifier :
			node->Sector.DefType    = SecDef_Body;
			node->Sector.Definition = Parse_Static_Identifier();
			// Sector definition is complete.
		break;

		case Def_End :
			Parser_EatToken(Def_End);
			// Sector definition is complete.
		break;
	}

	return node;
}

ast_Node* Parse_Sector_Proc()
{
	Log("Prase: Sector Procedure");
	Parser_EatToken(Sec_Proc);
	
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Proc);
	
	switch (CurrentToken->Type)
	{
		case Def_Start :
			Parser_EatToken(Def_Start);
			
			node->Sector.DefType    = SecDef_Body;
			node->Sector.Definition = Parse_SectorBody_Proc();
		break;
		
		case Sym_Identifier :
			node->Sector.DefType    = SecDef_Single;
			node->Sector.Definition = Parse_Proc_Identifier();
			// Sector definition is complete.
		break;
		
		case Def_End :
			Parser_EatToken(Def_End);
			// Sector definition is complete.
		break;
	}
	
	return node;
}

ast_Node* Parse_SectorBody_Stack()
{
	Log("Entering sector body stack");
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Body);
	
	while (CurrentToken->Type != Def_End)
	{
	#define sectorBody                      node->SectorBody
	#define sectorBody_Add(__Statement)     ast_SectorBody_Add(ptrof sectorBody, __Statement)
		switch (CurrentToken->Type)
		{
			case Sym_Identifier :
				sectorBody_Add(Parse_Stack_Identifier());			
			break;
		}
	#undef sectorBody
	#undef sectorBody_Add
	}
	
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_SectorBody_Static()
{
	Log("Entering sector body static");
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Body);
	
	while (CurrentToken->Type != Def_End)
	{
	#define sectorBody                      node->SectorBody
	#define sectorBody_Add(__Statement)     ast_SectorBody_Add(ptrof sectorBody, __Statement)
		switch (CurrentToken->Type)
		{
			case Sym_Identifier :
				sectorBody_Add(Parse_Static_Identifier());			
			break;
			
		default :
			Fatal_NoEntry("Static sector body cannot handle case.");
			return node;
		}
	#undef sectorBody
	#undef sectorBody_Add
	}
	
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_SectorBody_Proc()
{
	Log("Entering sector body proc");
	ast_Node* node = ast_Node_Make(ASTnode_Sector_Body);
	
	while (CurrentToken->Type != Def_End)
	{
	#define sectorBody                      node->SectorBody
	#define sectorBody_Add(__Statement)     ast_SectorBody_Add(ptrof sectorBody, __Statement)
		switch (CurrentToken->Type)
		{
			case Sym_Identifier :
				sectorBody_Add(Parse_Proc_Identifier());
			break;
		}
	#undef sectorBody
	#undef sectorBody_Add
	}
	
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_Stack_Identifier()
{
	Log("Parse: Stack Identifier");
	ast_Node* node = ast_Node_Make(ASTnode_Identifier);
	
	node->Identifier.Name = CurrentToken->Value;
	Parser_EatToken(Sym_Identifier);

	Parser_EatToken(Def_Start);
		node->Identifier.Definition = Parse_DataDef();
		
		LogF("Identifier: %s\n", node->Identifier.Name->Data);
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_Static_Identifier()
{
	Log("Parse: Static Identifier");
	ast_Node* node = ast_Node_Make(ASTnode_Identifier);
	
	node->Identifier.Name = CurrentToken->Value;
	Parser_EatToken(Sym_Identifier);

	Parser_EatToken(Def_Start);
		node->Identifier.Definition = Parse_DataDef();
		
		LogF("Identifier: %s\n", node->Identifier.Name->Data);
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_Proc_Identifier()
{
	LogF("Parse: Proc Identifier %s\n", CurrentToken->Value->Data);
	ast_Node* node = ast_Node_Make(ASTnode_Identifier);
	
	node->Identifier.Name = CurrentToken->Value;
	Parser_EatToken(Sym_Identifier);
	
	node->Identifier.Definition = Parse_Proc_Body();
	
	return node;
}

ast_Node* Parse_DataDef()
{
	ast_Node* node = ast_Node_Make(ASTnode_DataDef);
	
	if (CurrentToken->Type == OP_Sym_Ptr)
	{
		Parser_EatToken(OP_Sym_Ptr);	
		
		static 
		String  _PtrStr = STok_OP_Sym_Ptr;
		String* ptrType = String_MakeReserve(_PtrStr.Length + 1 + CurrentToken->Value->Length);
		
		String_Append_WFormat(ptrType, "ptr %s", CurrentToken->Value->Data);
		
		node->DataDef.Type = ptrType;
	}
	else
	{
		node->DataDef.Type = CurrentToken->Value;
	}

	LogF("DataDef Type: %s\n", node->DataDef.Type->Data);

	Parser_EatToken(CurrentToken->Type);
	if (CurrentToken->Type == OP_Assign)
	{
		Parser_EatToken(OP_Assign);

		node->DataDef.Value = CurrentToken->Value;

		LogF("DataDef Value: %s\n", node->DataDef.Value->Data);

		Parser_EatToken(CurrentToken->Type);
	}

	return node;	
}

ast_Node* Parse_Proc_Body()
{
	Log("Parsing proc body");
	
	Parser_EatToken(Def_Start);

	ast_Node* node = ast_Node_Make(ASTnode_Proc_Body);
	
	loop { switch (CurrentToken->Type)
	{
	#define procBody                    node->ProcBody
	#define procBody_Add(__Statement)   ast_ProcBody_Add(ptrof procBody, __Statement)

		case Sym_Identifier :
			Log("Symbol statement");

			LogF("Parent Symbol: %s\n", CurrentToken->Value->Data);

			String*  identifierStmt[Identifier_MaxContextDepth];
			uw      index = 0;
			
			identifierStmt[index++] = CurrentToken->Value;
			Parser_EatToken(Sym_Identifier);
			
			loop 
			{
				switch (CurrentToken->Type)
				{
					case OP_SMA :
						Log("SMA");
						Parser_EatToken(OP_SMA);
					break;
					
					case Sym_Identifier :
						LogF("NestedSymbol: %s\n", CurrentToken->Value->Data);
						identifierStmt[index++] = CurrentToken->Value;
						Parser_EatToken(Sym_Identifier);
					break;
					
					case OP_Assign :
						Parse_Op_Assign(identifierStmt, index);
					break;

					case Params_PStart :
						procBody_Add(Parse_Op_ProcCall(identifierStmt, index));	
						goto Loop_Return;
					
					case Def_End       :
						procBody_Add(Parse_Op_ProcCall(identifierStmt, index));
						goto Loop_Return;
				}
				
				if (index == Identifier_MaxContextDepth)
				{
					Fatal_Throw("Parse_Proc_body: At identifierStmt capacity!");
					return nullptr;
				}
			}
	Loop_Return:
		break;
		
		case Sec_Stack :
			procBody_Add(Parse_Sector_Stack());
		break;
		
		case Def_End :
			Parser_EatToken(Def_End);
			goto ReturnBody;

	#undef procBody
	#undef procBody_Add
	}}
	
ReturnBody:
	return node;
}

void Parser_EatToken(enum TokenType _type)
{
#define type    CurrentToken->Type
#define value   CurrentToken->Value->Data
	
	if (type == _type)
	{
		CurrentToken = Lexer_Next();
		return;
	}

	LogF("Token: %s of Type: %s\n", value, TokenTo[type].Str);
	Fatal_Throw("Was unexpected...");
	
#undef type
#undef value
}

ast_Node* Parse(ECodeUnitType _type)
{
	switch (_type)
	{
		case CUT_Specification :
			return Parse_UnitSpec();
		break;
	}
	
	return nullptr;
}

ast_Node* Parse_Identifier()
{
	return nullptr;
}

ast_Node* Parse_Stmt()
{
	// switch (CurrentToken->Type)
	// {
	// 	case Sym_Identifer :
	// 		// return Parse_
	// 	break;
		
	// 	case Sec_Static :
	// 		return Prase_Identifer();
	// 	break;
	// }
	
	return nullptr;
}

ast_Node* Parse_Stmts()
{
// 	ast_Node* node      = ast_Node_Make(ASTnode_Sector_Body);
// 	ast_Node* statement = Parse_Stmt();

// #define sectorBody node->SectorBody
// 		sectorBody.Nodes[0] = statement;
// 		sectorBody.Num      = 1;
	
// 	while (CurrentToken->Type == Def_End)
// 	{
// 		Parser_EatToken(Def_End);

// 		ast_Node* nextStatement = Parse_Stmt();
		
// 		sectorBody.Num++;
// 		sectorBody.Value = Mem_GlobalRealloc(AST_Node*, sectorBody.Node, sectorBody.Size);
// 	if (sectorBody.Value == nullptr)
// 		{
// 			Fatal_Throw("Failed to reallocate sector body.");
// 			return nullptr;
// 		}

// 	#define Next (sectorBody.Size -1)	

// 		sectorBody.Nodes[Next] = nextStatement;
		
// 	#undef Next
// 	}
	
// #undef sectorBody
	
// 	return node;

	return nullptr;
}

ast_Node* Parse_AL_Expr();
ast_Node* Parse_Term_Addi();
ast_Node* Parse_Term_Mult();

ast_Node* Parse_Op_Assign(ContextType _context, uw _depth)
{
	Fatal_NotImplemented("Parse_OP_Assign");
	return nullptr;
}

ast_Node* Parse_Op_ProcCall(ContextType _context, uw _depth)
{
	Log("Parse Op proc call");
	ast_Node* node = ast_Node_Make(ASTnode_Proc_Call);
			
	for (uw index = 0; index < _depth; index++)
	{
		node->ProcCall.Context[index] = _context[index];
	}

	switch (CurrentToken->Type)
	{
		case Params_PStart :
			
			Parser_EatToken(Params_PStart);
			
			for (uw index = 0; index < 6 && CurrentToken->Type != Params_PEnd; index++)
			{
				node->ProcCall.Parameters[index] = CurrentToken->Value;
				
				Parser_EatToken(CurrentToken->Type);
				
				if (CurrentToken->Type != Def_CD)
				{
					break;
				}

				Parser_EatToken(Def_CD);
			}
			
			Parser_EatToken(Params_PEnd);
			
		break;
		
		case Def_End :
			node->ProcCall.Parameters[0] = nullptr;
		break;
	}
	
	Parser_EatToken(Def_End);
	
	return node;
}

ast_Node* Parse_Symbol();
ast_Node* Parse_Literal_String();
 