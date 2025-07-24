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

set_target_properties(
    ${LIB_NAME} 
    PROPERTIES
    POSITION_INDEPENDENT_CODE ON
)

target_compile_definitions(${LIB_NAME}
    PUBLIC
    ${COMMON_COMPILE_DEFINITIONS}
)

target_link_options(${LIB_NAME}
    PUBLIC
    ${COMMON_LINK_OPTIONS}
)


if(BUILD_TESTS)
	add_subdirectory(tests)
endif()

