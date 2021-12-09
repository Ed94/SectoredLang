#ifndef AST__Def

#include "Core.h"



#define  AST_UnitSpec_ReserveEntires   32
#define  AST_SectorBody_ReserveEntires 6


enum AST_NodeType
{
	ASTnode_Unit_Context,
	ASTnode_Unit_Bp,
	ASTnode_Unit_Spec,
	
	ASTnode_Sector_Identifier,
	ASTnode_Sector_Identifier,
	ASTnode_Sector_Body,
	
	ASTnode_Identifier,
	ASTnode_Identifier_Def,
	
	ASTnode_Type,
	ASTnode_Struct,
	
	ASTnode_Term_Additive,
	ASTnode_Term_Multiplicative,
	ASTnode_AL_Expression
};

enum SectorType
{
	ST_Static,
	ST_Identifier
};


typedef uDM     
E_AST_NodeType;

typedef struct ast_Node                 ast_Node;
typedef struct ast_NodeArray            ast_NodeArray, 
ast_Context, 
ast_Bp, 
ast_UnitSpec, 
ast_SectorBody;

typedef struct ast_Identifier           ast_Identifier;

typedef struct ast_SectorSymbol         ast_SectorSymbol;
typedef struct ast_StaticIdentifier     ast_StaticIdentifier;
typedef struct ast_SymbolDef            ast_Statement_SymbolDef;


typedef struct ast_Type             ast_Type;
typedef struct ast_StructMember     ast_StructMember;


// Main Node for the AST.
struct ast_Node
{   
	enum    AST_NodeType    Type;
	union 	{
			ast_UnitSpec    UnitSpec;
			ast_SectorBody  SectorBody;
			ast_Identifier  Identifer;
	};
};

// Container for Code Units and Sectors
struct ast_NodeArray
{
	ast_Node ptr* Nodes;
	uDM           Num;
	uDM           Capacity;
};

struct ast_Identifier
{
	String*   Name;
	ast_Node* Definition;
};

struct AST_Type
{
	String Identifier;
};

struct AST_StructMember
{
	String   Identifier;
	// AST_Type Type;
};

struct AST_Struct
{
	ast_Identifier ptr* Members;
};


struct ast Sector
{
	enum SectorType     Type;
	
	union
	{
		ast_SectorBody  Body;
		ast_Sector      Sector;
	}
}



ast_Node* ast_Node_Make(enum AST_NodeType);

void ast_NodeArray_Add(ast_NodeArray* _body, ast_Node* _nodeToAdd);

#define AST__Def
#endif
