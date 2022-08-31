# Time Domains

## Frame of thought
When a turing machine executes instructions, it changes it state.  
These changes in state have a perciptible time period or frequency of state changes.  

For current physical hardware we consider *physical* rate of change on a machine to be the **physical-real-time** domain.

For complex machines they may have multiple clocks per execution-engine with varying rates making there be multiple **phsyical-real-time** domains per execution unit.

With our current **HALs (Hardware Abstraction Layers)** implemented via harware or software (The operating system and hardware modules that aid it), we have another the process **runtime**.  

Runtimes are either considered **hard** or **soft** **real-time** based on how restricted the delta between a process's state changes can veer from the physical delta of the hardware execution state changes.

Currently for program models that are compiled, they tend to have several ***translation phases*** in the compiler for transforming the model into the final object that may used to form a executable class for a program or an ABI for an executable. 

The compiler's processing of a program model is usually termed **compile-time**.

----

## Program Model Time Domains

A program model can either directly dictate (assembly) what state changes are possible in the **runtime** domain or dictate to meta-program (compiler & interpreter) what it would like it to **generate** a direct dictation for a runtime model.


In **C** executable scope for example:
```c
a ++ ;
```
This is quite close to **runtime dictation** even if its not the actual assembly
as the expression has 1:1 corresspondence on virtually all hardware to an instruciton.

Using a struct or procedure however is not:
```c
typedef struct
{
	u32 A;
	u32 B;
}
Container;

void Execution( Container* C )
{
	C.A ++ ;
	C.B ++ ;
}
```
The meta-program (compiler usually) is being requested to perform generation of the runtime model by the user. These could be considered **compile-time** dictation.

Based on optimizations either Exectuion will be inlined, or be setup as a subroutine, etc. Instructions for the stack will occur, and offsets for the data encpsulated by the Container struct type will be figured out automatically; etc.

However in **C** there is also macro directives.

```c
#define CONSTANT_VALUE 1234567

//...
{
	a = CONSTANT_VALUE
}
```
These are still considered within **compile-time** as they are handled by the compiler's transformation process. However its not during the same ***translation-phase*** as the struct or procedure definitions. It occurs during preprocessing.

So the compile-time domain as its own *sub*-time domains of *execution* for program model *transofrmations* until the final *runtime-model* for a *target machine* is generated.

In C I can make the distinction of around 3 domains:

The Runtime, Object Linkage, Data model,and Preprocessor.

* Runtime: Everything in an executable code block that correlates close enough conceptually to what will actually be executed.

* Object Linkage: Dictates how different units of the program model/s can share exposed symbols across each other. 

* Data Model: Type aliases and structs typedef descrptions and stack or static allocations that define the layout of runtime-data. Including what dictates the layout of execution data (ex: procedure inlining).

* Preprocessor : Text generator to futher generate or conditionally have the compiler consider any portions of the model that correlate with any of the three other domains.

In **C++** there are more:

* Compile-Time Expressions and constants
* Templates

----

# Program Model Language Domains

There was an attempt to categorize the syntax of the langauge into general domains of time they are considered for along with others for a program model (AKA: a project or a module being processed with or without module dependencies)

## Build System:

Program model definition processor.
Procduces an acceptable model based on module files.

## Translation-Time Executer:

Meta-program for a program model. 

Modifes static sector (tt static) to have variables that are only modifiable during translation-time.

1. All conditionals not within an exectable sector are translation-time and dictate which portions of the program model are handled by the generator. 
*(Acts a filter before PMG gets it)*

2. All symbols that relying on a dependent capture with a translation-time argument (arg : tt ...) to be resolved are generated. 

4. Translation-Time Execution sectors (tt exe) executed in the order found in a unit sector.  
*(This is why its important to order a module's unit files in a unit process order sector)*

## Program Model Generator(PMG)

Generates a variant of intended to be processed by a platform target. The arget can either be another compiler, interpreter, or a *(virtual or real)* machine.

For the interpreter it generates a database of the model intended.

* Data types that are needed for reflection are preserved in the program data sector.
* Static sectors are processed into the program's data sector.
* Exeuction sectors are processed into an execution graph.

## Execution Time:

Anything within a non-translation time execution sector is considered Execution-Time.
