#include <cstdlib>
#include <iostream>
#include <vector>

#ifdef __APPLE__
  #include "cl.hpp"
#else
  #include <CL/cl.hpp>
#endif


// Six constructs: Platform
//                 Device
//                 Context
//                 Program
//                 Kernel
//                 CommandQueue


int main() {
  std::vector<cl::Platform> platforms;
  std::vector<cl::Device> devices;
  cl::Platform::get(&platforms);
  if (platforms.size() == 0) {
    std::cerr << "No OpenCL platforms found. Check OpenCL Installation" << std::endl;
    return EXIT_FAILURE;
  } else {
    std::cout << "Platforms Available:\n";
    for (const cl::Platform& platform: platforms) {
      std::vector<cl::Device> devices;
      platform.getDevices(CL_DEVICE_TYPE_ALL, &devices);
      std::cout << "  - " << platform.getInfo<CL_PLATFORM_NAME>() << ", Devices:\n" ;
      for (const cl::Device& device : devices) {
        std::cout << "    + " << device.getInfo<CL_DEVICE_NAME>() << "\n";
      }
    }
  }
  return EXIT_SUCCESS;
}
