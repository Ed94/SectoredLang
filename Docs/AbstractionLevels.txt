// Abstraction stuff

// No Abstraction

// Manual data
inline binary Something :
0101010101010101100100110101010101
1010101010101010101010101010101010
1010101010101001010101010101010101
;

// Base Compaction

inline hex Something :
541321AD
FEEEAABB
00011345
;

// Instruction Abstraction
// Memory Segment Abstraction

// Manual Assembly 
ct if Is(ISA::x86_64) : inline Entry16:
	alias : ISA::ExposeASM(ISA::x86_64); ;
    // We are already in 16-bit mode here!
	cli;                        // Disable interrupts.
	// Need 16-bit Protected Mode GDT entries!
	mov(eax, DATASEL16);        // 16-bit Protected Mode data selector.
	mov(ds, eax);
	mov(es, eax);
	mov(fs, eax);
	mov(gs, eax);
	mov(ss, eax);
	// Disable paging (we need everything to be 1:1 mapped).
	mov(eax, cr0);
	mov([savcr0], eax);          // save pmode CR0
	and(eax, 0x7FFFFFFe);        // Disable paging bit & disable 16-bit pmode.
	mov(cr0, eax);
	jmp(0:GoRMode);              // Perform Far jump to set CS.
;;


// ABI / API Abstraction

// Manual Definitions

// 1 
(Subj : ptr type, Other : ptr type) :
...

proc Something :
...
;

...
;

// 2
proc Something (Sub : ptr type, Other : ptr type) : 
;

// 3
proc Something : 
...
(Sub : ptr type, Other : ptr type) :
...
;

...
;
// All 3 Produce function symbol: Something__ptr_type__ptr_type


// ABI / API / Programming specification abstraction

// Definition Generators

// 1
<AType : type> :
...

(Subj : ptr AType, Other : ptr AType) :
proc Something :
...
;

...
;

// 2
proc Something <AType : type> (Subj : ptr AType, Other : ptr AType) :
...
;

// 3
proc Something : 
...
<AType: type> :
...
(Subj : ptr A Type, Other : ptr BType) :
;
...
;
...
;

// All 3 produce a generator to make a function symbol conforming to: Something__ptr_{type}__ptr_{type}



// Declarative Programming (Functional Programming), mathy static space programming via proofs


// Pure programming specification generation
	// Where SomethingA is any function that maps to a SomethingB function
	fn SomethingA<AType : type> -> fn SomethingB<...> : ... ;

// Pure programming specific generation with dependent types.
	// Where Something A is any function that uses AType which satisfies 
	// an interface of interfaceA which maps to a SomethingB function.
	fn SomethingA<AType : interfaceA> -> fn SomethingB<...> : ... ;
	
	
	

