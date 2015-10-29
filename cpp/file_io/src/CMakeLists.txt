cmake_minimum_required (VERSION 2.6)
project (cppio)

set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")

include_directories ("${PROJECT_SOURCE_DIR}/tools")
add_subdirectory (tools) 
set(LINK_LIBS ${LINK_LIBS} tools)  

file(GLOB CXX_SRCS *.cc)
file(GLOB CXX_HDRS *.h)
add_executable(cppio ${CXX_SRCS} ${CXX_HDRS})
target_link_libraries (cppio ${LINK_LIBS})
