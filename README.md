# M.A.S. (Modular - Aliased - Sectored)
A dynamic, highly adaptable, programming language. (Currently only a concept)


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure logic using a single implementation handler.

Refactorable Syntax: All keys for every module/level can be refactored to an alias set/macro.

Explicit: Everything done must be declared visibity. All implicit features must be declared in a sector before use.

Comprehendable: The language is designed for comprehendability in mind. Symbols used must conform to design principles used in the visual fields for optimal human perception. The naming of all key terms used in the base lexicon set are carefully considered and should be easy to pick up and understand. (No excessive mnemonic nonsense) Structural use of those terms in accordance to their meaning must visually statisfy the meaning as much as practically posssible.


# M.A.S. Handler:

The general purpose handler(compiler/interpeter/etc) for an MAS programming langauge. The handler is fully modular. Whatever is generated soley depends on what modules are installed. Thus portability varies on what modules are available per platform.

All modules Unissembly and higher have sub-levels that divide features by the level of overhead they require. The lowest levels are the least overhead (thus the least performance cost), while the higher levels go up in complexity and have lower performance.

Modules are written from each other, assembly to unissembly, unissembly to compiler etc. This is to provide a complete all inclusive scope to how the modules abstract/alias or provide overhead to each other. There is no need to learn a foreign set of documentation / concepts outside of the conventions of M.A.S. (Exceptions would be around the binary or assembly module since that is by the architecture.

The handler will deduce what modules to use when using the formatting of the sectors within the mas files.

Naturally downside of this handler is there is an minimum degree of overhead for supporting a module based system. It has to interpet how to package implementation based on all these factors. Also any modules beyond compiled will need a byte-code level interpreter at least to be able to generate a proper package. Package types can also greatly vary depending on modules used from compiled code to pure vm code or hybrid.

The benefit is its one single programming language platform to do entire implmentation of a project or any other use case. Code from other languages can be brought into being managed by the handler so long as an alias set is defined for the lanauge the code was written in. Everything done is strictly explicit (To the level specified) to prevent hidden ambiguities.

## Modules:
Metal - The raw binary packager. (x86/64, ARM, RISC, etc)
( Can have several sub-modules installed depending on hardware platform support. )

Assembler - Native Hardware Assembler. (x86/64, ARM, RISC, etc)
( Can have several sub-modules depending on hardware platform support. )

Unissembly - Universal Assembler. Abstracts platform assembly to a low level universal assembly alias set. Has different levels for abstraction support. (Ranging from 1:1 statement execution to multi-statement abstraction) (Must have at least one assembler installed for a compatible Alias Set)

Compiler - Traditional High-Level compiled langauge. Has various low level support (sub-levels) ranging from low lying operation to very high overhead. (Written in Unissembly)

Interpreter (Written in Compiler/Unissembly)

Functional

Logical


## Alias Sets:
Allow for all key's to be defined, or ordered set of statments, to be mapped to an alias. These can be used as a preprocessor or macro of sort. Can also be used to import a foreign language that MAS's functionality could support.

Module/Level dependencies must be explcitly defined within the alias.

These mappings are saved as an alias set.


## Sectors:

Sector: Defines a area of code within a mas file for the handler to properly compile.

There are three built in defined sectors: Modules, Aliases, and Source code.

* Module: - Declares a module to be used. (Modules can be defined, but must be packaged in such a way that the handler can import them).

Alias: Defines an alias to the base lexicon set the language uses, as well as macros.

* Alias  - Used after level declaration to determine alias. Done after a level is declared and before a source space.
* Append - Extends an alias space.

Source: Implementation to be compiled or interpreted, etc; By the handler with the use of aliases and modules to determine specifications.

* Source - Used as an include.
* Append - Extends a source space.

All sectors are scope using brackets as done traditionally in languages for functions and classes for example.

New sectors can possibly be defined. (Built on top of existing sectors and base base support the handler provides.)

Ex: Library Packages.

## Organization

**.mcsource** (managed code source) files are the source code implementation to be managed by the handler.

.mcsource files can be locked to a specifc module or level by appending .mcs_(module name)_(level/platform specifier) to the end of the file. (Ignore paretheses. Level/platform specifier is only if the module supports it.)

**.bp** (blueprint) files are the header/table of contents/indexer of implementation. They are read first within the designated directories for the handler to manage or generate packages. Completely optional. Used as a way to better organize code and provide implementation level documentation.

**.alis** (alias set) files are used to explicity store only alias information. Provides better support from the handler in aiding the developer to produce an alias set of any scale. (Ex: Producing an alias set to support foreign programming language code)

## Proof of Concept (Proposal):
The proof of concept will be made using rust. 

It will use a compiler sub-module called Concept.

There will be an alias set to support C.

## Example of an .mcsource file:
![ExImage](https://i.imgur.com/RD6CKjp.png)
![ExImage](https://i.imgur.com/py8PPtY.png)
![ExImage](https://i.imgur.com/7xcYhs3.png)
