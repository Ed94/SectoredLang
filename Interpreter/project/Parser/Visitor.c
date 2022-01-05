#include "Visitor.h"


#pragma region      Static Data
static
Visitor     VisitorObj;

static ast_Node*   Node    = nullptr;
static String*     Context = nullptr;
#pragma endregion   Static Data


#pragma region Fowards
ast_Node* Visit_UnitSpec();

ast_Node* Visit_Sector_Identifier();
ast_Node* Visit_Sector_Stack();
ast_Node* Visit_Sector_Static();
ast_Node* Visit_Sector_Body();

ast_Node* Visit_Identifier();
ast_Node* Visit_DataDef();
#pragma endregion Forwards



#define Unit_StaticIdens        VisitorObj->Unit_StaticIdentifiers
#define Unit_Procedures         VisitorObj->Unit_Procedures

void vistr_Init()
{

}

ast_Node* vistr_Visit(ast_Node* _node)
{
	if (! _node)
	{
		Fatal_Throw("_node cannot be null!");
		return nullptr;
	}
	
	Node = _node;

	switch (Node->Type)
	{
		case ASTnode_Unit_Context :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;
		
		case ASTnode_Unit_Bp :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;
		
		case ASTnode_Unit_Spec :
			return Visit_UnitSpec();
		break;
		
		case ASTnode_Sector_Identifier :
			return Visit_Sector_Identifier();
		break;
		
		case ASTnode_Sector_Stack :
			return Visit_Sector_Stack();
		break;
	
		case ASTnode_Sector_Static :
			return Visit_Sector_Static();
		break;

		case ASTnode_Sector_Proc :
		break;

		case ASTnode_Sector_Body :
			return Visit_Sector_Body();
		break;

		
		case ASTnode_Identifier :
			// You were last here.
		break;

		case ASTnode_Identifier_Def :
		break;


		case ASTnode_DataDef :
			return Visit_DataDef();
		break;
		
		case ASTnode_Proc_Body :
		break;
		
		case ASTnode_Proc_Call :
		break;

		
		case ASTnode_Type :
		break;
		
		case ASTnode_Struct :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;

		
		case ASTnode_Term_Additive :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;
		
		case ASTnode_Term_Multiplicative :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;
		
		case ASTnode_AL_Expression :
			Fatal_NotImplemented("Visitor: ASTnode not supported");
		break;
		
		case ASTnode_NoOperation :
		break;
	}
	
	LogF("Node Type: %d\n", _node->Type);
	Fatal_NoEntry("Uncaught statement");
	return ast_Node_Make(ASTnode_NoOperation);
}

ast_Node* Visit_UnitContext()
{
	return nullptr;
}

ast_Node* Visit_UnitBP()
{
	return nullptr;
}

ast_Node* Visit_UnitSpec()
{
	ast_UnitSpec* spec = ptrof Node->UnitSpec;
	
	LogF("Visit - Type: UnitSpec, Nodes: %llu\n",  spec->Num);
	
	for (uDM index = 0; index < spec->Num; index++)
	{
		ast_Node* specNode = spec->Nodes[index];
		
		vistr_Visit(specNode);
	}	
	
	return nullptr;
}

ast_Node* Visit_Sector_Identifier()
{
	ast_Identifier* identifier = ptrof Node->Identifier;
	
	LogF("Visit - Type : Identifier, Name: %s", identifier->Name->Data);
	
	return identifier->Definition;
}

ast_Node* Visit_Sector_Stack()
{
	return nullptr;
}

ast_Node* Visit_Sector_Static()
{
	ast_Sector* sector = ptrof Node->Sector;
	
	switch (sector->DefType)
	{
		case SecDef_Single :
			Log("Vist - Type : Static Sector, Type : Single");
		break;

		case SecDef_Body :
			Log("Vist - Type : Static Sector, Type : Body");
		break;
	}
	
	return sector->Definition;
}

ast_Node* Visit_Sector_Proc()
{
	return nullptr;
}

ast_Node* Visit_Sector_Body()
{
	return nullptr;
}

ast_Node* Visit_Identifier()
{
	Log("Please");
	return nullptr;
}

ast_Node* Visit_Identifier_Def()
{
	return nullptr;
}

ast_Node* Visit_DataDef()
{
	return nullptr;
}

ast_Node* Visit_Proc_Body()
{
	return nullptr;
}

ast_Node* Visit_Proc_Call()
{
	return nullptr;
}

ast_Node* Visit_Type()
{
	return nullptr;
}

ast_Node* Visit_Struct()
{
	return nullptr;
}

#undef Unit_StaticIdens
#undef Unit_Procedures

