#include "accumulator.h"

#include <iostream>
#include <vector> 
#include <numeric>
#include <string>
#include <chrono>
#include <cmath>

#include "OpenCL.h"
#include "sources.h"

#define NVIDIA 2

namespace Kernels {

  // Todo: tune block size, number of blocks 
  float vecsum_accadd(cl::Buffer& input_,
                      cl::CommandQueue& queue_,
                      cl::Program& program_,
                      cl::Context& _context,
                      size_t elements_,
                      size_t block_size_) {

    // Why does this claim an incorrect checksum if set to 256?
    cl::NDRange global(elements_ / 512);
    cl::NDRange local(block_size_);
    size_t out_els = static_cast<size_t>(
      ceil(static_cast<double>(global[0]) / static_cast<double>(local[0]))
     );
    size_t outsize = out_els * sizeof(cl_float);
    cl::Buffer output = cl::Buffer(_context, CL_MEM_READ_ONLY, outsize);
    cl::Kernel kernel = cl::Kernel(program_, "vecsum_accadd");
    kernel.setArg(0, input_);
    kernel.setArg(1, output);
    kernel.setArg(2, sizeof(cl_float) * local[0], NULL);
    kernel.setArg(3, elements_);
    queue_.enqueueNDRangeKernel(kernel, cl::NullRange, global, local);
    std::vector<float> receiver(global[0]);
    queue_.enqueueReadBuffer(output, CL_TRUE, 0, outsize, receiver.data());
    return std::accumulate(receiver.begin(), receiver.end(), 0.0);
  }

  float vecsum_loadadd(cl::Buffer& input_,
                       cl::CommandQueue& queue_,
                       cl::Program& program_,
                       cl::Context& _context,
                       size_t elements_,
                       size_t block_size_) {
    size_t global_size = elements_ / 2;;
    size_t remainder = global_size % block_size_;
    if (remainder != 0) {
      global_size += block_size_ - remainder;
    }
    cl::NDRange global(global_size);
    cl::NDRange local(block_size_);
    size_t out_els = static_cast<size_t>(
      ceil(static_cast<double>(global[0]) / static_cast<double>(local[0]))
     );
    size_t outsize = out_els * sizeof(cl_float);

    cl::Buffer output = cl::Buffer(_context, CL_MEM_READ_ONLY, outsize);
    cl::Kernel kernel = cl::Kernel(program_, "vecsum_loadadd");
    kernel.setArg(0, input_);
    kernel.setArg(1, output);
    kernel.setArg(2, sizeof(cl_float) * local[0], NULL);
    kernel.setArg(3, elements_);
    queue_.enqueueNDRangeKernel(kernel, cl::NullRange, global, local);
    std::vector<float> receiver(out_els);
    queue_.enqueueReadBuffer(output, CL_TRUE, 0, outsize, receiver.data());
    return std::accumulate(receiver.begin(), receiver.end(), 0.0);
  }


  float __vecsum_simple_impl(cl::Buffer& input_,
                             cl::CommandQueue& queue_,
                             cl::Program& program_,
                             cl::Context& context_,
                             size_t elements_,
                             size_t block_size_,
                             const char* kernel_name_) {
    size_t global_size = elements_;
    size_t remainder = global_size % block_size_;
    if (remainder != 0) {
      global_size += block_size_ - remainder;
    }
    cl::NDRange global(global_size);
    cl::NDRange local(block_size_);
    size_t out_els = static_cast<size_t>(
      ceil(static_cast<double>(elements_) / static_cast<double>(local[0]))
     );
    size_t outsize = out_els * sizeof(cl_float);

    cl::Buffer output = cl::Buffer(context_, CL_MEM_READ_ONLY, outsize);
    cl::Kernel kernel = cl::Kernel(program_, kernel_name_);
    kernel.setArg(0, input_);
    kernel.setArg(1, output);
    kernel.setArg(2, sizeof(cl_float) * local[0], NULL);
    kernel.setArg(3, elements_);
    queue_.enqueueNDRangeKernel(kernel, cl::NullRange, global, local);
    std::vector<float> receiver(out_els);
    queue_.enqueueReadBuffer(output, CL_TRUE, 0, outsize, receiver.data());
    return std::accumulate(receiver.begin(), receiver.end(), 0.0);
  }

  float vecsum_contiguous(cl::Buffer& input_,
                          cl::CommandQueue& queue_,
                          cl::Program& program_,
                          cl::Context& context_,
                          size_t elements_,
                          size_t block_size_) {
    return __vecsum_simple_impl(input_, queue_, program_, context_, elements_, block_size_, "vecsum_contiguous");
  }

} // Namespace Kernels


Accumulator::Accumulator(const std::vector<float>& data_) : _data(data_) {
  std::vector<cl::Platform> platforms;
  cl::Platform::get(&platforms);
  _platform = platforms.front();

  _platform.getDevices(CL_DEVICE_TYPE_ALL, &_devices);
  _device = _devices[NVIDIA];
  std::cout << "Device:" <<  _device.getInfo<CL_DEVICE_NAME>() << std::endl;  
  _context = cl::Context(_devices);; 
  _queue = cl::CommandQueue(_context, _device, CL_QUEUE_PROFILING_ENABLE);
  std::string source = Tools::Sources::read_file("vecsum.cl");
  _options.append("-DEXPERIMENT_ONE"); // Just an example
  _program = Tools::Sources::build_program(source, _context, _devices, _options);
}

float Accumulator::sum() {
  // Copy data to the card
  // Copy data from the card
  const int elements = _data.size();
  const int datasize = elements * sizeof(float);
  cl::Buffer input  = cl::Buffer(_context, CL_MEM_READ_ONLY, datasize);
  _queue.enqueueWriteBuffer(input, CL_TRUE, 0, datasize, _data.data());

  // Timing loop
  float value = 0;
  std::chrono::steady_clock::time_point t_start = std::chrono::steady_clock::now();
  for (int i = 0; i < 100; ++i) {
    value += Kernels::vecsum_accadd(input, _queue, _program, _context, elements, 256); 
  }
  std::chrono::steady_clock::time_point t_end = std::chrono::steady_clock::now();
  std::chrono::duration<double> runtime = std::chrono::duration_cast<std::chrono::duration<double>>(t_end - t_start);
  std::cout << "Runtime: " << runtime.count() << " secs. Rand no: " <<  value << std::endl;

  return Kernels::vecsum_accadd(input, _queue, _program, _context, elements, 32); 
}
