#pragma once

#include "Memory_Assist.hpp"
#include "String_Assist.hpp"
#include <vector>



using std::move;

template<typename Type>
using vector = std::vector<Type>;



// Base class for all expression nodes.
class ExpressionAST
{
public:
	virtual ~ExpressionAST() {}
};


// Expression class for numeric literals. Ex: 1.0
class NumberExAST : public ExpressionAST
{
public:
	NumberExAST(double ValueToAssign) : value(ValueToAssign) {}

private:
	double value;
};


class VariableExAST : public ExpressionAST
{
public:
	VariableExAST(const string& NameToAssign) : name(NameToAssign) {}

private:
	string name;
};


class BinaryExAST : public ExpressionAST
{
public:
	BinaryExAST
	(
		char                OperationToAssign    , 
		UPtr<ExpressionAST> LeftArgumentToAssign ,
		UPtr<ExpressionAST> RightArgumentToAssign
	) : 
	operation    (OperationToAssign          ),
	leftArgument (move(LeftArgumentToAssign )), 
	rightArgument(move(RightArgumentToAssign))
	{}

private:
	char operation;

	UPtr<ExpressionAST> leftArgument, rightArgument;
};



using ExpressionList = vector< UPtr<ExpressionAST> >;

class FunctionCallExAST : public ExpressionAST
{
public:
	FunctionCallExAST
	(
		const string&  RecipientToAssign,
		ExpressionList ArgumentsToAssgin
	) :
	recipient(RecipientToAssign      ),
	arguments(move(ArgumentsToAssgin)) 
	{}


private:
	string         recipient;
	ExpressionList arguments;
};


using StringList = vector< string >;

class PrototypeAST
{
public:
	PrototypeAST(const string& NameToAssign, StringList ArgumentsToAssign) :
	name(NameToAssign), arguments(move(ArgumentsToAssign))
	{}

	const string& GetName() const 
	{ 
		return name; 
	}

private:
	string name;

	StringList arguments;
};


class FunctionAST
{
public:
	FunctionAST(UPtr<PrototypeAST> PrototypeToAssign, UPtr<ExpressionAST> BodyToAssign) :
	prototype(move(PrototypeToAssign)), body(move(BodyToAssign))
	{}

private:
	UPtr<PrototypeAST > prototype;
	UPtr<ExpressionAST> body     ;
};
