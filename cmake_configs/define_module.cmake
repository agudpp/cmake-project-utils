# Utilities to define a module and its variables

include (${GLOBAL_CMAKE_CONFIGS_DIR}/general_utils.cmake)

assert_def_exists(PROJECT_NAME)

set(MODULE_NAME ${PROJECT_NAME})
set(MODULE_DEFINITIONS "")
set(MODULE_INCLUDE_DIRS)
set(MODULE_DEPENDENCIES "")
set(MODULE_SOURCES_LIST "")
set(MODULE_HEADERS_LIST "")


# define current working directories for the module
set(PRJ_ROOT_DIR ${PROJECT_SOURCE_DIR})
set(SRC_ROOT_DIR ${PRJ_ROOT_DIR}/src)
set(INCLUDE_ROOT_DIR ${PRJ_ROOT_DIR}/include)


function(add_mod_sources)
    set(MODULE_SOURCES_LIST ${MODULE_SOURCES_LIST} ${ARGN} PARENT_SCOPE)
endfunction()

function(add_mod_headers)
    set(MODULE_HEADERS_LIST ${MODULE_HEADERS_LIST} ${ARGN} PARENT_SCOPE)
endfunction()

function(add_mod_definitions)
    set(MODULE_DEFINITIONS ${MODULE_DEFINITIONS} PARENT_SCOPE)
endfunction()

function(add_mod_dependencies)
    set(MODULE_DEPENDENCIES ${MODULE_DEPENDENCIES} ${ARGN} PARENT_SCOPE)
endfunction()

function(add_mod_include_dirs)
    set(all_args ${ARGV})
    message("BEFORE: ${MODULE_NAME}: MODULE_INCLUDE_DIRS -> ${MODULE_INCLUDE_DIRS}")
    set(MODULE_INCLUDE_DIRS ${MODULE_INCLUDE_DIRS} ${all_args} PARENT_SCOPE)
    message("AFTER: ${MODULE_NAME}: MODULE_INCLUDE_DIRS -> ${MODULE_INCLUDE_DIRS}")
    message(" ARGN: ${all_args}")
endfunction()

macro(add_dep_module DEP_MOD_NAME)
    assert_def_exists(${DEP_MOD_NAME}_MODULE_NAME)
    add_mod_definitions(${${DEP_MOD_NAME}_MODULE_DEFINITIONS})
    add_mod_dependencies(${${DEP_MOD_NAME}_MODULE_DEPENDENCIES})
    add_mod_include_dirs(${${DEP_MOD_NAME}_MODULE_INCLUDE_DIRS})
endmacro()


macro(_print_module_info)
    message("Module ${MODULE_NAME} information: ")
    print_var(MODULE_DEFINITIONS)
    print_var(MODULE_INCLUDE_DIRS)
    print_var(MODULE_DEPENDENCIES)
endmacro()

function(_common_module_build)
    add_definitions(${MODULE_DEFINITIONS})
    include_directories(${MODULE_INCLUDE_DIRS})

    # verbose mode
    if (${GLOBAL_VERBOSE_MODE})
        _print_module_info()
    endif()
endfunction()

function(create_module_lib)
    _common_module_build()
    add_library(${MODULE_NAME} SHARED ${MODULE_SOURCES_LIST} ${MODULE_HEADERS_LIST})
    if (CMAKE_SYSTEM_NAME STREQUAL Android)
      set_target_properties( ${MODULE_NAME} PROPERTIES IMPORTED_LOCATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${MODULE_NAME}.so)
    else()
      set_target_properties(${MODULE_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    target_link_libraries(${MODULE_NAME} ${MODULE_DEPENDENCIES})
endfunction()

function(create_module_executable)
    _common_module_build()
    add_executable(${MODULE_NAME} ${MODULE_SOURCES_LIST} ${MODULE_HEADERS_LIST})
    target_link_libraries(${MODULE_NAME} ${MODULE_DEPENDENCIES})
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
    set(${MODULE_NAME}_MODULE_DEPENDENCIES ${MODULE_DEPENDENCIES} ${MODULE_NAME}
        CACHE INTERNAL "${MODULE_NAME}: Dependencies" FORCE)
endmacro()


# Add the default values here
add_mod_include_dirs(${INCLUDE_ROOT_DIR})