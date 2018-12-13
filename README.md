# M.A.S. (Modular - Aliased - Sectored)
A dynamic, highly adaptable, programming language. (Currently only a concept)


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure logic using a single implementation handler.

Refactorable Syntax: All keys for every module/level can be refactored to an alias set/macro.

Explicit: Everything done must be declared visibity. All implicit features must be declared in a sector before use.

Comprehendable: Everything int the language is designed for comprehendability in mind. Symbols used must conform to design principles used in the visual fields for optimal human perception. The naming of all key terms used in the base lexicon set are carefully considered and should be easy to pick up and understand. (No excessive mnemonic nonsense) Structural use of those terms in accordance to their meaning must visually statisfy the meaning as much as practically posssible.


# M.A.S. Handler:

The general purpose handler(compiler/interpeter/etc) for an MAS programming langauge. The handler is fully modular. Whatever is generated soley depends on what modules are installed. Thus portability varies on what modules are available per platform.

All modules compiled and higher have sub-levels that divide features by the level of overhead they require. The lowest levels are the least overhead (thus the least performance cost), while the higher levels go up in complexity and have lower performance.

The handler will deduce what modules to use when using the formatting of the sectors within the mas files.

Naturally downside of this handler is there is an minimum degree of overhead for supporting a module based system. It has to interpet how to package implementation based on all these factors. Also any modules beyond compiled will need a byte-code level interpreter at least to be able to generate a proper package. Package types can also greatly vary depending on modules used from compiled code to pure vm code or hybrid.

The benefit is its one single programming language platform to do entire implmentation of a project or any other use case. Code from other languages can be brought into being managed by the handler so long as an alias set is defined for the lanauge the code was written in. Everything done is strictly explicit (To the level specified) to prevent hidden ambiguities.

## Modules:
Metal - The raw binary packager.
( Can have several sub-modules installed depending on hardware platform support. )

Assembly - Assembler.
( Can have several sub-modules depending on hardware platform support. )

Unisembly - Universal Assembler. Abstracts assembly to a low level universal assembly alias set. Has different levels for abstraction support. (Ranging from 1:1 statement execution to multi-statement abstraction)

Compiled - Traditional High-Level compiled langauge. Has various low level support (sub-levels) ranging from low lying operation to very high overhead.

Interpreter

Functional

Logical


## Alias Sets:
Allow for all key's to be defined, or ordered set of statments, to be mapped to an alias. These can be used as a preprocessor or macro of sort. Can also be used to import a foreign language that MAS's functionality could support.

Module/Level dependencies must be explcitly defined within the alias.

These mappings are saved as an alias set.


## Sectors:

Sector: Defines a area of code within a mas file for the handler to properly compile.

There are three built in defined sectors: || - For modules. {} - For aliases. [] - For source code.

| Module | - Declares a module to be used. (Modules cannot be defined, they are the imported into the handler).

Alias: Defines an alias to the base lexicon set the language uses, as well as macros.

* { Alias } - Used after level declaration to determine alias ( { } for default). Done after a level is declared and before a source space.
* {{ Alias }} - Extends an alias space.
* {{{ Alias }}} - Declares a new alias space.

Source: Implementation to be compiled or interpreted, etc; By the handler with the use of aliases and modules to determine specifications.

* [ Name ] - Used as an include.
* [[ Name ]] - Extends a source space.
* [[[ Name ]]] - Declares a new source space.

All sectors are closed by just putting the brackets without a space between: || {} []

New sectors can possibly be defined. (Built on top of existing sectors and base base support the handler provides.)

Ex: Library Packages.

## Organization

**.mcsource** (managed code source) files are the source code implementation to be managed by the handler.

.mcsource files can be locked to a specifc module or level by appending .mcs_(module name)_(level/platform specifier) to the end of the file. (Ignore paretheses. Level/platform specifier is only if the module supports it.)

**.bp** (blueprint) files are the header/table of contents/indexer of implementation. They are read first within the designated directories for the handler to manage or generate packages. Completely optional. Used as a way to better organize code and provide implementation level documentation.

**.alis** (alias set) files are used to explicity store only alias information. Provides better support from the handler in aiding the developer to produce an alias set of any scale. (Ex: Producing an alias set to support foreign programming language code)

## Proof of Concept (Proposal):
The proof of concept will be made using rust. 

It will use a module called Concept.

There will be an alias set to support C.
