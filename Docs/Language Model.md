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
                                                        Formatting (Ignored by the compiler)
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
.               Member Resolution       op_SMA
->              Map Resolution          op_Map
#------------------------------------------------------
                                                        Literals
'$'             Character               literal_Char
0b{0-1}         Binary                  literal_Binary
0t{0-2}         Ternary          		literal_Ternary
0o{0-7}         Octal                   literal_Octal
0x{0-F}         Hex                     literal_Hex
{0-9}...        Decimal Digits          literal_Digit                        
"..."           String                  literal_String
#------------------------------------------------------
                                                        Sectors
    # Directors
tt              Translation Time        sec_tt
<!-- cc              CallingConvention       sec_callc -->
        # Alias
alias           Aliasing                sec_alias
expose          Expose Symbols As       sec_expose   
in              Expose Member Symbols   sec_in
        # Metaprogramming
layer           Explicit layer use      sec_layer
meta            Metaprogramming         sec_meta          
macro           Macro                   sec_macro
    # Conditional
if              Conditional If          sec_if
else            Coniditonal Else        sec_else
    # General
enum            Enumeration             sec_enum    
{Identifer}     Symbol Definitions      sec_DefSym
type            Type definition         sec_Type
#-------------------------------------------------------
                                                        Statements
:               start def block         def_Start
;               end   def block         def_End
{               start def block (brace) def_Start 
}               end   def block (brace) def_End
,               Comma delimiter         def_CD
#-------------------------------------------------------
                                                        Symbols
{Identifier}    User defined symbol     sym_Identifier
Type            Top Type                sym_TType
{undefined}     Invalid                 sym_Invalid
</pre>

## Grammar:

<pre>
...                             Symbol pattern generator

{identifier : body ;            Symbol defining statement
identifier : symbol ;           Symbol associated with identifier

(symbol, ...)                   Parenthesized expression symbol defining statement
&lt;symbol, ...&gt;                   Angle bracketed expression symbol defining statement
[symbol, ...]                   Square bracketed expression symbol defining statement

symbol[symbol]                  Access element of symbol
symbol.symbol                   Access symbol associated with symbol

specifier {(..., ...)} symbol   Specify specifier with optional parameterized flags for symbol

symbol -> symbol                Symbol mapping to other symbol

{symbol} identifier             specify symbol for one identifier
{symbol} : body ;               specify symbol for body

typeof(identifier)              Accessor to associated type of identifier
</pre>

## LTP Directors
### Alias
<pre>
{aliasIdentifier} : {symbol} ;	            Expose a mybol
</pre>

### Meta
### Translation Time


# Layer 0

| | |
|:--|:--|
| APS | 1 |
| CNL                 | 1        # (AKA Context Nesting Limit) {unit} : {sector} : {identifier} : {identifier}; ;; |
| Typing              | Weak |
| Implicit Mutability | mut |

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
ternay          Ternary block           sec_Ternary
octal           Octal   block           sec_Octal
hex             Hex     block           sec_Hex
			# Control Flow
label           Label                   sec_Lable
loop            Loop execution          sec_Loop
			# Memory
align           Alignment               sec_Align
embed			Embed Data				sec_Embed
mpage           Memory Paging Segments  sec_Mempage
register        Register Type           sec_Register
ro              Read-only               sec_Ro
stack           Stack  Segment          sec_Stack
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
ptr             Address Pointer                     sym_Ptr
byte            Smallest addressable unit of bits   sym_Byte
word            Machine data model width            sym_Word
</pre>

## Grammar

<pre>
ret   symbol;                   Return a valid symbol for the context   
label identifier;               Deifne label with identifier
goto  identifier;               Jump to identitfier

alignof(identifier)             Alignment of struct member
offsetof(identifier)            Offset of struct member
posof(identifier)               Position of struct member
sizeof(identifier)              Size of struct or a type symbol

ptr type                        Defines a pointer to a type
symbol.ptr                      Accessor to pointer of a symbol
symbol.val                      Value of pointer type associated symbol

identfier {assign op} value     Assign value to identifier
value op ...                    perform operation on value (delimiter)
op(value, ...)                  perform operation on values (functional)

struct :                        Define a data record or structure
    {data member definitions}
;

union :
    {data member associations}  Define a untagged union
;

[{enum}] union :
    {data member associations}  Define a tagged union
;
</pre>

## Directors

### Alias

### Meta

### Translation Time


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
#------------------------------------------------------
                                                        Sector
			# Memory
heap            Heap Memory block       sec_Heap
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>

## Grammar


# Layer 1

| | |
| :-- | :-- |
| APS | 1 |
| CNL                 | 1 ```# {unit} : {sector} : {identifier} : {identifier}; ;;``` |
| Typing              | Weak |
| Implicit Mutability | mut |

## Feature Removal
Direct Stack Manipulation
Direct Encoding injection  

## Removed:
binary  
ternary  
hex  

## Tokens

<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
			# Memory
allocate        allocate heap           op_Alloc
deallocate      deallocate heap         op_Dealloc
			# Type System
typeof          Type Accessor           op_TypeOf
#------------------------------------------------------
                                                        Sector
			# Memory
heap            Heap Memory block       sec_Heap
			# Execution
for             For loop                sec_For
soa             Structure of Arrays     sec_SOA
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>

## Grammar


# Layer 2

| | |
| :-- | :-- |
| CNL                 | 4  ```{unit} {sector} {identifier} : {identifier} : {identifier} : {identifier}; ;;``` |
| Typing              | Strong |
| Implicit Mutability | ro |
| MN                  | | 
| Borrow Checker ||

Removed:  
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
gc          Garbage Collector           sec_GC
mut         Mutable                     sec_Mut
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
ref         References                  sec_Ref                                                        
</pre>

## Grammar


# Layer 3

Typing : Strong  

Removed:

## Tokens
<pre>
#------------------------------------------------------
                                                        Parameters
#------------------------------------------------------
                                                        Operators
#------------------------------------------------------
                                                        Sector
#-------------------------------------------------------
                                                        Statements
#-------------------------------------------------------
                                                        Symbols
</pre>

## Grammar :


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

## Grammar


# Layer Boostrap
(This does not use the universal context)  

| | |
| :-- | :-- |
| APS                 | 1 |
| CNL                 | 0         ```{sector} {identifier} : {definition} ; (Only one definition, bodies are not allowed)``` |
| Typing              | Untyped |
| Implicit Mutability | mut |
| Math Notation       | op(a, b) |

## Tokens
<pre>
#------------------------------------------------------
                                                        Comments
//              Comment Line            cmt_SS
#------------------------------------------------------
                                                        Components
' '             Whitespace              comp_WS
'_'             Underscore              comp_UnderS
\0              Null Terminator         comp_Null             
EOF             End of file             comp_EOF
'"'             Stirng Dilimiter        comp_SDilim
#------------------------------------------------------
                                                        Formatting (Ignored by the compiler)
" ..."          Whitespace String       fmt_WSS
\n              NewLine                 fmt_NL
{               Open Brace              fmt_OB
}               Close Brace             fmt_CB
#------------------------------------------------------
                                                        Operators
.               Member Resolution       op_SMA
->              Map Resolution          op_Map 
            # Execution
pop             Pop current stack       op_pop
push            Push current stack      op_push
goto            Jump to Label           op_goto                 
ret             Return                  op_return
            # Logical (If machine available)
!               Logical NOT             op_LNOT
&&              Logical And             op_LAND
||              Logical OR              op_LOR    
&               Bitwise And             op_BAND
|               Bitwise Or              op_BOR
^               Bitwise XOr             op_BXOR
~               Bitwise Not             op_BNOT
<<              Bitwise Shift Left      op_BSL
>>              Bitwise Shift Right     op_BSR
            # Arithmetic (If machine available)
+               Addition                op_Add
-               Subtraction             op_Subtract
*               Multiply                op_Multiply
/               Divide                  op_Divide
#------------------------------------------------------
                                                        Literals
'$'             Character               literal_Char
0b{0-1}         Binary                  literal_Binary
0t{0-2}         Ternary          		literal_Ternary
0o{0-7}         Octal                   literal_Octal
0x{0-F}         Hex                     literal_Hex
{0-9}...        Decimal Digits          literal_Digit                        
"..."           String                  literal_String
#-------------------------------------------------------
                                                        Sectors
			# Control Flow
label           Label                   sec_Label
            # Memory
stack           Stack  Segment          sec_Stack
static          Static Segment          sec_Static
struct          Data Record/ Structure  sec_Struct   
            # Execution
exec            Execution               sec_Exec
proc            Procedure               sec_Proc
#-------------------------------------------------------
                                                        Symbols
byte            Smallest addressable unit of bits   sym_Byte                                                        
word            Machine data model width            sym_Word

</pre>

## LFL : unsupported
