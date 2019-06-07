/*
Trial By Fire: C Assist

An supportive library for C.
*/

#pragma once

#include "stdlib.h"


//Macros:

//Entry point:

#define ResultCode \
int

#define EntryPoint \
main

//Pointer Handling:

//Provides a more explicit method for declaring a pointer.
#define Ptr(_type) \
_type*

//Provides a more explicit method for getting a reference.
#define Ref(_instance) \
&_instance

//Provides a more explicit method for dereferencing a pointer. (Get value contained at address)
#define Dref(_pointer) \
*_pointer


//Mutability

////Used for defining a non-compile time constant. Where something is really just said to not be changeable instead of being a true constant.
#define Immutable \
const

//Explicit Extern:

//Makes Variables/Functions in Global/File Scope available to other files.
#define EPublic \
extern


//Explicit Statics:

//Hides variables/Functions that would be accessible via extern. (Global scope/File Scope Only)
#define SPrivate \
static

//Used to define a permanent variable within a function scope. (Function Scope Only)
#define StaticV \
static


//Array Stuff:

#define GetFromPtrArray(_pointer, _index) \
dref( (_pointer + _index) )


//Function Stuff:

#define Func(_type) \
_type

//Creates a pointer to a function.
#define FuncPtr(_function) \
(*FPtr_##_function)

//Provides a reference to a function.

//Provides a reference to a defined function. The ... is the parameters of the function (__VA_ARGS__ is where they are placed). 
#define FuncRef(_ReturnType, _functionIdentifier, ...) \
_ReturnType FuncPtr(_functionIdentifier) (__VA_ARGS__)

//Calls a function that is a member within a struct.
#define MemberFunc(_StructInstance, _functionIdentifier, ...) \
(_StructInstance)->_functionIdentifier(_StructInstance, __VA_ARGS__)


//Memory Management

#define MAllocate(_pointer, _numOfObjects, _sizeOfObject, _shouldInitialize) \
if (_shouldInitialize == 0) \
{ \
	_pointer = malloc(_sizeOfObject * _numOfObjects); \
} \
else \
{ \
	_pointer = calloc(_numOfObjects, _sizeOfObject); \
}

typedef unsigned long long int uInt64;

Func(void) Allocate
(
	Ptr(void) _instanceToAllocate,
	uInt64    _numOfObjects      ,
	size_t    _sizeOfObject      ,
	int       _shouldInitalize
);

Func(void) Deallocate(Ptr(void) _instanceToDeallocate);