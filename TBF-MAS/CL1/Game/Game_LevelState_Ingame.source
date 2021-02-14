// Parent Headers
#include "Game_LevelState_Ingame.h"



// Includes

#include "Game_EntryState.h"
#include "Game_LevelState_Paused.h"
#include "Game_Util.h"



// Static Data

// Private

StateObj Ingame_State;

UI_Text Ingame_Text;

UI_Text Ingame_GameOver_Fell;

UI_Text Ingame_GameOver_MadeIt;

Character Player;

Level Level1;

Level Level2;

sInt CurrentLevel = 1;

bool ShouldReload = true;

bool Ingame_DoneOnce = false;



// Functions

// Class Public

void LevelState_Ingame_OnKeyEnter(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			LevelState_SetSubstate(GetPausedState());

			break;
		}
	}
}

void LevelState_Ingame_OnKeyUp(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Player.ShouldJump = true;

			break;
		}
		case EInput_Released:
		{
			break;
		}
	}
}

void LevelState_Ingame_OnKeyLeft(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Player.MoveState = ECharacter_MoveLeft;

			break;
		}
		case EInput_Released:
		{
			if (Player.MoveState == ECharacter_MoveLeft)
			{
				Player.MoveState = ECharacter_DontMove;
			}

			break;
		}
	}
}

void LevelState_Ingame_OnKeyRight(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			Player.MoveState = ECharacter_MoveRight;

			break;
		}
		case EInput_Released:
		{
			if (Player.MoveState == ECharacter_MoveRight)
			{
				Player.MoveState = ECharacter_DontMove;
			}

			break;
		}
	}
}

void Load_Ingame(void)
{
	if (! Ingame_DoneOnce)
	{
		COORD 
			start = { 1, 1 }, 
			end   = { 1, 1 } ;

		UI_Text_Create
		(
			&Ingame_Text,

			L"Press enter to pause.\0",
			start, end,
			false
		);

		start.X = 0; start.Y = 9;
		end  .X = 0; end  .Y = 9;
		
		UI_Text_Create
		(
			&Ingame_GameOver_Fell,

			L"Game Over: You fell\0",
			start, end,
			true
		);

		UI_Text_Create
		(
			&Ingame_GameOver_MadeIt,

			L"Game Over: You Made It!\0",
			start, end,
			true
		);

		// Level 1

		start.X = 0;                    start.Y = Renderer_GameEnd - 1;
		end  .X = Renderer_Width - 70; end  .Y = Renderer_GameEnd - 1;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		start.X = 0;                    start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 70; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		start.X = Renderer_Width - 70; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 60; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level1, start, end, ELevelCellType_Pit);

		start.X = Renderer_Width - 60; start.Y = Renderer_GameEnd -1;
		end  .X = Renderer_Width - 40; end  .Y = Renderer_GameEnd -1;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		start.X = Renderer_Width - 60; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 40; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		start.X = Renderer_Width - 40; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 20; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level1, start, end, ELevelCellType_Pit);

		start.X = Renderer_Width - 20; start.Y = Renderer_GameEnd - 1;
		end  .X = Renderer_Width;      end  .Y = Renderer_GameEnd - 1;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		start.X = Renderer_Width - 20; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width;      end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level1, start, end, ELevelCellType_Ground);

		// Level 2

		start.X = 0;                    start.Y = Renderer_GameEnd - 1;
		end  .X = Renderer_Width - 40; end  .Y = Renderer_GameEnd - 1;

		Level_SetCells(&Level2, start, end, ELevelCellType_Ground);

		start.X = 0;                    start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 40; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level2, start, end, ELevelCellType_Ground);

	 	start.X = Renderer_Width - 40; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 25; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level2, start, end, ELevelCellType_Pit);

		start.X = Renderer_Width - 25; start.Y = Renderer_GameEnd -1;
		end  .X = Renderer_Width - 20; end  .Y = Renderer_GameEnd -1;

		Level_SetCells(&Level2, start, end, ELevelCellType_Ground);

		start.X = Renderer_Width - 25; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 20; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level2, start, end, ELevelCellType_Ground);
	 
		start.X = Renderer_Width - 20; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width - 10; end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level2, start, end, ELevelCellType_Pit);

		start.X = Renderer_Width - 10; start.Y = Renderer_GameEnd - 1;
		end  .X = Renderer_Width;      end  .Y = Renderer_GameEnd - 1;

		Level_SetCells(&Level2, start, end, ELevelCellType_Finish);

		start.X = Renderer_Width - 10; start.Y = Renderer_GameEnd;
		end  .X = Renderer_Width;      end  .Y = Renderer_GameEnd;

		Level_SetCells(&Level2, start, end, ELevelCellType_Finish);


		Ingame_DoneOnce = true;
	}

	if (ShouldReload == true)
	{
		Character_Load(&Player);

		CurrentLevel = 1;

		ShouldReload = false;
	}

	Input_SubscribeTo(Key_Enter      , &LevelState_Ingame_OnKeyEnter);
	Input_SubscribeTo(Key_Arrow_Up   , &LevelState_Ingame_OnKeyUp   );
	Input_SubscribeTo(Key_Arrow_Left , &LevelState_Ingame_OnKeyLeft );
	Input_SubscribeTo(Key_Arrow_Right, &LevelState_Ingame_OnKeyRight);
}

void Unload_Ingame(void)
{
	Input_Unsubscribe(Key_Enter      , &LevelState_Ingame_OnKeyEnter);
	Input_Unsubscribe(Key_Arrow_Up   , &LevelState_Ingame_OnKeyUp   );
	Input_Unsubscribe(Key_Arrow_Left , &LevelState_Ingame_OnKeyLeft );
	Input_Unsubscribe(Key_Arrow_Right, &LevelState_Ingame_OnKeyRight);
}

void Update_Ingame(void)
{
	if (CurrentLevel == 2 && ! Character_AtFinish(&Player, &Level2))
	{
		Character_Update(&Player, &Level2);	
	}

	if (CurrentLevel == 1)
	{
		Character_Update(&Player, &Level1);
	}

	if (CurrentLevel == 1 && Player.Position.X >= 0.98f)
	{
		CurrentLevel = 2;

		Player.Position.X = -0.975f; 
	}
}

void Render_Ingame(void)
{
	if (CurrentLevel == 1)
	{
		Level_Render(&Level1);
	}
	else
	{
		Level_Render(&Level2);
	}

	UI_Text_Render(&Ingame_Text);

	Character_Render(&Player);	

	if (Player.Fell)
	{
		UI_Text_Render(&Ingame_GameOver_Fell);
	}

	if (CurrentLevel == 2 && Character_AtFinish(&Player, &Level2))
	{
		UI_Text_Render(&Ingame_GameOver_MadeIt);
	}
}



// Public

StateObj* GetIngameState(void)
{
	static bool stateConstructed = false;

	if (!stateConstructed)
	{
		Ingame_State.Load   = &Load_Ingame  ;
		Ingame_State.Unload = &Unload_Ingame;
		Ingame_State.Update = &Update_Ingame;
		Ingame_State.Render = &Render_Ingame;

		stateConstructed = true;
	}

	return &Ingame_State;
}

void Ingame_Reload(void)
{
	ShouldReload = true;
}

