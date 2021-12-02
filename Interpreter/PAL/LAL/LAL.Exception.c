#include "LAL.Exception.h"

#include "LAL.IO.h"
#include "LAL.Memory.h"


void Exception_Throw(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
}

void Exception_NoEntry(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
}

void Exception_NoRecursion(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
}

void Exception_NoReentry(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
}

void Exception_NotImplemented(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
}


void Fatal_Throw(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);
	
	assert(false);
}

void Fatal_NoEntry(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);

	assert(false);
}

void Fatal_NoRecursion(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);

	assert(false);
}

void Fatal_NoReentry(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);

	assert(false);
}

void Fatal_NotImplemented(str _message)
{
	IO_StdWrite(IO_StdError, "\nError: %s\n", _message);

	assert(false);
}

