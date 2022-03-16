#ifndef TPAL__Def
#define TPAL__Def

#include "Config.TPAL.h"


#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic push 
#pragma GCC diagnostic ignored "-Weverything"
#endif

#ifndef OSAL_Platform__Def
// Yeet any platform grime here..
#   define  TPAL_Avoid_WindowsIssues
#   include "TPAL.Platform.h"
#endif

#pragma region REQUIRED
#       include <assert.h>
#       include <errno.h>
#       include <stdarg.h>
#       include <stdbool.h>
#       include <stddef.h>
#       include <stdio.h>
#       include <stdint.h>
#       include <stdlib.h>
#       include <uchar.h>
#       include <wchar.h>
#       include <wctype.h>
#pragma endregion REQUIRED

#ifdef TPAL_STD
#       include <ctype.h>
#       include <inttypes.h>
#       include <float.h>
#       include <math.h>
#       include <limits.h>
#       include <locale.h>
#       include <setjmp.h>
#       include <signal.h>
// #       include <stdalign.h>
// #       include <stdatomic.h>
// #       include <stdnoreturn.h>
#       include "string.h"
// #       include <threads.h>
#       include <time.h>
#endif

#ifdef TPAL_allegro
#endif

#if defined(TPAL_zlib) || defined(TPAL_klib)
// Requires posix interface.
#       include "unistd/unistd.h"
#       include "unistd/uni_signal.h"
#endif

#ifdef TPAL_bstring
#       include "bstrlib/bsafe.h"
#       include "bstrlib/bstraux.h"
#       include "bstrlib/bstrlib.h"
#       include "bstrlib/buniutil.h"
#       include "bstrlib/utf8util.h"
#endif

#ifdef TPAL_glib
#endif

#ifdef TPAL_Hedley
#       include "hedley.h"
#endif

#ifdef TPAL_zlib
//  Some klib features depend on zlib.
#   include "zlib/zlib.h"
	
#   ifdef      TPAL_CharWidth_Wide
#       undef  TPAL_CharWidth_Wide
#       define TPAL_CharWidth_Narrow
//      zlib does not suppor wide char.
#   endif

#   define LAL_Unsupported__IO_SetCharMode	
//         zlib doesn't support setting character mode.
#endif

#ifdef TPAL_klib

#   ifdef TPAL_zlib
#       include "klib/bgzf.h"
#   endif
#       include "klib/kalloc.h"
#       include "klib/kavl.h"
#       include "klib/kavl-lite.h"
#       include "klib/kbit.h"
#       include "klib/kbtree.h"
#       include "klib/kdq.h"
#       include "klib/keigen.h"
#       include "klib/ketopt.h"
#       include "klib/kexpr.h"
#       include "klib/kgraph.h"
#       include "klib/khash.h"
#       include "klib/khmm.h"
#   undef FLOAT
#       include "klib/klist.h"
#       include "klib/kmath.h"
#       include "klib/knetfile.h"
#       include "klib/knhx.h"
#       include "klib/krmq.h"
#       include "klib/krng.h"
#       include "klib/kseq.h"
#       include "klib/kson.h"
#       include "klib/ksort.h"
#       include "klib/kstring.h"
#       include "klib/ksw.h"
#       include "klib/kthread.h"
#       include "klib/kurl.h"
#       include "klib/kvec.h"
#endif

#ifdef TPAL_qlib
#       include "qlibc/qlibc.h"
#endif 

#ifdef TPAL_sqlite
#       include "sqlite3.h"
#endif

#ifdef TPAL_zpl
#       include "zpl.h"
#endif

#if defined(__GNUC__) || defined(__clang__)
#   pragma GCC diagnostic pop
#endif

#endif // TPAL__Def
