#ifndef LAL_Exception__Def

#include "LAL_C_STL.h"
#include "LAL_String.h"


ForceInline
ErrorType Exception_GetLastError(void)
{
	return errno;
}

void Exception_Throw         (str _message);
void Exception_NoEntry       (str _message);
void Exception_NoRecursion   (str _message);
void Exception_NoReentry     (str _message);
void Exception_NotImplemented(str _message);

void Fatal_Throw         (str _message);
void Fatal_NoEntry       (str _message);
void Fatal_NoRecursion   (str _message);
void Fatal_NoReentry     (str _message);
void Fatal_NotImplemented(str _message);


#define LAL_Exception__Def
#endif

