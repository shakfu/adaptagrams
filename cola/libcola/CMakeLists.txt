set(LIB_NAME cola)

set(LIB_SOURCES
	cola.h
	cola.cpp
	colafd.cpp
	conjugate_gradient.cpp
	conjugate_gradient.h
	exceptions.h
	gradient_projection.cpp
	gradient_projection.h
	shortest_paths.h
	straightener.h
	straightener.cpp
	connected_components.cpp
	convex_hull.h
	convex_hull.cpp
	cluster.cpp
	compound_constraints.h
	compound_constraints.cpp
	pseudorandom.h 
	pseudorandom.cpp 
	output_svg.cpp
	output_svg.h 
	unused.h 
	cc_clustercontainmentconstraints.cpp 
	cc_clustercontainmentconstraints.h 
	cc_nonoverlapconstraints.cpp 
	cc_nonoverlapconstraints.h 
	box.cpp 
	box.h 
	shapepair.cpp 
	shapepair.h
)

set(LIB_HEADERS
	cola.h
	cluster.h
	commondefs.h
	compound_constraints.h
	pseudorandom.h 
	exceptions.h
	gradient_projection.h
	sparse_matrix.h
	straightener.h 
	output_svg.h 
	unused.h 
	cc_clustercontainmentconstraints.h 
	cc_nonoverlapconstraints.h 
	box.h 
	shapepair.h
)

add_library(${LIB_NAME}
	${LIB_SOURCES}
)

target_include_directories(${LIB_NAME}
	PUBLIC
	${CMAKE_SOURCE_DIR}/cola
	${CMAKE_CURRENT_SOURCE_DIR}
	# ${CAIROMM_CFLAGS}
)

target_compile_options(${LIB_NAME}
	PUBLIC
	-fPIC
)

add_dependencies(${LIB_NAME}
	vpsc
)

# target_link_options(${LIB_NAME}
# 	PUBLIC
# 	-no-undefined
# )

# target_link_libraries(${LIB_NAME}
# 	PUBLIC
# 	${CAIROMM_LIBS}
# )


if(BUILD_TESTS)
add_subdirectory(tests)
endif()

