cmake_minimum_required (VERSION 2.6)
project (crtp)

file(GLOB CXX_SRCS *.cc)
file(GLOB CXX_HDRS *.h)
add_executable(crtp.x ${CXX_SRCS} ${CXX_HDRS})
target_link_libraries (crtp.x ${LINK_LIBS})
