# 
################################################################################

# project name
project(main_project)
cmake_minimum_required(VERSION 3.2.2)

include($ENV{GLOBAL_CMAKE_CONFIGS_DIR}/global_definitions.cmake)
include($ENV{GLOBAL_CMAKE_CONFIGS_DIR}/testing.cmake)


# enable testing
enable_global_testing()

# add all modules here
add_subdirectory(module_1)
add_subdirectory(module_3)
add_subdirectory(module_2)
