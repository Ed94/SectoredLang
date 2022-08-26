# Token Types :

<pre>
Comment         # Author commentary
Components      # Helper tokens to aid in tokenization.
Formatting      # Ignored tokens intended to be used by the author to format text properly. (Not necessary unless using the Tokenization frontend)
Parameters      # Used for parametization contexts
Operator        # LTP supported operation interface
Literal         # Translation time data formats
    Digit
    Character
    String
Sector          # Context sectorizers, the bread and butter structrual organization for MAS language programs.
Statement       # Used to delimit what a (statement) should be in MAS.
</pre>

# Universal Context

## Tokens
<pre>
#------------------------------------------------------
                                                        Comments
//              Comment Line            cmt_SS
/-              Start Comment           cmt_SC
-/              End Comment             cmt_EC
#------------------------------------------------------
                                                        Components
' '             Whitespace              comp_WS
'_'             Underscore              comp_UnderS
\0              Null Terminator         comp_Null             
EOF             End of file             comp_EOF
'"'             Stirng Dilimiter        comp_SDilim
#------------------------------------------------------
                                                        Formatting
" ..."          Whitespace String       fmt_WSS
\n              NewLine                 fmt_NL
<!-- {               Open Brace              fmt_OB -->
<!-- }               Close Brace             fmt_CB -->
#------------------------------------------------------
                                                        Parameters
(               Parenthesis Start        params_PStart
)               Parenthesis End          params_PEnd
<               Angle Bracket Start      params_ABStart
>               Angle Bracket End        params_ABEnd
[               Square Bracket Start     params_SBStart
]               Square Bracket End       params_SBEnd
#------------------------------------------------------
                                                        Operators
,               Comma delimiter         op_CD
:               Define                  op_Define
.               Member Resolution       op_SMA
->              Map Resolution          op_Map
#------------------------------------------------------
                                                        Literals
true            Boolean True            literal_True
false           Boolean False           literal_False
'$'             Character               literal_Char
0b{0-1}         Binary                  literal_Binary
0o{0-7}         Octal                   literal_Octal
0x{0-F}         Hex                     literal_Hex
{0-9}...        Integer Digits          literal_Digit
{0-9.0-9}...    Decimal Format          literal_Decimal
"..."           String                  literal_String
#------------------------------------------------------
                                                        Sectors
    # Directors
tt              Translation Time        sec_tt
<!-- cc              CallingConvention       sec_callc -->
        # Alias
alias           Aliasing                sec_alias
in              Expose Member Symbols   sec_in
        # Metaprogramming
depend          Symbol depends on       sec_Depend (*)
expose          Expose Symbols As       sec_expose (*)
layer           Explicit layer use      sec_layer
meta            Metaprogramming         sec_meta
    # Conditional
if              Conditional If          sec_if
else            Coniditonal Else        sec_else
    # General
enum            Enumeration             sec_enum
type            Type Sector             sec_Type
{Identifer}     Symbol Definitions      sec_DefSym
#-------------------------------------------------------
                                                        Statements
;               end statemnt            def_End
{               start def block         def_Start
}               end   def block         def_End
#-------------------------------------------------------
                                                        Symbols
{Identifier}    User defined symbol     sym_Identifier
self            Self Referiential       sym_Self
type            Top / Type Symbol       sym_Type
{undefined}     Invalid                 sym_Invalid
</pre>

# Layer 0

## Tokens

<pre>
#------------------------------------------------------
                                                        Operators
            # Inference
alignof         Alignment Accessor      op_alingof
cast            Type cast               op_Cast
offsetof        Member Offset           op_offsetof
posof           Member Position         op_posof
sizeof          Symbol memory           op_sizeof
            # Indirection
ptr             Pointer accessor        op_ptr
val             Value Accessor          op_val
            # Execution
break           Jump out of block       op_break
continue        Jump to start of loop   op_continue
fall            Switch fall directive   op_fall
goto            Jump to Label           op_goto
pop             Pop current stack       op_pop
push            Push current stack      op_push
ret             Return                  op_return


{PI};		
{PI}<...>(...); Call Procedure          op_callproc
            # Logical
!               Logical NOT             op_LNOT
&&              Logical And             op_LAND
||              Logical OR              op_LOR    
&               Bitwise And             op_BAND
|               Bitwise Or              op_BOR
^               Bitwise XOr             op_BXOR
~               Bitwise Not             op_BNOT
<<              Bitwise Shift Left      op_BSL
>>              Bitwise Shift Right     op_BSR
            # Arithmetic
+               Addition                op_Add
-               Subtraction             op_Subtract
*               Multiply                op_Multiply
/               Divide                  op_Divide
%               Modulo                  op_Modulo
++              Increment               op_Increment
--              Decrement               op_Decrement
==              Equals                  op_Equal
!=              Not Equal               op_NotEqul
>=              Greater Equal           op_GreaterEqual
<=              Lesser Equal            op_LesserEqul
            # Assignment
=               Assignment              op_ASSIGN
&=              Assign Bit And          op_AB_And
|=              Assign Bit Or           op_AB_Or
^=              Assign Bit XOr          op_AB_XOr
~=              Assign Bit Not          op_AB_Not
<<=             Assign Bit Shift Left   op_AB_SL
>>=             Assign Bit Shift Right  op_AB_SR
+=              Assign Add              op_A_Add
-=              Assign Subtract         op_A_Subtract
*=              Assign Multiple         op_A_Multiply
/=              Assign Divide           op_A_Divide
%=              Assign Modulo           op_A_Modulo
#-------------------------------------------------------
                                                        Sectors
			# Encoding
binary          Binary  block           sec_Binary
octal           Octal   block           sec_Octal
hex             Hex     block           sec_Hex
			# Control Flow
label           Label                   sec_Lable
loop            Loop execution          sec_Loop
switch          Switch on value         sec_Switch
			# Memory
align           Alignment               sec_Align
mpage           Memory Paging Segments  sec_Mempage
register        Register Type           sec_Register
ro              Read-only               sec_Ro
static          Static Segment          sec_Static
strict          Strict reference        sec_Strict
struct          Data Record/ Structure  sec_Struct   
volatile        Volatile reference      sec_Volatile
union           Discriminated Union     sec_Union
			# Execution
exe             Execute                 sec_Exe
inline          Redefine inplace        sec_Inline
interrupt       Interrupt               sec_Interrupt
op              Operator Defining       sec_Operator
proc            Procedure               sec_Proc
#-------------------------------------------------------
                                                        Symbols
ro              Read-only                           sym_Ro
ptr             Address Pointer                     sym_Ptr
byte            Smallest addressable unit of bits   sym_Byte
word            Machine data model width            sym_Word
</pre>

# Layer 0.OS

Same as Layer 0 with exception:

## Feature Removal
CPU Interrupts
Paging Management

## Removed
interrupt
mpage  

## Tokens
<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
            # Memory
allocate        Memory Allocate         op_Alloc
free            Memory Free             op_Free
resize          Memory Resize           op_Resize
wipe            Memory Wipe             op_Wipe
#------------------------------------------------------
                                                        Sector
			# Memory
heap            Heap Memory block       sec_Heap
allocator       User Defined Allocator  sec_Allocator
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
heap            Heap Symbol             sym_Heap
allocator       Allocator Symbol        sym_Allocator
</pre>

## Grammar


# Layer 1

## Feature Removal
* Direct Stack Manipulation

## Tokens

<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
			# Type System
cast            Type Cast
typeof          Type Accessor           op_TypeOf
#------------------------------------------------------
                                                        Sector
			# Execution
soa             Structure of Arrays     sec_SOA
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>

## Grammar


# Layer 2

# Featuree Removed:  
* label
* goto

## Tokens

<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
dcast       Dynamic Type Cast           sec_DCast
#------------------------------------------------------
                                                        Sector
		# Execution
interface   Dispatch Specification      sec_Interface
trait       Static Dispatch             sec_Trait
virtual     Dynamic Dispatch            sec_Virtual
		# Memory
mut         Mutable                     sec_Mut
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
ref         References                  sec_Ref          
</pre>

# Layer 3

## Tokens
<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
#------------------------------------------------------
                                                        Sector
        # Memory
gc          Garbage Collector           sec_GC
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>

# Layer 4

Strong-Typing  
Purely-functional

## Tokens
<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
#------------------------------------------------------
                                                        Sector
fn          Function                    sec_FN
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>
