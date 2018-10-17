# LAR (Layer Abstracted Refactorable)
A little project to test a concept for programming.


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure functional in one language.

Refactorable Syntax: All keys for every level can be refactored to an alias set.
# LAR Handler:

## Modules:
Metal

Assembly

Unisembly

Compiled

Interpreter

Functional


## Alias Sets:
Allow for all key's used during parsing to be mapped to an alias for use of foreign language that LAR's functionality could support if a key sutiably matches the original's function.

These mappings are saved as an alias set.

## Spaces:

Levels:
| Level | - Decalres a level to be used. (Levels cannot be defined, they are built into the handler).

Alias

* { Alias } - Used after level declaration to determine alias. ( { } for default)
* {{ Alias }} - Extends an alias
* {{{ Alias }} - Declares a new alias.

Source

* [ Name ] - Used as an include.
* [[ Name ]] - Extends a source space.
* [[[ Name ]]] - Declares a new source space.

All spaces are closed by just putting the brackets without a space between: || {} []
