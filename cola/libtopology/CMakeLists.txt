set(LIB_NAME topology)

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
