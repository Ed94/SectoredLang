static InputObj : type : Data;;

proc :
GetContext -> ptr Data : ret InputObj.ptr;

LoadModule exe :;

Update : in InputObj
{
	stack index : uword = 0;
	
	exe : 
		loop : if index < NumKeysTracked : break;
		{
			stack : current, previous : bool;;
			
			PreviousState[index] = CurrentState[index];
			previous             = CurrentState[index];
			
			CurrentState[index] = OS.KeyCode[index];
			current             = CurrentState[index];
			
			stack latestState     : State = State.None;
			alias currentKeyState : KeyStates[index] ;
			
			if current == previous :
				if current == true :
					latestState = State.PressHeld;
				;
				else :
					if currentKeyState != State.PressHeld :
						latestState = None;
					;
				;
			;
			else :
				if current == false : 
					latestState = State.Released;
				;
				else :
					latestState = State.Pressed;
				;
			;
			
			if latestState != currentKeyState :
				currentKeyState = latestState;
					
				stack subindex    : uword = 0;
				alias keyEventSub : KeyEventSubs[subindex];
				loop : if subindex < KeyEventSubs.Num : break;
				{
					if keyEventSub.Get(subIndex)currentKeyState.val != null :
						// Call subscribed.
						keyEventSub.Get(subIndex) (currentKeyState.val);
					;
					subIndex++;
				};
			;
		};
	;
}

(_key : OS.KeyCode, _callback : ptr Event)
{
	Subscribe :
		alias 
	;
	
	Unsubscribe :

	;
}
/- proc -/;


