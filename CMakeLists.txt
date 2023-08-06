cmake_minimum_required(VERSION 3.19)

project(adaptagrams)

option(BUILD_SWIG_PYTHON "Enable building swig python wrapper")
option(BUILD_TESTS "Enable building tests")

set(CMAKE_CXX_STANDARD 11)

# use ccache if available
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    message(STATUS "Found ccache in ${CCACHE_PROGRAM}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
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
        set(HAS_HOMEBREW 1)
        set(local_prefix ${homebrew_prefix})
    endif()
endif()

if(BUILD_TESTS)
    enable_testing()
endif()

add_subdirectory(cola)
