// Parent Header
#include "Game_Util.h"



// Functions

// Public

// Character

bool Character_AtFinish(Character* _character, Level* _level)
{
	Vector2D collisionPostion = _character->Position;

	collisionPostion.Y -= 0.085f;

	sInt cellCollided = Level_GetCellAtPosition(_level, collisionPostion);

	return cellCollided == ELevelCellType_Finish;
}

bool Character_IsGrounded(Character* _character, Level* _level)
{
	Vector2D collisionPostion = _character->Position;

	collisionPostion.Y -= 0.085f;

	sInt cellCollided = Level_GetCellAtPosition(_level, collisionPostion);

	return cellCollided == ELevelCellType_Ground || cellCollided == ELevelCellType_Finish;
}

void Character_Load(Character* _character)
{
	_character->Sprite.Char.UnicodeChar = 0;
	_character->Sprite.Attributes       = BACKGROUND_INTENSITY | BACKGROUND_RED | BACKGROUND_GREEN | BACKGROUND_BLUE;

	_character->Position.X = -0.975f;
	_character->Position.Y = -0.075f;

	_character->VerticalVelocity = 0.0f;

	_character->ShouldJump = false;
	_character->Fell       = false;

	_character->MoveState        = ECharacter_DontMove;
	_character->Active_MoveState = ECharacter_DontMove;
}

void Character_Update(Character* _character, Level* _level)
{
	if (_character->Fell == true) return;


	float32 deltaTime = (float32)Timing_GetContext()->DeltaTime;

	static float32 velocity = 1.0f;
	static float32 gravity  = 0.00004f;

	Vector2D collisionPostion = _character->Position;

	collisionPostion.Y -= 0.085f;

	sInt cellCollided = Level_GetCellAtPosition(_level, collisionPostion);

	if (cellCollided == ELevelCellType_Ground || cellCollided == ELevelCellType_Finish)
	{
		_character->VerticalVelocity = 0.0f;

		_character->Position.Y = -0.9f;

		_character->Active_MoveState = _character->MoveState;
	}
	else if (cellCollided == ELevelCellType_Pit)
	{
		_character->VerticalVelocity = 0.0f;

		_character->Position.Y = -0.9f;

		_character->Fell = true;
	}
	else
	{
		_character->VerticalVelocity -= gravity * deltaTime;

		_character->Position.Y += _character->VerticalVelocity;
	}

	if (cellCollided == ELevelCellType_Finish) return;

	if (_character->ShouldJump && cellCollided == ELevelCellType_Ground)
	{
		Renderer_WriteToLog(L"Giving character jump velocity");

		_character->VerticalVelocity = 0.075f * deltaTime;

		_character->Position.Y = -0.75f;

		_character->ShouldJump = false;
	}

	switch (_character->Active_MoveState)
	{
		case ECharacter_MoveLeft:
		{
			if (_character->Position.X > -1.0f)
			{
				_character->Position.X -= velocity * deltaTime;
			}

			break;
		}
		case ECharacter_MoveRight:
		{
			if (_character->Position.X < 1.0f)
			{
				_character->Position.X += velocity * deltaTime;
			}

			break;
		}
	}
}

void Character_Render(Character* _character)
{
	if (_character->Fell) return;

	COORD renderCoord = Convert_Vector2D_ToRenderCoord(_character->Position);

	Renderer_WriteToPersistentSection(1, L"Pos X: %f", _character->Position.X);
	Renderer_WriteToPersistentSection(3, L"Pos Y: %f", _character->Position.Y);

	Renderer_WriteToPersistentSection(2, L"RC  X: %u", renderCoord.X);
	Renderer_WriteToPersistentSection(4, L"RC  Y: %u", renderCoord.Y);

	if (renderCoord.Y < 0               ) renderCoord.Y = 0;
	if (renderCoord.Y > Renderer_GameEnd) renderCoord.Y = Renderer_GameEnd;

	Renderer_WriteToBufferCells(&_character->Sprite, renderCoord, renderCoord);

#ifdef Debug

	static Cell colliderView = 
	{
		0,
		BACKGROUND_INTENSITY | BACKGROUND_RED | BACKGROUND_GREEN
	};

	COORD colliderViewCoord;

	Vector2D collisionPostion = _character->Position;

	collisionPostion.Y -= 0.085f;

	colliderViewCoord = Convert_Vector2D_ToRenderCoord(collisionPostion);

	if (colliderViewCoord.Y < 0               ) colliderViewCoord.Y = 0;
	if (colliderViewCoord.Y > Renderer_GameEnd) colliderViewCoord.Y = Renderer_GameEnd;

	Renderer_WriteToBufferCells(&colliderView, colliderViewCoord, colliderViewCoord);
#endif
}

// Level

sInt Level_GetCellAtPosition(Level* _level, Vector2D _position)
{
	COORD renderCoord = Convert_Vector2D_ToRenderCoord(_position);

	Cell* cellBuffer = (Cell*)_level;

	size_t lineOffset = renderCoord.Y * Renderer_Width;
	size_t colOffset  = renderCoord.X;

	size_t totalOffset = lineOffset + colOffset;

	return cellBuffer[totalOffset].Attributes;
}

void Level_SetCells(Level* _level, COORD _firstCell, COORD _lastCell, ELevelCellType _cellType) 

SmartScope
{

	size_t lineOffset = _firstCell.Y * Renderer_Width;
	size_t colOffset  = _firstCell.X;

	size_t totalOffset = lineOffset + colOffset;

	Cell* levelCellBuffer = (Cell*)_level;

	Cell* bufferOffset = &levelCellBuffer[totalOffset];

	size_t dataSize = totalOffset;

	lineOffset = _lastCell.Y * Renderer_Width;

	colOffset  = _lastCell.X;

	totalOffset = lineOffset + colOffset;

	dataSize = totalOffset - dataSize;

	if (dataSize == 0) dataSize = 1;

	Cell* setCellBuffer = ScopedAllocate(Cell, dataSize);

	for (size_t index = 0; index < dataSize; index++)
	{
		setCellBuffer[index].Char.UnicodeChar = 0;
		setCellBuffer[index].Attributes       = _cellType;
	}

	Memory_FormatWithData(Cell, bufferOffset, (void*)setCellBuffer, dataSize);
}
SmartScope_End

void Level_Render(Level* _level)
{
	COORD 
		screenStart = {               0,                 0 }, 
		screenEnd   = { Renderer_Width, Renderer_GameEnd } ;

	Renderer_WriteToBufferCells((Cell*)_level, screenStart, screenEnd);
}

// Space

COORD Convert_Vector2D_ToRenderCoord(Vector2D _vector)
{
	static float32 
		offsetX = (float32)Renderer_Width   / 2.0f, 
		offsetY = (float32)Renderer_GameEnd / 2.0f;

	float32 
		convertedX = _vector.X * ((float32)Renderer_Width   / 2.0f), 
		convertedY = _vector.Y * ((float32)Renderer_GameEnd / 2.0f);

	COORD renderingCoord;

	renderingCoord.X = (sInt16)(convertedX + offsetX   );	
	renderingCoord.Y = (sInt16)(offsetY    - convertedY);

	if (renderingCoord.X >= Renderer_Width) renderingCoord.X = Renderer_Width - 1;

	return renderingCoord;
}


// General Rendering

void ChangeCellsTo_Grey(Cell* _renderCells, size_t _length)
{
	for (size_t cellIndex = 0; cellIndex < _length; cellIndex++)
	{
		_renderCells[cellIndex].Attributes = FOREGROUND_INTENSITY;
	}
}

void ChangeCellsTo_White(Cell* _renderCells, size_t _length)
{
	for (size_t cellIndex = 0; cellIndex < _length; cellIndex++)
	{
		_renderCells[cellIndex].Attributes = Console_WhiteCell;
	}
}


// UI

// Text

void UI_Text_Create 
(
	      UI_Text*  _uiText, 
	const WideChar* _content, 
	      COORD     _startingCell, 
	      COORD     _endingCell,
	      bool      _shouldCenter
)
{
	// Get length of contents.

	_uiText->Length = wcslen(_content) + 1;

	// Format the contents.

	_uiText->Content = GlobalAllocate(WideChar, _uiText->Length);

	wcscpy_s(_uiText->Content, _uiText->Length, _content);

	_uiText->RenderCells = GlobalAllocate(Cell, _uiText->Length);

	for (size_t cellIndex = 0; cellIndex < _uiText->Length; cellIndex++)
	{
		_uiText->RenderCells[cellIndex].Char.UnicodeChar = _uiText->Content[cellIndex];
		_uiText->RenderCells[cellIndex].Attributes       = Console_WhiteCell;
	}

	_uiText->StartingCell = _startingCell;
	_uiText->EndingCell   = _endingCell;

	if (_shouldCenter)
	{
		_uiText->StartingCell.X += (Renderer_Width / 2) - ((uInt16)_uiText->Length / 2);
		_uiText->EndingCell  .X += (Renderer_Width / 2) + ((uInt16)_uiText->Length / 2);

		_uiText->StartingCell.X--;
		_uiText->EndingCell  .X--;
	}
	else
	{
		_uiText->EndingCell.X += (uInt16)_uiText->Length;
	}
}

void UI_Text_Render(const UI_Text* _uiText)
{
	Renderer_WriteToBufferCells(_uiText->RenderCells, _uiText->StartingCell, _uiText->EndingCell);
}


// Button

void UI_Button_Create 
(
	      UI_Button*     _button, 
	const WideChar*      _text, 
	      COORD          _startingCell, 
	      COORD          _endingCell, 
	      bool           _shouldCenter,
	      Void_Function* _callback
)
{
	// Get length of contents.

	_button->Text.Length = wcslen(_text) + 1;

	// Format the contents.

	_button->Text.Content = GlobalAllocate(WideChar, _button->Text.Length);

	wcscpy_s(_button->Text.Content, _button->Text.Length, _text);

	_button->Text.RenderCells = GlobalAllocate(Cell, _button->Text.Length);

	for (size_t cellIndex = 0; cellIndex < _button->Text.Length; cellIndex++)
	{
		_button->Text.RenderCells[cellIndex].Char.UnicodeChar = _button->Text.Content[cellIndex];
		_button->Text.RenderCells[cellIndex].Attributes       = Console_WhiteCell;
	}

	_button->Text.StartingCell = _startingCell;
	_button->Text.EndingCell   = _endingCell;

	if (_shouldCenter)
	{
		_button->Text.StartingCell.X += (Renderer_Width / 2) - ((uInt16)_button->Text.Length / 2);
		_button->Text.EndingCell  .X += (Renderer_Width / 2) + ((uInt16)_button->Text.Length / 2);

		_button->Text.StartingCell.X--;
		_button->Text.EndingCell  .X--;
	}
	else
	{
		_button->Text.EndingCell.X += (uInt16)_button->Text.Length / 2;
	}

	_button->Callback = _callback;
}

void UI_Button_Press(const UI_Button* _uiButton)
{
	_uiButton->Callback();
}

void UI_Button_Render(const UI_Button* _uiButton)
{
	Renderer_WriteToBufferCells(_uiButton->Text.RenderCells, _uiButton->Text.StartingCell, _uiButton->Text.EndingCell);
}


// Grid

void UI_Grid_Add 
(
	      UI_Grid*       _uiGrid, 
	const WideChar*      _text, 
	      COORD          _startingCell, 
	      COORD          _endingCell, 
	      bool           _shouldCenter,
	      Void_Function* _callback
)
{
	if (_uiGrid->Num == 0)
	{
		_uiGrid->Buttons = GlobalAllocate(UI_Button, 1);

		_uiGrid->Num++;
	}
	else
	{
		void* resizeIntermediary = GlobalReallocate(UI_Button, _uiGrid->Buttons, (_uiGrid->Num + 1));

		if (resizeIntermediary != NULL)
		{
			_uiGrid->Buttons = resizeIntermediary;

			_uiGrid->Num++;
		}
		else
		{
			perror("Failed to globally reallocate subscription array.");

			exit(1);
		}
	}

	UI_Button_Create
	(
		&_uiGrid->Buttons[_uiGrid->Num - 1], 
		
		_text, 
		_startingCell, 
		_endingCell, 
		_shouldCenter, 
		_callback
	);

	if (_uiGrid->Num != 1)
	{
		ChangeCellsTo_Grey
		(
			_uiGrid->Buttons[_uiGrid->Num -1].Text.RenderCells, 
			_uiGrid->Buttons[_uiGrid->Num -1].Text.Length
		);
	}
}

void UI_Grid_MoveUp(UI_Grid* _uiGrid)
{
	size_t* currentIndex = &_uiGrid->CurrentIndex;

	UI_Text* buttonText = &_uiGrid->Buttons[*currentIndex].Text;

	if (*currentIndex > 0)
	{
		ChangeCellsTo_Grey(buttonText->RenderCells, buttonText->Length);

		*currentIndex =  *currentIndex - 1;

		buttonText = &_uiGrid->Buttons[*currentIndex].Text;

		ChangeCellsTo_White(buttonText->RenderCells, buttonText->Length);
	}
}

void UI_Grid_MoveDown(UI_Grid* _uiGrid)
{
	size_t* currentIndex = &_uiGrid->CurrentIndex;

	UI_Text* buttonText = &_uiGrid->Buttons[*currentIndex].Text;

	if (*currentIndex < (_uiGrid->Num - 1))
	{
		ChangeCellsTo_Grey(buttonText->RenderCells, buttonText->Length);

		*currentIndex = *currentIndex + 1;

		buttonText = &_uiGrid->Buttons[*currentIndex].Text;

		ChangeCellsTo_White(buttonText->RenderCells, buttonText->Length);
	}
}

void UI_Grid_Select(UI_Grid* _uiGrid)
{
	UI_Button_Press(&_uiGrid->Buttons[_uiGrid->CurrentIndex]);
}

void UI_Grid_Render(UI_Grid* _uiGrid)
{
	for (size_t index = 0; index < _uiGrid->Num; index++)
	{
		UI_Button_Render(&_uiGrid->Buttons[index]);
	}
}


// Grid

void UI_Widget_AddText
(
	      UI_Widget* _uiWidget,
	const WideChar*  _text,
	       COORD     _startingCell,
	       COORD     _endingCell,
	       bool      _shouldCenter
)
{
	if (_uiWidget->Num_TextUIs == 0)
	{
		_uiWidget->TextUIs = GlobalAllocate(UI_Text, 1);

		_uiWidget->Num_TextUIs++;
	}
	else
	{
		void* resizeIntermediary = GlobalReallocate(UI_Text, _uiWidget->TextUIs, (_uiWidget->Num_TextUIs + 1));

		if (resizeIntermediary != NULL)
		{
			_uiWidget->TextUIs = resizeIntermediary;

			_uiWidget->Num_TextUIs++;
		}
		else
		{
			perror("Failed to globally reallocate subscription array.");

			exit(1);
		}
	}

	UI_Text_Create
	(
		&_uiWidget->TextUIs[_uiWidget->Num_TextUIs - 1], 
		
		_text, 
		_startingCell, 
		_endingCell, 
		_shouldCenter
	);
}

void UI_Widget_AddButton 
(
	      UI_Widget*      _uiWidget,
	const WideChar*       _text,
	       COORD          _startingCell,
	       COORD          _endingCell,
	       bool           _shouldCenter,
	       Void_Function* _callback
)
{
	UI_Grid_Add
	(
		&_uiWidget->Grid, 
		
		_text, 
		_startingCell, 
		_endingCell, 
		_shouldCenter, 
		_callback
	);
}

void UI_Widget_MoveUp(UI_Widget* _uiWidget)
{
	UI_Grid_MoveUp(&_uiWidget->Grid);
}

void UI_Widget_MoveDown(UI_Widget* _uiWidget)
{
	UI_Grid_MoveDown(&_uiWidget->Grid);
}

void UI_Widget_Select(UI_Widget* _uiWidget)
{
	UI_Grid_Select(&_uiWidget->Grid);
}

void UI_Widget_Render(UI_Widget* _uiWidget)
{
	for (size_t index = 0; index < _uiWidget->Num_TextUIs; index++)
	{
		UI_Text_Render(&_uiWidget->TextUIs[index]);
	}

	UI_Grid_Render(&_uiWidget->Grid);
}
