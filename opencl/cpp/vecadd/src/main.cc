#include <cstdlib>
#include <iostream>
#include <vector>

#define __CL_ENABLE_EXCEPTIONS
#ifdef __APPLE__
#include "cl.hpp"
#else
#include <CL/cl.h>
#endif

#include "vecadd_config.h"

int main(int argc, char *argv[]) {

  const int elements = 2048;
  size_t datasize = elements * sizeof(int);
  std::vector<int> A(elements);
  std::vector<int> B(elements);
  std::vector<int> C(elements);

  // Expected answer = 2047 * 2048
  for (int i = 0; i < elements; ++i) {
    A[i] = i;
    B[i] = i;
  }

  try {
    std::vector<cl::Platform> platforms;
    std::vector<cl::Device> devices;
    // Use the first platform
    cl::Platform::get(&platforms);
    cl::Platform& platform = platforms.front();
    // Use the first (GPU) device
    platform.getDevices(CL_DEVICE_TYPE_GPU, &devices);
    cl::Device& device = devices.front();
    cl::Context context(devices);
    cl::CommandQueue queue(context, device);

    // Create Memory Buffers
    cl::Buffer bufferA = cl::Buffer(context, CL_MEM_READ_ONLY, datasize);
    cl::Buffer bufferB = cl::Buffer(context, CL_MEM_READ_ONLY, datasize);
    cl::Buffer bufferC = cl::Buffer(context, CL_MEM_WRITE_ONLY, datasize);

    // Copy the input data to the input buffers
    queue.enqueueWriteBuffer(bufferA, CL_TRUE, 0, datasize, A.data());
    queue.enqueueWriteBuffer(bufferB, CL_TRUE, 0, datasize, B.data());

  } catch (cl::Error& error) {
    std::cerr << error.what() << "(" << error.err() << ")" << std::endl;
    return EXIT_FAILURE; 
  }
  return EXIT_SUCCESS;
}
