set(LIB_NAME dialect)

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

add_library(${LIB_NAME}
	${LIB_SOURCES}
)

target_include_directories(${LIB_NAME}
    PUBLIC
    ${CMAKE_SOURCE_DIR}/cola
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_options(${LIB_NAME}
	PUBLIC
	-fPIC
)

target_link_options(${LIB_NAME}
    PUBLIC
    $<$<PLATFORM_ID:Darwin>:-Wl,-undefined,error>
    $<$<PLATFORM_ID:Linux>:-no-undefined>
)

add_dependencies(${LIB_NAME}
    avoid
    cola
    vpsc
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
