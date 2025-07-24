set(LIB_NAME vpsc)

set(LIB_SOURCES
	block.cpp
	blocks.cpp
	cbuffer.cpp
	constraint.cpp
	rectangle.cpp
	solve_VPSC.cpp
	variable.cpp
)

set(LIB_HEADERS
	assertions.h
	block.h
	blocks.h
	cbuffer.h
	constraint.h
	exceptions.h
	linesegment.h
	pairing_heap.h
	rectangle.h
	solve_VPSC.h
	variable.h
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

if(BUILD_TESTS)
	add_subdirectory(tests)
endif()
