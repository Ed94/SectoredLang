#ifndef Visitor_Def

#include "AST.h"

typedef struct Visitor      Visitor;





struct Visitor
{
	ast_NodeArray Unit_StaticIdentifiers;
	ast_NodeArray Unit_Procedures;
};


ast_Node* vistr_Visit(ast_Node* _node);

#define Visitor_Def
#endif
