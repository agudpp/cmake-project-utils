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
  message("--- ARG_LIST: ${ARG_LIST}")
  list(REMOVE_DUPLICATES ARG_LIST)
  # string (REGEX REPLACE "([^\\]|^);" "\\1 " _TMP_STR "${ARG_LIST}")
  # string (REGEX REPLACE "[\\](.)" "\\1" _TMP_STR "${_TMP_STR}") #fixes escaping
  set(RESULT_VAL "${ARG_LIST}")
  message("---- RESULT_VAL: ${RESULT_VAL}")
  set(${OUTPUT} RESULT_VAL PARENT_SCOPE)
endfunction()