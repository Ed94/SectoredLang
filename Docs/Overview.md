## Hello World
```
exe "Hello World!";
```

Will output: `Hello World!` to the *default output device* specified by the **LP (Langauge Platform)**

`exe` means ***Execute*** and will have its contents executed by the LP if within the unit scope and no symbols are unresolved.

All *literals* and *built-in* data types have support for LP output.

## Static Memory
```
static variable : byte;
```

The most basic memory allocation feature supported by LP. Will be reserved during program startup. Released on shutdown (So its static relative to the program).

```
static varaible : byte = 0x01;
```
*Simple* assigment is supported for static varaibles. Anything else requires assignment in an `exe` sector.

## Sectors
| sector   | context           | end statement   |
| :----:   | :----:            | :----:          |
| `static` | `variable : byte` | `;`             |

```
exe
{ 
	"Hello World!";
	1 + 2;
}
```

A context may either be a single statement or be defined with multiple statements with a context body.

`exe` and `static` are also considered sectors. Sectors are special keywords that are used to resolve a **context**.

What a context can do depends on how sectors are stacked. Not all sectors allow just any other sector to be stacked within them as well.

```
Print_HelloWorld exe
{
	"Hello World!";
}

exe Print_HelloWorld;
```

`Print_HelloWorld` is an **identifier sector**. It provides a symbol that *associates the name with its contents.  
In the above example its stacked with an `exe` sector which has its context resolve to the `exe` context.  

The stacking allows for this execution to now be referenced throughout the program using the identifier.
So you can call it by just putting it in an `exe`!

What a context needs to be passed? 

## Captures

```
(...)
```
Allow for the capturing of a context which can be used by other sectors within its context.

Captures can contain the following:

### Named Captures
```
(variable : u32)
( a : tt bool, b : ptr ro u32)
```
These should look familiar if you've used other programming langauges.

### Special Captures
(We'll go over these soon)
```
(self, allocator)
```
Just like any sector you can stack em!

```
main (args : []ptr u8, count : uw) exe
{
	"Hello World!";
}
```
Starting to look familiar huh. Were just missing a return...

## Maps
```
AnIdentifier_WithReturn -> u32

AddFour (variable : u32) -> (variable + 4)
```

Certain sectors may have a mapping sector stacked with them (Usually ***identifiers*** and ***captures***).

The `->` is the map symbol and expects its `mapping` to be an *expression*.  
Maps are not evaluated until they are used in an exe context. So you can consider them lazy evaluated!  
If the map resolves to a type, its expected that an exe body will provide implementation with a return value matching the type.

Now we have everything needed for a traditional main entrypoint! :
```
main (args : darray(string)) -> u32 exe
{
	"Hello World!";

	ret 0;
}

exe main( LP.CLI.Args )
```

`ret` is the return keyword. It behaves like it ussually does in most most other imperative languages (C/C++, D, Python, Rust, JS, Zig etc)

The `LP` is a special symbol that repressents the program model's access to the language platform's context.

### LP (Langauge Platform)

The langauge platform is this language's explicit handling of the platform toolchain for the langauge model. 
Within a program's model the program may reference specific features the LP has allowed the program to have exposure to.

In the entrypoint example within Maps, its using its CLI context to provide access to the possible arguments provided to the program on launch from command-line.
