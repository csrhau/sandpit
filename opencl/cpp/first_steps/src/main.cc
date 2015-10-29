#include <cstdlib>
#include <iostream>
#include <vector>

#ifdef __APPLE__
  #include <OpenCL/cl.hpp>
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
  cl::Platform::get(&platforms);
  if (platforms.size() == 0) {
    std::cerr << "No OpenCL platforms found. Check OpenCL Installation" << std::endl;
    return EXIT_FAILURE;
  } 

  // Just choose the first platform
  cl::Platform& platform = platforms[0];
  std::vector<cl::Device> devices;
  platform.getDevices(CL_DEVICE_TYPE_ALL, &devices);
  if (devices.size() == 0) {
    std::cerr << "No devices found for OpenCL platform" 
              << platform.getInfo<CL_PLATFORM_NAME>() << std::endl;
    return EXIT_FAILURE;
  }

  std::vector<cl::Device> active_devices{devices[0]};
  cl::Context context(active_devices);
  cl::Program::Sources sources;
  
  return EXIT_SUCCESS;
}
