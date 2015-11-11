#include "simulation.h"

#include <iostream>
#include <algorithm>


#include "input_file.h"
#include "OpenCL.h"

Simulation::Simulation(const InputFile& infile_,
                       const cl::Device& device_) : _rows(infile_.get_rows()),
                                                    _cols(infile_.get_cols()),
                                                    _width(infile_.get_width()),
                                                    _depth(infile_.get_depth()),
                                                    _nu(infile_.get_nu()),
                                                    _sigma(infile_.get_sigma()),
                                                    _state(_rows * _cols),
                                                    _devices{device_} {
  const double dx = infile_.get_width() / _cols;
  const double dy = infile_.get_depth() / _rows;
  const double dt = infile_.get_sigma() * dx * dy / infile_.get_nu();
  _cx = infile_.get_nu() * dt / (dx * dx);
  _cy = infile_.get_nu() * dt / (dy * dy); 
  infile_.populate_data(_state.data());





}

void Simulation::advance() {
  diffuse();
  update_boundaries();
  // TODO: Swap opencl vectors
}

int Simulation::get_rows() const { return _rows; }
int Simulation::get_cols() const { return _cols; }
int Simulation::get_xmin() const { return 1; }
int Simulation::get_xmax() const { return _cols - 1; }
int Simulation::get_ymin() const { return 1; }
int Simulation::get_ymax() const { return _rows - 1; }

double Simulation::temperature() const {
  // TODO
  return 0.0;
}

// TODO: A Snapshot function which extracts inner data

void Simulation::diffuse() {
  // TODO
}

void Simulation::update_boundaries() {
  // TODO
}