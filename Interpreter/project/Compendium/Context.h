#ifndef Context__De

#include "Core.h"


enum BackendModule
{
	BModule_ISA,
	BModule_Assembler,
	BModule_IR,
	BModule_Compiler,
	BModule_Interpreter,
	BModule_Meta,
	BModule_Alias
};

enum FeatureLayerFlag
{
	FLayer_0    = bit(0),
	FLayaer_1   = bit(1),
	FLayer_2    = bit(2),
	FLayer_3    = bit(3),
	FLayer_4    = bit(4)
};

enum Alias
{

};

typedef enum BackendModule
EBackendModule;

typedef uw
FLayersFlags;

typedef struct ConxtDependency   ConxtDependency;

struct DependNode
{
	DependNode* Next;
	
	String Name;
};

struct Context
{
	/* data */
	String         Name;
	EBackendModule Module;
	FLayersFlags   FeatureLayers;
	DependNode*    Dependencies;
};


#define Context__Def
#endif
