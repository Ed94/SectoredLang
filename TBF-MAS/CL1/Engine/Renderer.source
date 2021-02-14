// Parent Header
#include "Renderer.h"



// Includes

#include "FloatCompare.h"
#include "Input.h"
#include "Memory.h"
#include "Timing.h"
#include "State.h"



// Static Data

// Private

CHAR_INFO* Buffer;

RendererData Renderer;
ScreenInfo   Screen;

Line Border_GameDebug    ;
Line Border_LogPersistent;

// Eliminate these?

typedef 
		
struct Lines_Def
{
	Line* Array;

	size_t Num;
}

Lines;
	
Lines DebugLogSection_Dynamic;

uInt DebugLogSection_RelativeLastLine = 1;


#ifdef Debug
	Line PersistentSection[Renderer_PersistentSectionSize];
#endif

const CTS_CWString Renderer_ConsoleTitle = L"TBF C Engine: Phase 14";

const COORD Console_ScreenPos_00 = 
{
	0,  // X
	0   // Y
};



// Forward Declarations

void DrawGameScanlines    (void);
void InitalizeData        (void);
void SetupConsole         (void);
bool ShouldRender         (void);
bool UpdateConsoleInfo    (void);
void UpdateSizeAndPosition(void);



// Functions

// Public

void Renderer_Clear(void)
{
	if (UpdateConsoleInfo())
	{
		Memory_FormatByFill(CHAR_INFO, Buffer, 0, Renderer_Width * Renderer_Height);
	}
}

// Return value tells you if it did the job.
bool Renderer_FillCellsWithWhitespace(void)
{
	return FillConsoleOutputCharacter
	(
		Renderer.Output_Handle,
		(TCHAR)' ',
		Renderer.BufferSize,
		Console_ScreenPos_00,
		&Renderer.CharactersWritten
	);
}

bool Renderer_FormatCells(void)
{
	return FillConsoleOutputAttribute
	(
		Renderer.Output_Handle,
		Renderer.CSBI_Instance.wAttributes,
		Renderer.BufferSize,
		Console_ScreenPos_00,
		&Renderer.CharactersWritten
	);
}

const RendererData* Renderer_GetContext(void)
{
	return &Renderer;
}

void Renderer_LoadModule(void)
{
	SetupConsole();

	InitalizeData();

	// Setup Console to ideal configuration.

	SetConsoleTitle(Renderer_ConsoleTitle);

	UpdateSizeAndPosition();

	return;
}

void Renderer_ProcessTiming(float64 _deltaTime)
{
	Timer_Tick(&Renderer.RefreshTimer);
}

void Renderer_RenderFrame(void)
{
	// Renders buffer to console.
	WriteConsoleOutput(Renderer.Output_Handle, Buffer, Renderer.CoordSize, Console_ScreenPos_00, &Renderer.Size);

	return;
}

void Renderer_ResetDrawPosition(void)
{
	SetConsoleCursorPosition(Renderer.Output_Handle, Console_ScreenPos_00);

	return;
}

void Renderer_UnloadModule(void)
{
	if (Unbind_IOBufferTo_Console() != true)
	{
		perror("Failed to unbind standard IO from renderer console");

		exit(1);
	}

	if (FreeConsole() != true)
	{
		perror("Failed to free renderer console properly.");

		exit(1);
	}
}

void Renderer_Update(void)
{
	if (Timer_Ended(&Renderer.RefreshTimer))
	{
		Renderer_Clear();

		DrawGameScanlines();

		State_Render();

		//Renderer_WriteToPersistentSection(1, L"Relative Last Line: %u", DebugLogSection_RelativeLastLine);

	#ifdef Debug


		COORD 
			startingCell = { 0             , Renderer_BorderLine }, 
			finalCell    = { Renderer_Width, Renderer_BorderLine };

		Renderer_WriteToBufferCells((Cell*)&Border_GameDebug, startingCell, finalCell);

		startingCell.Y = Renderer_DebugPersistentStart - 1;
		finalCell   .Y = Renderer_DebugPersistentStart - 1;

		Renderer_WriteToBufferCells((Cell*)&Border_LogPersistent, startingCell, finalCell);

		if (DebugLogSection_Dynamic.Num <= 18)
		{
			for (size_t index = 0; index < DebugLogSection_Dynamic.Num - 1; index++)
			{
				startingCell.Y = Renderer_DebugStart + (uInt16)index;
				finalCell   .Y = Renderer_DebugStart + (uInt16)index;

				Renderer_WriteToBufferCells(DebugLogSection_Dynamic.Array[index], startingCell, finalCell);
			}
		}
		else
		{
			size_t LogStart = DebugLogSection_Dynamic.Num - 18 - DebugLogSection_RelativeLastLine;

			for (size_t index = 0; index < Renderer_DebugLogSize; index++)
			{
				startingCell.Y = Renderer_DebugStart + (uInt16)index;
				finalCell   .Y = Renderer_DebugStart + (uInt16)index;

				Renderer_WriteToBufferCells((Cell*)DebugLogSection_Dynamic.Array[LogStart + index], startingCell, finalCell);
			}
		}

		for (size_t index = 0; index < Renderer_PersistentSectionSize; index++)
		{
			startingCell.Y = Renderer_DebugPersistentStart + (uInt16)index;
			finalCell   .Y = Renderer_DebugPersistentStart + (uInt16)index;

			Renderer_WriteToBufferCells((Cell*)&PersistentSection[index], startingCell, finalCell);
		}

	#endif

		Renderer_RenderFrame();

		Timer_Reset(&Renderer.RefreshTimer);
	}
}

void Renderer_WriteToBufferCells(const Cell* _cells, COORD _initalCell, COORD _finalCell)
{
	size_t lineOffset = _initalCell.Y * Renderer_Width;
	size_t colOffset  = _initalCell.X;

	size_t totalOffset = lineOffset + colOffset;

	Cell* bufferOffset = &Buffer[totalOffset];

	size_t dataSize = totalOffset;

	lineOffset =  _finalCell.Y * Renderer_Width;
	colOffset  =  _finalCell.X                  ;

	totalOffset = lineOffset + colOffset;

	dataSize = totalOffset - dataSize;

	if (dataSize == 0) dataSize = 1;

	Memory_FormatWithData(Cell, bufferOffset, _cells, dataSize);

	return;
}

void Renderer_DebugLogDynamic_AddLine(void)
{
#ifdef Debug

	if (DebugLogSection_Dynamic.Num == 0)
	{
		DebugLogSection_Dynamic.Array = GlobalAllocate(Line, 1);

		DebugLogSection_Dynamic.Num++;
	}
	else
	{
		void* resizeIntermediary = GlobalReallocate(Line, DebugLogSection_Dynamic.Array, (DebugLogSection_Dynamic.Num + 1));

		if (resizeIntermediary != NULL)
		{
			DebugLogSection_Dynamic.Array = resizeIntermediary;

			DebugLogSection_Dynamic.Num++;
		}
		else
		{
			perror("Failed to globally reallocate log line array.");

			exit(1);
		}
	}

#endif
}

void Renderer_WriteToLog(const WideChar* _logString)
{
#ifdef Debug


	static uInt nextLine = 0;

	size_t logLength = wcslen(_logString);
	size_t linePos   = 0;

	if (nextLine == 0)
	{
		Renderer_DebugLogDynamic_AddLine();
	}

	for (size_t index = 0; index < logLength; index++)
	{
		if (linePos > Renderer_Width - 1)
		{
			nextLine++;

			Renderer_DebugLogDynamic_AddLine();

			linePos = 0;
		}

		DebugLogSection_Dynamic.Array[nextLine][linePos].Char.UnicodeChar = _logString[index];
		DebugLogSection_Dynamic.Array[nextLine][linePos].Attributes       = Console_WhiteCell;

		linePos++;
	}

	for (size_t index = linePos; index < Renderer_Width; index++)
	{
		DebugLogSection_Dynamic.Array[nextLine][index].Char.UnicodeChar = 0;
		DebugLogSection_Dynamic.Array[nextLine][index].Attributes       = 0;
	}

	nextLine++;

	Renderer_DebugLogDynamic_AddLine();

	DebugLogSection_RelativeLastLine = 1;

#endif
}

// Note: Row starts at 1.
void Renderer_WriteToPersistentSection(sInt _row, const WideChar* _lineformat, ...)
{
#ifdef Debug

	WideChar TranslationBuffer[Renderer_Width];

	Cell* PersistentSubSection = PersistentSection[_row - 1];

	sInt CellsFormatted;

	va_list argList;


	va_start(argList, _lineformat);

	CellsFormatted = 
		
		// Windows hard coding.
		_vswprintf_s_l
		(
			TranslationBuffer, 
			Renderer_Width, 
			_lineformat, 
			NULL,
			argList
		);

	va_end(argList);

	for (size_t index = 0; index < CellsFormatted; index++)
	{
		PersistentSubSection[index].Char.UnicodeChar = TranslationBuffer[index];
		PersistentSubSection[index].Attributes       = Console_WhiteCell;
	}

	for (size_t index = CellsFormatted + 1; index < Renderer_Width; index++)
	{
		PersistentSubSection[index].Char.UnicodeChar = 0;
		PersistentSubSection[index].Attributes       = 0;
	}

#endif
}



// Private

void DrawGameScanlines(void)
{
	static COORD cellIndex = { 0, 0 };

	const WideChar blockChar = '-';

	Cell cellUnit;

	cellUnit.Char.UnicodeChar = blockChar;
	cellUnit.Attributes       = FOREGROUND_INTENSITY;

	Cell cellLine[Renderer_Width];

	for (size_t index = 0; index < Renderer_Width; index++)
	{
		cellLine[index] = cellUnit;
	}

	COORD cellIndex_End = { Renderer_Width, cellIndex.Y };

	Renderer_WriteToBufferCells((Cell*)&cellLine, cellIndex, cellIndex_End);

	cellIndex.Y++;

	if (cellIndex.X >= Renderer_Width)
	{
		cellIndex.X = 0;

		cellIndex.Y++;
	}

	if (cellIndex.Y > Renderer_GameEnd)
	{
		cellIndex.X = 0;

		cellIndex.Y = 0;
	}
}

void InitalizeData(void)
{
	// Setup Necessary Data

	Screen.Center.X = GetSystemMetrics(SM_CXSCREEN) / 2;
	Screen.Center.Y = GetSystemMetrics(SM_CYSCREEN) / 2;

	Renderer.ScreenPosition.X = (Screen.Center.X - ((Renderer_Width  / 2) * 8)) - 20;
	Renderer.ScreenPosition.Y = (Screen.Center.Y - ((Renderer_Height / 2) * 8)) - 200;

	Renderer.RefreshTimer.Elapsed = 0.0;
	Renderer.RefreshTimer.EndTime = 1.0 / 60.0;

	Renderer.CoordSize.X = Renderer_Width ;
	Renderer.CoordSize.Y = Renderer_Height;

	Renderer.Output_Handle = GetStdHandle(STD_OUTPUT_HANDLE);

	Renderer.Window_Handle = GetConsoleWindow();

	Renderer.Size.Left   = Console_ScreenPos_00.X;
	Renderer.Size.Top    = Console_ScreenPos_00.Y;
	Renderer.Size.Right  = Renderer_Width  - 1;
	Renderer.Size.Bottom = Renderer_Height - 1;

	Renderer.CursorSettings.dwSize   = Console_Cursor_MinSize;
	Renderer.CursorSettings.bVisible = Console_Cursor_NotVisible;

	Buffer = GlobalAllocate(CHAR_INFO, Renderer_Width * Renderer_Height);

	Memory_FormatByFill(CHAR_INFO, Buffer, 0, Renderer_Width * Renderer_Height);

	Cell borderCell; 
	
	borderCell.Char.UnicodeChar = '='; 
	borderCell.Attributes       = Console_WhiteCell;

#ifdef Debug

	for (size_t index = 0; index < Renderer_Width; index++)
	{
		Border_GameDebug    [index] = borderCell;
		Border_LogPersistent[index] = borderCell;
	}

	DebugLogSection_Dynamic.Array = NULL;
	DebugLogSection_Dynamic.Num = 0;

#endif

	return;
}

// Do initial request and IO binding for console interface.
void SetupConsole(void)
{
	if (RequestConsole() != true)
	{
		perror("Failed to get console for rendering from operating system.");

		exit(1);
	}

	if (Bind_IOBufferTo_Console() != true)
	{
		perror("Failed to bind standard IO to renderer console.");

		exit(1);
	}

	return;
}

bool UpdateConsoleInfo(void)
{
	return GetConsoleScreenBufferInfo(Renderer.Output_Handle, &Renderer.CSBI_Instance);
}

void UpdateSizeAndPosition(void)
{
	// Set desired cursor preferences.
	SetConsoleCursorInfo(Renderer.Output_Handle, &Renderer.CursorSettings);

	// Change the window size.
	SetConsoleWindowInfo(Renderer.Output_Handle, true, &Renderer.Size);

	// Update the buffer size.
	SetConsoleScreenBufferSize(Renderer.Output_Handle, Renderer.CoordSize);

	// Update the window size.
	SetConsoleWindowInfo(Renderer.Output_Handle, true, &Renderer.Size);

	SetWindowPos
	(
		Renderer.Window_Handle,
		HWND_TOP,
		Renderer.ScreenPosition.X,
		Renderer.ScreenPosition.Y,
		0,
		0,
		SWP_NOSIZE
	);

	return;
}

void Renderer_Logs_ScrollUp(void)
{
#ifdef Debug

	if (DebugLogSection_RelativeLastLine < DebugLogSection_Dynamic.Num)
	{
		DebugLogSection_RelativeLastLine++;
	}

#endif
}

void Renderer_Logs_ScrollDown(void)
{
#ifdef Debug

	if (DebugLogSection_RelativeLastLine > 1)
	{
		DebugLogSection_RelativeLastLine --;
	}

#endif
}