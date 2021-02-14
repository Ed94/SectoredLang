// Parent Header
#include "State_Intro.h"



// Include
#include "Memory.h"
#include "Renderer.h"
#include "Cycler.h"
#include "Timing.h"



StateObj IntroState;

TimerData IntroTimer;

TimerData Timer_TillTitle;
TimerData Timer_TillVersion;
TimerData Timer_TillIntroFadeToGrey;

TimerData Timer_TillTitle_ToWhite;
TimerData Timer_TillVersion_ToWhite;

TimerData Timer_Till_FadeOut;


bool Intro_DoneOnce = false;

CTS_CWString IntroTitle    = L"Trial By Fire Engine";
CTS_CWString EngineVersion = L"Type C Phase 14"     ;

bool 
	RenderTitle   = false, 
	RenderVersion = false ;

Cell* IntroTitle_RenderCells = NULL;
Cell* Version_RenderCells    = NULL;

size_t 
	Title_Length         = 0,
	EngineVersion_Length = 0 ;



// Functions

// Private

void ChangeTitleTo_Grey()
{
	for (size_t cellIndex = 0; cellIndex < Title_Length; cellIndex++)
	{
		IntroTitle_RenderCells[cellIndex].Attributes = FOREGROUND_INTENSITY;
	}
}

void ChangeEngineVerTo_Grey()
{
	for (size_t cellIndex = 0; cellIndex < EngineVersion_Length; cellIndex++)
	{
		Version_RenderCells[cellIndex].Attributes = FOREGROUND_INTENSITY;
	}
}

void ChangeTitleTo_White()
{
	for (size_t cellIndex = 0; cellIndex < Title_Length; cellIndex++)
	{
		IntroTitle_RenderCells[cellIndex].Attributes = Console_WhiteCell;
	}
}

void ChangeEngineVerTo_White()
{
	for (size_t cellIndex = 0; cellIndex < EngineVersion_Length; cellIndex++)
	{
		Version_RenderCells[cellIndex].Attributes = Console_WhiteCell;
	}
}


// Class Public

void IntroState_Load(void)
{
	Renderer_WriteToLog(L"Intro State: Loaded");

	if (! Intro_DoneOnce)
	{
		IntroTimer.EndTime = 7.0L;

		Timer_TillTitle    .EndTime = 2.0;
		Timer_TillVersion  .EndTime = 1.2;

		Timer_TillIntroFadeToGrey.EndTime = Timer_TillTitle.EndTime + 4.2;

		Timer_Till_FadeOut.EndTime = 0.134;

		Timer_TillTitle_ToWhite  .EndTime = 0.134;
		Timer_TillVersion_ToWhite.EndTime = 0.134;

		Title_Length         = wcslen(IntroTitle);
		EngineVersion_Length = wcslen(EngineVersion) + 1;

		IntroTitle_RenderCells = GlobalAllocate(Cell, Title_Length        );
		Version_RenderCells    = GlobalAllocate(Cell, EngineVersion_Length);

		for (size_t cellIndex = 0; cellIndex < Title_Length; cellIndex++)
		{
			IntroTitle_RenderCells[cellIndex].Char.UnicodeChar = IntroTitle[cellIndex];
		}

		for (size_t cellIndex = 0; cellIndex < EngineVersion_Length; cellIndex++)
		{
			Version_RenderCells[cellIndex].Char.UnicodeChar = EngineVersion[cellIndex];
		}

		Intro_DoneOnce = true;
	}
	
	ChangeTitleTo_Grey();

	ChangeEngineVerTo_Grey();
}

void IntroState_Unload(void)
{
	Renderer_WriteToLog(L"Intro State: Unloaded");
}

void IntroState_Update(void)
{
	static bool 
		LogTitle   = true, 
		LogVersion = true, 
		LogFade    = true, 
		LogEnd     = true,

		Log_ChangeToWhite_Title   = true,
		Log_ChangeToWhite_Version = true,

		Log_FadeToGrey = true;


	Timer_Tick(&IntroTimer);

	Timer_Tick(&Timer_TillTitle);

	Renderer_WriteToPersistentSection(4, L"Intro Time Elapsed: %.7Lf", IntroTimer.Elapsed);

	if (Timer_Ended(&Timer_TillTitle))
	{
		if (LogTitle)
		{
			Renderer_WriteToLog(L"Title should show up now (Grey).");

			RenderTitle = true;

			LogTitle = false;
		}

		Timer_Tick(&Timer_TillTitle_ToWhite);

		if (Log_ChangeToWhite_Title &&  Timer_Ended(&Timer_TillTitle_ToWhite))
		{
			ChangeTitleTo_White();

			Renderer_WriteToLog(L"Title: White attribute set.");

			Log_ChangeToWhite_Title = false;
		}

		Timer_Tick(&Timer_TillVersion);

		if (LogVersion && Timer_Ended(&Timer_TillVersion))
		{
			Renderer_WriteToLog(L"Version should show up now.");

			RenderVersion = true;

			LogVersion = false;
		}

		if (RenderVersion)
		{
			Timer_Tick(&Timer_TillVersion_ToWhite);

			if (Log_ChangeToWhite_Version && Timer_Ended(&Timer_TillVersion_ToWhite))
			{
				ChangeEngineVerTo_White();

				Renderer_WriteToLog(L"Engine Version: White attribute set.");

				Log_ChangeToWhite_Version = false;
			}
		}
	}

	Timer_Tick(&Timer_TillIntroFadeToGrey);

	if (Timer_Ended(&Timer_TillIntroFadeToGrey))
	{
		ChangeTitleTo_Grey();

		ChangeEngineVerTo_Grey();

		if (Log_FadeToGrey)
		{
			Renderer_WriteToLog(L"Title should fade to grey now.");

			Log_FadeToGrey = false;
		}

		Timer_Tick(&Timer_Till_FadeOut);

		if (LogFade && Timer_Ended(&Timer_Till_FadeOut))
		{
			Renderer_WriteToLog(L"Title should fade out now.");

			RenderTitle   = false;
			RenderVersion = false;

			LogFade = false;
		}
	}

	if (LogEnd && Timer_Ended(&IntroTimer) )
	{
		Renderer_WriteToLog(L"Intro Ends now.");

		LogEnd = false;

		State_LoadGame();
	}
}

void IntroState_Render(void)
{
	static COORD
		startingCell = { 0, 9 },
		endingCell   = { 0, 9 };

	// Render Title
	if (RenderTitle)
	{
		startingCell.X = (Renderer_Width / 2) - ((uInt16)Title_Length / 2);
		endingCell  .X = (Renderer_Width / 2) + ((uInt16)Title_Length / 2);

		startingCell.Y = 9;
		endingCell  .Y = 9;

		Renderer_WriteToBufferCells(IntroTitle_RenderCells, startingCell, endingCell);
	}

	// Render Version
	if (RenderVersion)
	{
		startingCell.X = (Renderer_Width / 2) - ((uInt16)EngineVersion_Length / 2);
		endingCell  .X = (Renderer_Width / 2) + ((uInt16)EngineVersion_Length / 2);

		startingCell.Y = 11;
		endingCell  .Y = 11;

		Renderer_WriteToBufferCells(Version_RenderCells, startingCell, endingCell);
	}
}



// Public

StateObj* GetIntroState(void)
{
	static bool firstGet = true;

	if (firstGet) 
	{
		IntroState.Load   = &IntroState_Load  ;
		IntroState.Unload = &IntroState_Unload;
		IntroState.Update = &IntroState_Update;
		IntroState.Render = &IntroState_Render;

		firstGet = false;
	}

	return &IntroState;
}
