/-
u8  : type :     byte;;
u16 : type : [2] byte;;
u32 : type : [4] byte;;
u64 : type : [8] byte;;
-/

/-
alias expose :
uWord : ISA.uWord;
sWord : ISA.sWord;
;
-/

/-
bool :
	type : byte;

	ct :
	false : bool = 0x00;
	true  : bool = 0x01;
	;
;
-/


static testingType : ptr type;


static :
{
	testingStr : 
		// [] byte = "Hello World!"
		ptr byte = "Hello World!"
	;
	
	testingValue : u8 = 0;
};

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
	
	GoodbyeWorld :
	{	
		stack : 
			// GoodbyeStr : [] byte = "Goodbye World!";
			GoodbyeStr : ptr byte = "Goodbye World!";
			
			/-
			GoodbyeStr;
			
			push GoodbyeStr
			-/
		;
	
		PAL.Console. Send(GoodbyeStr);
	};
;

/-
proc Namespaced :
	Procedure :
		PAL.Console. Send("Nested.Procedure!");
		
		Nested :
			PAL.Console. Send("Nested Inline Procedure!");
		;
		
		Nested;
	;
;

proc Another.Nested.Procedure : 
	PAL.Console. Send("Another.Nested.Procedure!");
;

proc Another.Nested :
	Procedure2 :
		PAL.Console. Send("Another.Nested.Procedure2!");
	;
;
-/

proc (u32 , u32) : 

	Add 

;

proc Entrypoint :
	// Say hello
	HelloWorld;
	
	// Say Goodbye
	GoodbyeWorld;
;
