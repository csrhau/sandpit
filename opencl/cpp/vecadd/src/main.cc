#nclude <cstdlib>
#include <iostream>
#include <vector>

#define __CL_ENABLE_EXCEPTIONS
#ifdef __APPLE__
#include "cl.hpp"
#else
#include <CL/cl.hpp>
#endif

#include "sources.h"
#include "fpcompare.h"
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
    std::cout << "Performing task on device: " << device.getInfo<CL_DEVICE_NAME>() << std::endl; 
    cl::CommandQueue queue(context, device);

    // Create Memory Buffers
    cl::Buffer bufferA = cl::Buffer(context, CL_MEM_READ_ONLY, datasize);
    cl::Buffer bufferB = cl::Buffer(context, CL_MEM_READ_ONLY, datasize);
    cl::Buffer bufferC = cl::Buffer(context, CL_MEM_WRITE_ONLY, datasize);

    // Copy the input data to the input buffers
    queue.enqueueWriteBuffer(bufferA, CL_TRUE, 0, datasize, A.data());
    queue.enqueueWriteBuffer(bufferB, CL_TRUE, 0, datasize, B.data());

    std::string source = Tools::Sources::read_file("vecadd.cl");
    cl::Program program(context, source);
    try {
      program.build(devices);
    } catch (cl::Error& error) {
      if (error.err() == CL_BUILD_PROGRAM_FAILURE) { 
        std::cout << "Build Status: " << program.getBuildInfo<CL_PROGRAM_BUILD_STATUS>(device)
                  << "\nBuild Options: " << program.getBuildInfo<CL_PROGRAM_BUILD_OPTIONS>(device)
                  << "\nBuild Log:\n" << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(device)
                  << "\n---End---" << std::endl;
      }
      throw;
    }
    // Extract the kernels and specify arguments
    cl::Kernel vecadd_kernel(program, "vecadd4");
    { // Specify kernel arguments
      int arg = 0;
      vecadd_kernel.setArg(arg++, bufferA);
      vecadd_kernel.setArg(arg++, bufferB);
      vecadd_kernel.setArg(arg++, bufferC);
    }

    // Execute the kernel
    cl::NDRange global(elements);
    cl::NDRange local(256);

    queue.enqueueNDRangeKernel(vecadd_kernel, cl::NullRange, global, local);

    // Copy the output data back to the host
    queue.enqueueReadBuffer(bufferC, CL_TRUE, 0, datasize, C.data());

    int errors = 0;
    for (int i = 0; i < elements; ++i) {
      if (Tools::DoubleCompare::not_equal(A[i] + B[i], C[i])) {
        std::cerr << "Data mismatch at index " << i << ", expected: " 
                  << A[i] + B[i] << ", got: " << C[i] << std::endl;
        ++errors;
      }
    }
    if (errors) {
      std::cerr << "Data mismatches detected in " << errors << " out of "
                << elements << " possible cases! " << std::endl;
    } else {
      std::cout << "Success!" << std::endl;
    }
  } catch (cl::Error& error) {
    std::cerr << "Error in OpenCL Execution:" << error.what() 
              << "(" << error.err() << ")" << std::endl;
    return EXIT_FAILURE; 
  }
  return EXIT_SUCCESS;
}
