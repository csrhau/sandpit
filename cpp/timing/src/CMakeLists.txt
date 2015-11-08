cmake_minimum_required (VERSION 2.8)
project (timing)

set(CMAKE_BUILD_TYPE Release)
set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")

file(GLOB CXX_SRCS *.cc)
file(GLOB CXX_HDRS *.h)
add_executable(timing ${CXX_SRCS} ${CXX_HDRS})
