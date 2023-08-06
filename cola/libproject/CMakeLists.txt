set(LIB_NAME project)

set(LIB_SOURCES
	project.cpp
    util.h
    util.cpp
)

set(LIB_HEADERS
    project.h
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

# target_link_options(${LIB_NAME}
# 	PUBLIC
# 	-no-undefined
# )


if(BUILD_TESTS)
add_subdirectory(tests)
endif()

