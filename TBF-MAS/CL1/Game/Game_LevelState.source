// Parent Header
#include "Game_LevelState.h"



// Includes

#include "Game_EntryState.h"
#include "Game_LevelState_Ingame.h"
#include "Game_Util.h"



// Static Data

// Private

StateObj LevelState;

StateObj* LevelState_CurrentSubstate = NULL;



// Functions

// Class Public

void Load_Level(void)
{
	LevelState_SetSubstate(GetIngameState());
}

void Unload_Level(void)
{
	LevelState_CurrentSubstate->Unload();

	LevelState_CurrentSubstate = NULL;
}

void Update_Level(void)
{
	LevelState_CurrentSubstate->Update();
}

void Render_Level(void)
{
	LevelState_CurrentSubstate->Render();
}



// Public

StateObj* GetLevelState(void)
{
	static bool stateConstructed = false;

	if (! stateConstructed)
	{
		LevelState.Load   = &Load_Level  ;
		LevelState.Unload = &Unload_Level;
		LevelState.Update = &Update_Level;
		LevelState.Render = &Render_Level;

		stateConstructed = true;
	}

	return &LevelState;
}

void LevelState_SetSubstate(StateObj* _state)
{
	if (LevelState_CurrentSubstate != NULL)
	{
		LevelState_CurrentSubstate->Unload();
	}

	LevelState_CurrentSubstate = _state;

	LevelState_CurrentSubstate->Load();
}
