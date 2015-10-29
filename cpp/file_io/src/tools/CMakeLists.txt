file(GLOB CXX_SRCS *.cc)

add_library(tools STATIC ${CXX_SRCS})
