inline :

ct :
if (ISA::Arch == ISAx86-64) :
{
	alias : AddressLine : ISA::AddressLine; ;

	proc :
		Enter_ProtectedMode :
			ISA:: DisableInterrupts;
			ISA:: Enable_A20;
			
			if (! ISA:: Is_Enabled_A20) :
				Hang;
			;
			
			ISA:: DS_Init;
			ISA:: Load_GDT;
			ISA:: JumpTo_ProtectedMode;
		;
	
		ProtectedMode_MakeScratchStack :
			alias : 
				ISA::Expose_Registers; 
				GDT : ISA::GDT;
				mov : ISA::mov;
			;
			
			mov(ax, GDT::DS);
			mov(ds, ax);
			mov(ss, ax);
			mov(es, ax);
			mov(esp, 0x90000);
		;
	
		Setup_4LevelPaging :
			ISA:: Enable_PAE;
			ISA:: Enable_LME;
			ISA:: Enable_PG;
			ISA:: Set_PML4_Ptr;
			ISA:: EnablePaging;
		;
	
		Enter_LongMode :
		;

		Trampoline_x86-64 :
			alias : TextMode : ISA:: VideoMode:: TextMode; ;
		
			ISA:: SetVideoMode(TextMode);

			Enter_ProtectedMode;
			ProtectedMode_MakeScratchStack;
			
			Setup_4LevelPaging;
			Enter_LongMode;
		;
	;
};
else
;;


proc : 
{
	Boot :
		Trampoline;
		Hang;
	;
	
	Hang : 
		loop :; 
	;
	
	ct Is_x86-64 : bool = ISA::Arch == ISA::x86-64;
	
	Trampoline :
		ct if Is_x86-64 : 
			Trampoline_x86-64;
		;
	;
};

; // inline
