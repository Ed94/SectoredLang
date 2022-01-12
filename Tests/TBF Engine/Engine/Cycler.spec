proc :
	Lapse exe : 
		Exist = false; 
	;
	
	Initialize :
		loop : if Exist == true : break;
			Timing. TakeInitialSnapshot;	

			Input   . Update;
			State   . Update;
			Renderer. Update;

			Timing. TakeEndingSnapshot;
			Timing. Update;
		;
	;
	
	LoadModule :
		Exist = true;
	;
;
