#ifndef VECSUM_ACCUMULATOR_H
#define VECSUM_ACCUMULATOR_H

#include <vector> 

#include "OpenCL.h"

class Accumulator {
  private:
    const std::vector<float>& _data;
    std::vector<cl::Device> _devices;
    std::string _options;
    cl::Device _device;
    cl::Platform _platform;
    cl::Context _context;
    cl::CommandQueue _queue;
    cl::Program _program;
    cl::Kernel _sum_kernel;

  public:
    Accumulator(const std::vector<float>& data_);
    ~Accumulator() = default;
    Accumulator(Accumulator const&) = delete;
    Accumulator& operator=(Accumulator const&) = delete;

    float sum();
};

#endif
