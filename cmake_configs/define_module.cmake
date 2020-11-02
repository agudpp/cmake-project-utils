# Utilities to define a module and its variables

include (${GLOBAL_CMAKE_CONFIGS_DIR}/general_utils.cmake)

assert_def_exists(PROJECT_NAME)

set(MODULE_NAME ${PROJECT_NAME})
set(MODULE_DEFINITIONS "")
set(MODULE_INCLUDE_DIRS "")
set(MODULE_DEPENDENCIES "")
set(MODULE_SOURCES_LIST "")
set(MODULE_HEADERS_LIST "")


# define current working directories for the module
set(PRJ_ROOT_DIR ${PROJECT_SOURCE_DIR})
set(SRC_ROOT_DIR ${PRJ_ROOT_DIR}/src)
set(INCLUDE_ROOT_DIR ${PRJ_ROOT_DIR}/include)
set(TEST_ROOT_DIR ${PRJ_ROOT_DIR}/test)


function(add_mod_sources)
    set(temp_list ${MODULE_SOURCES_LIST} "${ARGN}")
    remove_dup_entries(temp_list temp_list_simplified)
    set(MODULE_SOURCES_LIST ${temp_list_simplified} PARENT_SCOPE)
endfunction()

function(add_mod_headers)
    set(temp_list ${MODULE_HEADERS_LIST} "${ARGN}")
    remove_dup_entries(temp_list temp_list_simplified)
    set(MODULE_HEADERS_LIST ${temp_list_simplified} PARENT_SCOPE)
endfunction()

function(add_mod_definitions)
    set(temp_list ${MODULE_DEFINITIONS} "${ARGN}")
    remove_dup_entries(temp_list temp_list_simplified)
    set(MODULE_DEFINITIONS ${temp_list_simplified} PARENT_SCOPE)
endfunction()

function(add_mod_dependencies)
    set(temp_list ${MODULE_DEPENDENCIES} "${ARGN}")
    remove_dup_entries(temp_list temp_list_simplified)
    set(MODULE_DEPENDENCIES ${temp_list_simplified} PARENT_SCOPE)
endfunction()

function(add_mod_include_dirs)
    set(temp_list ${MODULE_INCLUDE_DIRS} "${ARGN}")
    remove_dup_entries(temp_list temp_list_simplified)
    set(MODULE_INCLUDE_DIRS ${temp_list_simplified} PARENT_SCOPE)
endfunction()

macro(add_dep_module)
    set(all_modules "${ARGN}")
    foreach(curr_mod_name IN LISTS all_modules)
        assert_def_exists(${curr_mod_name}_MODULE_NAME)
        add_mod_definitions(${${curr_mod_name}_MODULE_DEFINITIONS})
        add_mod_dependencies(${${curr_mod_name}_MODULE_DEPENDENCIES}  ${${curr_mod_name}_MODULE_NAME})
        add_mod_include_dirs(${${curr_mod_name}_MODULE_INCLUDE_DIRS})
    endforeach()
endmacro()


macro(_print_module_info)
    message("\n\n*****************************************************")
    message("Module ${MODULE_NAME} information: ")
    message("*****************************************************")
    print_var(MODULE_DEFINITIONS)
    print_var(MODULE_INCLUDE_DIRS)    
    print_var(MODULE_DEPENDENCIES)
    # get_property(test_LINK_DIRECTORIES DIRECTORY PROPERTY LINK_DIRECTORIES)
    # get_property(test_INCLUDE_DIRECTORIES DIRECTORY PROPERTY INCLUDE_DIRECTORIES)
    # message("LINK_DIRECTORIES: ${test_LINK_DIRECTORIES}")
    # message("INCLUDE_DIRECTORIES: ${test_INCLUDE_DIRECTORIES}")
    message("-----------------------------------------------------")
endmacro()

function(_common_module_build)
    add_definitions(${MODULE_DEFINITIONS})
    include_directories(${MODULE_INCLUDE_DIRS})

    # verbose mode
    if (${OPT_GLOBAL_VERBOSE_MODE})
        _print_module_info()
    endif()
endfunction()

function(create_module_lib)
    _common_module_build()
    add_library(${MODULE_NAME} SHARED ${MODULE_SOURCES_LIST} ${MODULE_HEADERS_LIST})
    if (CMAKE_SYSTEM_NAME STREQUAL Android)
      set_target_properties(${MODULE_NAME} PROPERTIES IMPORTED_LOCATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${MODULE_NAME}.so)
      set_property(TARGET ${MODULE_NAME} PROPERTY IMPORTED_NO_SONAME 1)
    else()
      set_target_properties(${MODULE_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    target_link_libraries(${MODULE_NAME} ${MODULE_DEPENDENCIES})
endfunction()

function(configure_mod_install destination_dir)
    install(TARGETS ${MODULE_NAME} DESTINATION ${destination_dir})
endfunction()

function(create_module_executable)
    _common_module_build()
    add_executable(${MODULE_NAME} ${MODULE_SOURCES_LIST} ${MODULE_HEADERS_LIST})
    target_link_libraries(${MODULE_NAME} ${MODULE_DEPENDENCIES})
endfunction()

function(add_extra_module_executable extra_executable_name)
    _common_module_build()
    add_executable(${extra_executable_name} ${ARGN})
    target_link_libraries(${extra_executable_name} ${MODULE_DEPENDENCIES})
endfunction()


macro(expose_definitions)
    # Expose C's definitions (in this case only the ones of XXX transitively)
    # to other subprojects through cache variable.
    # Variables will be
    #   {project_name}_MODULE_NAME: the name of the module
    #   {project_name}_MODULE_DEFINITIONS the definitions of this module plus dependencies
    #   {project_name}_MODULE_INCLUDE_DIRS the include dirs of this module plus dependencies
    #   {project_name}_MODULE_DEPENDENCIES the dependencies of this module plus internal dependencies

    set(${MODULE_NAME}_MODULE_NAME ${MODULE_NAME}
        CACHE INTERNAL "${MODULE_NAME}: MODULE NAME" FORCE)
    set(${MODULE_NAME}_MODULE_DEFINITIONS ${MODULE_DEFINITIONS}
        CACHE INTERNAL "${MODULE_NAME}: Definitions" FORCE)
    # Expose toolbx public includes to other subprojects through cache variable.
    set(${MODULE_NAME}_MODULE_INCLUDE_DIRS ${MODULE_INCLUDE_DIRS}
        CACHE INTERNAL "${MODULE_NAME}: Include Directories" FORCE)
    set(${MODULE_NAME}_MODULE_DEPENDENCIES ${MODULE_DEPENDENCIES}
        CACHE INTERNAL "${MODULE_NAME}: Dependencies" FORCE)
endmacro()


# Add the default values here
add_mod_include_dirs(${INCLUDE_ROOT_DIR})



