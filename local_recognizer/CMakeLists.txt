

cmake_minimum_required (VERSION 2.8)
message(STATUS "CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}") 
message(STATUS "INTEL_SAMPLE_DIR=${INTEL_SAMPLE_DIR}") 
file (GLOB_RECURSE SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
file (GLOB_RECURSE HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)

ie_add_sample(NAME local_recognizer
              SOURCES ${SOURCES}
              HEADERS ${HEADERS}
              INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include"
              OPENCV_DEPENDENCIES highgui)

file (GLOB MAIN_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
        )

file (GLOB MAIN_HEADERS
        ${CMAKE_CURRENT_SOURCE_DIR}/*.h
        )

# Create named folders for the sources within the .vcproj
# Empty name lists them directly under the .vcproj
source_group("src" FILES ${MAIN_SRC})
source_group("include" FILES ${MAIN_HEADERS})


include_directories("${INTEL_SAMPLE_DIR}/extension")
include_directories("${INTEL_SAMPLE_DIR}/extension/common")
include_directories("${INTEL_SAMPLE_DIR}/common/samples")
include_directories("../src")
include_directories (${InferenceEngine_INCLUDE_DIRS})

#set(TARGET_NAME "local_recognizer")
#
#if(OpenCV_FOUND)
#    add_definitions(-DUSE_OPENCV)
#endif()
#
#
## Properties->C/C++->General->Additional Include Directories
#include_directories (
#    ${InferenceEngine_INCLUDE_DIRS}
#)
#
#
#if(OpenCV_FOUND)
#    message(STATUS "OPENCV is enabled")
#else()
#    message(STATUS "OPENCV is disabled or not found, " ${TARGET_NAME} " skiped\n")
#    return()
#endif()
#
#if( BUILD_SAMPLE_NAME AND NOT ${BUILD_SAMPLE_NAME} STREQUAL ${TARGET_NAME} )
#    message(STATUS "SAMPLE ${TARGET_NAME} SKIPPED")
#    return()
#endif()
#
#file (GLOB MAIN_SRC
#        ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
#        )
#
#file (GLOB MAIN_HEADERS
#        ${CMAKE_CURRENT_SOURCE_DIR}/*.h
#        )
#
## Create named folders for the sources within the .vcproj
## Empty name lists them directly under the .vcproj
#source_group("src" FILES ${MAIN_SRC})
#source_group("include" FILES ${MAIN_HEADERS})
#
#
##Ana server side 
#include_directories ("../../../include")
#include_directories ("../../../")
#
##InferenceEngine side
#include_directories("${INTEL_SAMPLE_DIR}/extension")
#include_directories("${INTEL_SAMPLE_DIR}/extension/common")
#include_directories("${INTEL_SAMPLE_DIR}/common/samples")
#include_directories("../src")
#
#link_directories("/home/xiaojiang/Downloads/Ana/plugin/lib")
##set(CMAKE_EXE_LINKER_FLAGS "-L${DL_SDK_LIB} ")
#link_directories("/opt/intel/computer_vision_sdk_2018.3.323/inference_engine/lib/ubuntu_16.04/intel64")
#
#add_executable(${TARGET_NAME} main.cpp ${MAIN_HEADERS})
#
#
#set_target_properties(${TARGET_NAME} PROPERTIES "CMAKE_CXX_FLAGS" "${CMAKE_CXX_FLAGS} -fPIE"
#COMPILE_PDB_NAME ${TARGET_NAME})
#
#
#target_link_libraries(${TARGET_NAME}  cpu_extension inference_engine )
##target_link_libraries(${TARGET_NAME} -ldl -lplugin -fPIC -shared -std=gnu++11)
#target_link_libraries(${TARGET_NAME} -ldl -lplugin -fPIC -std=gnu++11)
#
#if(UNIX)
#    target_link_libraries( ${TARGET_NAME} ${LIB_DL} pthread ${OpenCV_LIBRARIES} )
#endif()