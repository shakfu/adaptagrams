set(LIB_NAME project)

set(LIB_SOURCES
	project.cpp
    util.cpp
)

set(LIB_HEADERS
    project_log.h
    project.h
    util.h
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

