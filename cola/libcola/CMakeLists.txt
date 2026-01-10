set(LIB_SOURCES
    box.cpp
    cc_clustercontainmentconstraints.cpp
    cc_nonoverlapconstraints.cpp
    cluster.cpp
    cola.cpp
    colafd.cpp
    compound_constraints.cpp
    conjugate_gradient.cpp
    connected_components.cpp
    convex_hull.cpp
    gradient_projection.cpp
    output_svg.cpp
    pseudorandom.cpp
    shapepair.cpp
    straightener.cpp
)

set(LIB_HEADERS
    box.h
    cc_clustercontainmentconstraints.h
    cc_nonoverlapconstraints.h
    cluster.h
    cola_log.h
    cola.h
    commondefs.h
    compound_constraints.h
    conjugate_gradient.h
    connected_components.h
    convex_hull.h
    exceptions.h
    gradient_projection.h
    output_svg.h
    pseudorandom.h
    shapepair.h
    shortest_paths.h
    sparse_matrix.h
    straightener.h
    unused.h
)

adaptagrams_add_library(
    NAME cola
    SOURCES ${LIB_SOURCES}
    HEADERS ${LIB_HEADERS}
    EXPORT_SUBDIR libcola
    PUBLIC_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/cola ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC_DEFINITIONS ${COMMON_COMPILE_DEFINITIONS}
    PUBLIC_LINK_OPTIONS ${COMMON_LINK_OPTIONS}
    PUBLIC_LINK_LIBS adaptagrams::vpsc
    OPTIONAL_CAIROMM
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()
