# M.A.S. (Modular - Aliased - Sectored)
A little project to test a concept for programming.


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure functional in one language.

Refactorable Syntax: All keys for every level can be refactored to an alias set.

Explicit: Everything done must be declared visibity. All implicit features must be declared in a sector before use.


# M.A.S. Handler:

The general purpose handler(compiler/interpeter/etc) for an MAS programming langauge. The handler is fully modular. Whatever is generated soley depends on what modules are installed.

All modules compiled and higher have sub-levels that divide features by the level of overhead they require. The lowest levels are the least overhead (thus the least performance cost), while the higher levels go up in complexity and lower performance.


## Modules:
Metal - The binary packager. 
( Can have several sub-modules installed depending on hardware platforms support. )

Assembly - Assembler.
( Can have several sub-modules depending on hardware paltform support. )

Unisembly - Universal Assembler. Abstracts assembly packages to a low level universal assmelby alias set. Has different abstraction level support. Ranging from 1:1 statement execution. To multi-statement abstraction.

Compiled - Traditional High-Level compiled langauge. Has various low level support (sub-levels) ranging from low lying level operation. To very high level. (Think of the difference between c to the highest overload features of c++). 

Interpreter

Functional

Logical


## Alias Sets:
Allow for all key's used during parsing to be mapped to an alias for use of foreign language that LAR's functionality could support if a key sutiably matches the original's function.

These mappings are saved as an alias set.


## Sectors:

Sector: Defines a area of code within a mas file for the handler to properly compile.

There are three built in defined sectors: || - For modules. {} - For aliases. [] - For code to handle.

| Module | - Declares a module to be used. (Modules cannot be defined, they are built into the handler).

Alias: Defines an alias to the base lexicon set the language uses, as well as macros.

* { Alias } - Used after level declaration to determine alias ( { } for default). Done after a is level declared and before a source space.
* {{ Alias }} - Extends an alias space.
* {{{ Alias }} - Declares a new alias space.

Source: Implementation to be compiled or interpreted, etc; By the handler with the use of aliases and modules to determine specifications.

* [ Name ] - Used as an include.
* [[ Name ]] - Extends a source space.
* [[[ Name ]]] - Declares a new source space.

All sectors are closed by just putting the brackets without a space between: || {} []

New sectors can possibly be defined. (Built on top of existing sectors and base base support the handler provides.
