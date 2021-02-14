#pragma once



// Includes

#include "LAL.h"



// Aliases (Typedefs)

typedef struct StateObj_Def StateObj;



// Structs

struct StateObj_Def
{
	Void_Function* Load  ;
	Void_Function* Unload; 
	Void_Function* Update;
	Void_Function* Render;
};



// Functions

void State_LoadModule(void);

void State_SetState(StateObj* _state);

void State_Update(void);

void State_Render(void);

void State_LoadGame(void);

