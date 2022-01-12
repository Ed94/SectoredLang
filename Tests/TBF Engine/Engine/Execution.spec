proc :
	PrepareModules exe :
		Cycler  . LoadModule;
		Timing  . LoadModule;
		Input   . LoadModule;
		Renderer. LoadModule;
		State   . LoadModule;
	;
	
	PrintStartMessage exe :
		Renderer. DLog("TBF MAS Engine");
		Renderer. DLog("");
		Renderer. DLog("Version: C Phase 14 Translated");
	;
	
	UnloadModules exe :
		Renderer. UnloadModule;	
		Memory  . UnloadModule;
	;
	
	Entrypoint exe :
		PrepareModules;
		PrintStartMessage;
		
		Cycler. Initialize;
		
		UnloadModules;
		
		ret ExecResult.Success;
	;
;
