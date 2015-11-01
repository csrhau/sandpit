cmake_minimum_required (VERSION 3.1)
project (vecadd)

set (VECADD_VERSION_MAJOR 1)
set (VECADD_VERSION_MINOR 0)

# Include kernels directory
add_subdirectory(kernels)
# Auto-configure #define vars
configure_file (
  "${PROJECT_SOURCE_DIR}/vecadd_config.h.in"
  "${PROJECT_BINARY_DIR}/vecadd_config.h"
)
# Copy across the kernel files
include_directories("${PROJECT_BINARY_DIR}")

set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}") 

# Find OpenCL
find_package(OpenCL REQUIRED)
if (APPLE)
  include_directories ("${PROJECT_SOURCE_DIR}/cpp_bindings")
endif()
include_directories(${OpenCL_INCLUDE_DIR})
set(LINK_LIBS ${LINK_LIBS} ${OpenCL_LIBRARIES})

file (GLOB CXX_HDRS *.h)
file (GLOB CXX_SRCS *.cc)
add_executable (vecadd.x ${CXX_SRCS} ${CXX_HDRS})
target_link_libraries(vecadd.x ${LINK_LIBS})
