cmake_minimum_required (VERSION 2.6)
project (mathparse)

file(GLOB CC_SRCS *.c)
file(GLOB CC_HDRS *.h)
add_executable(mathparse ${CC_SRCS} ${CC_HDRS})
