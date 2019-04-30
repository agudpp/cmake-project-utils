# run it cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=1
################################################################################
cmake_minimum_required(VERSION  3.2.2)

# project name
project(module_2 C CXX)

# define the module here, we expect to be called from the main cmake
# which include and define the main variables
include(${GLOBAL_CMAKE_CONFIGS_DIR}/define_module.cmake)

# Define the source list
add_mod_sources(
  ${SRC_ROOT_DIR}/main.cpp
)

# Define the header list
# add_mod_headers(
  
# )

# Define the library dependencies if any
add_mod_dependencies(
  # m # math lib
)

# Define the modules depenndecies

add_dep_module(
  module_1
)

# Add the include directories if any
# add_mod_include_dirs(
#   include_dir_1
# )


# build the module
create_module_executable()

# expose definitions
#expose_definitions()