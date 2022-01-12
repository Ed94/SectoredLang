/-
u8  : type :     byte;;
u16 : type : [2] byte;;
u32 : type : [4] byte;;
u64 : type : [8] byte;;
-/

/-
alias : 
uWord : ISA.uWord;
sWord : ISA.sWord;
;
-/

/-
bool :
	type : byte;
	ct :
	false : bool = 0x01;
	true  : bool = 0x01;
	;
;
-/


static testingType : ptr Type;


static 
{
	testingStr : 
		// [] byte = "Hello World!"
		ptr byte = "Hello World!"
	;
	
	testingValue : u8 = 0;
}

static :
	testingValue2 : bool = false;
;
/-
PAL : Console : proc : 
Send:; 
;;;
-/


proc : 
	HelloWorld :
		PAL.Console. Send("Hello World!");
	;
	
	GoodbyeWorld
	{	
		stack : 
			// GoodbyeStr : [] byte = "Goodbye World!";
			GoodbyeStr : ptr byte = "Goodbye World!";
		;
	
		PAL.Console. Send(GoodbyeStr);
	}
;

proc Entrypoint :
	// Say hello
	HelloWorld;
	
	// Say Goodbye
	GoodbyeWorld;
;