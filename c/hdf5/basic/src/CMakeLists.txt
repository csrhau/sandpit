cmake_minimum_required (VERSION 2.8)
project (basic.x)

find_package(HDF5 COMPONENTS C)
include_directories (${HDF5_INCLUDE_DIR})
set (LINK_LIBS ${LINK_LIBS} ${HDF5_LIBRARIES})
set (CMAKE_C_FLAGS "-std=c11 ${CMAKE_C_FLAGS}")
set(CMAKE_BUILD_TYPE Release)

file(GLOB C_SRCS *.c)
file(GLOB C_HDRS *.h)
add_executable(basic.x ${C_SRCS} ${C_HDRS})
target_link_libraries (basic.x ${LINK_LIBS})
