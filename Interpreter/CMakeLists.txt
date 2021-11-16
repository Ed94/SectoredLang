# MIT License 
# Copyright (c) 2018-Today Michele Adduci <adduci@tutanota.com>
#
# Main CMake Project file

#####################################
# Define Project-Wide Settings
#####################################
cmake_minimum_required(VERSION 3.15.0 FATAL_ERROR)

# Enables the Visibility Property on all target types
cmake_policy(SET CMP0063 NEW)

# Enables the MSVC_RUNTIME_LIBRARY property on targets
# cmake_policy(SET CMP0091 NEW)

# Define the Project Name and Description
project(
	MAS-Interpreter 
	VERSION 0.1.0
	LANGUAGES C 
	DESCRIPTION "A MAS language interpeter"
)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(
	FATAL_ERROR
	"In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
	)
endif()

# Set required C Standard
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED TRUE)

# Set required C++ Standard
# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED FALSE)

# Generate the compile_commands.json file
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)
# Set the Relative Path Configurations
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
# Configure the visibility of symbols in targets
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
# Define installation folder and the module path (this one required by conan)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR} ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR} ${CMAKE_PREFIX_PATH})

#####################################
# Define Options
#####################################
option(BUILD_TESTING "Build tests" FALSE)
option(BUILD_SHARED_LIBS "Build shared libraries" FALSE)
option(BUILD_WITH_MT "Build libraries as MultiThreaded DLL (Windows Only)" FALSE)

#####################################
# Define CMake Module Imports
#####################################
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(InstallRequiredSystemLibraries)
include(GenerateExportHeader)

// Formatting
# include(${CMAKE_SOURCE_DIR}/cmake/clang_format.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/compiler_options.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/cpack.cmake)
# include(${CMAKE_SOURCE_DIR}/cmake/cppcheck.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/dependencies.cmake)

#####################################
# Define Targets
#####################################
add_subdirectory(project)

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/project/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/project/*.cpp")
