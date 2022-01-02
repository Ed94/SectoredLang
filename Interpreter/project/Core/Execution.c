// Core
#include "Core.h"
// Lexer
#include "Lexer.h"
// Parser
#include "Parser.mas.h"
// Shell
// #include "Shell.h"

#pragma region StaticData

static const 
OS_EnvArgs* 
EnvArgsArray = nullptr;

static 
String 
StreamBuffer = { 0, nullptr };

#pragma endregion StaticData


void Console_PrintTitle       (void);
void Console_PrintEnvArguments(void);
void ProcessFile              (void);
void RunShell                 (void);


void Console_PrintTitle(void) 
{
	Log(sl"MAS Interpreter"); 
	Log(sl"Type: C");
	Log(sl"");

	Log(sl"App Env Arguments:");
}

void Console_PrintEnvArguments(void)
{
	for (uDM index = 0; index < EnvArgsArray->Count; index++)
	{
		LogF(sl"%lld : %s", index, EnvArgsArray->Arguments[index]);
	}

	Log(sl"");
}

void ProcessFile(void)
{
	Log("Checking first argument for file.");

	String* 
	filePath = strTo_String(EnvArgsArray->Arguments[1]);

	LogF(sl"Opening File: %s\n", filePath->Data);
	
	IO_File
	fileStream;
	
	IO_FileContent content = IO_File_ReadContent(filePath->Data, true);
	
	// ErrorType 
	// resultCode = IO_File_Open(ptrof fileStream, filePath->Data, IO_AccessMode_Read);

	if (content.Size <= 0)
	{
		Exception_Throw(sl"Failed to open the file.\n");
		return;
	}
	
	Log(sl"File successfuly opened\n");	
	
	bool 
	result = String_Reserve(ptrof StreamBuffer, _4K);
	
	if (! result)
	{
		Exception_Throw("Not able to reserve string.\n");
		return;
	}
	
	str rawBuffer = StreamBuffer.Data;
	
	Mem_FormatWithData(schar, rawBuffer, content.Data, content.Size);

	// uDM test = IO_File_Read(ptrof fileStream, rawBuffer, _4K);
	
	// rawBuffer[test -1] = '\0';

	Log(sl"Contents:\n");
	LogF("%s\n", rawBuffer);
}

void LexStream(void) 
{
	Lexer_Init(ptrof StreamBuffer);

	Log("Streaming Tokens:");
	
	Token* 
	currentToken = Lexer_NextToken();
	
#define Type    currentToken->Type
#define Value   currentToken->Value
	loop
	{
		if (currentToken == nullptr
		||  Type == Token_Invalid
		||  Type == Tok_Comp_EOF
		) break;

		LogF("\nType : %-15s, Value: %s", TokenTo[Type].Str, Value->Data);

		currentToken = Lexer_NextToken();
	}
#undef Type
#undef Vlaue
}

void ParseStream()
{
	Lexer_Init(ptrof StreamBuffer);
	
	Parser_Init();
	
	// Currently we know the file passed will be a spec unit.
	ast_Node* ast = Parse(CUT_Specification);
	
	Log("Completed parse.");
}

OS_ExitVal 
OSAL_EntryPoint()
{
	Console_PrintTitle();

	EnvArgsArray = OSAL_GetEnvArgs();
	
	Console_PrintEnvArguments();

	if (EnvArgsArray->Count < 2)
	{
		Log(sl"No context file (<NameOfFile>.context>) was not provided.");
		Log(sl"\n");
	}
	else
	{
		ProcessFile();
		
		Log("\nFinished processing file...\n");
		
		// LexStream();
		ParseStream();
	}
	
	// RunShell();

	Log(sl"Press enter to exit.");
	getchar();
	
	return OS_ExitCode_Success;
}
