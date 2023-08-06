set(LIB_NAME dialect)

set(LIB_SOURCES
	aca.cpp
    aca.h
    bendseqlookup.cpp
    chains.cpp
    chains.h
    commontypes.h
    constraints.cpp
    constraints.h
    edges.cpp
    expansion.cpp
    expansion.h
    faces.cpp
    faces.h
    graphs.cpp
    graphs.h
    hola.cpp
    hola.h
    io.cpp
    io.h
    logging.cpp
    logging.h
    nearalign.cpp
    nearalign.h
    nexes.cpp
    nodeconfig.cpp
    nodeconfig.h
    nodes.cpp
    opts.h
    ortho.cpp
    ortho.h
    peeling.cpp
    peeling.h
    planarise.cpp
    planarise.h
    qalookup.cpp
    quadaction.cpp
    quadaction.h
    routing.cpp
    routing.h
    sides.cpp
    treeplacement.cpp
    treeplacement.h
    trees.cpp
    trees.h
    util.h
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

# target_link_options(${LIB_NAME}
# 	PUBLIC
# 	-no-undefined
# )

add_dependencies(${LIB_NAME}
    avoid
    cola
    vpsc
)

if(BUILD_TESTS)
add_subdirectory(tests)
endif()
