set(LIB_NAME topology)

set(LIB_SOURCES
	topology_graph.cpp
	topology_constraints.cpp
	compute_forces.cpp
	topology_constraints_constructor.cpp
	resize.cpp
	cola_topology_addon.cpp
	orthogonal_topology.cpp
	topology_constraints.h
	topology_graph.h
	cola_topology_addon.h
	orthogonal_topology.h
	topology_log.h
	util.h
)

set(LIB_HEADERS
	topology_constraints.h
	topology_graph.h
	cola_topology_addon.h
	orthogonal_topology.h
	topology_log.h
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

add_dependencies(${LIB_NAME}
    avoid
    cola
    vpsc
)

# target_link_options(${LIB_NAME}
# 	PUBLIC
# 	-no-undefined
# )


if(BUILD_TESTS)
add_subdirectory(tests)
endif()
