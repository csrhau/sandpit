cmake_minimum_required (VERSION 2.8)
project (openclapp)

set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}") 

file (GLOB CXX_HDRS *.h)
file (GLOB CXX_SRCS *.cc)
add_executable (openclapp.x ${CXX_SRCS} ${CXX_HDRS})
