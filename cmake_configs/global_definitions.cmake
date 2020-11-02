# GLOBAL definitions required for other .cmake files

##
## Options
##
option(OPT_GLOBAL_VERBOSE_MODE "if we want to print aditional information when compiling" ON)


set(GLOBAL_CMAKE_CONFIGS_DIR ${CMAKE_CURRENT_LIST_DIR})

# global verbose mode set on / false
set(CMAKE_VERBOSE_MAKEFILE ${OPT_GLOBAL_VERBOSE_MODE})

# detect if we are in DEBUG mode or not
set(DEBUG_MODE false)
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(DEBUG_MODE true)
    message("WE ARE IN DEBUG MODE")
endif ()

# CXX general flags and definitions
set(GLOBAL_CXX_FLAGS "-Wall -fPIC")
set(COMMON_DEFINITIONS "-DRAPIDJSON_HAS_STDSTRING=1")
if (DEBUG_MODE)
    set(GLOBAL_CXX_FLAGS "${GLOBAL_CXX_FLAGS} -ggdb3")
    set(COMMON_DEFINITIONS ${COMMON_DEFINITIONS} -DDEBUG -DUSE_DEBUG)
else()
    set(GLOBAL_CXX_FLAGS "${GLOBAL_CXX_FLAGS} -O3 -fwrapv")
    set(COMMON_DEFINITIONS "${COMMON_DEFINITIONS}")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GLOBAL_CXX_FLAGS}")
add_definitions(${COMMON_DEFINITIONS})


# set the ROOT_PROJECT_DIR if not set by default
if(NOT ROOT_PROJECT_DIR)
    set(ROOT_PROJECT_DIR ${PROJECT_SOURCE_DIR})
endif(NOT ROOT_PROJECT_DIR)
