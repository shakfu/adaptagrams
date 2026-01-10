set(LIB_SOURCES
    cola_topology_addon.cpp
    compute_forces.cpp
    orthogonal_topology.cpp
    resize.cpp
    topology_constraints_constructor.cpp
    topology_constraints.cpp
    topology_graph.cpp
)

set(LIB_HEADERS
    cola_topology_addon.h
    orthogonal_topology.h
    topology_constraints.h
    topology_graph.h
    topology_log.h
    util.h
)

adaptagrams_add_library(
    NAME topology
    SOURCES ${LIB_SOURCES}
    HEADERS ${LIB_HEADERS}
    EXPORT_SUBDIR libtopology
    PUBLIC_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/cola ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC_DEFINITIONS ${COMMON_COMPILE_DEFINITIONS}
    PUBLIC_LINK_OPTIONS ${COMMON_LINK_OPTIONS}
    PUBLIC_LINK_LIBS adaptagrams::avoid adaptagrams::cola adaptagrams::vpsc
)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()

