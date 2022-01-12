#ifndef AST__Def

#include "Core.h"


// CWU: Capacity Width Unit

#define AST_UnitSpec_CWU                32
#define AST_SectorBody_CWU              6
#define AST_ProcBody_CWU                32
#define Identifier_MaxContextDepth      16


enum AST_NodeType
{
	ASTnode_Unit_Context,
	ASTnode_Unit_Bp,
	ASTnode_Unit_Spec,
	
	ASTnode_Sector_Identifier,
	ASTnode_Sector_Stack,
	ASTnode_Sector_Static,
	ASTnode_Sector_Proc,
	ASTnode_Sector_Body,
	
	ASTnode_Identifier,
	ASTnode_Identifier_Def,
	
	ASTnode_DataDef,
	ASTnode_Proc_Body,
	ASTnode_Proc_Call,
	
	ASTnode_Type,
	ASTnode_Struct,
	
	ASTnode_Term_Additive,
	ASTnode_Term_Multiplicative,
	ASTnode_AL_Expression,
	
	ASTnode_NoOperation
};

enum SectorType
{
	ST_Static,
	ST_Identifier
};

enum SectorDefType
{
	SecDef_Single,
	SecDef_Body
};


typedef u32
E_AST_NodeType,
ESectorType,
ESectorDefType;

typedef struct ast_Node                 ast_Node;
typedef struct ast_NodeArray            ast_NodeArray, 
ast_Context, 
ast_Bp, 
ast_UnitSpec, 
ast_ProcBody,
ast_SectorBody;

typedef struct ast_Identifier           ast_Identifier;
typedef struct ast_Sector               ast_Sector,
ast_SectorStack,
ast_SectorStatic;

typedef struct ast_SectorSymbol         ast_SectorSymbol;
typedef struct ast_StaticIdentifier     ast_StaticIdentifier;
typedef struct ast_SymbolDef            ast_Statement_SymbolDef;


typedef struct ast_Type             ast_Type;
typedef struct ast_StructMember     ast_StructMember;
typedef struct ast_DataDef          ast_DataDef;
typedef struct ast_Value            ast_Value;
typedef struct ast_ProcCall         ast_ProcCall;

typedef String*   
ContextType[Identifier_MaxContextDepth];



// Container for Code Units and Sectors
struct ast_NodeArray
{
	uw            Capacity;
	uw            Num;
	ptr(ast_Node)* Nodes;
};

struct ast_Identifier
{
	String*   Name;
	ast_Node* Definition;
};

struct ast_Sector
{
	ESectorDefType          DefType;
	ast_Node*               Definition;
	// union   {
	// 		ast_Identifier* Single;
	// 		ast_SectorBody* Body;
	// };
};

struct ast_DataDef
{
	String*   Type;
	// ast_Value Value;
	String*   Value;
};

// struct ast_Value
// {
	// enum ValueType      Type;
	// union   {
			
	// 		String* 
	// };
// };

struct ast_ProcCall
{
	ContextType Context;

	String* Parameters[6];
};

struct ast_Type
{
	String Identifier;
};

struct ast_StructMember
{
	String   Identifier;
	// AST_Type Type;
};

struct ast_Struct
{
	ptr(ast_Identifier)*  Members;
};

// Main Node for the AST.
struct ast_Node
{   
			// String*             Context;
	enum    AST_NodeType        Type;
	union 	{
			ast_UnitSpec        UnitSpec;
			ast_Sector          Sector; 
			ast_SectorBody      SectorBody;
			ast_Identifier      Identifier;
			ast_DataDef         DataDef;
			ast_ProcBody        ProcBody;
			ast_ProcCall        ProcCall;
	};
};

// struct ast_Sector
// {
// 	enum SectorType         Type;
// 	union   {
// 			ast_SectorBody  Body;
// 			ast_Sector      Sector;
// 	}
// }




ast_Node* ast_Node_Make(E_AST_NodeType _type);

void ast_NodeArray_Add(ast_NodeArray* _self, ast_Node* _nodeToAdd, uw _capacityWidthUnit);

#define ast_UnitSpec_Add(_self, _nodeToAdd) \
ast_NodeArray_Add(_self, _nodeToAdd, AST_UnitSpec_CWU)

#define ast_SectorBody_Add(_self, _nodeToAdd) \
ast_NodeArray_Add(_self, _nodeToAdd, AST_SectorBody_CWU)

#define ast_ProcBody_Add(_self, _nodeToAdd) \
ast_NodeArray_Add(_self, _nodeToAdd, AST_ProcBody_CWU)

#define AST__Def
#endif
