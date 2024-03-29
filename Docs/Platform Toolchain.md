## LP (Language Platform) :
These are domain specific compatible platforms to handle MAS programs.
MAS platforms can support different LPs.

## Backend Categories :
<pre>
ISA            Instruction Set Architecture (x86, ARM, RISC, etc). Machine code signal interface
Assembler      ISA supported assembler
IR             Intermediary representation compiler framework.
Compiler       Low (L0) to high (L4) level compiled language. Can use the previous modules to support translation
Interpreter    Runtime interpreter for the same language specification used of for the compiler
</pre>

## LP Directors :
<pre>
These are metaprogramming platforms that may be provided by a Language Platform. 
The language feature layering provides the default policy for what features are allowed from these directors.

(Note: I may remove Alias)

Alias      Not sure how far this is going to go, but its going to be for symbol aliasing.

LP         Handles directives to tooling.

TT         Translation Time: Allows for translation time execution and code generation. 
</pre>

## LFLs (Language Feature Layering) :

All language/module features can be explicitly disabled or enabled in context specification  
Generalized set of features are group into layers from layer 0 to layer 4.  
With an extra sub-layer called "0.OS" for the 0th layer but ommiting features ussually handled by a OS kernel.  

<pre>
Layer 0     Low-level features, binary, hex, interrupts, paging, stack, registers, etc (C/Asm - Freesatnding)
Lyaer 0.OS  Removes features handled by the OS kernel and provides a standard interface to OS
            Features
Layer 1     C Features (Non-Freestanding)
Layer 2     Memory and execution safety, garbage collection, V-Table generation, etc
Layer 3     C++ level of expressability
Layer 4     Purely functional
</pre>

# File/Unit associations :

## .context                Context Specification  
Context unit for a project or package. Determines how the related content will be processed  
<br />

<pre>
symbols:
    context             Provides a designated named context unit for a project
    description         Description for context
    LP                  States what backend modules to use for program specification
    layers              Specifies which language layers are implicity allowed. (To allow none, leave empty)
    explicit layers     Whether or not layers may be explicitly allowed within units
    alias               Specifies either the model language standard or support for an external language syntax
    dependencides       States what external packages this context depends on
    alias               Allows for in context appending of the current alias set (intended for small additions)
    units/files         Used to specify what units or files are associated with the context
    exec                Specifies the execution entrypoint (if the context is a program)
</pre>

## .bp.*                Blueprint
<pre>
Serve a few purposes :

    An Outline              Blueprints provide a clean outline for unit/s encapsulated as subject
    Conflict Avoidance      In conjunction with contexts and alias sets, blueprints prevent circular 
                            dependency issues or issues with symbol resolution
    Package Optimization    Allow the backend to cache and process packing and context efficiently
    Unit/s sectoring        Acts as a namespace for a set of implementation

Note: While it is ideal, blueprints could also be generated if desired (intended feature later on)   

A blueprint's syntax closely follows the language model used for spec units  
</pre>

## .spec.*              Specification

Where a unit of implementation for a subject or context is defined  
There can be multiple units for each bp (blueprint)

## .gen.*.*             Generated Specification

These are generated units that have completed the meta and/or ct pass.  
These files are optionally outputted to the filesystem.  
These files are mainly intended to be rendered or debugged in a mas compatiable editor.  

The purpose is to provide an visual of how meta-programming (alias, meta, tt) features are generated in a clear way.  

## .db.*                Database

This is a full image of a processed context.  
Which includes the structured table organized by the context and subject units.  
Contains all unit defined symbols and their properites along with AST of execution specification.  
These are meant to be saved to cache previous passes or as an intermediary between tools.  

Should be viewable using a database viewer.  

## .ast.*               Abstract Syntax There

This is a Dion (hopefully) formatted ast file that contains the raw parsed ast of a context.
This can be used as intermediary between tools or as a way to store the "live" source code.  
Unit text files can be generated from the ast.

This is meant to be the live "code" the user writes source code in with a toolchain. ASTs should be rendered live in "tiled" or "tokened" text.