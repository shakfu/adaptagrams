
# libtopology tests

function(add_topology_test)

    set(options)

    set(oneValueArgs
        NAME
    )

    set(multiValueArgs
      SOURCES
    )

    cmake_parse_arguments(
        TOPOLOGY_TEST 
        "${options}" "${oneValueArgs}"
        "${multiValueArgs}" ${ARGN}
    )

    add_executable(${TOPOLOGY_TEST_NAME}
        ${TOPOLOGY_TEST_SOURCES}
    )

    target_include_directories(${TOPOLOGY_TEST_NAME}
        PUBLIC
        ${CMAKE_SOURCE_DIR}/cola
        ${CMAKE_CURRENT_SOURCE_DIR}
        #${CAIROMM_CFLAGS}
    )

    target_link_libraries(${TOPOLOGY_TEST_NAME}
        PUBLIC
        topology
        cola
        vpsc
        avoid
        # ${CAIROMM_LIBS}
    )

    add_test(NAME ${TOPOLOGY_TEST_NAME}
         COMMAND ${TOPOLOGY_TEST_NAME}
    )

endfunction()

add_topology_test(NAME simple_bend SOURCES simple_bend.cpp)
add_topology_test(NAME nooverlap SOURCES nooverlap.cpp)
add_topology_test(NAME nodedragging SOURCES nodedragging.cpp)
add_topology_test(NAME beautify SOURCES beautify.cpp)
add_topology_test(NAME orthogonalOpt SOURCES orthogonalOpt.cpp)
