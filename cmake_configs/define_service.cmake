################################################################################
#
# This file defines the interface to add services in and include them on the modules
# We expect to have a structure like this
# root_project_dir
#  |- src
#  |   |- module_1
#  |   |- module_2
#  |- services
#  |   |- module_1
#  |       |- auto_gen (where the auto generated files will be created)
#  |...
#
# We will generate a lib per service called libservice_<module_name>
#

include (${GLOBAL_CMAKE_CONFIGS_DIR}/general_utils.cmake)

# Ensure we have the required libraries
set(SERVICE_GRPC_LIBRARIES protobuf grpc++ grpc grpc++_reflection)
assert_libs_exists(${SERVICE_GRPC_LIBRARIES})

# ensure we have the required variables set
assert_def_exists(ROOT_PROJECT_DIR)
set(SERVICE_ROOT_PROTO_DIR ${ROOT_PROJECT_DIR}/services)

# we need the compiler of protoc and the plugin
assert_file_exists("$ENV{ONLINELOCK_DEP_DIR}/bin/protoc")
assert_file_exists("$ENV{ONLINELOCK_DEP_DIR}/bin/grpc_cpp_plugin")
set(PROTOC_COMPILER "$ENV{ONLINELOCK_DEP_DIR}/bin/protoc")
set(SERVICE_GRPC_PLUGIN "$ENV{ONLINELOCK_DEP_DIR}/bin/grpc_cpp_plugin")


# we define here the general function that will compile the protos
# into the required headers and sources
function(service_grpc_generate_cpp SRCS HDRS SERVICE_PROTO_DIR OUTPUT_GEN_FOLDER)
    cmake_parse_arguments(service_grpc_generate_cpp "" "EXPORT_MACRO" "" ${ARGN})

    set(_proto_files "${service_grpc_generate_cpp_UNPARSED_ARGUMENTS}")
    if(NOT _proto_files)
        message(SEND_ERROR "Error: service_grpc_generate_cpp() called without any proto files")
        return()
    endif()

    if(SERVICE_GRPC_GENERATE_CPP_APPEND_PATH)
        set(_append_arg APPEND_PATH)
    endif()

    if(DEFINED SERVICE_GRPC_IMPORT_DIRS)
        set(_import_arg IMPORT_DIRS ${SERVICE_GRPC_IMPORT_DIRS})
    endif()

    # compile protos first
    execute_process(COMMAND 
        ${PROTOC_COMPILER} 
        "--proto_path=${SERVICE_PROTO_DIR}" 
        "--cpp_out=${OUTPUT_GEN_FOLDER}" 
        ${ARGN}
    )
    
    # compile the grpc part
    execute_process(COMMAND 
        ${PROTOC_COMPILER} 
        "--proto_path=${SERVICE_PROTO_DIR}" 
        "--grpc_out=${OUTPUT_GEN_FOLDER}"
        "--plugin=protoc-gen-grpc=${SERVICE_GRPC_PLUGIN}" 
        ${ARGN}
    )
    
    file(GLOB GRPCGenFiles "${OUTPUT_GEN_FOLDER}/*")

    foreach(_file ${GRPCGenFiles})
        if(_file MATCHES "cc$")
            list(APPEND ${SRCS} ${_file})
        elseif(_file MATCHES "h$")
            list(APPEND ${HDRS} ${_file})
        else()
            # nothing
        endif()
    endforeach()
    set(${SRCS} ${${SRCS}} PARENT_SCOPE)
    set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()


function(create_service_lib service_folder service_name)
    # generate the folder where we will put the headers and sources
    set(AUTOGEN_SERVICE_DIR ${service_folder}/auto_gen)
    execute_process(COMMAND "mkdir" "-p" ${AUTOGEN_SERVICE_DIR})

    file(GLOB ProtoFiles "${service_folder}/*.proto")
    message("   ----> ProtoFiles: ${ProtoFiles}")
    service_grpc_generate_cpp(
        PROTO_SRCS 
        PROTO_HDRS
        ${service_folder}
        ${AUTOGEN_SERVICE_DIR}
        ${ProtoFiles}
    )
    
    set(SERVICE_GRPC_SRCS ${PROTO_SRCS})
    set(SERVICE_GRPC_HDRS ${PROTO_HDRS})

    set(SERVICE_LIB_NAME service_${service_name})

    #add_definitions(${MODULE_DEFINITIONS})
    include_directories(${AUTOGEN_SERVICE_DIR})
    add_library(${SERVICE_LIB_NAME} SHARED ${SERVICE_GRPC_SRCS} ${SERVICE_GRPC_HDRS})
    if (CMAKE_SYSTEM_NAME STREQUAL Android)
      set_target_properties( ${SERVICE_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${MODULE_NAME}.so)
    else()
      set_target_properties(${SERVICE_LIB_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    target_link_libraries(${SERVICE_LIB_NAME} ${SERVICE_GRPC_LIBRARIES})

endfunction()

# Will biuld all the services on listed by names
function(build_services)
    foreach(service_name IN LISTS ARGN)
        set(CURR_SERVICE_FOLDER ${SERVICE_ROOT_PROTO_DIR}/${service_name})
        create_service_lib(${CURR_SERVICE_FOLDER} ${service_name})
    endforeach()
endfunction()




macro(use_service)
    set(all_services "${ARGN}")
    foreach(curr_service_name IN LISTS all_services)
        set(SRV_LIB_NAME service_${curr_service_name})
        set(SRV_INC_DIR ${SERVICE_ROOT_PROTO_DIR}/${service_name}/auto_gen)

        add_mod_dependencies(${SRV_LIB_NAME})
        add_mod_include_dirs(${SRV_INC_DIR})
    endforeach()
endmacro()


# Print path to generated files
# message ("SERVICE_GRPC_SRCS = ${SERVICE_GRPC_SRCS}")
# message ("SERVICE_GRPC_HDRS = ${SERVICE_GRPC_HDRS}")
# message ("SERVICE_GRPC_LIBRARIES = ${SERVICE_GRPC_LIBRARIES}")


