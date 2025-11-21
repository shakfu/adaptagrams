cmake_minimum_required(VERSION 3.22)

project(Adaptagrams VERSION 0.9.0)

# Extra CMake support modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(AdaptagramsLibrary)

# Standards
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR} CACHE PATH "" FORCE)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR} CACHE PATH "" FORCE)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR} CACHE PATH "" FORCE)

# use ccache if available
option(ENABLE_CCACHE "Use ccache if available" ON)
if(ENABLE_CCACHE)
    find_program(CCACHE_PROGRAM ccache)
    if(CCACHE_PROGRAM)
        message(STATUS "Found ccache in ${CCACHE_PROGRAM}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    endif()
endif()

# Build shared and static unless disabled by user
if (NOT DEFINED BUILD_SHARED_LIBS)
    set(BUILD_SHARED_LIBS ON)
endif()
if (NOT DEFINED BUILD_STATIC_LIBS)
    set(BUILD_STATIC_LIBS ON)
endif()

# Set an RPATH value on install
if(NOT DEFINED LIB_DIR)
    set(LIB_DIR lib)
endif()
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${LIB_DIR}")

# Adaptagrams uses Cario for some debug outputs - it is an optional dependency.
# If the user hasn't told us what to do about tests, or if they have already
# told us to build them, check and see if we have Cairo available.
if(NOT DEFINED BUILD_TESTS OR BUILD_TESTS)
    # optional cairo package
    if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
	set(package_name cairomm-1.16)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	set(package_name cairomm-svg-1.16)
    else()
	set(HAVE_CAIROMM 0 CACHE BOOL "" FORCE)
    endif()

    if(DEFINED package_name)
	find_package(PkgConfig)
	if(PkgConfig_FOUND)
	    pkg_check_modules(CAIROMM ${package_name})
	    if(CAIROMM_FOUND)
		set(HAVE_CAIROMM 1 CACHE BOOL "have cairomm on system" FORCE)
		message(STATUS "CAIROMM_INCLUDE_DIRS: ${CAIROMM_INCLUDE_DIRS}")
		message(STATUS "CAIROMM_LIBRARY_DIRS: ${CAIROMM_LIBRARY_DIRS}")
		message(STATUS "CAIROMM_LIBRARIES: ${CAIROMM_LIBRARIES}")
		message(STATUS "CAIROMM_CFLAGS: ${CAIROMM_CFLAGS}")
		message(STATUS "CAIROMM_LDFLAGS: ${CAIROMM_LDFLAGS}")
	    else()
		message(STATUS "${package_name} NOT FOUND")
		set(HAVE_CAIROMM 0 CACHE BOOL "" FORCE)
	    endif()
	else()
	    message(STATUS "PkgConfig NOT FOUND")
	    set(HAVE_CAIROMM 0 CACHE BOOL "" FORCE)
	endif()
    endif()

    if (BUILD_TESTS AND NOT HAVE_CAIROMM)
	# Since BUILD_TESTS can't work without Cairo, explicitly override the
	# user supplied BUILD_TESTS activation.
	message(WARNING "BUILD_TESTS enabled, but Cairo not found - disabling")
	unset(BUILD_TESTS CACHE)
	unset(BUILD_TESTS)
    endif()
endif()
if(DEFINED HAVE_CAIROMM AND HAVE_CAIROMM)
  set(_default_BUILD_TESTS ON)
else()
  set(_default_BUILD_TESTS OFF)
endif()

# The optional Python support requires both Python and SWIG.  Like the debug
# case, check if we have what we need.
if(NOT DEFINED BUILD_SWIG_PYTHON OR BUILD_SWIG_PYTHON)
    find_package(SWIG COMPONENTS python)
    find_package(Python COMPONENTS Interpreter Development.Module)
    if(BUILD_SWIG_PYTHON)
	if (NOT SWIG_FOUND OR NOT Python_FOUND)
	    # Since BUILD_SWIG_PYTHON can't work without SWIG and Python,
	    # explicitly override the user supplied BUILD_SWIG_PYTHON
	    # activation in this situation.
	    message(WARNING "BUILD_SWIG_PYTHON enabled, but not all necessary components were found - disabling")
	    message(FATAL_ERROR "SWIG/Python search status: SWIG: ${SWIG_FOUND} Python: ${Python_FOUND}")
	    unset(BUILD_SWIG_PYTHON CACHE)
	    unset(BUILD_SWIG_PYTHON)
	endif()
    endif()
endif()


# Build options
option(BUILD_SWIG_PYTHON "Enable building swig python wrapper" OFF)
option(BUILD_TESTS "Enable building tests" ${_default_BUILD_TESTS})

# If you enable the following option, find_package calls identifying the
# installed version from these outputs will prefer to use the static versions
# of the libraries even if shared versions are present.  I.e. if you don't
# target a specific type, and this option is set, parent code find_package
# calls will preferentially get the static versions of the libraries.
option(ADAPTAGRAMS_DEFAULT_TO_STATIC "Chooser targets in CMake exported config files prefer static variant when both static and shared are built" OFF)

# Compiler Flags
include(CheckCXXCompilerFlag)
function(check_cxx_flag out_list flag)
    string(REGEX REPLACE "[^A-Za-z0-9]" "_" _key "${flag}")
    check_cxx_compiler_flag("${flag}" HAVE_FLAG_${_key})
    if(HAVE_FLAG_${_key})
	list(APPEND ${out_list} "${flag}")
	set(${out_list} "${${out_list}}" PARENT_SCOPE)
    endif()
endfunction()
set(TGT_COMPILE_FLAGS "")
check_cxx_flag(TGT_COMPILE_FLAGS "-Wall")
check_cxx_flag(TGT_COMPILE_FLAGS "-Wpointer-arith")
check_cxx_flag(TGT_COMPILE_FLAGS "-Wcast-align")
check_cxx_flag(TGT_COMPILE_FLAGS "-Wsign-compare")
check_cxx_flag(TGT_COMPILE_FLAGS "-Woverloaded-virtual")
check_cxx_flag(TGT_COMPILE_FLAGS "-Wswitch")

# Header files
include(CheckIncludeFile)
CHECK_INCLUDE_FILE(dlfcn.h HAVE_DLFCN_H)
CHECK_INCLUDE_FILE(inttypes.h HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE(stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stdio.h HAVE_STDIO_H)
CHECK_INCLUDE_FILE(stdlib.h HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(strings.h HAVE_STRINGS_H)
CHECK_INCLUDE_FILE(string.h HAVE_STRING_H)
CHECK_INCLUDE_FILE(sys/stat.h HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(unistd.h HAVE_UNISTD_H)

# Write config header file
configure_file(
    ${CMAKE_SOURCE_DIR}/cola/libcola/config.h.cmake.in 
    ${CMAKE_SOURCE_DIR}/cola/libcola/config.h
)

if(BUILD_TESTS)
    enable_testing()
endif()

# Global accumulator used by the helper for final export step
set(ADAPTAGRAMS_EXPORT_TARGETS "")

# Ready for the main source files
add_subdirectory(cola)

# ------------------------------------------------------------------------------
# Optional SWIG Python module
# ------------------------------------------------------------------------------
# TODO - should this be in the cola subdirectory?
if(BUILD_SWIG_PYTHON)
    message(STATUS "Building Adaptagrams SWIG Python extension")
    set(generated_file ${CMAKE_BINARY_DIR}/adaptagrams_wrap.cxx)
    execute_process(
	OUTPUT_FILE ${CMAKE_BINARY_DIR}/adaptagrams_wrap.cxx
	COMMAND ${SWIG_EXECUTABLE} -DNDEBUG -c++ -python
	-outdir ${CMAKE_BINARY_DIR}
	-o ${generated_file} adaptagrams.i
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/cola
    )
    if(NOT EXISTS ${generated_file})
	message(FATAL_ERROR "did not generate: ${generated_file}")
    endif()

    python_add_library(
	_adaptagrams
	MODULE WITH_SOABI
	${generated_file}
    )

    set_target_properties(
	_adaptagrams
	PROPERTIES
	CXX_STANDARD 11
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
    )

    target_compile_definitions(
	_adaptagrams
	PRIVATE
	USE_ASSERT_EXCEPTIONS
	SWIG_PYTHON_SILENT_MEMLEAK
    )

    target_include_directories(
	_adaptagrams
	PUBLIC
	${CMAKE_SOURCE_DIR}/cola
    )

    target_link_libraries(
	_adaptagrams
	PRIVATE
	avoid
	cola
	dialect
	topology
	vpsc
    )

    install(TARGETS _adaptagrams DESTINATION lib/adaptagrams)
    install(FILES ${CMAKE_SOURCE_DIR}/cola/__init__.py DESTINATION lib/adaptagrams)
    install(FILES ${CMAKE_BINARY_DIR}/adaptagrams.py DESTINATION lib/adaptagrams)
endif()

# ------------------------------------------------------------------------------
# Export / Package Configuration
# ------------------------------------------------------------------------------
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/AdaptagramsConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

# Collect built components from the global property
get_property(_adaptagrams_components GLOBAL PROPERTY ADAPTAGRAMS_BUILT_COMPONENTS)
if(NOT _adaptagrams_components)
    set(_adaptagrams_components "")
endif()
# Normalize list
list(REMOVE_DUPLICATES _adaptagrams_components)
list(SORT _adaptagrams_components)
set(ADAPTAGRAMS_BUILT_COMPONENTS "${_adaptagrams_components}")
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/AdaptagramsConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/AdaptagramsConfig.cmake"
    @ONLY
)

# Install the export set (targets added via adaptagrams_add_library)
install(
    EXPORT AdaptagramsTargets
    NAMESPACE adaptagrams::
    DESTINATION lib/cmake/Adaptagrams
    FILE AdaptagramsTargets.cmake
)

# Install the package config & version file
install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/AdaptagramsConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/AdaptagramsConfigVersion.cmake"
    DESTINATION lib/cmake/Adaptagrams
)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=4 tabstop=8 cino=N-s
