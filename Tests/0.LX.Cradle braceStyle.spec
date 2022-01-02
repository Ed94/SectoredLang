static testingType { ptr type }

static 
{
	testingStr { 
		ptr byte = "Hello World!" 
	}
	
	testingValue { u8 = 0 }
}

static {
	testingValue2 { bool = "false" }
}

/-
PAL : Console : proc : 
Send:; 
;;;
-/

proc {
	HelloWorld {
		PAL.Console. Send("Hello World!");
	}
	
	GoodbyeWorld
	{	
		stack {
			GoodbyeStr { ptr ro byte = "Goodbye World!" }
		}
	
		PAL.Console. Send(GoodbyeStr);
	}
}

proc Entrypoint {
	// Say hello
	HelloWorld;
	
	// Say Goodbye
	GoodbyeWorld;
}
