#include "AST.h"


ast_Node* ast_Node_Make(E_AST_NodeType _type)
{
	ast_Node* astNode = Mem_GlobalAllocClear(ast_Node, 1);
	
	astNode->Type = _type;
	
	switch (_type)
	{
	#define UnitSpec        astNode->UnitSpec
	#define SectorBody      astNode->SectorBody
	#define Identifier      astNode->Identifier
	#define SectorStatic    astNode->SectorStatic
	#define DataDef         astNode->DataDef
	#define ProcBody        astNode->ProcBody
	
		case ASTnode_Unit_Spec :
			UnitSpec.Nodes    = Mem_GlobalAllocClear(ast_Node*, AST_UnitSpec_CWU);
			UnitSpec.Capacity = AST_UnitSpec_CWU;
			UnitSpec.Num      = 0;
		break;
		
		case ASTnode_Sector_Stack  : break;
		case ASTnode_Sector_Static : break;
		case ASTnode_Sector_Proc   : break;
		
		case ASTnode_Proc_Body :
			ProcBody.Nodes    = Mem_GlobalAllocClear(ast_Node*, AST_SectorBody_CWU);
			ProcBody.Capacity = AST_ProcBody_CWU;
			ProcBody.Num      = 0;
		break;

		case ASTnode_Sector_Body :
			SectorBody.Nodes    = Mem_GlobalAllocClear(ast_Node*, AST_SectorBody_CWU);
			SectorBody.Capacity = AST_SectorBody_CWU;
			SectorBody.Num      = 0;
		break;
		
		case ASTnode_Identifier :
			Identifier.Definition       = Mem_GlobalAllocClear(ast_Node, 1);
			Identifier.Definition->Type = ASTnode_Identifier;
			Identifier.Name             = nullptr;
		break;
		
		case ASTnode_DataDef :
		break;
		
		case ASTnode_Proc_Call :

		break;
		
	#undef UnitSpec
	#undef SectorBody
	#undef Identifier
	#undef SectorStatic
	#undef DatDef
	#undef ProcBody
	}
	
	return astNode;
}


#define Nodes       _self->Nodes
#define Capacity    _self->Capacity
#define Num         _self->Num

void ast_NodeArray_Add(ast_NodeArray* _self, ast_Node* _nodeToAdd, uDM _capacityUnitWidth)
{
	if (Capacity == _capacityUnitWidth)
	{
		Nodes = Mem_GlobalRealloc
		(
			ast_Node*, 
			Nodes, 
			Capacity + _capacityUnitWidth
		);

		if (Nodes == nullptr)
		{
			Fatal_Throw("Failed to reallocate sector body.");
		}
		
		Capacity += _capacityUnitWidth;
	}
	
	Nodes[Num++] = _nodeToAdd;
}

#undef Nodes
#undef Capacity
#undef Num
