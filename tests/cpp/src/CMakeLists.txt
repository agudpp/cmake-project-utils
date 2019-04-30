# 
################################################################################

# project name
project(main_project)
cmake_minimum_required(VERSION 3.2.2)

include(../../../cmake_configs/global_definitions.cmake)
include(${GLOBAL_CMAKE_CONFIGS_DIR}/testing.cmake)

# enable testing
enable_global_testing()

# add all modules here
add_subdirectory(module_1)
add_subdirectory(module_3)
add_subdirectory(module_2)
