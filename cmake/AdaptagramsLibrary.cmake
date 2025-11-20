# Wrap common logic used for building Adaptagrams libraries into
# a reusable function (Option C: no separate iface target; usage requirements
# applied directly to variants). Chooser target uses an internal name to avoid
# collisions with any legacy ALIAS targets.
function(adaptagrams_add_library)
    set(options OPTIONAL_CAIROMM)
    set(oneValueArgs NAME EXPORT_SUBDIR)
    set(multiValueArgs SOURCES HEADERS PUBLIC_INCLUDE_DIRS PUBLIC_DEFINITIONS PUBLIC_COMPILE_OPTIONS PUBLIC_LINK_OPTIONS PUBLIC_LINK_LIBS)
    cmake_parse_arguments(ALIB "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ALIB_NAME)
        message(FATAL_ERROR "adaptagrams_add_library: NAME is required")
    endif()
    if(NOT ALIB_SOURCES)
        message(FATAL_ERROR "adaptagrams_add_library(${ALIB_NAME}): SOURCES list is empty")
    endif()
    if(NOT ALIB_HEADERS)
        message(FATAL_ERROR "adaptagrams_add_library(${ALIB_NAME}): HEADERS list is empty")
    endif()
    if(NOT ALIB_EXPORT_SUBDIR)
        message(FATAL_ERROR "adaptagrams_add_library(${ALIB_NAME}): EXPORT_SUBDIR is required")
    endif()

    # Object library (single compilation of sources)
    set(_obj "${ALIB_NAME}_obj")
    add_library(${_obj} OBJECT ${ALIB_SOURCES})
    set_target_properties(${_obj} PROPERTIES POSITION_INDEPENDENT_CODE ON)

    # Compilation-only flags/defs
    if(TGT_COMPILE_FLAGS)
        target_compile_options(${_obj} PRIVATE ${TGT_COMPILE_FLAGS})
    endif()
    if(ALIB_PUBLIC_COMPILE_OPTIONS)
        target_compile_options(${_obj} PRIVATE ${ALIB_PUBLIC_COMPILE_OPTIONS})
    endif()
    if(ALIB_PUBLIC_DEFINITIONS)
        target_compile_definitions(${_obj} PRIVATE ${ALIB_PUBLIC_DEFINITIONS})
    endif()

    # Include dirs required to compile object sources
    if(ALIB_PUBLIC_INCLUDE_DIRS)
        target_include_directories(${_obj} PRIVATE ${ALIB_PUBLIC_INCLUDE_DIRS})
    endif()
    if(ALIB_OPTIONAL_CAIROMM AND DEFINED HAVE_CAIROMM AND HAVE_CAIROMM)
        target_include_directories(${_obj} PRIVATE ${CAIROMM_INCLUDE_DIRS})
    endif()

    set(_variants "")
    foreach(_kind STATIC SHARED)
        if((${_kind} STREQUAL "STATIC" AND BUILD_STATIC_LIBS) OR
           (${_kind} STREQUAL "SHARED" AND BUILD_SHARED_LIBS))
            set(_variant "${ALIB_NAME}_${_kind}")
            add_library(${_variant} ${_kind} $<TARGET_OBJECTS:${_obj}>)
            set_target_properties(${_variant} PROPERTIES
                OUTPUT_NAME ${ALIB_NAME}
                POSITION_INDEPENDENT_CODE ON
            )

            # PUBLIC usage requirements (with generator expressions)
            if(ALIB_PUBLIC_INCLUDE_DIRS)
                foreach(_inc IN LISTS ALIB_PUBLIC_INCLUDE_DIRS)
                    target_include_directories(${_variant} PUBLIC
                        $<BUILD_INTERFACE:${_inc}>
                    )
                endforeach()
            endif()
            target_include_directories(${_variant} PUBLIC
                $<INSTALL_INTERFACE:include/${ALIB_EXPORT_SUBDIR}>
            )

            if(ALIB_PUBLIC_DEFINITIONS)
                target_compile_definitions(${_variant} PUBLIC ${ALIB_PUBLIC_DEFINITIONS})
            endif()
            if(ALIB_PUBLIC_COMPILE_OPTIONS)
                target_compile_options(${_variant} PUBLIC ${ALIB_PUBLIC_COMPILE_OPTIONS})
            endif()
            if(ALIB_PUBLIC_LINK_OPTIONS)
                target_link_options(${_variant} PUBLIC ${ALIB_PUBLIC_LINK_OPTIONS})
            endif()
            if(ALIB_PUBLIC_LINK_LIBS)
                target_link_libraries(${_variant} PUBLIC ${ALIB_PUBLIC_LINK_LIBS})
            endif()

            if(ALIB_OPTIONAL_CAIROMM AND DEFINED HAVE_CAIROMM AND HAVE_CAIROMM)
                foreach(_cinc IN LISTS CAIROMM_INCLUDE_DIRS)
                    target_include_directories(${_variant} PUBLIC
                        $<BUILD_INTERFACE:${_cinc}>
                    )
                endforeach()
                if(CAIROMM_LIBRARY_DIRS)
                    target_link_directories(${_variant} PUBLIC ${CAIROMM_LIBRARY_DIRS})
                endif()
                if(CAIROMM_LIBRARIES)
                    target_link_libraries(${_variant} PUBLIC ${CAIROMM_LIBRARIES})
                endif()
            endif()

            # Header FILE_SET
            target_sources(${_variant} PUBLIC
                FILE_SET ${ALIB_NAME}_headers
                BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
                TYPE HEADERS
                FILES ${ALIB_HEADERS}
            )

            # Build-tree alias for variant
            string(TOLOWER "${_kind}" _kind_lc)
            add_library(adaptagrams::${ALIB_NAME}_${_kind_lc} ALIAS ${_variant})

            # Install/export variant
            install(
                TARGETS ${_variant}
                EXPORT AdaptagramsTargets
                FILE_SET ${ALIB_NAME}_headers DESTINATION include/${ALIB_EXPORT_SUBDIR}
            )

            list(APPEND _variants ${_variant})
        endif()
    endforeach()

    list(LENGTH _variants _count)
    if(_count EQUAL 0)
        message(FATAL_ERROR "adaptagrams_add_library(${ALIB_NAME}): No variants built.")
    endif()

    # Internal chooser target name to avoid collisions with any legacy ALIAS targets
    set(_chooser "adaptagrams_${ALIB_NAME}_chooser")
    add_library(${_chooser} INTERFACE)
    if(TARGET ${ALIB_NAME}_SHARED AND NOT ADAPTAGRAMS_DEFAULT_TO_STATIC)
        target_link_libraries(${_chooser} INTERFACE ${ALIB_NAME}_SHARED)
    else()
        target_link_libraries(${_chooser} INTERFACE ${ALIB_NAME}_STATIC)
    endif()
    add_library(adaptagrams::${ALIB_NAME} ALIAS ${_chooser})
    install(TARGETS ${_chooser} EXPORT AdaptagramsTargets)

    # Record built component
    set(ADAPTAGRAMS_BUILT_COMPONENTS "${ADAPTAGRAMS_BUILT_COMPONENTS};${ALIB_NAME}" PARENT_SCOPE)
endfunction()