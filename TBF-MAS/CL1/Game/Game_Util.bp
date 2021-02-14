#pragma once



// Includes

#include "Engine/Engine.h"




// Enums

enum ECharacter_MoveState_Def
{
	ECharacter_DontMove ,
	ECharacter_MoveLeft ,
	ECharacter_MoveRight,
};

enum ELevelCellType_Def
{
	ELevelCellType_Empty  = 0,
	ELevelCellType_Pit    = BACKGROUND_BLUE,
	ELevelCellType_Ground = BACKGROUND_GREEN,
	ELevelCellType_Finish = BACKGROUND_RED
};



// Aliases

// Character

typedef enum ECharacter_MoveState_Def ECharacter_MoveState;

typedef struct Character_Def Character;

// Level

typedef enum ELevelCellType_Def ELevelCellType;

typedef Line GameScreenBuffer[Renderer_GameEnd + 1];

typedef GameScreenBuffer Level;

// Space

typedef struct Vector2D_Def Vector2D;

// UI

typedef struct UI_Text_Def   UI_Text;
typedef struct UI_Button_Def UI_Button;
typedef struct UI_Grid_Def   UI_Grid;
typedef struct UI_Widget_Def UI_Widget;



// Structs

// Space

struct Vector2D_Def
{
	float32 X;
	float32 Y;
};

// Character

struct Character_Def
{
	Cell Sprite;

	Vector2D Position;

	float32 VerticalVelocity;

	bool ShouldJump, Fell;

	sInt Active_MoveState;
	sInt MoveState;
};

// UI

struct UI_Text_Def
{
	WideChar* Content;

	size_t Length;

	Cell* RenderCells;

	COORD StartingCell, EndingCell;
};

struct UI_Button_Def
{
	UI_Text Text;

	Void_Function* Callback;
};

struct UI_Grid_Def
{
	UI_Button* Buttons;

	size_t Num;

	size_t CurrentIndex;
};

struct UI_Widget_Def
{
	UI_Text* TextUIs;

	size_t Num_TextUIs;

	//Ptr(UI_Grid) Grids;

	UI_Grid Grid;
};



// Functions

// Character

bool Character_AtFinish(Character* _character, Level* _level);

bool Character_IsGrounded(Character* _character, Level* _level);

void Character_Load(Character* _character);

void Character_Update(Character* _character, Level* _level);

void Character_Render(Character* _character);

// Level

sInt Level_GetCellAtPosition(Level* _level, Vector2D _position);

void Level_SetCells(Level* _level, COORD _firstCell, COORD _lastCell, ELevelCellType _cellType);

void Level_Render(Level* _level);

// Space

COORD Convert_Vector2D_ToRenderCoord(Vector2D _vector);

// General Rendering

void ChangeCellsTo_Grey(Cell* _renderCells, size_t _length);

void ChangeCellsTo_White(Cell* _renderCells, size_t _length);

// UI

void UI_Text_Create 
(
	      UI_Text*  _uiText, 
	const WideChar* _content, 
	      COORD     _startingCell, 
	      COORD     _endingCell,
	      bool      _shouldCenter
);

void UI_Text_Render(const UI_Text* _uiText);

void UI_Button_Create 
(
	      UI_Button*     _button, 
	const WideChar*      _text, 
	      COORD          _startingCell, 
	      COORD          _endingCell, 
	      bool           _shouldCenter,
	      Void_Function* _callback
);

void UI_Button_Press (const UI_Button* _uiButton);
void UI_Button_Render(const UI_Button* _uiButton);

void UI_Grid_Add 
(
	      UI_Grid*        _uiGrid, 
	const WideChar*       _text, 
	       COORD          _startingCell, 
	       COORD          _endingCell, 
	       bool           _shouldCenter,
	       Void_Function* _callback
);

void UI_Grid_MoveUp  (UI_Grid* _uiGrid);
void UI_Grid_MoveDown(UI_Grid* _uiGrid);
void UI_Grid_Select  (UI_Grid* _uiGrid);
void UI_Grid_Render  (UI_Grid* _uiGrid);

void UI_Widget_AddText
(
	      UI_Widget*     _uiWidget,
	const WideChar*      _text,
	      COORD          _startingCell,
	      COORD          _endingCell,
	      bool           _shouldCenter
);

void UI_Widget_AddButton 
(
	      UI_Widget*     _uiWidget,
	const WideChar*      _text,
	      COORD          _startingCell,
	      COORD          _endingCell,
	      bool           _shouldCenter,
	      Void_Function* _callback
);

void UI_Widget_MoveUp  (UI_Widget* _uiWidget);
void UI_Widget_MoveDown(UI_Widget* _uiWidget);
void UI_Widget_Select  (UI_Widget* _uiWidget);
void UI_Widget_Render  (UI_Widget* _uiWidget);


