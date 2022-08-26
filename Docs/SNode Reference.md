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

## Alias

A statement that will associate an user identifier with another symbol. 

Available Sectors : None

```
<stack> alias <identifier> : <symbol>
```

## Allocator

...

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
<stack> (...) <stack>;
<stack> (...) { <sectors> ... }
```

## Condition

...

## Enum

...

## Exe (Executable Scope)

...

## Exe Conditional

...

## Exe Switch

...

## Exe Using

...

## External

...

## Heap

...

## Identifier

A user defined symbol that is used to associate with a valid definition. In the case of a sector, it behaves as a namespace for an encapsulation of definitions.

Available Sectors :

* Capture
* Conditional
* Enum
* Exe
* External
* Identifier
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

## Loop

...

## Readonly

...

## Return Map

...

## Stack

...

## Static

...

## Struct

...


## Struct Using

...

## Switch

...

## Translation Time

...

## Unit

A sector defining an encapsualted *Unit* of a program model. Defined by the user in a module file.

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

## Type

...

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
|  |  |
| :---- | :---- |
| Array      | Linear Indexed List |
| Identifier | User Defined Symbol |
| Literal    | Value of a type represented as a string of text |
| Procedure  | Symbol signature represented as a type definition |
| Pointer    | May either be corresponding SNodes or a text string |
| Type       | Type definition |
| TT_Type    | Translation Time Type definiton |
