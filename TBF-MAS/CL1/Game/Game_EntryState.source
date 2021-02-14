// Parent Header
#include "Game_EntryState.h"



// Include

#include "Game_LevelState.h"
#include "Game_Util.h"



// Static Data

// Private

StateObj MainMenu;

UI_Widget MenuWidget;

bool Menu_DoneOnce = false;

bool 
	Log_Load   = true,
	Log_Unload = true ;



// Functions

// Public Class

void MainMenu_PressStart(void)
{
	Renderer_WriteToLog(L"UI Start Selected");

	State_SetState(GetLevelState());
}

void MainMenu_PressQuit(void)
{
	Cycler_Lapse();
}

void Game_EntryState_OnKeyArrowUp(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Renderer_WriteToLog(L"EntryState: On Key Up");

			UI_Widget_MoveUp(&MenuWidget);

			break;
		}
	}
}

void Game_EntryState_OnKeyArrowDown(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Renderer_WriteToLog(L"EntryState: On Key Down");

			UI_Widget_MoveDown(&MenuWidget);

			break;
		}
	}
}

void Game_EntryState_OnKeyEnter(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Renderer_WriteToLog(L"EntryState: On Key Enter");

			UI_Widget_Select(&MenuWidget);

			break;
		}
	}
}

void MainMenu_Load(void)
{
	if (! Menu_DoneOnce)
	{
		MenuWidget.TextUIs           = NULL;
		MenuWidget.Num_TextUIs       = 0;
		MenuWidget.Grid.Buttons      = NULL;
		MenuWidget.Grid.Num          = 0;
		MenuWidget.Grid.CurrentIndex = 0;

		COORD startCell, endCell;

		startCell.X = 0; endCell.X = 0;
		startCell.Y = 9; endCell.Y = 9;


		UI_Widget_AddText
		(
			&MenuWidget,

			L"Generic Platformer Demo\0",
			startCell, 
			endCell,
			true   // Should Center
		);

		startCell.Y = 15; endCell.Y = 15;

		UI_Widget_AddButton
		(
			&MenuWidget,

			L"Start\0",
			startCell, endCell,
			true,
			&MainMenu_PressStart
		);

		startCell.X = -1; endCell.X = -1;
		startCell.Y = 17; endCell.Y = 17;

		UI_Widget_AddButton
		(
			&MenuWidget,

			L"Quit\0",
			startCell, endCell,
			true,
			&MainMenu_PressQuit
		);

		Menu_DoneOnce = true;
	}

	Input_SubscribeTo(Key_Arrow_Up  , &Game_EntryState_OnKeyArrowUp  );
	Input_SubscribeTo(Key_Arrow_Down, &Game_EntryState_OnKeyArrowDown);
	Input_SubscribeTo(Key_Enter     , &Game_EntryState_OnKeyEnter    );

	if (Log_Load)
	{
		Renderer_WriteToLog(L"Loaded: Main Menu");

		Log_Load = false;
	}
}

void MainMenu_Unload(void)
{
	Input_Unsubscribe(Key_Arrow_Up  , &Game_EntryState_OnKeyArrowUp  );
	Input_Unsubscribe(Key_Arrow_Down, &Game_EntryState_OnKeyArrowDown);
	Input_Unsubscribe(Key_Enter     , &Game_EntryState_OnKeyEnter    );

	if (Log_Unload)
	{
		Renderer_WriteToLog(L"Unload: Main Menu");

		Log_Unload = false;
	}
}

void MainMenu_Update(void)
{
}

void MainMenu_Render(void)
{
	UI_Widget_Render(&MenuWidget);
}



// Engine Entrypoint

StateObj* LoadGame(void)
{
	static bool stateConstructed = false;

	if (! stateConstructed)
	{
		MainMenu.Load   = &MainMenu_Load  ;
		MainMenu.Unload = &MainMenu_Unload;
		MainMenu.Update = &MainMenu_Update;
		MainMenu.Render = &MainMenu_Render;

		stateConstructed = true;
	}

	return &MainMenu;
}



