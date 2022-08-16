## Hello World
```
exe "Hello World!";
```

Will output: `Hello World!` to the *default output device* specified by the **LP (Langauge Platform)**

`exe` means ***Execute*** and will have its contents executed by the LP if within the unit scope and no symbols are unresolved.

All *literals* and *built-in* data types have support for LP output.

`exe` is also considered a sector.

## Sectors
| sector   | context           | end statement   |
| :----:   | :----:            | :----:          |
| `exe`    | `"Hello World!`   | `;`             |

```
exe
{ 
	"Hello World!";
	1 + 2;
}
```
 Sectors are special keywords that are used to resolve a **context**.

A context may either be a single statement or be defined with multiple statements with a context body.

What a context can do depends on how sectors are stacked. Not all sectors allow just any other sector to be stacked within them as well.

```
Print_HelloWorld exe
{
	"Hello World!";
}

exe Print_HelloWorld;
```

`Print_HelloWorld` is an **identifier sector**. It provides a symbol that *associates* the name with its contents.  
In the above example its stacked with an `exe` sector which has its context resolve to the `exe` context.  

The stacking allows for this execution to now be referenced throughout the program using the identifier.
So you can call it by just putting it in an `exe`!

Note that certain sectors may not share association with the same identifier:  
* type
* struct
* union
* exe
* ... etc (Defined in BNF eventually...)

These would need their own identifier.  

*What if a context needs to be passed?*

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
Just like any sector they may be stacked!

```
main (args : []ptr u8, count : uw) exe
{
	"Hello World!";
}
```
Starting to look familiar huh. Just missing a return...

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

## Static Memory
```
static variable : byte;
```

The most basic memory allocation feature supported by LP. Will be reserved during program startup. Released on shutdown (So its static relative to the program).

```
static varaible : byte = 0x01;
```

*Simple* assigment is supported for static varaibles. Anything else requires assignment in an `exe` sector.

## Stack Memory

```
exe 
{
	stack message : string = "Hello World!";

	message;
}
```

Just like stack memory in most procedural langauges. Can only be used within execution blocks.  
Freed when execution exits the context where the memory identifier was declared.

## Heap Memory
```
exe
{
	stack message : ptr u8;
	heap  message : allocate(u8, 12);

	LP.Memory.Set(message, "Hello World!", 12);
	LP.Log(message);

	heap message : free;
}
```
Manual memory management using the OS provided heap (if using an LP with access to the OS).

Unlike static or stack, heap is an allocator sector and thus cannot declare variables.  
Instead you must provide it a pointer stored in a stack or static memory region.  

Like any manually managed heap. It must be manually freed.

## Allocator
```
Arena allocator
{
	struct { ... }

	(self)
	{
		allocate (Type : tt type, numDesired : uw) -> ptr Type exe { ... }
		free     (_allocationID : ptr Type)                    exe { ... }
		resize   (Type : tt type, numDesired : uw) -> ptr Type exe { ... }
		wipe                                                   exe { ... }
	}

	Snapshot
	{
		struct { ... }

		Begin;
		End;
	}
}
```
A sector defining custom allocators. It has special **procedures** that must be implemented.  

These are respectively:

* allocate
* free
* resize
* wipe

The default captures are shown in the Arena example.

***_allocationID*** is a special capture used by free to represent the object reference being freed.  
Its automatically assigned with the syntax for the sector:
```
<allocator> <_allocationID> : free;
```

So it does not need to be passed.

wipe does not need an identifier as such you can just call it via:
```
<allocator> wipe;
```

Captures for the allocation procedures may be extended to suit the requirements of the allocator.  
One of the extensions shown is the ***self*** capture.  

## Self Capture
```
Vehicle
{
	struct
	{
		Velocity : f32;
		...
	}

	Drive (self) exe
	{
		Velocity += ...;
		...
	}
}
```

Allows for a resolved object of the identifier type to be automatically captured when using an infix call to a named execution which has self in its capture resolution.  

Its pure syntactic sugar and resolves to a function symbol with the object passed as a pointer:
```
// Symbol implementation during runtime generation stage.
Vehicle.Drive (self : ptr Vehicle) exe
{
	self.Velocity += ...;
	...
}
```
If a pointer is not desired, self can have its type manually specified: 
```
Vehicle
{
	Drive (self : Vehicle struct) exe
	{
		Velocity...
		...
	}
}
```

Thus if desired, the infix syntax is completely optional and the functions may be called using traiditonal syntax:
```
static Cobra427 : Vehicle;

exe
{
	Cobra427.Drive();
	// or
	Drive( Cobra427 );
}
```
