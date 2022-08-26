# Sectors

Sectors are any symbol that may contextually encapsulate a valid statement element or set of statements bound by a statement context.

```
<statement>

<statement> ;

<statement> { <statement> ... }
```
`start definition` : `:`  
`end   definition` : `;` or `}`  
*Note : `;` is intended for single statement termination*

---

A statement element is a stack of sectors and expressions that terminate either with an \<end definition> symbol or satisfy its terminating condition during parsing.


```
<ordered set of elemnets> <terimnation element>

<ordered set of statement elements> ;

<ordered set of elements> 
{
	<ordered set of elements> 
	... 
}
```

---

# Standard Sectors

**Note: Some of these sectors may be omitted by the langauge platform if unsupported (example: interpreter will most likely not support heap allocation)**

## Alias

A statement that will associate an user identifier with another symbol. 

Available Sectors : None

```
alias <identifier> : <symbol>
```

## Allocator

User defined allocators.  Denotes memory associated with a varaible of addressable type (a type resolving to an address).

Available Sectors : None

```
allocator <name> <addressable> : <allocator OP>

allocator <name> 
{
	 <addressable> : <allocator OP>
	 ...
}
```

## Capture

A parenthesized set of named or unamed (special if so) arguments that be used in resolved symbols that depend on additional contextual information to provided either for translation time symbol generation or for data transformation during execution.

Available Sectors :

* Capture
* Conditional
* Exe
* External
* Identifier
* Readonly
* Return Map
* Static
* Switch
* Translation Time

```
(...) <sector stack>;

(...) 
{ 
	<sector> 
	... 
}
```

## Conditional

An if-else set of sectors. Sectors within are only considiered if the `<conditional expression>` resolves to a true value.

Available Sectors :

* Capture
* Exe
* External
* Identifier
* Readonly
* Switch
* Static
* Translation Time

```
if <conditional expression> <sector stack>

if <conditional expression>
{
	 <sector>
	 ...
}

if <conditional expression> <sector stack> else <sector stack>

if <conditional expression>
{
	 <sector>
	 ...
}
else
{
	 <sector>
	 ...
}
```

## Enum

Sector denoting a list of identifiers that are enumerated. An optional capture may be provided that resolves to a built-in type supported to be used with enumerations.

Available Sectors : None

```
enum <capture> <name> : <value>
enum <capture> { <name> : <value> ... }
```

## Exe (Executable Scope)

Defines a set of executable elements used to generate a procedural (or imperative) execution graph.

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Heap
* Loop
* Return
* Stack
* Switch (Exe)

```
exe <sector or operation>

exe
{
	<sector or operation>
	...
}
```

## Exe Conditional

An if-else set of sectors. Sectors within are only considiered if the `<conditional expression>` resolves to a true value.Conditional. This variant is constrained to the available sectors and operations of an exe sector.

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Heap
* Loop
* Return
* Stack
* Switch (Exe)

```
if <conditional expression> <sector or operation>

if <conditional expression> 
{ 
	<sector or operation>
	...
}

if <conditional expression> <sector or operation> else <sector or operation>

if <conditional expression> 
{ 
	<sector or operation>
	...
} 
else
{
	<sector or operation>
	...
}
```

## Exe Switch

A sector where a value resolved from an expression is matched with one of a series of case values. The case value matched will be used executed (implemented as either as conditional or jump table).

```
switch <expression> <case expression> <sector or operation>

switch <expression>
{
	<case expression> pass
	<case expression>
	{
		<sector or operation>
		...
	}
}
```

## Exe Using

Used in execution sectors to allow members of an identifier sector or variable definition to be used without the identifier namespace. If its a variable, the instance members of a struct or union are transparently available as well.

A sector where a value resolved from an expression is matched with one of a series of case values. The case value matched will be used in translation time or the program model.

If the using sector is defined with a body it will only be applied to the body, otherwise it will be applied to the immediate sector body declared within.

Available Sectors :

* Allocator
* Break
* Conditional (Exe)
* Heap
* Loop
* Return
* Stack
* Switch (Exe)

```
<executable sector>
{
	using identifier;

	// or
	
	using identifier
	{
		...
	}
}
```

## External

Denotes the member symbols to be signatures for runtime defined symbols available in a foreign module.

Available Sectors :

* Capture
* Condition
* Identifier
* Switch

```
external <sector stack>

extenral
{
	<sector>
	...
}
```

## Heap

Denotes heap allocated memory associated with a varaible of addressable type (a type resolving to an address).

Available Sectors : None

```
heap <addressable> : allocation

heap
{
	<name> : <type sector>
	...
}
```

## Identifier

A user defined symbol that is used to associate with a valid definition. In the case of a sector, it behaves as a namespace for an encapsulation of definitions.

Available Sectors :

* Capture
* Conditional
* Enum
* Exe
* External
* Identifier
* Layout
* Readonly
* Return Map
* Static
* Struct
* Switch
* Translation Time
* Typedef
* Union

```
<stack> A <stack>;
<stack> A { <sectors> }
```

## Layout

Used to define the memory layout of an user identiifer that resolves to a type. Intended to be used with symbols resolving to struct type.

A capture may optionally be defined with the layout to also define the alignment of a struct.
Padding may optionally be added using the `<pad>` keyword along with an appopriate size of the padding in bytes.

Available Sectors : None

```
A struct { 
	VarA : <type sector> 
	VarB : <type sector>
	VarC : <type sector>
}

A layout { 
	VarC
	VarB
	VarA
}
// or
A layout (alignment = 4) { 
	VarC
	pad : <byte value>

	VarB
	pad : <byte value>
	
	VarA
}
```

## Loop

Used in execution sectors to denote a iterative sector. May optionally contain an if condition to break out of the loop automatically if the condition state resolves to false.

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Heap
* Loop
* Return
* Stack
* Switch (Exe)

```
loop
{
	...
}

loop if <condition>
{
	...
}
```

## Readonly

Used to denote members as being readonly to sectors outside of the inhabited unit sector.

**Note: Right now the only members that this should resolve to are static variable symbols.**

Available Sectors :

* Capture
* Condition
* Static
* Identifier

```
ro <sector stack>

ro
{
	<sector>
	...
}
```

## Return Map

Used in either an identifier sector or a capture sector. Denotes a mapping of an expression or type as a return value to a function or procedure.

If the mapping is an expression its considered a function.
Otherwise it will be a procedure.

**Note: This sector is embeeded in either an identifier or capture sector and thus does not have available sectors within its own context**

```
<identifier> -> <type or expression>

<identifier> -> <type or expression>
{
	<sector>
	...
}
```

## Stack

Denotes stack allocated variables (Allocated on the machine stack or virtual stack).

Available Sectors : None

```
stack <name> : <type sector>

stack
{
	<name> : <type sector>
	...
}
```

## Static

Denotes static allocated variables (Allocated in some form of static-time memory relative to the execution).

Available Sectors : None

```
static <name> : <type sector>

static
{
	<name> : <type sector>
	...
}
```

## Struct

Defines a type of grouped types that will have its addressing automatically resolved.

Available Sectors : None

```
struct
{
	<name> : <type sector>
	...
}
```

## Struct Using

Takes an identifier with struct as its type and inline's that struct's members into *this* struct's member definition.

Available Sectors : None

```
struct 
{
	using <name>

	...
}
```

If a layout is defined all members of `<name>` are natrually available in the layout sector.

## Switch

A sector where a value resolved from an expression is matched with one of a series of case values. The case value matched will be used in translation time or the program model.

Available Sectors :

* Capture
* Conditional
* Exe
* External
* Identifier
* Readonly
* Static
* Switch
* Translation Time

```
switch <expression> <case expression> <sector stack>

switch <expression>
{
	<case expression> pass
	<case expression>
	{
		<sector>
		...
	}
}
```

## Translation Time

Defines an encapsulation of sectors that are intended to be processed at translation-time.

*Note: Currently the design of the langauge has it so that only the static sector really has a usage with this sector.  
Sectors like the Conditional, Exe (when not bound to identifier), and Switch do not need this sector for the RSParser to infer that they will be translation time (its implicit).

Available Sectors :

* Conditional
* Static
* Switch

```
tt <sector stack>

tt
{
	<sector stack>
}
```

## Unit

Defines an encapsualted *Unit* of a program model. Defined by the user in a module file.

Available Sectors :

* Capture
* Conditional
* Exe
* External
* Readonly
* Static
* Switch
* Translation Time
* Identifier

## Union

Denotes a union type definition. May optionally have a capture that resolves to an enumeration which will serve to define a tagged union. The `<name>` identifiers for the union must match the tag enumeration `<name>`s

Available Sectors : None

```
union (<enum>)
{
	<name> <type sector>
	...
}

union
{
	<name> <type sector>
	...
}
```

## Type

Denotes a type definition. Type definitions may have an initial value assigned to them. Type inference using `:=` notation may be used to omit explicit typedefs.

Available Sectors : None

**Note: This sector has different notations depending on its use context**
*This was done to make the typedef in an identifier sector use a clearer keyword.

Identifier Sector:
```
<identifier> type <typedef>
<identifier> type <typedef> = <value>
<identifier> type := <value>

<identifier>
{
	...
	type <typedef> = <value>
	...
}
```

Any other sector:
```
<name> : <typedef>
<name> : <typedef> = <value>
<name> := <value>

<stack or static>
{
	<name> : <typedef>
	...
}
```

# Expressions

An executable set actions of symbols or just a symbol.

*Note: Post-fix notation similar to forth and lisp for expressions could be added as a policy option for a context layer*

Operator Precedence (First is lowest)
| Category | Symbol |
| :---- | :---- |
| Delimited | `,` |
| Assignment | `= += -= *= /= %= != ~= ^= &= |= <<= >>=` |
| Logical Or | `||` |
| Logical And | `&&` |
| Equality | `== !=` |
| Relational | `> >= < <=` |
| Bitwise Or | `|` |
| Bitwise And | `&` |
| Bitsift | `<< >>` |
| Additive | `+ -` |
| Multiplicative | `* / %` |
| Unary | `! - ~` |
| Capture | `( )` |
| Proc Call | `A()` |
| Bracketed Capture | `A[ B ]` |
| Cast | `A(<type>, B)` |
| Symbol Member Access | `A.B` |
| Element | `<builtin member> <identifier> <literal>` |

The following are implemented as binary expressions ( `A <op> B` ):

* Assignment
* Logical Or, And
* Equality
* Relational
* Bitwise Or, And
* Bitshift
* Additive
* Multiplicative

# Symbol

A user identifer, or language platform defined conceptual element.

These conceptual elements may be of type :
| Type | Description |
| :---- | :---- |
| Fixed-Array | Linear Indexed List |
| Identifier  | User Defined Symbol |
| Literal     | Value of a type represented as a string of text |
| Procedure   | Symbol signature represented as a type definition |
| Pointer     | May either be corresponding SNodes or a text string |
| Type        | Type definition |
| TT_Type     | Translation Time Type definiton |

## Array

```
[<value>] <type symbol>
```
## Literal

```
<built-in literal>
```

## Pointer

```
ptr <type symbol>
```

## Procedure

```
exe <optional capture> <optional return map>
```

## Type symbol

| Name  | Description |
| :---- | :---- |
| type             | Top Type |
| `<builtin type>` | Builtin Type definition |
| `<identifier>`   | User defined type |
| exe              | Procedure type |
| ptr              | Pointer Type |
| [<value>]        | Fixed-Array type |

## Translation-Time Type
```
tt <type symbol>
```