#pragma once



// Includes

#include "Config.h"
#include "LAL.h"
#include "OSPlatform.h"
#include "Timing.h"



// Enums

enum Renderer_Constants
{
	Renderer_Width                 = 80,

#ifdef Debug
	Renderer_Height                = 48,

	Renderer_BorderLine            = 24,

	Renderer_DebugStart            = 25,
	Renderer_DebugLogSize          = 18,

	Renderer_DebugPersistentStart  = 44,
	Renderer_PersistentSectionSize = 4 ,
#else
	Renderer_Height                = 24,
#endif

	Renderer_GameEnd               = 23,	
};



// Aliases (Typedefs)

typedef CONSOLE_SCREEN_BUFFER_INFO CSBI;

typedef CHAR_INFO Cell;

typedef Cell Line[Renderer_Width];

typedef struct RendererData_Def RendererData;
typedef struct ScreenInfo_Def   ScreenInfo;


typedef struct Vec2D_Int_Def Vec2D_Int;



// Structures

struct Vec2D_Int_Def { sInt X, Y; };

struct RendererData_Def
{
	// Console Data

	HWND   Window_Handle;
	HANDLE Output_Handle;

	DWORD      CharactersWritten;
	COORD      CoordSize;
	CSBI       CSBI_Instance;
	DWORD      BufferSize;
	SMALL_RECT Size;

	CONSOLE_CURSOR_INFO CursorSettings;

	Vec2D_Int ScreenPosition;

	TimerData RefreshTimer;
};

struct ScreenInfo_Def
{
	Vec2D_Int Center;
};



// Constants

#define SizeOf_Renderer \
	sizeof(RendererData)



// Functions

void Renderer_Clear(void);

bool Renderer_FillCellsWithWhitespace(void);

bool Renderer_FormatCells(void);

const RendererData* Renderer_GetContext(void);

void Renderer_LoadModule(void);

void Renderer_ProcessTiming(float64 _deltaTime);

void Renderer_RenderFrame(void);

void Renderer_ResetDrawPosition(void);

void Renderer_UnloadModule(void);

void Renderer_Update(void);

void Renderer_WriteToBufferCells(const Cell* _cells, COORD _initalCell, COORD _finalCell);

void Renderer_WriteToLog(const WideChar* _logString);

void Renderer_WriteToPersistentSection(sInt _row, const WideChar* _lineformat, ...);

void Renderer_Logs_ScrollUp(void);

void Renderer_Logs_ScrollDown(void);



