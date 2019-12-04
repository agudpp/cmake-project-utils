# testing function utils

macro(enable_global_testing)
    # We assume gtest is enabled, we can perform some checks here
    # Locate GTest
    #find_package(GTest REQUIRED)
    #include_directories(${GTEST_INCLUDE_DIRS})
    enable_testing()
endmacro()

macro(add_module_test)
    if (CMAKE_SYSTEM_NAME STREQUAL Android)
    # do nothing for now
    else()
        set(TEST_FILES "${ARGN}")
        if(NOT TEST_FILES)
            message("Setting the default test_file ${MODULE_NAME}_test.cpp file")
            set(TEST_FILES ${TEST_ROOT_DIR}/${MODULE_NAME}_test.cpp)
        endif()
        set(GTEST_LIBRARIES gtest gtest_main gmock)
        add_executable(${MODULE_NAME}_test ${TEST_FILES})
        message("--- gtest_libraries: ${GTEST_LIBRARIES}")
        #message("--- GTEST_MAIN_LIBRARIES lib: ${GTEST_MAIN_LIBRARIES}")
        message("--- MODULE_NAME name test: ${MODULE_NAME}")
        target_link_libraries(${MODULE_NAME}_test ${GTEST_LIBRARIES} ${MODULE_DEPENDENCIES} ${MODULE_NAME})
        add_test(NAME ${MODULE_NAME}_test COMMAND ${MODULE_NAME}_test)    
    endif()
endmacro()
