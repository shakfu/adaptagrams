set(LIB_SOURCES
    block.cpp
    blocks.cpp
    cbuffer.cpp
    constraint.cpp
    rectangle.cpp
    solve_VPSC.cpp
    variable.cpp
)

set(LIB_HEADERS
    assertions.h
    block.h
    blocks.h
    cbuffer.h
    constraint.h
    exceptions.h
    linesegment.h
    pairing_heap.h
    rectangle.h
    solve_VPSC.h
    variable.h
)

adaptagrams_add_library(
    NAME vpsc
    SOURCES ${LIB_SOURCES}
    HEADERS ${LIB_HEADERS}
    EXPORT_SUBDIR libvpsc
    PUBLIC_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/cola ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC_DEFINITIONS ${COMMON_COMPILE_DEFINITIONS}
    PUBLIC_LINK_OPTIONS ${COMMON_LINK_OPTIONS}
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
