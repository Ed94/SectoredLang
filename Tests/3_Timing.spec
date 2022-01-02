Layer 0 :


static : Timing : TimingData;;

alias : Clock : Platform:: HResClock;;

Snapshot : pub proc :
	Start : Timing.Snapshot.Start = Clock.Now(); ;
	End   : Timing.Snapshot.Ended = Clock.Now(); ;
;;

proc :
pub :
{
	GetContext -> ptr TimingData : ret Timing.ptr ;
	
	Load_Module : InitData; ;
	
	Update :
	{
		in Timing :
			TicksElapsed = Snapshot.End - Snapshot.Start;
			
			Microseconds  = TicksElapsed * Ticks_ToMicroseconds;
			Microseconds /= Clock.Frequency;
			
			DeltaTime = TicksElapsed / Microsecond_ToSecond;

			Renderer:: TimingUpdated(DeltaTime);
		;
	};
};

proc InitData : in Timing :
	TicksElapsed = 0;
	Microseconds = 0.0;
	DeltaTime    = 0.0;
;;
; // proc



(_self : ptr Timer) : pub proc : in _self :

	// This alias definition is restrictd to this pub proc: scope
	alias :
	{	
		// This is overloading the default floating point operator 
		// with one that takes into account float accuracy to the epsilon.
		// f64.epsilon is a member defined by SL::Numerics.
		f64.>= : SL::Numerics:: f64.>=<f64.epsilon>;
		f64.<= : SL::Numerics:: f64.<=<f64.epsilon>;
	};

	Ended -> bool : ret Elapsed >= EndTime;;
	Reset : Elapsed = 0.0;;
	Tick : 
	{
		if Timing.DeltaTime <= 0.000001 : 
			Elapsed += 0.000001;
		;
		else : Elapsed += Timing.DeltaTime;;
	};
;;;


; // End of Layer 0
