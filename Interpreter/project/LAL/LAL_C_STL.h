/*
*/

#ifndef LAL_C_STL__Def


#include "LAL_Platform.h"


// C STL Libraries

// Library to use
#define LAL_STD
// #define LAL_STL_allegro
// #define LAL_STL_sqlite
// #define LAL_zlib
// #define LAL_zpl

// Both require posix and I don't feel like supporting.
//#define LAL_bstring
//#define LAL_klib   

// Character Width
#define LAL_CharWidth_Narrow

#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic push 
#pragma GCC diagnostic ignored "-Weverything"
#endif

#ifdef LAL_STD
		#include <assert.h>
		#include <ctype.h>
		#include <errno.h>
		#include <inttypes.h>
		#include <float.h>
		#include <math.h>
		#include <limits.h>
		#include <locale.h>
		#include <setjmp.h>
		#include <signal.h>
		// #include <stdalign.h>
		#include <stdarg.h>
		// #include <stdatomic.h>
		#include <stdbool.h>
		#include <stddef.h>
		#include <stdint.h>
		#include <stdio.h>
		#include <stdlib.h>
		// #include <stdnoreturn.h>
		#include "string.h"
		// #include <threads.h>
		#include <time.h>
		#include <uchar.h>
		#include <wchar.h>
		#include <wctype.h>
#endif

#ifdef LAL_zpl
		#include "zpl/code/zpl.h"
#endif

#if defined(LAL_zlib) || defined(LAL_klib)
		// Requires posix interface.
//#include "unistd/unistd.h"
//#include "unistd/uni_signal.h"
#endif

#ifdef LAL_allegro
#endif

// #ifdef LAL_bstring
// 		#include "bstrlib/bsafe.h"
// 		#include "bstrlib/bstraux.h"
// 		#include "bstrlib/bstrlib.h"
// 		#include "bstrlib/buniutil.h"
// 		#include "bstrlib/utf8util.h"
// #endif

#ifdef LAL_glib
#endif

#ifdef LAL_zlib
		#include "zlib/zlib.h"
	
	#ifdef LAL_CharWidth_Wide
		// zlib does not suppor wide char.
		#undef  LAL_CharWidth_Wide
		#define LAL_CharWidth_Narrow
	#endif
#endif

// #ifdef LAL_klib

// 	#ifdef LAL_zlib
// 		#include "klib/bgzf.h"
// 	#endif

// 		#include "klib/kalloc.h"
// 		#include "klib/kavl.h"
// 		#include "klib/kavl-lite.h"
// 		#include "klib/kbit.h"
// 		#include "klib/kbtree.h"
// 		#include "klib/kdq.h"
// 		#include "klib/keigen.h"
// 		#include "klib/ketopt.h"
// 		#include "klib/kexpr.h"
// 		#include "klib/kgraph.h"
// 		#include "klib/khash.h"
// 		#include "klib/khmm.h"
// #undef FLOAT
// 		#include "klib/klist.h"
// 		#include "klib/kmath.h"
// 		#include "klib/knetfile.h"
// 		#include "klib/knhx.h"
// 		#include "klib/krmq.h"
// 		#include "klib/krng.h"
// 		#include "klib/kseq.h"
// 		#include "klib/kson.h"
// 		#include "klib/ksort.h"
// 		#include "klib/kstring.h"
// 		#include "klib/ksw.h"
// 		#include "klib/kthread.h"
// 		#include "klib/kurl.h"
// 		#include "klib/kvec.h"
// #endif

#ifdef LAL_sqlite
		#include "sqlite3.h"
#endif

#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic pop
#endif

#define LAL_C_STL__Def
#endif
