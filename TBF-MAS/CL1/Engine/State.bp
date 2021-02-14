// Parent Header
#include "State.h"



// Includes

#include "State_Intro.h"
#include "Engine.h"


enum 
{
	 EFocusState_Game,
	 EFocusState_Logs
};




// State

StateObj* CurrentState = NULL;

uInt FocusState = EFocusState_Game;



// Functions

// Public

void State_OnKeyArrowUp(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			switch (FocusState)
			{
				case EFocusState_Logs:
				{
					Renderer_Logs_ScrollUp();

					break;
				}
			}

			break;
		}
	}
}

void State_OnKeyArrowDown(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			switch (FocusState)
			{
				case EFocusState_Logs:
				{
					Renderer_Logs_ScrollDown();

					break;
				}
			}

			break;
		}
	}
}

void State_OnKeyTab(EInputState _state)
{
	switch (_state)
	{
		case EInput_Pressed:
		{
			switch (FocusState)
			{
				case EFocusState_Game:
				{
					FocusState = EFocusState_Logs;

					break;
				}
				case EFocusState_Logs:
				{
					FocusState = EFocusState_Game;

					break;
				}
			}

			break;
		}
	}
}


void State_LoadModule(void)
{
	CurrentState = GetIntroState();

	CurrentState->Load();

	Input_SubscribeTo(Key_Arrow_Up  , &State_OnKeyArrowUp  );
	Input_SubscribeTo(Key_Arrow_Down, &State_OnKeyArrowDown);
	Input_SubscribeTo(Key_Tab       , &State_OnKeyTab      );
}

void State_SetState(StateObj* _state)
{
	if (CurrentState != NULL)
	{
		CurrentState->Unload();
	}

	CurrentState = _state;

	CurrentState->Load();
}

void State_Update(void)
{
	if (CurrentState != NULL)
	{
		CurrentState->Update();
	}
}

void State_Render(void)
{
	if (CurrentState != NULL)
	{
		CurrentState->Render();
	}
}

void State_LoadGame(void)
{
	State_SetState(LoadGame());
}
