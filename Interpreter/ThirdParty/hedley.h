/* Hedley - https://nemequ.github.io/hedley
 * Created by Evan Nemerson <evan@nemerson.com>
 *
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to
 * the public domain worldwide. This software is distributed without
 * any warranty.
 *
 * For details, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 * SPDX-License-Identifier: CC0-1.0
 */

// NOTE: This file has been been changed in the following way:
// FindAndReplace: "HEDLEY_" -> ""

#if !defined(HEDLEY_VERSION) || (HEDLEY_VERSION < 15)
#if defined(HEDLEY_VERSION)
#  undef HEDLEY_VERSION
#endif
#define HEDLEY_VERSION 15

#if defined(STRINGIFY_EX)
#  undef STRINGIFY_EX
#endif
#define STRINGIFY_EX(x) #x

#if defined(STRINGIFY)
#  undef STRINGIFY
#endif
#define STRINGIFY(x) STRINGIFY_EX(x)

#if defined(CONCAT_EX)
#  undef CONCAT_EX
#endif
#define CONCAT_EX(a,b) a##b

#if defined(CONCAT)
#  undef CONCAT
#endif
#define CONCAT(a,b) CONCAT_EX(a,b)

#if defined(CONCAT3_EX)
#  undef CONCAT3_EX
#endif
#define CONCAT3_EX(a,b,c) a##b##c

#if defined(CONCAT3)
#  undef CONCAT3
#endif
#define CONCAT3(a,b,c) CONCAT3_EX(a,b,c)

#if defined(VERSION_ENCODE)
#  undef VERSION_ENCODE
#endif
#define VERSION_ENCODE(major,minor,revision) (((major) * 1000000) + ((minor) * 1000) + (revision))

#if defined(VERSION_DECODE_MAJOR)
#  undef VERSION_DECODE_MAJOR
#endif
#define VERSION_DECODE_MAJOR(version) ((version) / 1000000)

#if defined(VERSION_DECODE_MINOR)
#  undef VERSION_DECODE_MINOR
#endif
#define VERSION_DECODE_MINOR(version) (((version) % 1000000) / 1000)

#if defined(VERSION_DECODE_REVISION)
#  undef VERSION_DECODE_REVISION
#endif
#define VERSION_DECODE_REVISION(version) ((version) % 1000)

#if defined(GNUC_VERSION)
#  undef GNUC_VERSION
#endif
#if defined(__GNUC__) && defined(__GNUC_PATCHLEVEL__)
#  define GNUC_VERSION VERSION_ENCODE(__GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__)
#elif defined(__GNUC__)
#  define GNUC_VERSION VERSION_ENCODE(__GNUC__, __GNUC_MINOR__, 0)
#endif

#if defined(GNUC_VERSION_CHECK)
#  undef GNUC_VERSION_CHECK
#endif
#if defined(GNUC_VERSION)
#  define GNUC_VERSION_CHECK(major,minor,patch) (GNUC_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define GNUC_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(MSVC_VERSION)
#  undef MSVC_VERSION
#endif
#if defined(_MSC_FULL_VER) && (_MSC_FULL_VER >= 140000000) && !defined(__ICL)
#  define MSVC_VERSION VERSION_ENCODE(_MSC_FULL_VER / 10000000, (_MSC_FULL_VER % 10000000) / 100000, (_MSC_FULL_VER % 100000) / 100)
#elif defined(_MSC_FULL_VER) && !defined(__ICL)
#  define MSVC_VERSION VERSION_ENCODE(_MSC_FULL_VER / 1000000, (_MSC_FULL_VER % 1000000) / 10000, (_MSC_FULL_VER % 10000) / 10)
#elif defined(_MSC_VER) && !defined(__ICL)
#  define MSVC_VERSION VERSION_ENCODE(_MSC_VER / 100, _MSC_VER % 100, 0)
#endif

#if defined(MSVC_VERSION_CHECK)
#  undef MSVC_VERSION_CHECK
#endif
#if !defined(MSVC_VERSION)
#  define MSVC_VERSION_CHECK(major,minor,patch) (0)
#elif defined(_MSC_VER) && (_MSC_VER >= 1400)
#  define MSVC_VERSION_CHECK(major,minor,patch) (_MSC_FULL_VER >= ((major * 10000000) + (minor * 100000) + (patch)))
#elif defined(_MSC_VER) && (_MSC_VER >= 1200)
#  define MSVC_VERSION_CHECK(major,minor,patch) (_MSC_FULL_VER >= ((major * 1000000) + (minor * 10000) + (patch)))
#else
#  define MSVC_VERSION_CHECK(major,minor,patch) (_MSC_VER >= ((major * 100) + (minor)))
#endif

#if defined(INTEL_VERSION)
#  undef INTEL_VERSION
#endif
#if defined(__INTEL_COMPILER) && defined(__INTEL_COMPILER_UPDATE) && !defined(__ICL)
#  define INTEL_VERSION VERSION_ENCODE(__INTEL_COMPILER / 100, __INTEL_COMPILER % 100, __INTEL_COMPILER_UPDATE)
#elif defined(__INTEL_COMPILER) && !defined(__ICL)
#  define INTEL_VERSION VERSION_ENCODE(__INTEL_COMPILER / 100, __INTEL_COMPILER % 100, 0)
#endif

#if defined(INTEL_VERSION_CHECK)
#  undef INTEL_VERSION_CHECK
#endif
#if defined(INTEL_VERSION)
#  define INTEL_VERSION_CHECK(major,minor,patch) (INTEL_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define INTEL_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(INTEL_CL_VERSION)
#  undef INTEL_CL_VERSION
#endif
#if defined(__INTEL_COMPILER) && defined(__INTEL_COMPILER_UPDATE) && defined(__ICL)
#  define INTEL_CL_VERSION VERSION_ENCODE(__INTEL_COMPILER, __INTEL_COMPILER_UPDATE, 0)
#endif

#if defined(INTEL_CL_VERSION_CHECK)
#  undef INTEL_CL_VERSION_CHECK
#endif
#if defined(INTEL_CL_VERSION)
#  define INTEL_CL_VERSION_CHECK(major,minor,patch) (INTEL_CL_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define INTEL_CL_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(PGI_VERSION)
#  undef PGI_VERSION
#endif
#if defined(__PGI) && defined(__PGIC__) && defined(__PGIC_MINOR__) && defined(__PGIC_PATCHLEVEL__)
#  define PGI_VERSION VERSION_ENCODE(__PGIC__, __PGIC_MINOR__, __PGIC_PATCHLEVEL__)
#endif

#if defined(PGI_VERSION_CHECK)
#  undef PGI_VERSION_CHECK
#endif
#if defined(PGI_VERSION)
#  define PGI_VERSION_CHECK(major,minor,patch) (PGI_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define PGI_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(SUNPRO_VERSION)
#  undef SUNPRO_VERSION
#endif
#if defined(__SUNPRO_C) && (__SUNPRO_C > 0x1000)
#  define SUNPRO_VERSION VERSION_ENCODE((((__SUNPRO_C >> 16) & 0xf) * 10) + ((__SUNPRO_C >> 12) & 0xf), (((__SUNPRO_C >> 8) & 0xf) * 10) + ((__SUNPRO_C >> 4) & 0xf), (__SUNPRO_C & 0xf) * 10)
#elif defined(__SUNPRO_C)
#  define SUNPRO_VERSION VERSION_ENCODE((__SUNPRO_C >> 8) & 0xf, (__SUNPRO_C >> 4) & 0xf, (__SUNPRO_C) & 0xf)
#elif defined(__SUNPRO_CC) && (__SUNPRO_CC > 0x1000)
#  define SUNPRO_VERSION VERSION_ENCODE((((__SUNPRO_CC >> 16) & 0xf) * 10) + ((__SUNPRO_CC >> 12) & 0xf), (((__SUNPRO_CC >> 8) & 0xf) * 10) + ((__SUNPRO_CC >> 4) & 0xf), (__SUNPRO_CC & 0xf) * 10)
#elif defined(__SUNPRO_CC)
#  define SUNPRO_VERSION VERSION_ENCODE((__SUNPRO_CC >> 8) & 0xf, (__SUNPRO_CC >> 4) & 0xf, (__SUNPRO_CC) & 0xf)
#endif

#if defined(SUNPRO_VERSION_CHECK)
#  undef SUNPRO_VERSION_CHECK
#endif
#if defined(SUNPRO_VERSION)
#  define SUNPRO_VERSION_CHECK(major,minor,patch) (SUNPRO_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define SUNPRO_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(EMSCRIPTEN_VERSION)
#  undef EMSCRIPTEN_VERSION
#endif
#if defined(__EMSCRIPTEN__)
#  define EMSCRIPTEN_VERSION VERSION_ENCODE(__EMSCRIPTEN_major__, __EMSCRIPTEN_minor__, __EMSCRIPTEN_tiny__)
#endif

#if defined(EMSCRIPTEN_VERSION_CHECK)
#  undef EMSCRIPTEN_VERSION_CHECK
#endif
#if defined(EMSCRIPTEN_VERSION)
#  define EMSCRIPTEN_VERSION_CHECK(major,minor,patch) (EMSCRIPTEN_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define EMSCRIPTEN_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(ARM_VERSION)
#  undef ARM_VERSION
#endif
#if defined(__CC_ARM) && defined(__ARMCOMPILER_VERSION)
#  define ARM_VERSION VERSION_ENCODE(__ARMCOMPILER_VERSION / 1000000, (__ARMCOMPILER_VERSION % 1000000) / 10000, (__ARMCOMPILER_VERSION % 10000) / 100)
#elif defined(__CC_ARM) && defined(__ARMCC_VERSION)
#  define ARM_VERSION VERSION_ENCODE(__ARMCC_VERSION / 1000000, (__ARMCC_VERSION % 1000000) / 10000, (__ARMCC_VERSION % 10000) / 100)
#endif

#if defined(ARM_VERSION_CHECK)
#  undef ARM_VERSION_CHECK
#endif
#if defined(ARM_VERSION)
#  define ARM_VERSION_CHECK(major,minor,patch) (ARM_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define ARM_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(IBM_VERSION)
#  undef IBM_VERSION
#endif
#if defined(__ibmxl__)
#  define IBM_VERSION VERSION_ENCODE(__ibmxl_version__, __ibmxl_release__, __ibmxl_modification__)
#elif defined(__xlC__) && defined(__xlC_ver__)
#  define IBM_VERSION VERSION_ENCODE(__xlC__ >> 8, __xlC__ & 0xff, (__xlC_ver__ >> 8) & 0xff)
#elif defined(__xlC__)
#  define IBM_VERSION VERSION_ENCODE(__xlC__ >> 8, __xlC__ & 0xff, 0)
#endif

#if defined(IBM_VERSION_CHECK)
#  undef IBM_VERSION_CHECK
#endif
#if defined(IBM_VERSION)
#  define IBM_VERSION_CHECK(major,minor,patch) (IBM_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define IBM_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_VERSION)
#  undef TI_VERSION
#endif
#if \
    defined(__TI_COMPILER_VERSION__) && \
    ( \
      defined(__TMS470__) || defined(__TI_ARM__) || \
      defined(__MSP430__) || \
      defined(__TMS320C2000__) \
    )
#  if (__TI_COMPILER_VERSION__ >= 16000000)
#    define TI_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#  endif
#endif

#if defined(TI_VERSION_CHECK)
#  undef TI_VERSION_CHECK
#endif
#if defined(TI_VERSION)
#  define TI_VERSION_CHECK(major,minor,patch) (TI_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_CL2000_VERSION)
#  undef TI_CL2000_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && defined(__TMS320C2000__)
#  define TI_CL2000_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_CL2000_VERSION_CHECK)
#  undef TI_CL2000_VERSION_CHECK
#endif
#if defined(TI_CL2000_VERSION)
#  define TI_CL2000_VERSION_CHECK(major,minor,patch) (TI_CL2000_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_CL2000_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_CL430_VERSION)
#  undef TI_CL430_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && defined(__MSP430__)
#  define TI_CL430_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_CL430_VERSION_CHECK)
#  undef TI_CL430_VERSION_CHECK
#endif
#if defined(TI_CL430_VERSION)
#  define TI_CL430_VERSION_CHECK(major,minor,patch) (TI_CL430_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_CL430_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_ARMCL_VERSION)
#  undef TI_ARMCL_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && (defined(__TMS470__) || defined(__TI_ARM__))
#  define TI_ARMCL_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_ARMCL_VERSION_CHECK)
#  undef TI_ARMCL_VERSION_CHECK
#endif
#if defined(TI_ARMCL_VERSION)
#  define TI_ARMCL_VERSION_CHECK(major,minor,patch) (TI_ARMCL_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_ARMCL_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_CL6X_VERSION)
#  undef TI_CL6X_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && defined(__TMS320C6X__)
#  define TI_CL6X_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_CL6X_VERSION_CHECK)
#  undef TI_CL6X_VERSION_CHECK
#endif
#if defined(TI_CL6X_VERSION)
#  define TI_CL6X_VERSION_CHECK(major,minor,patch) (TI_CL6X_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_CL6X_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_CL7X_VERSION)
#  undef TI_CL7X_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && defined(__C7000__)
#  define TI_CL7X_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_CL7X_VERSION_CHECK)
#  undef TI_CL7X_VERSION_CHECK
#endif
#if defined(TI_CL7X_VERSION)
#  define TI_CL7X_VERSION_CHECK(major,minor,patch) (TI_CL7X_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_CL7X_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TI_CLPRU_VERSION)
#  undef TI_CLPRU_VERSION
#endif
#if defined(__TI_COMPILER_VERSION__) && defined(__PRU__)
#  define TI_CLPRU_VERSION VERSION_ENCODE(__TI_COMPILER_VERSION__ / 1000000, (__TI_COMPILER_VERSION__ % 1000000) / 1000, (__TI_COMPILER_VERSION__ % 1000))
#endif

#if defined(TI_CLPRU_VERSION_CHECK)
#  undef TI_CLPRU_VERSION_CHECK
#endif
#if defined(TI_CLPRU_VERSION)
#  define TI_CLPRU_VERSION_CHECK(major,minor,patch) (TI_CLPRU_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TI_CLPRU_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(CRAY_VERSION)
#  undef CRAY_VERSION
#endif
#if defined(_CRAYC)
#  if defined(_RELEASE_PATCHLEVEL)
#    define CRAY_VERSION VERSION_ENCODE(_RELEASE_MAJOR, _RELEASE_MINOR, _RELEASE_PATCHLEVEL)
#  else
#    define CRAY_VERSION VERSION_ENCODE(_RELEASE_MAJOR, _RELEASE_MINOR, 0)
#  endif
#endif

#if defined(CRAY_VERSION_CHECK)
#  undef CRAY_VERSION_CHECK
#endif
#if defined(CRAY_VERSION)
#  define CRAY_VERSION_CHECK(major,minor,patch) (CRAY_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define CRAY_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(IAR_VERSION)
#  undef IAR_VERSION
#endif
#if defined(__IAR_SYSTEMS_ICC__)
#  if __VER__ > 1000
#    define IAR_VERSION VERSION_ENCODE((__VER__ / 1000000), ((__VER__ / 1000) % 1000), (__VER__ % 1000))
#  else
#    define IAR_VERSION VERSION_ENCODE(__VER__ / 100, __VER__ % 100, 0)
#  endif
#endif

#if defined(IAR_VERSION_CHECK)
#  undef IAR_VERSION_CHECK
#endif
#if defined(IAR_VERSION)
#  define IAR_VERSION_CHECK(major,minor,patch) (IAR_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define IAR_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(TINYC_VERSION)
#  undef TINYC_VERSION
#endif
#if defined(__TINYC__)
#  define TINYC_VERSION VERSION_ENCODE(__TINYC__ / 1000, (__TINYC__ / 100) % 10, __TINYC__ % 100)
#endif

#if defined(TINYC_VERSION_CHECK)
#  undef TINYC_VERSION_CHECK
#endif
#if defined(TINYC_VERSION)
#  define TINYC_VERSION_CHECK(major,minor,patch) (TINYC_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define TINYC_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(DMC_VERSION)
#  undef DMC_VERSION
#endif
#if defined(__DMC__)
#  define DMC_VERSION VERSION_ENCODE(__DMC__ >> 8, (__DMC__ >> 4) & 0xf, __DMC__ & 0xf)
#endif

#if defined(DMC_VERSION_CHECK)
#  undef DMC_VERSION_CHECK
#endif
#if defined(DMC_VERSION)
#  define DMC_VERSION_CHECK(major,minor,patch) (DMC_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define DMC_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(COMPCERT_VERSION)
#  undef COMPCERT_VERSION
#endif
#if defined(__COMPCERT_VERSION__)
#  define COMPCERT_VERSION VERSION_ENCODE(__COMPCERT_VERSION__ / 10000, (__COMPCERT_VERSION__ / 100) % 100, __COMPCERT_VERSION__ % 100)
#endif

#if defined(COMPCERT_VERSION_CHECK)
#  undef COMPCERT_VERSION_CHECK
#endif
#if defined(COMPCERT_VERSION)
#  define COMPCERT_VERSION_CHECK(major,minor,patch) (COMPCERT_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define COMPCERT_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(PELLES_VERSION)
#  undef PELLES_VERSION
#endif
#if defined(__POCC__)
#  define PELLES_VERSION VERSION_ENCODE(__POCC__ / 100, __POCC__ % 100, 0)
#endif

#if defined(PELLES_VERSION_CHECK)
#  undef PELLES_VERSION_CHECK
#endif
#if defined(PELLES_VERSION)
#  define PELLES_VERSION_CHECK(major,minor,patch) (PELLES_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define PELLES_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(MCST_LCC_VERSION)
#  undef MCST_LCC_VERSION
#endif
#if defined(__LCC__) && defined(__LCC_MINOR__)
#  define MCST_LCC_VERSION VERSION_ENCODE(__LCC__ / 100, __LCC__ % 100, __LCC_MINOR__)
#endif

#if defined(MCST_LCC_VERSION_CHECK)
#  undef MCST_LCC_VERSION_CHECK
#endif
#if defined(MCST_LCC_VERSION)
#  define MCST_LCC_VERSION_CHECK(major,minor,patch) (MCST_LCC_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define MCST_LCC_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(GCC_VERSION)
#  undef GCC_VERSION
#endif
#if \
  defined(GNUC_VERSION) && \
  !defined(__clang__) && \
  !defined(INTEL_VERSION) && \
  !defined(PGI_VERSION) && \
  !defined(ARM_VERSION) && \
  !defined(CRAY_VERSION) && \
  !defined(TI_VERSION) && \
  !defined(TI_ARMCL_VERSION) && \
  !defined(TI_CL430_VERSION) && \
  !defined(TI_CL2000_VERSION) && \
  !defined(TI_CL6X_VERSION) && \
  !defined(TI_CL7X_VERSION) && \
  !defined(TI_CLPRU_VERSION) && \
  !defined(__COMPCERT__) && \
  !defined(MCST_LCC_VERSION)
#  define GCC_VERSION GNUC_VERSION
#endif

#if defined(GCC_VERSION_CHECK)
#  undef GCC_VERSION_CHECK
#endif
#if defined(GCC_VERSION)
#  define GCC_VERSION_CHECK(major,minor,patch) (GCC_VERSION >= VERSION_ENCODE(major, minor, patch))
#else
#  define GCC_VERSION_CHECK(major,minor,patch) (0)
#endif

#if defined(HAS_ATTRIBUTE)
#  undef HAS_ATTRIBUTE
#endif
#if \
  defined(__has_attribute) && \
  ( \
    (!defined(IAR_VERSION) || IAR_VERSION_CHECK(8,5,9)) \
  )
#  define HAS_ATTRIBUTE(attribute) __has_attribute(attribute)
#else
#  define HAS_ATTRIBUTE(attribute) (0)
#endif

#if defined(GNUC_HAS_ATTRIBUTE)
#  undef GNUC_HAS_ATTRIBUTE
#endif
#if defined(__has_attribute)
#  define GNUC_HAS_ATTRIBUTE(attribute,major,minor,patch) HAS_ATTRIBUTE(attribute)
#else
#  define GNUC_HAS_ATTRIBUTE(attribute,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_ATTRIBUTE)
#  undef GCC_HAS_ATTRIBUTE
#endif
#if defined(__has_attribute)
#  define GCC_HAS_ATTRIBUTE(attribute,major,minor,patch) HAS_ATTRIBUTE(attribute)
#else
#  define GCC_HAS_ATTRIBUTE(attribute,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_CPP_ATTRIBUTE)
#  undef HAS_CPP_ATTRIBUTE
#endif
#if \
  defined(__has_cpp_attribute) && \
  defined(__cplusplus) && \
  (!defined(SUNPRO_VERSION) || SUNPRO_VERSION_CHECK(5,15,0))
#  define HAS_CPP_ATTRIBUTE(attribute) __has_cpp_attribute(attribute)
#else
#  define HAS_CPP_ATTRIBUTE(attribute) (0)
#endif

#if defined(HAS_CPP_ATTRIBUTE_NS)
#  undef HAS_CPP_ATTRIBUTE_NS
#endif
#if !defined(__cplusplus) || !defined(__has_cpp_attribute)
#  define HAS_CPP_ATTRIBUTE_NS(ns,attribute) (0)
#elif \
  !defined(PGI_VERSION) && \
  !defined(IAR_VERSION) && \
  (!defined(SUNPRO_VERSION) || SUNPRO_VERSION_CHECK(5,15,0)) && \
  (!defined(MSVC_VERSION) || MSVC_VERSION_CHECK(19,20,0))
#  define HAS_CPP_ATTRIBUTE_NS(ns,attribute) HAS_CPP_ATTRIBUTE(ns::attribute)
#else
#  define HAS_CPP_ATTRIBUTE_NS(ns,attribute) (0)
#endif

#if defined(GNUC_HAS_CPP_ATTRIBUTE)
#  undef GNUC_HAS_CPP_ATTRIBUTE
#endif
#if defined(__has_cpp_attribute) && defined(__cplusplus)
#  define GNUC_HAS_CPP_ATTRIBUTE(attribute,major,minor,patch) __has_cpp_attribute(attribute)
#else
#  define GNUC_HAS_CPP_ATTRIBUTE(attribute,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_CPP_ATTRIBUTE)
#  undef GCC_HAS_CPP_ATTRIBUTE
#endif
#if defined(__has_cpp_attribute) && defined(__cplusplus)
#  define GCC_HAS_CPP_ATTRIBUTE(attribute,major,minor,patch) __has_cpp_attribute(attribute)
#else
#  define GCC_HAS_CPP_ATTRIBUTE(attribute,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_BUILTIN)
#  undef HAS_BUILTIN
#endif
#if defined(__has_builtin)
#  define HAS_BUILTIN(builtin) __has_builtin(builtin)
#else
#  define HAS_BUILTIN(builtin) (0)
#endif

#if defined(GNUC_HAS_BUILTIN)
#  undef GNUC_HAS_BUILTIN
#endif
#if defined(__has_builtin)
#  define GNUC_HAS_BUILTIN(builtin,major,minor,patch) __has_builtin(builtin)
#else
#  define GNUC_HAS_BUILTIN(builtin,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_BUILTIN)
#  undef GCC_HAS_BUILTIN
#endif
#if defined(__has_builtin)
#  define GCC_HAS_BUILTIN(builtin,major,minor,patch) __has_builtin(builtin)
#else
#  define GCC_HAS_BUILTIN(builtin,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_FEATURE)
#  undef HAS_FEATURE
#endif
#if defined(__has_feature)
#  define HAS_FEATURE(feature) __has_feature(feature)
#else
#  define HAS_FEATURE(feature) (0)
#endif

#if defined(GNUC_HAS_FEATURE)
#  undef GNUC_HAS_FEATURE
#endif
#if defined(__has_feature)
#  define GNUC_HAS_FEATURE(feature,major,minor,patch) __has_feature(feature)
#else
#  define GNUC_HAS_FEATURE(feature,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_FEATURE)
#  undef GCC_HAS_FEATURE
#endif
#if defined(__has_feature)
#  define GCC_HAS_FEATURE(feature,major,minor,patch) __has_feature(feature)
#else
#  define GCC_HAS_FEATURE(feature,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_EXTENSION)
#  undef HAS_EXTENSION
#endif
#if defined(__has_extension)
#  define HAS_EXTENSION(extension) __has_extension(extension)
#else
#  define HAS_EXTENSION(extension) (0)
#endif

#if defined(GNUC_HAS_EXTENSION)
#  undef GNUC_HAS_EXTENSION
#endif
#if defined(__has_extension)
#  define GNUC_HAS_EXTENSION(extension,major,minor,patch) __has_extension(extension)
#else
#  define GNUC_HAS_EXTENSION(extension,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_EXTENSION)
#  undef GCC_HAS_EXTENSION
#endif
#if defined(__has_extension)
#  define GCC_HAS_EXTENSION(extension,major,minor,patch) __has_extension(extension)
#else
#  define GCC_HAS_EXTENSION(extension,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_DECLSPEC_ATTRIBUTE)
#  undef HAS_DECLSPEC_ATTRIBUTE
#endif
#if defined(__has_declspec_attribute)
#  define HAS_DECLSPEC_ATTRIBUTE(attribute) __has_declspec_attribute(attribute)
#else
#  define HAS_DECLSPEC_ATTRIBUTE(attribute) (0)
#endif

#if defined(GNUC_HAS_DECLSPEC_ATTRIBUTE)
#  undef GNUC_HAS_DECLSPEC_ATTRIBUTE
#endif
#if defined(__has_declspec_attribute)
#  define GNUC_HAS_DECLSPEC_ATTRIBUTE(attribute,major,minor,patch) __has_declspec_attribute(attribute)
#else
#  define GNUC_HAS_DECLSPEC_ATTRIBUTE(attribute,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_DECLSPEC_ATTRIBUTE)
#  undef GCC_HAS_DECLSPEC_ATTRIBUTE
#endif
#if defined(__has_declspec_attribute)
#  define GCC_HAS_DECLSPEC_ATTRIBUTE(attribute,major,minor,patch) __has_declspec_attribute(attribute)
#else
#  define GCC_HAS_DECLSPEC_ATTRIBUTE(attribute,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(HAS_WARNING)
#  undef HAS_WARNING
#endif
#if defined(__has_warning)
#  define HAS_WARNING(warning) __has_warning(warning)
#else
#  define HAS_WARNING(warning) (0)
#endif

#if defined(GNUC_HAS_WARNING)
#  undef GNUC_HAS_WARNING
#endif
#if defined(__has_warning)
#  define GNUC_HAS_WARNING(warning,major,minor,patch) __has_warning(warning)
#else
#  define GNUC_HAS_WARNING(warning,major,minor,patch) GNUC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(GCC_HAS_WARNING)
#  undef GCC_HAS_WARNING
#endif
#if defined(__has_warning)
#  define GCC_HAS_WARNING(warning,major,minor,patch) __has_warning(warning)
#else
#  define GCC_HAS_WARNING(warning,major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if \
  (defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)) || \
  defined(__clang__) || \
  GCC_VERSION_CHECK(3,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  IAR_VERSION_CHECK(8,0,0) || \
  PGI_VERSION_CHECK(18,4,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  TI_ARMCL_VERSION_CHECK(4,7,0) || \
  TI_CL430_VERSION_CHECK(2,0,1) || \
  TI_CL2000_VERSION_CHECK(6,1,0) || \
  TI_CL6X_VERSION_CHECK(7,0,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  CRAY_VERSION_CHECK(5,0,0) || \
  TINYC_VERSION_CHECK(0,9,17) || \
  SUNPRO_VERSION_CHECK(8,0,0) || \
  (IBM_VERSION_CHECK(10,1,0) && defined(__C99_PRAGMA_OPERATOR))
#  define PRAGMA(value) _Pragma(#value)
#elif MSVC_VERSION_CHECK(15,0,0)
#  define PRAGMA(value) __pragma(value)
#else
#  define PRAGMA(value)
#endif

#if defined(DIAGNOSTIC_PUSH)
#  undef DIAGNOSTIC_PUSH
#endif
#if defined(DIAGNOSTIC_POP)
#  undef DIAGNOSTIC_POP
#endif
#if defined(__clang__)
#  define DIAGNOSTIC_PUSH _Pragma("clang diagnostic push")
#  define DIAGNOSTIC_POP _Pragma("clang diagnostic pop")
#elif INTEL_VERSION_CHECK(13,0,0)
#  define DIAGNOSTIC_PUSH _Pragma("warning(push)")
#  define DIAGNOSTIC_POP _Pragma("warning(pop)")
#elif GCC_VERSION_CHECK(4,6,0)
#  define DIAGNOSTIC_PUSH _Pragma("GCC diagnostic push")
#  define DIAGNOSTIC_POP _Pragma("GCC diagnostic pop")
#elif \
  MSVC_VERSION_CHECK(15,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DIAGNOSTIC_PUSH __pragma(warning(push))
#  define DIAGNOSTIC_POP __pragma(warning(pop))
#elif ARM_VERSION_CHECK(5,6,0)
#  define DIAGNOSTIC_PUSH _Pragma("push")
#  define DIAGNOSTIC_POP _Pragma("pop")
#elif \
    TI_VERSION_CHECK(15,12,0) || \
    TI_ARMCL_VERSION_CHECK(5,2,0) || \
    TI_CL430_VERSION_CHECK(4,4,0) || \
    TI_CL6X_VERSION_CHECK(8,1,0) || \
    TI_CL7X_VERSION_CHECK(1,2,0) || \
    TI_CLPRU_VERSION_CHECK(2,1,0)
#  define DIAGNOSTIC_PUSH _Pragma("diag_push")
#  define DIAGNOSTIC_POP _Pragma("diag_pop")
#elif PELLES_VERSION_CHECK(2,90,0)
#  define DIAGNOSTIC_PUSH _Pragma("warning(push)")
#  define DIAGNOSTIC_POP _Pragma("warning(pop)")
#else
#  define DIAGNOSTIC_PUSH
#  define DIAGNOSTIC_POP
#endif

/* DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_ is for
   HEDLEY INTERNAL USE ONLY.  API subject to change without notice. */
#if defined(DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_)
#  undef DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_
#endif
#if defined(__cplusplus)
#  if HAS_WARNING("-Wc++98-compat")
#    if HAS_WARNING("-Wc++17-extensions")
#      if HAS_WARNING("-Wc++1z-extensions")
#        define DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(xpr) \
           DIAGNOSTIC_PUSH \
           _Pragma("clang diagnostic ignored \"-Wc++98-compat\"") \
           _Pragma("clang diagnostic ignored \"-Wc++17-extensions\"") \
           _Pragma("clang diagnostic ignored \"-Wc++1z-extensions\"") \
           xpr \
           DIAGNOSTIC_POP
#      else
#        define DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(xpr) \
           DIAGNOSTIC_PUSH \
           _Pragma("clang diagnostic ignored \"-Wc++98-compat\"") \
           _Pragma("clang diagnostic ignored \"-Wc++17-extensions\"") \
           xpr \
           DIAGNOSTIC_POP
#      endif
#    else
#      define DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(xpr) \
         DIAGNOSTIC_PUSH \
         _Pragma("clang diagnostic ignored \"-Wc++98-compat\"") \
         xpr \
         DIAGNOSTIC_POP
#    endif
#  endif
#endif
#if !defined(DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_)
#  define DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(x) x
#endif

#if defined(CONST_CAST)
#  undef CONST_CAST
#endif
#if defined(__cplusplus)
#  define CONST_CAST(T, expr) (const_cast<T>(expr))
#elif \
  HAS_WARNING("-Wcast-qual") || \
  GCC_VERSION_CHECK(4,6,0) || \
  INTEL_VERSION_CHECK(13,0,0)
#  define CONST_CAST(T, expr) (__extension__ ({ \
      DIAGNOSTIC_PUSH \
      DIAGNOSTIC_DISABLE_CAST_QUAL \
      ((T) (expr)); \
      DIAGNOSTIC_POP \
    }))
#else
#  define CONST_CAST(T, expr) ((T) (expr))
#endif

#if defined(REINTERPRET_CAST)
#  undef REINTERPRET_CAST
#endif
#if defined(__cplusplus)
#  define REINTERPRET_CAST(T, expr) (reinterpret_cast<T>(expr))
#else
#  define REINTERPRET_CAST(T, expr) ((T) (expr))
#endif

#if defined(STATIC_CAST)
#  undef STATIC_CAST
#endif
#if defined(__cplusplus)
#  define STATIC_CAST(T, expr) (static_cast<T>(expr))
#else
#  define STATIC_CAST(T, expr) ((T) (expr))
#endif

#if defined(CPP_CAST)
#  undef CPP_CAST
#endif
#if defined(__cplusplus)
#  if HAS_WARNING("-Wold-style-cast")
#    define CPP_CAST(T, expr) \
       DIAGNOSTIC_PUSH \
       _Pragma("clang diagnostic ignored \"-Wold-style-cast\"") \
       ((T) (expr)) \
       DIAGNOSTIC_POP
#  elif IAR_VERSION_CHECK(8,3,0)
#    define CPP_CAST(T, expr) \
       DIAGNOSTIC_PUSH \
       _Pragma("diag_suppress=Pe137") \
       DIAGNOSTIC_POP
#  else
#    define CPP_CAST(T, expr) ((T) (expr))
#  endif
#else
#  define CPP_CAST(T, expr) (expr)
#endif

#if defined(DIAGNOSTIC_DISABLE_DEPRECATED)
#  undef DIAGNOSTIC_DISABLE_DEPRECATED
#endif
#if HAS_WARNING("-Wdeprecated-declarations")
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#elif INTEL_VERSION_CHECK(13,0,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("warning(disable:1478 1786)")
#elif INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED __pragma(warning(disable:1478 1786))
#elif PGI_VERSION_CHECK(20,7,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("diag_suppress 1215,1216,1444,1445")
#elif PGI_VERSION_CHECK(17,10,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("diag_suppress 1215,1444")
#elif GCC_VERSION_CHECK(4,3,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("GCC diagnostic ignored \"-Wdeprecated-declarations\"")
#elif MSVC_VERSION_CHECK(15,0,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED __pragma(warning(disable:4996))
#elif MCST_LCC_VERSION_CHECK(1,25,10)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("diag_suppress 1215,1444")
#elif \
    TI_VERSION_CHECK(15,12,0) || \
    (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
    TI_ARMCL_VERSION_CHECK(5,2,0) || \
    (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
    TI_CL2000_VERSION_CHECK(6,4,0) || \
    (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
    TI_CL430_VERSION_CHECK(4,3,0) || \
    (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
    TI_CL6X_VERSION_CHECK(7,5,0) || \
    TI_CL7X_VERSION_CHECK(1,2,0) || \
    TI_CLPRU_VERSION_CHECK(2,1,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("diag_suppress 1291,1718")
#elif SUNPRO_VERSION_CHECK(5,13,0) && !defined(__cplusplus)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("error_messages(off,E_DEPRECATED_ATT,E_DEPRECATED_ATT_MESS)")
#elif SUNPRO_VERSION_CHECK(5,13,0) && defined(__cplusplus)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("error_messages(off,symdeprecated,symdeprecated2)")
#elif IAR_VERSION_CHECK(8,0,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("diag_suppress=Pe1444,Pe1215")
#elif PELLES_VERSION_CHECK(2,90,0)
#  define DIAGNOSTIC_DISABLE_DEPRECATED _Pragma("warn(disable:2241)")
#else
#  define DIAGNOSTIC_DISABLE_DEPRECATED
#endif

#if defined(DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS)
#  undef DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS
#endif
#if HAS_WARNING("-Wunknown-pragmas")
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("clang diagnostic ignored \"-Wunknown-pragmas\"")
#elif INTEL_VERSION_CHECK(13,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("warning(disable:161)")
#elif INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS __pragma(warning(disable:161))
#elif PGI_VERSION_CHECK(17,10,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("diag_suppress 1675")
#elif GCC_VERSION_CHECK(4,3,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("GCC diagnostic ignored \"-Wunknown-pragmas\"")
#elif MSVC_VERSION_CHECK(15,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS __pragma(warning(disable:4068))
#elif \
    TI_VERSION_CHECK(16,9,0) || \
    TI_CL6X_VERSION_CHECK(8,0,0) || \
    TI_CL7X_VERSION_CHECK(1,2,0) || \
    TI_CLPRU_VERSION_CHECK(2,3,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("diag_suppress 163")
#elif TI_CL6X_VERSION_CHECK(8,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("diag_suppress 163")
#elif IAR_VERSION_CHECK(8,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("diag_suppress=Pe161")
#elif MCST_LCC_VERSION_CHECK(1,25,10)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS _Pragma("diag_suppress 161")
#else
#  define DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS
#endif

#if defined(DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES)
#  undef DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES
#endif
#if HAS_WARNING("-Wunknown-attributes")
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("clang diagnostic ignored \"-Wunknown-attributes\"")
#elif GCC_VERSION_CHECK(4,6,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("GCC diagnostic ignored \"-Wdeprecated-declarations\"")
#elif INTEL_VERSION_CHECK(17,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("warning(disable:1292)")
#elif INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES __pragma(warning(disable:1292))
#elif MSVC_VERSION_CHECK(19,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES __pragma(warning(disable:5030))
#elif PGI_VERSION_CHECK(20,7,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("diag_suppress 1097,1098")
#elif PGI_VERSION_CHECK(17,10,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("diag_suppress 1097")
#elif SUNPRO_VERSION_CHECK(5,14,0) && defined(__cplusplus)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("error_messages(off,attrskipunsup)")
#elif \
    TI_VERSION_CHECK(18,1,0) || \
    TI_CL6X_VERSION_CHECK(8,3,0) || \
    TI_CL7X_VERSION_CHECK(1,2,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("diag_suppress 1173")
#elif IAR_VERSION_CHECK(8,0,0)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("diag_suppress=Pe1097")
#elif MCST_LCC_VERSION_CHECK(1,25,10)
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES _Pragma("diag_suppress 1097")
#else
#  define DIAGNOSTIC_DISABLE_UNKNOWN_CPP_ATTRIBUTES
#endif

#if defined(DIAGNOSTIC_DISABLE_CAST_QUAL)
#  undef DIAGNOSTIC_DISABLE_CAST_QUAL
#endif
#if HAS_WARNING("-Wcast-qual")
#  define DIAGNOSTIC_DISABLE_CAST_QUAL _Pragma("clang diagnostic ignored \"-Wcast-qual\"")
#elif INTEL_VERSION_CHECK(13,0,0)
#  define DIAGNOSTIC_DISABLE_CAST_QUAL _Pragma("warning(disable:2203 2331)")
#elif GCC_VERSION_CHECK(3,0,0)
#  define DIAGNOSTIC_DISABLE_CAST_QUAL _Pragma("GCC diagnostic ignored \"-Wcast-qual\"")
#else
#  define DIAGNOSTIC_DISABLE_CAST_QUAL
#endif

#if defined(DIAGNOSTIC_DISABLE_UNUSED_FUNCTION)
#  undef DIAGNOSTIC_DISABLE_UNUSED_FUNCTION
#endif
#if HAS_WARNING("-Wunused-function")
#  define DIAGNOSTIC_DISABLE_UNUSED_FUNCTION _Pragma("clang diagnostic ignored \"-Wunused-function\"")
#elif GCC_VERSION_CHECK(3,4,0)
#  define DIAGNOSTIC_DISABLE_UNUSED_FUNCTION _Pragma("GCC diagnostic ignored \"-Wunused-function\"")
#elif MSVC_VERSION_CHECK(1,0,0)
#  define DIAGNOSTIC_DISABLE_UNUSED_FUNCTION __pragma(warning(disable:4505))
#elif MCST_LCC_VERSION_CHECK(1,25,10)
#  define DIAGNOSTIC_DISABLE_UNUSED_FUNCTION _Pragma("diag_suppress 3142")
#else
#  define DIAGNOSTIC_DISABLE_UNUSED_FUNCTION
#endif

#if defined(DEPRECATED)
#  undef DEPRECATED
#endif
#if defined(DEPRECATED_FOR)
#  undef DEPRECATED_FOR
#endif
#if \
  MSVC_VERSION_CHECK(14,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DEPRECATED(since) __declspec(deprecated("Since " # since))
#  define DEPRECATED_FOR(since, replacement) __declspec(deprecated("Since " #since "; use " #replacement))
#elif \
  (HAS_EXTENSION(attribute_deprecated_with_message) && !defined(IAR_VERSION)) || \
  GCC_VERSION_CHECK(4,5,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  ARM_VERSION_CHECK(5,6,0) || \
  SUNPRO_VERSION_CHECK(5,13,0) || \
  PGI_VERSION_CHECK(17,10,0) || \
  TI_VERSION_CHECK(18,1,0) || \
  TI_ARMCL_VERSION_CHECK(18,1,0) || \
  TI_CL6X_VERSION_CHECK(8,3,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,3,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define DEPRECATED(since) __attribute__((__deprecated__("Since " #since)))
#  define DEPRECATED_FOR(since, replacement) __attribute__((__deprecated__("Since " #since "; use " #replacement)))
#elif defined(__cplusplus) && (__cplusplus >= 201402L)
#  define DEPRECATED(since) DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[deprecated("Since " #since)]])
#  define DEPRECATED_FOR(since, replacement) DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[deprecated("Since " #since "; use " #replacement)]])
#elif \
  HAS_ATTRIBUTE(deprecated) || \
  GCC_VERSION_CHECK(3,1,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10) || \
  IAR_VERSION_CHECK(8,10,0)
#  define DEPRECATED(since) __attribute__((__deprecated__))
#  define DEPRECATED_FOR(since, replacement) __attribute__((__deprecated__))
#elif \
  MSVC_VERSION_CHECK(13,10,0) || \
  PELLES_VERSION_CHECK(6,50,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define DEPRECATED(since) __declspec(deprecated)
#  define DEPRECATED_FOR(since, replacement) __declspec(deprecated)
#elif IAR_VERSION_CHECK(8,0,0)
#  define DEPRECATED(since) _Pragma("deprecated")
#  define DEPRECATED_FOR(since, replacement) _Pragma("deprecated")
#else
#  define DEPRECATED(since)
#  define DEPRECATED_FOR(since, replacement)
#endif

#if defined(UNAVAILABLE)
#  undef UNAVAILABLE
#endif
#if \
  HAS_ATTRIBUTE(warning) || \
  GCC_VERSION_CHECK(4,3,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define UNAVAILABLE(available_since) __attribute__((__warning__("Not available until " #available_since)))
#else
#  define UNAVAILABLE(available_since)
#endif

#if defined(WARN_UNUSED_RESULT)
#  undef WARN_UNUSED_RESULT
#endif
#if defined(WARN_UNUSED_RESULT_MSG)
#  undef WARN_UNUSED_RESULT_MSG
#endif
#if \
  HAS_ATTRIBUTE(warn_unused_result) || \
  GCC_VERSION_CHECK(3,4,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  (SUNPRO_VERSION_CHECK(5,15,0) && defined(__cplusplus)) || \
  PGI_VERSION_CHECK(17,10,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define WARN_UNUSED_RESULT __attribute__((__warn_unused_result__))
#  define WARN_UNUSED_RESULT_MSG(msg) __attribute__((__warn_unused_result__))
#elif (HAS_CPP_ATTRIBUTE(nodiscard) >= 201907L)
#  define WARN_UNUSED_RESULT DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[nodiscard]])
#  define WARN_UNUSED_RESULT_MSG(msg) DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[nodiscard(msg)]])
#elif HAS_CPP_ATTRIBUTE(nodiscard)
#  define WARN_UNUSED_RESULT DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[nodiscard]])
#  define WARN_UNUSED_RESULT_MSG(msg) DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[nodiscard]])
#elif defined(_Check_return_) /* SAL */
#  define WARN_UNUSED_RESULT _Check_return_
#  define WARN_UNUSED_RESULT_MSG(msg) _Check_return_
#else
#  define WARN_UNUSED_RESULT
#  define WARN_UNUSED_RESULT_MSG(msg)
#endif

#if defined(SENTINEL)
#  undef SENTINEL
#endif
#if \
  HAS_ATTRIBUTE(sentinel) || \
  GCC_VERSION_CHECK(4,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  ARM_VERSION_CHECK(5,4,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define SENTINEL(position) __attribute__((__sentinel__(position)))
#else
#  define SENTINEL(position)
#endif

#if defined(NO_RETURN)
#  undef NO_RETURN
#endif
#if IAR_VERSION_CHECK(8,0,0)
#  define NO_RETURN __noreturn
#elif \
  INTEL_VERSION_CHECK(13,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define NO_RETURN __attribute__((__noreturn__))
#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#  define NO_RETURN _Noreturn
#elif defined(__cplusplus) && (__cplusplus >= 201103L)
#  define NO_RETURN DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[noreturn]])
#elif \
  HAS_ATTRIBUTE(noreturn) || \
  GCC_VERSION_CHECK(3,2,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  IAR_VERSION_CHECK(8,10,0)
#  define NO_RETURN __attribute__((__noreturn__))
#elif SUNPRO_VERSION_CHECK(5,10,0)
#  define NO_RETURN _Pragma("does_not_return")
#elif \
  MSVC_VERSION_CHECK(13,10,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define NO_RETURN __declspec(noreturn)
#elif TI_CL6X_VERSION_CHECK(6,0,0) && defined(__cplusplus)
#  define NO_RETURN _Pragma("FUNC_NEVER_RETURNS;")
#elif COMPCERT_VERSION_CHECK(3,2,0)
#  define NO_RETURN __attribute((noreturn))
#elif PELLES_VERSION_CHECK(9,0,0)
#  define NO_RETURN __declspec(noreturn)
#else
#  define NO_RETURN
#endif

#if defined(NO_ESCAPE)
#  undef NO_ESCAPE
#endif
#if HAS_ATTRIBUTE(noescape)
#  define NO_ESCAPE __attribute__((__noescape__))
#else
#  define NO_ESCAPE
#endif

#if defined(UNREACHABLE)
#  undef UNREACHABLE
#endif
#if defined(UNREACHABLE_RETURN)
#  undef UNREACHABLE_RETURN
#endif
#if defined(ASSUME)
#  undef ASSUME
#endif
#if \
  MSVC_VERSION_CHECK(13,10,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define ASSUME(expr) __assume(expr)
#elif HAS_BUILTIN(__builtin_assume)
#  define ASSUME(expr) __builtin_assume(expr)
#elif \
    TI_CL2000_VERSION_CHECK(6,2,0) || \
    TI_CL6X_VERSION_CHECK(4,0,0)
#  if defined(__cplusplus)
#    define ASSUME(expr) std::_nassert(expr)
#  else
#    define ASSUME(expr) _nassert(expr)
#  endif
#endif
#if \
  (HAS_BUILTIN(__builtin_unreachable) && (!defined(ARM_VERSION))) || \
  GCC_VERSION_CHECK(4,5,0) || \
  PGI_VERSION_CHECK(18,10,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  IBM_VERSION_CHECK(13,1,5) || \
  CRAY_VERSION_CHECK(10,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define UNREACHABLE() __builtin_unreachable()
#elif defined(ASSUME)
#  define UNREACHABLE() ASSUME(0)
#endif
#if !defined(ASSUME)
#  if defined(UNREACHABLE)
#    define ASSUME(expr) STATIC_CAST(void, ((expr) ? 1 : (UNREACHABLE(), 1)))
#  else
#    define ASSUME(expr) STATIC_CAST(void, expr)
#  endif
#endif
#if defined(UNREACHABLE)
#  if  \
      TI_CL2000_VERSION_CHECK(6,2,0) || \
      TI_CL6X_VERSION_CHECK(4,0,0)
#    define UNREACHABLE_RETURN(value) return (STATIC_CAST(void, ASSUME(0)), (value))
#  else
#    define UNREACHABLE_RETURN(value) UNREACHABLE()
#  endif
#else
#  define UNREACHABLE_RETURN(value) return (value)
#endif
#if !defined(UNREACHABLE)
#  define UNREACHABLE() ASSUME(0)
#endif

DIAGNOSTIC_PUSH
#if HAS_WARNING("-Wpedantic")
#  pragma clang diagnostic ignored "-Wpedantic"
#endif
#if HAS_WARNING("-Wc++98-compat-pedantic") && defined(__cplusplus)
#  pragma clang diagnostic ignored "-Wc++98-compat-pedantic"
#endif
#if GCC_HAS_WARNING("-Wvariadic-macros",4,0,0)
#  if defined(__clang__)
#    pragma clang diagnostic ignored "-Wvariadic-macros"
#  elif defined(GCC_VERSION)
#    pragma GCC diagnostic ignored "-Wvariadic-macros"
#  endif
#endif
#if defined(NON_NULL)
#  undef NON_NULL
#endif
#if \
  HAS_ATTRIBUTE(nonnull) || \
  GCC_VERSION_CHECK(3,3,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  ARM_VERSION_CHECK(4,1,0)
#  define NON_NULL(...) __attribute__((__nonnull__(__VA_ARGS__)))
#else
#  define NON_NULL(...)
#endif
DIAGNOSTIC_POP

#if defined(PRINTF_FORMAT)
#  undef PRINTF_FORMAT
#endif
#if defined(__MINGW32__) && GCC_HAS_ATTRIBUTE(format,4,4,0) && !defined(__USE_MINGW_ANSI_STDIO)
#  define PRINTF_FORMAT(string_idx,first_to_check) __attribute__((__format__(ms_printf, string_idx, first_to_check)))
#elif defined(__MINGW32__) && GCC_HAS_ATTRIBUTE(format,4,4,0) && defined(__USE_MINGW_ANSI_STDIO)
#  define PRINTF_FORMAT(string_idx,first_to_check) __attribute__((__format__(gnu_printf, string_idx, first_to_check)))
#elif \
  HAS_ATTRIBUTE(format) || \
  GCC_VERSION_CHECK(3,1,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  ARM_VERSION_CHECK(5,6,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define PRINTF_FORMAT(string_idx,first_to_check) __attribute__((__format__(__printf__, string_idx, first_to_check)))
#elif PELLES_VERSION_CHECK(6,0,0)
#  define PRINTF_FORMAT(string_idx,first_to_check) __declspec(vaformat(printf,string_idx,first_to_check))
#else
#  define PRINTF_FORMAT(string_idx,first_to_check)
#endif

#if defined(CONSTEXPR)
#  undef CONSTEXPR
#endif
#if defined(__cplusplus)
#  if __cplusplus >= 201103L
#    define CONSTEXPR DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(constexpr)
#  endif
#endif
#if !defined(CONSTEXPR)
#  define CONSTEXPR
#endif

#if defined(PREDICT)
#  undef PREDICT
#endif
#if defined(LIKELY)
#  undef LIKELY
#endif
#if defined(UNLIKELY)
#  undef UNLIKELY
#endif
#if defined(UNPREDICTABLE)
#  undef UNPREDICTABLE
#endif
#if HAS_BUILTIN(__builtin_unpredictable)
#  define UNPREDICTABLE(expr) __builtin_unpredictable((expr))
#endif
#if \
  (HAS_BUILTIN(__builtin_expect_with_probability) && !defined(PGI_VERSION)) || \
  GCC_VERSION_CHECK(9,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define PREDICT(expr, value, probability) __builtin_expect_with_probability(  (expr), (value), (probability))
#  define PREDICT_TRUE(expr, probability)   __builtin_expect_with_probability(!!(expr),    1   , (probability))
#  define PREDICT_FALSE(expr, probability)  __builtin_expect_with_probability(!!(expr),    0   , (probability))
#  define LIKELY(expr)                      __builtin_expect                 (!!(expr),    1                  )
#  define UNLIKELY(expr)                    __builtin_expect                 (!!(expr),    0                  )
#elif \
  (HAS_BUILTIN(__builtin_expect) && !defined(INTEL_CL_VERSION)) || \
  GCC_VERSION_CHECK(3,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  (SUNPRO_VERSION_CHECK(5,15,0) && defined(__cplusplus)) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  TI_ARMCL_VERSION_CHECK(4,7,0) || \
  TI_CL430_VERSION_CHECK(3,1,0) || \
  TI_CL2000_VERSION_CHECK(6,1,0) || \
  TI_CL6X_VERSION_CHECK(6,1,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  TINYC_VERSION_CHECK(0,9,27) || \
  CRAY_VERSION_CHECK(8,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define PREDICT(expr, expected, probability) \
     (((probability) >= 0.9) ? __builtin_expect((expr), (expected)) : (STATIC_CAST(void, expected), (expr)))
#  define PREDICT_TRUE(expr, probability) \
     (__extension__ ({ \
       double hedley_probability_ = (probability); \
       ((hedley_probability_ >= 0.9) ? __builtin_expect(!!(expr), 1) : ((hedley_probability_ <= 0.1) ? __builtin_expect(!!(expr), 0) : !!(expr))); \
     }))
#  define PREDICT_FALSE(expr, probability) \
     (__extension__ ({ \
       double hedley_probability_ = (probability); \
       ((hedley_probability_ >= 0.9) ? __builtin_expect(!!(expr), 0) : ((hedley_probability_ <= 0.1) ? __builtin_expect(!!(expr), 1) : !!(expr))); \
     }))
#  define LIKELY(expr)   __builtin_expect(!!(expr), 1)
#  define UNLIKELY(expr) __builtin_expect(!!(expr), 0)
#else
#  define PREDICT(expr, expected, probability) (STATIC_CAST(void, expected), (expr))
#  define PREDICT_TRUE(expr, probability) (!!(expr))
#  define PREDICT_FALSE(expr, probability) (!!(expr))
#  define LIKELY(expr) (!!(expr))
#  define UNLIKELY(expr) (!!(expr))
#endif
#if !defined(UNPREDICTABLE)
#  define UNPREDICTABLE(expr) PREDICT(expr, 1, 0.5)
#endif

#if defined(MALLOC)
#  undef MALLOC
#endif
#if \
  HAS_ATTRIBUTE(malloc) || \
  GCC_VERSION_CHECK(3,1,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(12,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define MALLOC __attribute__((__malloc__))
#elif SUNPRO_VERSION_CHECK(5,10,0)
#  define MALLOC _Pragma("returns_new_memory")
#elif \
  MSVC_VERSION_CHECK(14,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define MALLOC __declspec(restrict)
#else
#  define MALLOC
#endif

#if defined(PURE)
#  undef PURE
#endif
#if \
  HAS_ATTRIBUTE(pure) || \
  GCC_VERSION_CHECK(2,96,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  PGI_VERSION_CHECK(17,10,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define PURE __attribute__((__pure__))
#elif SUNPRO_VERSION_CHECK(5,10,0)
#  define PURE _Pragma("does_not_write_global_data")
#elif defined(__cplusplus) && \
    ( \
      TI_CL430_VERSION_CHECK(2,0,1) || \
      TI_CL6X_VERSION_CHECK(4,0,0) || \
      TI_CL7X_VERSION_CHECK(1,2,0) \
    )
#  define PURE _Pragma("FUNC_IS_PURE;")
#else
#  define PURE
#endif

#if defined(CONST)
#  undef CONST
#endif
#if \
  HAS_ATTRIBUTE(const) || \
  GCC_VERSION_CHECK(2,5,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  PGI_VERSION_CHECK(17,10,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define CONST __attribute__((__const__))
#elif \
  SUNPRO_VERSION_CHECK(5,10,0)
#  define CONST _Pragma("no_side_effect")
#else
#  define CONST PURE
#endif

#if defined(RESTRICT)
#  undef RESTRICT
#endif
#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) && !defined(__cplusplus)
#  define RESTRICT restrict
#elif \
  GCC_VERSION_CHECK(3,1,0) || \
  MSVC_VERSION_CHECK(14,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  PGI_VERSION_CHECK(17,10,0) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  TI_CL2000_VERSION_CHECK(6,2,4) || \
  TI_CL6X_VERSION_CHECK(8,1,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  (SUNPRO_VERSION_CHECK(5,14,0) && defined(__cplusplus)) || \
  IAR_VERSION_CHECK(8,0,0) || \
  defined(__clang__) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define RESTRICT __restrict
#elif SUNPRO_VERSION_CHECK(5,3,0) && !defined(__cplusplus)
#  define RESTRICT _Restrict
#else
#  define RESTRICT
#endif

#if defined(INLINE)
#  undef INLINE
#endif
#if \
  (defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)) || \
  (defined(__cplusplus) && (__cplusplus >= 199711L))
#  define INLINE inline
#elif \
  defined(GCC_VERSION) || \
  ARM_VERSION_CHECK(6,2,0)
#  define INLINE __inline__
#elif \
  MSVC_VERSION_CHECK(12,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  TI_ARMCL_VERSION_CHECK(5,1,0) || \
  TI_CL430_VERSION_CHECK(3,1,0) || \
  TI_CL2000_VERSION_CHECK(6,2,0) || \
  TI_CL6X_VERSION_CHECK(8,0,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define INLINE __inline
#else
#  define INLINE
#endif

#if defined(ALWAYS_INLINE)
#  undef ALWAYS_INLINE
#endif
#if \
  HAS_ATTRIBUTE(always_inline) || \
  GCC_VERSION_CHECK(4,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10) || \
  IAR_VERSION_CHECK(8,10,0)
#  define ALWAYS_INLINE __attribute__((__always_inline__)) INLINE
#elif \
  MSVC_VERSION_CHECK(12,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define ALWAYS_INLINE __forceinline
#elif defined(__cplusplus) && \
    ( \
      TI_ARMCL_VERSION_CHECK(5,2,0) || \
      TI_CL430_VERSION_CHECK(4,3,0) || \
      TI_CL2000_VERSION_CHECK(6,4,0) || \
      TI_CL6X_VERSION_CHECK(6,1,0) || \
      TI_CL7X_VERSION_CHECK(1,2,0) || \
      TI_CLPRU_VERSION_CHECK(2,1,0) \
    )
#  define ALWAYS_INLINE _Pragma("FUNC_ALWAYS_INLINE;")
#elif IAR_VERSION_CHECK(8,0,0)
#  define ALWAYS_INLINE _Pragma("inline=forced")
#else
#  define ALWAYS_INLINE INLINE
#endif

#if defined(NEVER_INLINE)
#  undef NEVER_INLINE
#endif
#if \
  HAS_ATTRIBUTE(noinline) || \
  GCC_VERSION_CHECK(4,0,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  SUNPRO_VERSION_CHECK(5,11,0) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(10,1,0) || \
  TI_VERSION_CHECK(15,12,0) || \
  (TI_ARMCL_VERSION_CHECK(4,8,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_ARMCL_VERSION_CHECK(5,2,0) || \
  (TI_CL2000_VERSION_CHECK(6,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL2000_VERSION_CHECK(6,4,0) || \
  (TI_CL430_VERSION_CHECK(4,0,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL430_VERSION_CHECK(4,3,0) || \
  (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
  TI_CL6X_VERSION_CHECK(7,5,0) || \
  TI_CL7X_VERSION_CHECK(1,2,0) || \
  TI_CLPRU_VERSION_CHECK(2,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10) || \
  IAR_VERSION_CHECK(8,10,0)
#  define NEVER_INLINE __attribute__((__noinline__))
#elif \
  MSVC_VERSION_CHECK(13,10,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define NEVER_INLINE __declspec(noinline)
#elif PGI_VERSION_CHECK(10,2,0)
#  define NEVER_INLINE _Pragma("noinline")
#elif TI_CL6X_VERSION_CHECK(6,0,0) && defined(__cplusplus)
#  define NEVER_INLINE _Pragma("FUNC_CANNOT_INLINE;")
#elif IAR_VERSION_CHECK(8,0,0)
#  define NEVER_INLINE _Pragma("inline=never")
#elif COMPCERT_VERSION_CHECK(3,2,0)
#  define NEVER_INLINE __attribute((noinline))
#elif PELLES_VERSION_CHECK(9,0,0)
#  define NEVER_INLINE __declspec(noinline)
#else
#  define NEVER_INLINE
#endif

#if defined(PRIVATE)
#  undef PRIVATE
#endif
#if defined(PUBLIC)
#  undef PUBLIC
#endif
#if defined(IMPORT)
#  undef IMPORT
#endif
#if defined(_WIN32) || defined(__CYGWIN__)
#  define PRIVATE
#  define PUBLIC   __declspec(dllexport)
#  define IMPORT   __declspec(dllimport)
#else
#  if \
    HAS_ATTRIBUTE(visibility) || \
    GCC_VERSION_CHECK(3,3,0) || \
    SUNPRO_VERSION_CHECK(5,11,0) || \
    INTEL_VERSION_CHECK(13,0,0) || \
    ARM_VERSION_CHECK(4,1,0) || \
    IBM_VERSION_CHECK(13,1,0) || \
    ( \
      defined(__TI_EABI__) && \
      ( \
        (TI_CL6X_VERSION_CHECK(7,2,0) && defined(__TI_GNU_ATTRIBUTE_SUPPORT__)) || \
        TI_CL6X_VERSION_CHECK(7,5,0) \
      ) \
    ) || \
    MCST_LCC_VERSION_CHECK(1,25,10)
#    define PRIVATE __attribute__((__visibility__("hidden")))
#    define PUBLIC  __attribute__((__visibility__("default")))
#  else
#    define PRIVATE
#    define PUBLIC
#  endif
#  define IMPORT    extern
#endif

#if defined(NO_THROW)
#  undef NO_THROW
#endif
#if \
  HAS_ATTRIBUTE(nothrow) || \
  GCC_VERSION_CHECK(3,3,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define NO_THROW __attribute__((__nothrow__))
#elif \
  MSVC_VERSION_CHECK(13,1,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0) || \
  ARM_VERSION_CHECK(4,1,0)
#  define NO_THROW __declspec(nothrow)
#else
#  define NO_THROW
#endif

#if defined(FALL_THROUGH)
# undef FALL_THROUGH
#endif
#if \
  HAS_ATTRIBUTE(fallthrough) || \
  GCC_VERSION_CHECK(7,0,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define FALL_THROUGH __attribute__((__fallthrough__))
#elif HAS_CPP_ATTRIBUTE_NS(clang,fallthrough)
#  define FALL_THROUGH DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[clang::fallthrough]])
#elif HAS_CPP_ATTRIBUTE(fallthrough)
#  define FALL_THROUGH DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_([[fallthrough]])
#elif defined(__fallthrough) /* SAL */
#  define FALL_THROUGH __fallthrough
#else
#  define FALL_THROUGH
#endif

#if defined(RETURNS_NON_NULL)
#  undef RETURNS_NON_NULL
#endif
#if \
  HAS_ATTRIBUTE(returns_nonnull) || \
  GCC_VERSION_CHECK(4,9,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define RETURNS_NON_NULL __attribute__((__returns_nonnull__))
#elif defined(_Ret_notnull_) /* SAL */
#  define RETURNS_NON_NULL _Ret_notnull_
#else
#  define RETURNS_NON_NULL
#endif

#if defined(ARRAY_PARAM)
#  undef ARRAY_PARAM
#endif
#if \
  defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) && \
  !defined(__STDC_NO_VLA__) && \
  !defined(__cplusplus) && \
  !defined(PGI_VERSION) && \
  !defined(TINYC_VERSION)
#  define ARRAY_PARAM(name) (name)
#else
#  define ARRAY_PARAM(name)
#endif

#if defined(IS_CONSTANT)
#  undef IS_CONSTANT
#endif
#if defined(REQUIRE_CONSTEXPR)
#  undef REQUIRE_CONSTEXPR
#endif
/* IS_CONSTEXPR_ is for
   HEDLEY INTERNAL USE ONLY.  API subject to change without notice. */
#if defined(IS_CONSTEXPR_)
#  undef IS_CONSTEXPR_
#endif
#if \
  HAS_BUILTIN(__builtin_constant_p) || \
  GCC_VERSION_CHECK(3,4,0) || \
  INTEL_VERSION_CHECK(13,0,0) || \
  TINYC_VERSION_CHECK(0,9,19) || \
  ARM_VERSION_CHECK(4,1,0) || \
  IBM_VERSION_CHECK(13,1,0) || \
  TI_CL6X_VERSION_CHECK(6,1,0) || \
  (SUNPRO_VERSION_CHECK(5,10,0) && !defined(__cplusplus)) || \
  CRAY_VERSION_CHECK(8,1,0) || \
  MCST_LCC_VERSION_CHECK(1,25,10)
#  define IS_CONSTANT(expr) __builtin_constant_p(expr)
#endif
#if !defined(__cplusplus)
#  if \
       HAS_BUILTIN(__builtin_types_compatible_p) || \
       GCC_VERSION_CHECK(3,4,0) || \
       INTEL_VERSION_CHECK(13,0,0) || \
       IBM_VERSION_CHECK(13,1,0) || \
       CRAY_VERSION_CHECK(8,1,0) || \
       ARM_VERSION_CHECK(5,4,0) || \
       TINYC_VERSION_CHECK(0,9,24)
#    if defined(__INTPTR_TYPE__)
#      define IS_CONSTEXPR_(expr) __builtin_types_compatible_p(__typeof__((1 ? (void*) ((__INTPTR_TYPE__) ((expr) * 0)) : (int*) 0)), int*)
#    else
#      include <stdint.h>
#      define IS_CONSTEXPR_(expr) __builtin_types_compatible_p(__typeof__((1 ? (void*) ((intptr_t) ((expr) * 0)) : (int*) 0)), int*)
#    endif
#  elif \
       ( \
          defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L) && \
          !defined(SUNPRO_VERSION) && \
          !defined(PGI_VERSION) && \
          !defined(IAR_VERSION)) || \
       (HAS_EXTENSION(c_generic_selections) && !defined(IAR_VERSION)) || \
       GCC_VERSION_CHECK(4,9,0) || \
       INTEL_VERSION_CHECK(17,0,0) || \
       IBM_VERSION_CHECK(12,1,0) || \
       ARM_VERSION_CHECK(5,3,0)
#    if defined(__INTPTR_TYPE__)
#      define IS_CONSTEXPR_(expr) _Generic((1 ? (void*) ((__INTPTR_TYPE__) ((expr) * 0)) : (int*) 0), int*: 1, void*: 0)
#    else
#      include <stdint.h>
#      define IS_CONSTEXPR_(expr) _Generic((1 ? (void*) ((intptr_t) * 0) : (int*) 0), int*: 1, void*: 0)
#    endif
#  elif \
       defined(GCC_VERSION) || \
       defined(INTEL_VERSION) || \
       defined(TINYC_VERSION) || \
       defined(TI_ARMCL_VERSION) || \
       TI_CL430_VERSION_CHECK(18,12,0) || \
       defined(TI_CL2000_VERSION) || \
       defined(TI_CL6X_VERSION) || \
       defined(TI_CL7X_VERSION) || \
       defined(TI_CLPRU_VERSION) || \
       defined(__clang__)
#    define IS_CONSTEXPR_(expr) ( \
         sizeof(void) != \
         sizeof(*( \
           1 ? \
             ((void*) ((expr) * 0L) ) : \
             ((struct { char v[sizeof(void) * 2]; } *) 1) \
           ) \
         ) \
       )
#  endif
#endif
#if defined(IS_CONSTEXPR_)
#  if !defined(IS_CONSTANT)
#    define IS_CONSTANT(expr) IS_CONSTEXPR_(expr)
#  endif
#  define REQUIRE_CONSTEXPR(expr) (IS_CONSTEXPR_(expr) ? (expr) : (-1))
#else
#  if !defined(IS_CONSTANT)
#    define IS_CONSTANT(expr) (0)
#  endif
#  define REQUIRE_CONSTEXPR(expr) (expr)
#endif

#if defined(BEGIN_C_DECLS)
#  undef BEGIN_C_DECLS
#endif
#if defined(END_C_DECLS)
#  undef END_C_DECLS
#endif
#if defined(C_DECL)
#  undef C_DECL
#endif
#if defined(__cplusplus)
#  define BEGIN_C_DECLS extern "C" {
#  define END_C_DECLS }
#  define C_DECL extern "C"
#else
#  define BEGIN_C_DECLS
#  define END_C_DECLS
#  define C_DECL
#endif

#if defined(STATIC_ASSERT)
#  undef STATIC_ASSERT
#endif
#if \
  !defined(__cplusplus) && ( \
      (defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L)) || \
      (HAS_FEATURE(c_static_assert) && !defined(INTEL_CL_VERSION)) || \
      GCC_VERSION_CHECK(6,0,0) || \
      INTEL_VERSION_CHECK(13,0,0) || \
      defined(_Static_assert) \
    )
#  define STATIC_ASSERT(expr, message) _Static_assert(expr, message)
#elif \
  (defined(__cplusplus) && (__cplusplus >= 201103L)) || \
  MSVC_VERSION_CHECK(16,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define STATIC_ASSERT(expr, message) DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(static_assert(expr, message))
#else
#  define STATIC_ASSERT(expr, message)
#endif

#if defined(NULL)
#  undef NULL
#endif
#if defined(__cplusplus)
#  if __cplusplus >= 201103L
#    define NULL DIAGNOSTIC_DISABLE_CPP98_COMPAT_WRAP_(nullptr)
#  elif defined(NULL)
#    define NULL NULL
#  else
#    define NULL STATIC_CAST(void*, 0)
#  endif
#elif defined(NULL)
#  define NULL NULL
#else
#  define NULL ((void*) 0)
#endif

#if defined(MESSAGE)
#  undef MESSAGE
#endif
#if HAS_WARNING("-Wunknown-pragmas")
#  define MESSAGE(msg) \
  DIAGNOSTIC_PUSH \
  DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS \
  PRAGMA(message msg) \
  DIAGNOSTIC_POP
#elif \
  GCC_VERSION_CHECK(4,4,0) || \
  INTEL_VERSION_CHECK(13,0,0)
#  define MESSAGE(msg) PRAGMA(message msg)
#elif CRAY_VERSION_CHECK(5,0,0)
#  define MESSAGE(msg) PRAGMA(_CRI message msg)
#elif IAR_VERSION_CHECK(8,0,0)
#  define MESSAGE(msg) PRAGMA(message(msg))
#elif PELLES_VERSION_CHECK(2,0,0)
#  define MESSAGE(msg) PRAGMA(message(msg))
#else
#  define MESSAGE(msg)
#endif

#if defined(WARNING)
#  undef WARNING
#endif
#if HAS_WARNING("-Wunknown-pragmas")
#  define WARNING(msg) \
  DIAGNOSTIC_PUSH \
  DIAGNOSTIC_DISABLE_UNKNOWN_PRAGMAS \
  PRAGMA(clang warning msg) \
  DIAGNOSTIC_POP
#elif \
  GCC_VERSION_CHECK(4,8,0) || \
  PGI_VERSION_CHECK(18,4,0) || \
  INTEL_VERSION_CHECK(13,0,0)
#  define WARNING(msg) PRAGMA(GCC warning msg)
#elif \
  MSVC_VERSION_CHECK(15,0,0) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define WARNING(msg) PRAGMA(message(msg))
#else
#  define WARNING(msg) MESSAGE(msg)
#endif

#if defined(REQUIRE)
#  undef REQUIRE
#endif
#if defined(REQUIRE_MSG)
#  undef REQUIRE_MSG
#endif
#if HAS_ATTRIBUTE(diagnose_if)
#  if HAS_WARNING("-Wgcc-compat")
#    define REQUIRE(expr) \
       DIAGNOSTIC_PUSH \
       _Pragma("clang diagnostic ignored \"-Wgcc-compat\"") \
       __attribute__((diagnose_if(!(expr), #expr, "error"))) \
       DIAGNOSTIC_POP
#    define REQUIRE_MSG(expr,msg) \
       DIAGNOSTIC_PUSH \
       _Pragma("clang diagnostic ignored \"-Wgcc-compat\"") \
       __attribute__((diagnose_if(!(expr), msg, "error"))) \
       DIAGNOSTIC_POP
#  else
#    define REQUIRE(expr) __attribute__((diagnose_if(!(expr), #expr, "error")))
#    define REQUIRE_MSG(expr,msg) __attribute__((diagnose_if(!(expr), msg, "error")))
#  endif
#else
#  define REQUIRE(expr)
#  define REQUIRE_MSG(expr,msg)
#endif

#if defined(FLAGS)
#  undef FLAGS
#endif
#if HAS_ATTRIBUTE(flag_enum) && (!defined(__cplusplus) || HAS_WARNING("-Wbitfield-enum-conversion"))
#  define FLAGS __attribute__((__flag_enum__))
#else
#  define FLAGS
#endif

#if defined(FLAGS_CAST)
#  undef FLAGS_CAST
#endif
#if INTEL_VERSION_CHECK(19,0,0)
#  define FLAGS_CAST(T, expr) (__extension__ ({ \
  DIAGNOSTIC_PUSH \
      _Pragma("warning(disable:188)") \
      ((T) (expr)); \
      DIAGNOSTIC_POP \
    }))
#else
#  define FLAGS_CAST(T, expr) STATIC_CAST(T, expr)
#endif

#if defined(EMPTY_BASES)
#  undef EMPTY_BASES
#endif
#if \
  (MSVC_VERSION_CHECK(19,0,23918) && !MSVC_VERSION_CHECK(20,0,0)) || \
  INTEL_CL_VERSION_CHECK(2021,1,0)
#  define EMPTY_BASES __declspec(empty_bases)
#else
#  define EMPTY_BASES
#endif

/* Remaining macros are deprecated. */

#if defined(GCC_NOT_CLANG_VERSION_CHECK)
#  undef GCC_NOT_CLANG_VERSION_CHECK
#endif
#if defined(__clang__)
#  define GCC_NOT_CLANG_VERSION_CHECK(major,minor,patch) (0)
#else
#  define GCC_NOT_CLANG_VERSION_CHECK(major,minor,patch) GCC_VERSION_CHECK(major,minor,patch)
#endif

#if defined(CLANG_HAS_ATTRIBUTE)
#  undef CLANG_HAS_ATTRIBUTE
#endif
#define CLANG_HAS_ATTRIBUTE(attribute) HAS_ATTRIBUTE(attribute)

#if defined(CLANG_HAS_CPP_ATTRIBUTE)
#  undef CLANG_HAS_CPP_ATTRIBUTE
#endif
#define CLANG_HAS_CPP_ATTRIBUTE(attribute) HAS_CPP_ATTRIBUTE(attribute)

#if defined(CLANG_HAS_BUILTIN)
#  undef CLANG_HAS_BUILTIN
#endif
#define CLANG_HAS_BUILTIN(builtin) HAS_BUILTIN(builtin)

#if defined(CLANG_HAS_FEATURE)
#  undef CLANG_HAS_FEATURE
#endif
#define CLANG_HAS_FEATURE(feature) HAS_FEATURE(feature)

#if defined(CLANG_HAS_EXTENSION)
#  undef CLANG_HAS_EXTENSION
#endif
#define CLANG_HAS_EXTENSION(extension) HAS_EXTENSION(extension)

#if defined(CLANG_HAS_DECLSPEC_DECLSPEC_ATTRIBUTE)
#  undef CLANG_HAS_DECLSPEC_DECLSPEC_ATTRIBUTE
#endif
#define CLANG_HAS_DECLSPEC_ATTRIBUTE(attribute) HAS_DECLSPEC_ATTRIBUTE(attribute)

#if defined(CLANG_HAS_WARNING)
#  undef CLANG_HAS_WARNING
#endif
#define CLANG_HAS_WARNING(warning) HAS_WARNING(warning)

#endif /* !defined(VERSION) || (VERSION < X) */
