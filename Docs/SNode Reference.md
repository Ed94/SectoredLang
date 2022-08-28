# Sectors

Sectors are any symbol that may contextually encapsulate a valid statement element, or set of statements bound by a statement context.

```
<statement>

<statement> ;

<statement> { <statement> ... }
```
`start definition` : `:`  
`end   definition` : `;` or `}`  
*Note : `;` is intended for single statement termination*

---

A statement element is a stack of sectors and expressions, which terminate either with an `<end definition>` symbol or satisfy its terminating condition during parsing.


```
<ordered set of elemnets> <terimnation element>

<ordered set of statement elements> ;

<ordered set of elements> 
{
	<ordered set of elements> 
	... 
}
```

**Note: The context of a stack of sectors inherits the restrictions of its most restrictive sector. (This is enforced when generating RSNodes in the SParser)**

---

# Standard Sectors

**Note: Some of these sectors may be omitted by the langauge platform if unsupported (example: interpreters will most likely not support heap allocation)**

## Alias

A statement that will associate a user identifier with another symbol. This is only for the sector context the alias is used in.  
Aliases are removed during one of the backend stages while producing the program model.
The intention is to keep them available as far as possible for readability.

Available Sectors : None

```
alias <identifier> : <symbol>
```

## Allocator

User defined allocators. Denotes memory associated with a varaible of addressable type (a type resolving to an address).

Available Sectors : None

```
allocator <name> <addressable> : <allocator OP>

allocator <name> 
{
	 <addressable> : <allocator OP>
	 ...
}
```

Allocators are defined within identifiers using an interface pattern :
```
// Equivalent of backend definitoin.
// Interfaces can either be implemented as traits or virtuals. 
// virtual indicates runtime dispatch, trait indicates translation-time resolved dispatch (static-dispatch).

allocator interface ( Type : tt Type ) {
	allocate (                     numDesired : uw ) -> ptr Type exe;
	resize   ( address : ptr Type, numDesired : uw ) -> ptr Type exe;
	free     ( address : ptr Type )                              exe;
	wipe                                                         exe;
}

<identifier>
{
	trait allocator
	{
		allocate ( numDesired : uw ) -> ptr Type exe { ... };
		resize (address : ptr Type, numDesired : uw ) -> ptr Type exe;
		free ( address : ptr Type ) exe;
		wipe exe;
	}
}
```

Allocator interfaces are unqiue in that they allow self capture.
```
<identifier> trait allocator (Type : tt type, self) { ... }
```

If attempting dynamic-dispatch with an allocator, be aware the allocator type will not be the same if using a self capture.

Allocator resolved symbols for non-self captures :
```
<identifier>.allocator.allocate( numDesired : uw ) -> ptr ResolvedType exe
<identifier>.allocator.resize( address : ptr ResolvedType, numDesired : uw ) -> ptr ResolvedType exe
<identifier>.allocator.free( address : ptr ResolvedType ) exe
<identifier>.allocator.wipe exe;
```

Allocator resolved symbols for self captures :
```
<identifier>.allocator.allocate (self : ptr <identifier>, numDesired : uw ) -> ptr ResolvedType exe
<identifier>.allocator.resize ( self : ptr <identifier>, address : ptr ResolvedType, numDesired : uw ) -> ptr ResolvedType exe
<identifier>.allocator.free ( self : ptr <identifier>, address : ptr ResolvedType ) exe
<identifier>.allocator.wipe ( self : ptr <identifier> ) exe;
```

These will not be compatiable with each other.
(This is the case for any interface implementation that changes the dependencies of a any of the interface symbols)

**Note : Like all program source, the IDE should be able to show the runtime resolved symbols for any RSNode.**

## Capture

A parenthesized set of named or unamed (special if so) arguments which can be used in resolved symbols that depend on additional contextual information provided, either for translation-time symbol generation or for data transformation, during execution.

Named captures with translation-time types are considered dependent captures. Dependent captures must be resolved at translation-time to generate a program model compatiable symbol.

Available Sectors :

* Alias
* Capture
* Conditional
* Exe
* External
* Identifier
* Inline
* Layer
* Readonly
* Return Map
* Static
* Switch
* Translation Time

(These are used )

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

* Alias
* Capture
* Exe
* External
* Identifier
* Inline
* Layer
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

Sector denoting a list of identifiers that are enumerated. An optional capture may be provided that resolves to a built-in type. Used to denote the type of the enum.

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
* Continue
* Fall
* Goto
* Heap
* Label
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

An if-else set of sectors. Sectors within are only considiered if the `<conditional expression>` resolves to a true value. This variant is constrained to the available sectors and operations of an exe sector.

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Continue
* Fall
* Goto
* Heap
* Label
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

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Continue
* Fall
* Goto
* Heap
* Label
* Loop
* Return
* Stack
* Switch (Exe)

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

If the using sector is defined with a body it will only be applied to the body, otherwise it will be applied to the immediate sector body declared within.

Available Sectors :

* Allocator
* Break
* Conditional (Exe)
* Continue
* Fall
* Goto
* Heap
* Label
* Loop
* Return
* Stack
* Switch (Exe)
* Using

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

## Goto

Allows for unconditional jump operations to marked positions in the execution graph set via labels.

Available Sectors : None

```
<executable sector>
{
	label A
	...
	goto A
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

A user defined symbol that is used as a namespace for an encapsulation of definitions.

An identifier may only resolve to either a type definition or executable and not both type definitions can either be defined using the type sector, struct sector, or union sector. Layout sector may only be defined if the type definition is a struct sector.

**structs** and **unions** may have multiple defintions within the sector.  
If multiple definitions are defined they are conncatenated into a single struct or union for the program model.

type, struct and union defintions **cannot** be mixed in an identifier sector. Only *one* of these types of definitons may be used.  
(The program model only supports resolving a symbol to a single type definition class)

Available Sectors :

* Alias
* Capture
* Conditional
* Enum
* Exe
* External
* Identifier
* Inline
* Interface
* Layer
* Layout
* Readonly
* Return Map
* Static
* Struct
* Switch
* Trait
* Translation Time
* Typedef
* Union
* Virtual

```
A <stack>;
A { <sectors> }
```

## Identifier Using

Used to inject an identifier's definitions into another identifer achieving inheritance.

Available Sectors : None

```
<identifier>
{
	using <another identifier>

	...
}
```

Note that this will literally inject the definitions into the identifier sector and doesn't provide stuff like a *super* or *parent* symbol to reference the current parent. If this is desired consider the following pattern:

```
<identifier>
{
	alias super : <another identifier>
	using super
}
```

Any interface implementation injected will be available. If an override is intended I recommend manual inheritance instead:

```
<identifier>
{
	alias super : <another identifier>
	
	<interface implementation> ...

	struct
	{
		using super
		...
	}
	// or
	union
	{
		using super
	}
	// or
	type super
}
```

## Inline

Indicates to the program generator that the executable implementation for symbols in this sector should be inlined instead of a call to a subroutine.

Available Sectors :

* Capture
* Conditional
* Identifier
* Switch

```
inline (...) -> ... 
{
	...
}
```

## Interface

Provides a way to define a set of exectuable symbols that may have their dispatch implementation generated by the backend of the language platform.

Used in conjunction with the trait and virtual sectors to define standard interfaces for functionality on data types.

Available Sectors :

* Capture
* Conditional
* Exe
* Identifier
* Switch

**Note : Use of the interface sector is entirely optional and manual interfaces are perfeclty possible.**

Example of manually defined interface:
```
// State definition with a dynamic dispatch interface
State
{
	Proc
	{
		Load   type exe;
		Unload type exe;
		Update type exe ( delta : f64 )
		Render type exe;
	}

	struct
	{
		Load   : ptr Proc.Load
		Unload : ptr Proc.Unload
		Update : ptr Proc.Update
		Render : ptr Proc.Render
	}
}

IntroState
{
	alias super : State
	using super

	StateImpl
	{
		Load exe { ... }
		Unload exe { ... }
		Update ( delta : f64 ) exe { ... }
		Render exe { ... }
	}

	Init ( self ) exe
	{
		Load   = StateImpl. Load
		Unload = StateImpl. Unload
		Update = StateImpl. Update
		Render = StateImpl. Render
	}
}

AnotherState
{
	...
}


static 
{
	intro   : IntroState
	another : AnotherState
}

pickState -> ptr State exe { ... }

exe
{
	stack randState : ptr State

	randState = pickState
	randState.Load()
}
```

## Label

Allows for positions in the execution graph to be marked for unconditional jumping using the goto sector.

Available Sectors & Operations :

* Allocator
* Break
* Conditional (Exe)
* Heap
* Label
* Loop
* Return
* Stack
* Switch (Exe)

```
<executable sector>
{
	label A
	{
		...
		goto B
	}

	label B
	...
	goto A
}
```

## Layer

A language platform policy encapsulated as a sector. Changes the allowed features that the langauge platform may provide from what was specified in the modules. 

Available Sectors :

* Alias
* Capture
* Conditional
* Exe
* External
* Identifier
* Inline
* Readonly
* Static
* Switch
* Translation Time

```
// Policy with more pragmatic rules on syntax for heavy engineering.
layer Engine.Core
{
	Something struct
	{
		...
	}

	Something Transformation (...) -> ptr ... exe
	{
		...
	}
}

// Policy wiht rules more friendly for gameplay-level code or scripting.
layer Gameplay
{
	Character
	{
		alias super : Entity
		using super

		...

		Init exe -> ptr Character
		{
			stack newCharacter : ptr Character = null

			// Only gameplay level code and above may use a garbage collector.
			GC Character

			if newCharacter == null
				ret ...

			SetupComponents
			...
		}
	}
}

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
	_bytepad : <byte value>

	VarB
	_bytepad : <byte value>

	VarA
}
```

## Loop

Used in execution sectors to denote a iterative sector. May optionally contain an if condition to break out of the loop automatically if the condition state resolves to false.

Available Sectors & Operations :

* Allocator
* Break
* Continue
* Conditional (Exe)
* Heap
* Label
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

* Alias
* Capture
* Conditional
* Exe
* External
* Identifier
* Inline
* Layer
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

## Trait

Used in conjunction with interfaces to define a static dispatch implementation that will be generated by the translation-time executer.

Available Sectors : 

* Capture
* Conditional
* Exe
* Identifier
* Switch

```
trait <identifier with interface definition>
{
	<interface member> ... exe { ... }
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

## Translation Time

Defines an encapsulation of sectors that are intended to be processed at translation-time.

Note: Any sectors defined within a translation-time sector which are not **static** sector symbols will not be available at for runtime usage.

Available Sectors :

* Alias
* Capture
* Conditional
* Exe
* Identifier
* Interface
* Layer
* Static
* Switch

```
tt <sector stack>

tt
{
	<sector stack>
}
```
Note: This has a bunch of potential in the future for metaprogramming... Not sure how far yet ast wise but to give an idea:
```
// This captures a symbol associated with a sector as a sector instead of a type.
tt inherit ( userSymbol : sector identifier ) exe
{
	// We define a symbol *super* in the current context calling inherit.
	alias super : userSymbol

	// We inject super's defintions into the current context.
	using super
}

// This will resolve to an invalid symbol for the current sector unless its done within an identifier.

// Usage:
BaseIdentifier
{
	...
}

InheritingIdentifier
{
	inherit(BaseIdentifier)
}

// In generated node:
InheritingIdentifier
{
	alias super : userSymbol
	using super
}
```

## Unit

Defines an encapsualted *Unit* of a program model. Defined by the user in a module file.

Available Sectors :

* Alias
* Capture
* Conditional
* Exe
* External
* Identifier
* Interface
* Inline
* Layer
* Readonly
* Static
* Switch
* Translation Time

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

## Virtual

Used in conjunction with interfaces to define a dynamic dispatch implementation that will be generated by the program model generator.

Available Sectors : 

* Capture
* Conditional
* Exe
* Identifier
* Switch

```
virtual <identifier with interface definition>
{
	<interface member> ... exe { ... }
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
| Assignment | = += -= *= /= %= != ~= ^= &= |= <<= >>= |
| Logical Or | `\|\|` |
| Logical And | `&&` |
| Equality | `== !=` |
| Relational | `> >= < <=` |
| Bitwise Or | `\|` |
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
