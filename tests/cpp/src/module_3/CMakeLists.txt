################################################################################
cmake_minimum_required(VERSION  3.2.2)

# project name
project(module_3 C CXX)

# define the module here, we expect to be called from the main cmake
# which include and define the main variables
include(${GLOBAL_CMAKE_CONFIGS_DIR}/define_module.cmake)

# Define the source list
add_mod_sources(
  ${SRC_ROOT_DIR}/test.cpp
)

# Define the header list
add_mod_headers(
  ${INCLUDE_ROOT_DIR}/${MODULE_NAME}/mod_3_test.h
)

# Define the library dependencies if any
add_mod_dependencies(
)

# Define the modules depenndecies
add_dep_module(
  module_1
)

# Add the include directories if any
# add_mod_include_dirs(
#   include_dir_1
# )


# module definitions
add_mod_definitions(
    -DD2
)

# build the module
create_module_lib()

# expose definitions
expose_definitions()

# enable or not testing for this module
# add_module_test(
#     # files here of testing if not the default one will be used
# )