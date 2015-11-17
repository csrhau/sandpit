#include "simulation.h"

#include <cmath>
#include <iostream>
#include <algorithm>

#include "OpenCL.h"
#include "sources.h"
#include "input_file.h"

Simulation::Simulation(const InputFile& infile_,
                       const cl::Device& device_) : _rows(infile_.get_rows()),
                                                    _cols(infile_.get_cols()),
                                                    _width(infile_.get_width()),
                                                    _depth(infile_.get_depth()),
                                                    _nu(infile_.get_nu()),
                                                    _sigma(infile_.get_sigma()),
                                                    _state(_rows * _cols),
                                                    _devices{device_},
                                                    _context(_devices),
                                                    _queue(_context, device_),
                                                    _u0(_context, CL_MEM_READ_WRITE, _rows * _cols * sizeof(cl_float)), 
                                                    _u1(_context, CL_MEM_READ_WRITE, _rows * _cols * sizeof(cl_float)) {
  const double dx = infile_.get_width() / _cols;
  const double dy = infile_.get_depth() / _rows;
  const double dt = infile_.get_sigma() * dx * dy / infile_.get_nu();
  _cx = infile_.get_nu() * dt / (dx * dx);
  _cy = infile_.get_nu() * dt / (dy * dy); 
  _state = infile_.get_data();
  // Read in kernels
  _program = Tools::Sources::build_program("deqn.cl", _context, _devices, _build_opts);
  _boundary_kernel = cl::Kernel(_program, "reflect");
  _diffusion_kernel = cl::Kernel(_program, "diffuse");
  _temp_kernel = cl::Kernel(_program, "temperature");

  size_t wg_size, wg_count, elements = get_rows() * get_cols();
  _temp_kernel.getWorkGroupInfo(_devices.front(), 
                                       CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE, 
                                       &wg_size);
  // Optimized for serial components
  _temp_local = cl::NDRange(wg_size);
  _temp_global = cl::NDRange(fmax(1, elements / (10 * wg_size)));
  size_t intermediate_sz = sizeof(cl_float) * static_cast<size_t>(
      ceil(static_cast<double>(_temp_global[0]) / static_cast<double>(_temp_local[0]))
  );
  _ut = cl::Buffer(_context, CL_MEM_WRITE_ONLY, intermediate_sz);
  _temp_kernel.setArg(0, _u0);
  _temp_kernel.setArg(1, _ut);
  _temp_kernel.setArg(2, sizeof(cl_float) * wg_size, NULL);
  _temp_kernel.setArg(3, elements);

  synchronize_htod();
  update_boundaries(); // Set up boundary conditions
  _initial_temp = temp();
}

void Simulation::advance() {
  diffuse();
  update_boundaries();
}

int Simulation::get_rows() const { return _rows; }
int Simulation::get_cols() const { return _cols; }
int Simulation::get_xmin() const { return 1; }
int Simulation::get_xmax() const { return _cols - 1; }
int Simulation::get_ymin() const { return 1; }
int Simulation::get_ymax() const { return _rows - 1; }
double Simulation::get_initial_temp() const { return _initial_temp; }


double Simulation::temp() const {
  std::cout << _temp_global[0] << ", " << _temp_local[0] << std::endl;
  _queue.enqueueNDRangeKernel(_temp_kernel, cl::NullRange, _temp_global, _temp_local);
  
  // TODO
  return 0.0;
}

// TODO: A Snapshot function which extracts inner data

void Simulation::diffuse() {
  // TODO

  std::swap(_u0, _u1);
}

void Simulation::update_boundaries() {
  // operate on u0

  // TODO
}

void Simulation::synchronize_htod() {
  _queue.enqueueWriteBuffer(_u0, CL_TRUE, 0, _state.size() * sizeof(float), _state.data());
}

void Simulation::syncronize_dtoh() {
  _queue.enqueueReadBuffer(_u0, CL_TRUE, 0, _state.size() * sizeof(float), _state.data());
}
