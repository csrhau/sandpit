cmake_minimum_required (VERSION 2.8)
project (type_convert.x)

find_package(HDF5 COMPONENTS CXX)
include_directories (${HDF5_INCLUDE_DIR})
set (LINK_LIBS ${LINK_LIBS} ${HDF5_LIBRARIES})
set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
set(CMAKE_BUILD_TYPE Release)

file(GLOB CXX_SRCS *.cc)
file(GLOB CXX_HDRS *.h)
add_executable(type_convert.x ${CXX_SRCS} ${CXX_HDRS})
target_link_libraries (type_convert.x ${LINK_LIBS})
