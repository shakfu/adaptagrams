cmake_minimum_required(VERSION 3.19)

project(adaptagrams)

option(BUILD_SWIG_PYTHON "Enable building swig python wrapper")
option(BUILD_TESTS "Enable building tests")
option(ENABLE_CCACHE "Use ccache if available" ON)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE STRING "set archive" FORCE)

# use ccache if available
if(ENABLE_CCACHE)
    find_program(CCACHE_PROGRAM ccache)
    if(CCACHE_PROGRAM)
        message(STATUS "Found ccache in ${CCACHE_PROGRAM}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    endif()
endif()

message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    # i.e check if homebrew is used, set local prefix accordingly
    set(local_prefix "/usr/local")
    execute_process(
        COMMAND brew --prefix
        OUTPUT_VARIABLE homebrew_prefix
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(DEFINED homebrew_prefix)
        set(HAVE_HOMEBREW 1 CACHE BOOL "have homebrew on system" FORCE)
        message(STATUS "HAVE_HOMEBREW: ${HAVE_HOMEBREW}")
        set(local_prefix ${homebrew_prefix})
        list(APPEND CMAKE_PREFIX_PATH ${homebrew_prefix})
        execute_process(
            COMMAND brew --prefix cairomm
            OUTPUT_VARIABLE cairomm_prefix
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        # list(APPEND CMAKE_PREFIX_PATH ${cairomm_prefix})
        # find_library(
        #     CAIROMM_LIB cairomm cairomm-1.16 libcairomm-1.16.dylib
        #     HINTS ${homebrew_prefix}/lib ${cairomm_prefix}/lib
        # )

        find_library(
            CAIROMM_LIB 
            NAMES cairomm cairomm-1.16 libcairomm-1.16.dylib
            HINTS ${homebrew_prefix}/lib ${cairomm_prefix}/lib
        )
        message("system: ${CMAKE_SYSTEM_PREFIX_PATH}")
        if(CAIROMM_LIB STREQUAL "CAIROMM_LIB-NOTFOUND")
            set(HAVE_CAIROMM 0 CACHE BOOL "have cairomm on system" FORCE)
            message(STATUS "HAVE_CAIROMM: ${HAVE_CAIROMM}")
            message(STATUS "CAIROMM_LIB: ${CAIROMM_LIB}")
        else()
            set(HAVE_CAIROMM 1 CACHE BOOL "have cairomm on system" FORCE)
            message(STATUS "HAVE_CAIROMM: ${HAVE_CAIROMM}")
            message(STATUS "CAIROMM_LIB: ${CAIROMM_LIB}")
        endif()
        # execute_process(
        #     COMMAND brew --prefix cairomm
        #     OUTPUT_VARIABLE cairomm_prefix
        #     OUTPUT_STRIP_TRAILING_WHITESPACE
        # )
        # if(DEFINED cairomm_prefix)
        #     set(HAVE_CAIROMM 1 CACHE BOOL "have cairomm on system" FORCE)
        #     message(STATUS "HAVE_CAIROMM: ${HAVE_CAIROMM}")
        # endif()
    endif()
endif()

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

configure_file(
    ${CMAKE_SOURCE_DIR}/cola/libcola/config.h.cmake.in 
    ${CMAKE_SOURCE_DIR}/cola/libcola/config.h
)

if(BUILD_TESTS)
    enable_testing()
endif()

add_subdirectory(cola)
