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

    # EARLY: create chooser so dependent targets can link to adaptagrams::<name> immediately
    # Use real chooser name <name>, then ALIAS adaptagrams::<name> for canonical external usage.
    if(NOT TARGET ${ALIB_NAME})
        add_library(${ALIB_NAME} INTERFACE)
        add_library(adaptagrams::${ALIB_NAME} ALIAS ${ALIB_NAME})
        # Install chooser now (variants will also install later)
        install(TARGETS ${ALIB_NAME} EXPORT AdaptagramsTargets)
    endif()

    # Object library
    set(_obj "${ALIB_NAME}_obj")
    add_library(${_obj} OBJECT ${ALIB_SOURCES})
    set_target_properties(${_obj} PROPERTIES POSITION_INDEPENDENT_CODE ON)

    if(TGT_COMPILE_FLAGS)
        target_compile_options(${_obj} PRIVATE ${TGT_COMPILE_FLAGS})
    endif()
    if(ALIB_PUBLIC_COMPILE_OPTIONS)
        target_compile_options(${_obj} PRIVATE ${ALIB_PUBLIC_COMPILE_OPTIONS})
    endif()
    if(ALIB_PUBLIC_DEFINITIONS)
        target_compile_definitions(${_obj} PRIVATE ${ALIB_PUBLIC_DEFINITIONS})
    endif()
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
            string(TOLOWER "${_kind}" _kind_lc)
            set(_variant "${ALIB_NAME}_${_kind_lc}")
            add_library(${_variant} ${_kind} $<TARGET_OBJECTS:${_obj}>)
            set_target_properties(${_variant} PROPERTIES
                OUTPUT_NAME ${ALIB_NAME}
                POSITION_INDEPENDENT_CODE ON
            )

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
                # Link dependencies to variant; chooser gets them later
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

            target_sources(${_variant} PUBLIC
                FILE_SET ${ALIB_NAME}_headers
                BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
                TYPE HEADERS
                FILES ${ALIB_HEADERS}
            )

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

    # Update chooser with appropriate variant
    if(TARGET ${ALIB_NAME}_shared AND NOT ADAPTAGRAMS_DEFAULT_TO_STATIC)
        target_link_libraries(${ALIB_NAME} INTERFACE ${ALIB_NAME}_shared)
    else()
        target_link_libraries(${ALIB_NAME} INTERFACE ${ALIB_NAME}_static)
    endif()

    # Propagate PUBLIC_LINK_LIBS also to chooser (if specified)
    if(ALIB_PUBLIC_LINK_LIBS)
        target_link_libraries(${ALIB_NAME} INTERFACE ${ALIB_PUBLIC_LINK_LIBS})
    endif()
    if(ALIB_PUBLIC_INCLUDE_DIRS)
        foreach(_inc IN LISTS ALIB_PUBLIC_INCLUDE_DIRS)
            target_include_directories(${ALIB_NAME} INTERFACE
                $<BUILD_INTERFACE:${_inc}>
            )
        endforeach()
        target_include_directories(${ALIB_NAME} INTERFACE
            $<INSTALL_INTERFACE:include/${ALIB_EXPORT_SUBDIR}>
        )
    else()
        target_include_directories(${ALIB_NAME} INTERFACE
            $<INSTALL_INTERFACE:include/${ALIB_EXPORT_SUBDIR}>
        )
    endif()
    if(ALIB_PUBLIC_DEFINITIONS)
        target_compile_definitions(${ALIB_NAME} INTERFACE ${ALIB_PUBLIC_DEFINITIONS})
    endif()
    if(ALIB_PUBLIC_COMPILE_OPTIONS)
        target_compile_options(${ALIB_NAME} INTERFACE ${ALIB_PUBLIC_COMPILE_OPTIONS})
    endif()
    if(ALIB_PUBLIC_LINK_OPTIONS)
        target_link_options(${ALIB_NAME} INTERFACE ${ALIB_PUBLIC_LINK_OPTIONS})
    endif()

    # Track components globally
    get_property(_built GLOBAL PROPERTY ADAPTAGRAMS_BUILT_COMPONENTS)
    if(NOT _built)
        set(_built "")
    endif()
    list(APPEND _built "${ALIB_NAME}")
    list(REMOVE_DUPLICATES _built)
    set_property(GLOBAL PROPERTY ADAPTAGRAMS_BUILT_COMPONENTS "${_built}")
endfunction()