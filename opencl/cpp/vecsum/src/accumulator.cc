#include "accumulator.h"

#include <iostream>
#include <vector> 
#include <numeric>
#include <string>
#include <cmath>

#include "OpenCL.h"
#include "sources.h"

#define INBUILD 0
#define NVIDIA 1

Accumulator::Accumulator(const std::vector<float>& data_) : _data(data_) {
  std::vector<cl::Platform> platforms;
  cl::Platform::get(&platforms);
  _platform = platforms.front();

  _platform.getDevices(CL_DEVICE_TYPE_GPU, &_devices);
  _device = _devices[NVIDIA];
  std::cout << "Device:" <<  _device.getInfo<CL_DEVICE_NAME>() << std::endl;  
  _context = cl::Context(_devices);; 
  _queue = cl::CommandQueue(_context, _device, CL_QUEUE_PROFILING_ENABLE);
  std::string source = Tools::Sources::read_file("vecsum.cl");
  _options.append("-DEXPERIMENT_ONE"); // Just an example
  _program = Tools::Sources::build_program(source, _context, _devices, _options);
  _sum_kernel = cl::Kernel(_program, "vecsum_contiguous");
}

float Accumulator::sum() {
  // Copy data to the card
  // Copy data from the card
  const int elements = _data.size();
  const int datasize = elements * sizeof(float);

  size_t local_size = 128;
  size_t global_size = _data.size();
  size_t remainder = global_size % local_size;
  if (remainder != 0) {
    global_size += local_size - remainder;
  }

  cl::NDRange local(local_size);
  cl::NDRange global(global_size);

  size_t out_els = static_cast<size_t>(
    ceil(static_cast<double>(_data.size()) / static_cast<double>(local[0]))
   );
  size_t outsize = out_els * sizeof(cl_float);

  cl::Buffer input  = cl::Buffer(_context, CL_MEM_READ_ONLY, datasize);
  cl::Buffer output = cl::Buffer(_context, CL_MEM_READ_ONLY, outsize);
  _queue.enqueueWriteBuffer(input, CL_FALSE, 0, datasize, _data.data());

  _sum_kernel.setArg(0, input);
  _sum_kernel.setArg(1, output);
  _sum_kernel.setArg(2, sizeof(cl_float) * local[0], NULL);
  _sum_kernel.setArg(3, elements);

  double duration_ns = 0;

  for(int i = 0; i < 1000; ++i) {
    cl::Event event;
    _queue.enqueueNDRangeKernel(_sum_kernel, cl::NullRange, global, local, NULL, &event);
    event.wait();
    duration_ns += event.getProfilingInfo<CL_PROFILING_COMMAND_END>() 
                - event.getProfilingInfo<CL_PROFILING_COMMAND_START>();
  }
   std::vector<float> receiver(out_els);
  _queue.enqueueReadBuffer(output, CL_TRUE, 0, outsize, receiver.data());
 

  std::cout << "vecsum kernel completed in " << duration_ns / 1e6 << "ms" << std::endl;
  return std::accumulate(receiver.begin(), receiver.end(), 0.0);
}
