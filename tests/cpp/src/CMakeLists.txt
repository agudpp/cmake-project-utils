# 
################################################################################

# project name
project(main_project)
cmake_minimum_required(VERSION 3.2.2)


include($ENV{GLOBAL_CMAKE_CONFIGS_DIR}/global_definitions.cmake)
include($ENV{GLOBAL_CMAKE_CONFIGS_DIR}/testing.cmake)

# specific folders
set(THIRD_PARTY_DIR ${ROOT_PROJECT_DIR}/third_party)


# add google test third party
# HACK to avoid installing google test in here
add_subdirectory(${THIRD_PARTY_DIR}/googletest EXCLUDE_FROM_ALL)


# enable testing
enable_global_testing()

# add all modules here
add_subdirectory(module_1)
add_subdirectory(module_3)
add_subdirectory(module_4)
add_subdirectory(module_2)
