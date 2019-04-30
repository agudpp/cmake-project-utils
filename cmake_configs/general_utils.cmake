# general utils methods


function(assert_def_exists def_to_check)
    if (NOT ${def_to_check})
        message(FATAL_ERROR "We expect to have a ${${def_to_check}} variable set")
    endif()
endfunction()


function(print_var var_to_print)
    message("${var_to_print}: ${${var_to_print}}")
endfunction()