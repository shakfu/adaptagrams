set(LIB_SOURCES
    project.cpp
    util.cpp
)

set(LIB_HEADERS
    project_log.h
    project.h
    util.h
    variable.h
)

adaptagrams_add_library(
    NAME project
    SOURCES ${LIB_SOURCES}
    HEADERS ${LIB_HEADERS}
    EXPORT_SUBDIR libproject
    PUBLIC_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/cola ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC_DEFINITIONS ${COMMON_COMPILE_DEFINITIONS}
    PUBLIC_LINK_OPTIONS ${COMMON_LINK_OPTIONS}
    PUBLIC_LINK_LIBS adaptagrams::cola adaptagrams::vpsc
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
