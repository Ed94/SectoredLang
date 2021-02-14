#pragma once



// Includes

#include "OSPlatform.h"
#include "FloatCompare.h"
#include "LAL.h"



// Enums

enum Timing_Constants
{
	TickToMicroseconds  = 1000000 ,
	MicrosecondToSecond = 10000000
};



// Aliases (Typedefs)

typedef struct TimingData_Def TimingData;



// Structures

struct TimingData_Def
{
	LARGE_INTEGER TimeSnapshot_Initial;
	LARGE_INTEGER TimeSnapshot_End    ;
	LARGE_INTEGER TimeFrequency       ;
	sInt64        Cycle_TicksElapsed  ;
	float64       Cycle_Microseconds  ;
	float64       DeltaTime           ;
};




// Functions

const TimingData* Timing_GetContext(void);

void Timing_LoadModule(void);

void Timing_TakeInitialSnapshot(void);

void Timing_TakeEndingSnapshot(void);

void Timing_Update(void);



// Timer Class

// Aliases (Typedefs)

typedef struct TimerData_Def TimerData;



// Structs

struct TimerData_Def
{
	float64 Elapsed;
	float64 EndTime;
};



// Functions

bool Timer_Ended(TimerData* _timer);

void Timer_Reset(TimerData* _timer);

void Timer_Tick(TimerData* _timer);

