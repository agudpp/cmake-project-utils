# general utils methods


function(assert_def_exists def_to_check)
    if (NOT ${def_to_check})
        message(FATAL_ERROR "We expect to have a ${def_to_check} variable set")
    endif()
endfunction()


function(print_var var_to_print)
    message("${var_to_print}: ${${var_to_print}}")
endfunction()

function(remove_dup_entries ARG_STR OUTPUT)
  set(ARG_LIST "${${ARG_STR}}")
  separate_arguments(ARG_LIST)
  list(REMOVE_DUPLICATES ARG_LIST)
  # string (REGEX REPLACE "([^\\]|^);" "\\1 " _TMP_STR "${ARG_LIST}")
  # string (REGEX REPLACE "[\\](.)" "\\1" _TMP_STR "${_TMP_STR}") #fixes escaping
  set(RESULT_VAL "${ARG_LIST}")
  set(${OUTPUT} ${RESULT_VAL} PARENT_SCOPE)
endfunction()

function(assert_lib_exists lib_name)
  unset(_THE_LIB_TO_FIND CACHE)
  find_library(_THE_LIB_TO_FIND NAMES ${lib_name})
  if(NOT _THE_LIB_TO_FIND)
    message(FATAL_ERROR "the library ${lib_name} is required and was not found")
  else()
    message(STATUS "lib ${lib_name} found in ${_THE_LIB_TO_FIND}")
  endif()
endfunction()

function(assert_libs_exists)
  foreach(the_lib IN LISTS ARGN)
    assert_lib_exists(${the_lib})
  endforeach()
endfunction()

function(assert_file_exists file_path)
  if(NOT EXISTS "${file_path}")
    message(FATAL_ERROR "the file ${file_path} does not exists and is required")
  endif()
endfunction()
