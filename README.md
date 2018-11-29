# M.A.S. (Modular - Aliased - Sectored)
A little project to test a concept for programming.


# Features:

Multi-Leveled abstraction approach to programming: Program from binary to pure functional in one language.

Refactorable Syntax: All keys for every level can be refactored to an alias set.


# M.A.S. Handler:

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

## Sectors:

Sector:

| Sector | - Decalres a Sector to be used. (Levels cannot be defined, they are built into the handler).

Alias:

* { Alias } - Used after level declaration to determine alias ( { } for default). Done after a is level declared and before a source space.
* {{ Alias }} - Extends an alias space.
* {{{ Alias }} - Declares a new alias space.

Source:

* [ Name ] - Used as an include.
* [[ Name ]] - Extends a source space.
* [[[ Name ]]] - Declares a new source space.

All spaces are closed by just putting the brackets without a space between: || {} []
