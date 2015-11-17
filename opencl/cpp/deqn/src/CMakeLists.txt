cmake_minimum_required (VERSION 2.8)

project (cldeqn)
set(CMAKE_BUILD_TYPE Release)
set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")

# Include HDF5
find_package(HDF5 COMPONENTS CXX)
include_directories (${HDF5_INCLUDE_DIR})
set (LINK_LIBS ${LINK_LIBS} ${HDF5_LIBRARIES})

# Include OpenCL
find_package(OpenCL REQUIRED)
if (APPLE)
  include_directories ("${PROJECT_SOURCE_DIR}/cpp_bindings")
endif()
include_directories(${OpenCL_INCLUDE_DIR})
set(LINK_LIBS ${LINK_LIBS} ${OpenCL_LIBRARIES})

# Include the kernels and testcases subdirectories
add_subdirectory(kernels)
add_subdirectory(testcases)

file(GLOB CXX_SRCS *.cc)
file(GLOB CXX_HDRS *.h)
add_executable(cldeqn ${CXX_SRCS} ${CXX_HDRS})
target_link_libraries (cldeqn ${LINK_LIBS})
