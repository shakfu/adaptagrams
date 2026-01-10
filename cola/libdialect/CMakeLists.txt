set(LIB_SOURCES
    aca.cpp
    bendseqlookup.cpp
    chains.cpp
    constraints.cpp
    edges.cpp
    expansion.cpp
    faces.cpp
    graphs.cpp
    hola.cpp
    io.cpp
    logging.cpp
    nearalign.cpp
    nexes.cpp
    nodeconfig.cpp
    nodes.cpp
    ortho.cpp
    peeling.cpp
    planarise.cpp
    qalookup.cpp
    quadaction.cpp
    routing.cpp
    sides.cpp
    treeplacement.cpp
    trees.cpp
)

set(LIB_HEADERS
    aca.h
    chains.h
    commontypes.h
    constraints.h
    expansion.h
    faces.h
    graphs.h
    hola.h
    io.h
    libdialect.h
    logging.h
    nearalign.h
    nodeconfig.h
    opts.h
    ortho.h
    peeling.h
    planarise.h
    quadaction.h
    routing.h
    treeplacement.h
    trees.h
    util.h
)

adaptagrams_add_library(
    NAME dialect
    SOURCES ${LIB_SOURCES}
    HEADERS ${LIB_HEADERS}
    EXPORT_SUBDIR libdialect
    PUBLIC_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/cola ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC_DEFINITIONS ${COMMON_COMPILE_DEFINITIONS}
    PUBLIC_LINK_OPTIONS ${COMMON_LINK_OPTIONS}
    PUBLIC_LINK_LIBS adaptagrams::avoid adaptagrams::cola adaptagrams::vpsc
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
