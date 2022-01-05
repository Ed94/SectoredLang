#ifndef LAL_Exception__Def

#include "TPAL.h"
#include "Config.LAL.h"
#include "LAL.Declarations.h"
#include "LAL.String.h"
#include "LAL.Types.h"


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


#ifdef LAL_TryCatch
#       define try     if (true)
#       define catch   else catch_label :
#       define throw   goto catch_lable
// https://twitter.com/thradams/status/1465733687270690818?s=20
#endif


#define LAL_Exception__Def
#endif

