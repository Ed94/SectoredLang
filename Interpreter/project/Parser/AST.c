#include "AST.h"



ast_Node* AST_Node_Make(enum AST_NodeType _type)
{
	ast_Node* astNode = Mem_GlobalAllocClear(ast_Node, 1);
	
	astNode->Type = _type;
	
	switch (_type)
	{
		case astNode->Identifier :
			astNode->Identifier = Mem_GlobalAllocClear(ast_Identifier, 1);

			astNode->Identifier->Definition       = Mem_GlobalAllocClear(ast_Node, 1);
			astNode->Identifier->Definition->Type = ASTnode_Identifier;
		break;
		
		case ASTnode_Unit_Spec :
			astNode->UnitSpec = Mem_GlobalAllocClear(AST_Node*, AST_UnitSpec_ReserveEntires);
			astNode->UnitSpec = { nullptr, 0, AST_UnitSpec_ReserveEntires };	
		break;
		
		case ASTnode_SectorBody :
			astNode->SectorBody = Mem_GlobalAllocClear(AST_Node*, AST_SectorBody_ReserveEntires);
			astNode->SectorBody = { nullptr, 0, AST_SectorBody_ReserveEntires };
		break;
	}
	
	return astNode;
}


void AST_SectorBody_Add(AST_SectorBody* _body, ast_Node* _nodeToAdd)
{
	if (_body->Capacity == AST_SectorBody_ReserveEntires)
	{
		_body.Nodes = Mem_GlobalRealloc
		(
			AST_Node*, 
			sectorBody.Nodes, 
			sectorBody.Capacity + AST_UnitSpec_ReservedEntires
		);

		if (specUnit.Nodes == nullptr)
		{
			Fatal_Throw("Failed to reallocate sector body.");
			return nullptr;
		}
		
		sectorBody.Capacity += AST_UnitSpec_ReserveEntires;
	}
	
	_body.Nodes[_body.Num - 1] = _nodeToAdd;
}
