#include <cstdlib>
#include <iostream>

#include "vecadd_config.h"

#ifdef __APPLE__
#include "cl.hpp"
#else
#include <CL/cl.h>
#endif

int main(int argc, char *argv[]) {
  
  cl_int status;
  cl_platform_id platform;
  status = clGetPlatformIDs(1, &platform, NULL);

  std::cout << "Hello, World!" <<  VECADD_VERSION_MAJOR << std::endl;
  return EXIT_SUCCESS;
}
