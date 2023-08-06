set(LIB_NAME vpsc)

set(LIB_SOURCES
	block.cpp
	blocks.cpp
	constraint.cpp
	rectangle.cpp
	solve_VPSC.cpp
	variable.cpp
	cbuffer.cpp
	# isnan.h
	block.h
	blocks.h
	constraint.h
	rectangle.h
	pairing_heap.h
	solve_VPSC.h
	variable.h
	cbuffer.h
	linesegment.h
	assertions.h
)

set(LIB_HEADERS
	solve_VPSC.h
	block.h
	constraint.h
	exceptions.h
	rectangle.h
	variable.h
	assertions.h
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


if(BUILD_TESTS)
add_subdirectory(tests)
endif()
