# M.A.S. (Modular - Aliased - Sectored)
A dynamic, highly adaptable, programming language. (Currently only a concept)


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure logic in using a single implementation handler.

Refactorable Syntax: All keys for every module/level can be refactored to an alias set/macro.

Explicit: Everything done must be declared visibity. All implicit features must be declared in a sector before use.


# M.A.S. Handler:

The general purpose handler(compiler/interpeter/etc) for an MAS programming langauge. The handler is fully modular. Whatever is generated soley depends on what modules are installed. Thus portability varies on what modules are available per platform.

All modules compiled and higher have sub-levels that divide features by the level of overhead they require. The lowest levels are the least overhead (thus the least performance cost), while the higher levels go up in complexity and lower performance.

The handler will deduce what modules to use when using the formatting of the sectors within the mas files.

Naturally downside of this handler is there is an minimum degree of overhead for supporting a module based system. It has to interpet how to package implementation based on all these factors. Also any modules beyond compiled will need a byte-code level interpreter at least to be able to generate a proper package. Package types can also greatly vary depending on modules used from compiled code to pure vm code or hybrid.

## Modules:
Metal - The raw binary packager.
( Can have several sub-modules installed depending on hardware platforms support. )

Assembly - Assembler.
( Can have several sub-modules depending on hardware paltform support. )

Unisembly - Universal Assembler. Abstracts assembly to a low level universal assmelby alias set. Has different abstraction level support. (Ranging from 1:1 statement execution to multi-statement abstraction)

Compiled - Traditional High-Level compiled langauge. Has various low level support (sub-levels) ranging from low lying level operation to very high level.

Interpreter

Functional

Logical


## Alias Sets:
Allow for all key's used during parsing to be mapped to an alias for use of foreign language that MAS's functionality could support if a key sutiably matches the original's function.

These mappings are saved as an alias set.


## Sectors:

Sector: Defines a area of code within a mas file for the handler to properly compile.

There are three built in defined sectors: || - For modules. {} - For aliases. [] - For code to handle.

| Module | - Declares a module to be used. (Modules cannot be defined, they are built into the handler).

Alias: Defines an alias to the base lexicon set the language uses, as well as macros.

* { Alias } - Used after level declaration to determine alias ( { } for default). Done after a is level declared and before a source space.
* {{ Alias }} - Extends an alias space.
* {{{ Alias }}} - Declares a new alias space.

Source: Implementation to be compiled or interpreted, etc; By the handler with the use of aliases and modules to determine specifications.

* [ Name ] - Used as an include.
* [[ Name ]] - Extends a source space.
* [[[ Name ]]] - Declares a new source space.

All sectors are closed by just putting the brackets without a space between: || {} []

New sectors can possibly be defined. (Built on top of existing sectors and base base support the handler provides.
