set(LIB_NAME avoid)

set(LIB_SOURCES
	connectionpin.cpp 
	connector.cpp
	connend.cpp
	geometry.cpp
	geomtypes.cpp
	graph.cpp
	junction.cpp
	makepath.cpp
	obstacle.cpp
	orthogonal.cpp
	router.cpp
	shape.cpp
	timer.cpp
	vertices.cpp
	viscluster.cpp
	visibility.cpp
	vpsc.cpp
	hyperedge.cpp
	hyperedgeimprover.cpp
	mtst.cpp
	hyperedgetree.cpp
	scanline.cpp
	actioninfo.cpp
	assertions.h
	connector.h
	connectionpin.h
	connend.h
	debug.h
	geometry.h
	geomtypes.h
	graph.h
	junction.h
	libavoid.h
	makepath.h
	obstacle.h
	orthogonal.h
	router.h
	shape.h
	timer.h
	vertices.h
	viscluster.h
	visibility.h
	hyperedge.h
	mtst.h
	hyperedgetree.h
	scanline.h
	actioninfo.h
	vpsc.h
	debughandler.h
)

set(LIB_HEADERS
	assertions.h
	connector.h
	connectionpin.h
	connend.h
	debug.h
	dllexport.h
	geometry.h
	geomtypes.h
	graph.h
	junction.h
	libavoid.h
	makepath.h
	obstacle.h
	orthogonal.h
	router.h
	shape.h
	timer.h
	vertices.h
	viscluster.h
	visibility.h
	hyperedge.h
	hyperedgeimprover.h
	mtst.h
	hyperedgetree.h
	scanline.h
	actioninfo.h
	vpsc.h
	debughandler.h
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
# 	--no-undefined
# )

if(BUILD_TESTS)
add_subdirectory(tests)
endif()


