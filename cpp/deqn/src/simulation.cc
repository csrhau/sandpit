#include "simulation.h"

#include <iostream>
#include <algorithm>

#include "input_file.h"

Simulation::Simulation(int rows_, 
                       int cols_) : _rows(rows_), 
                                    _cols(cols_),
                                    _cx(0),
                                    _cy(0),
                                    _u0(new double[rows_ * cols_]),
                                    _u1(new double[rows_ * cols_]) {}
                                    
Simulation::~Simulation() {
  delete[] _u0;
  delete[] _u1;
}

void Simulation::setup(const InputFile& input_file_) {
  // TODO - this really needs thinking about carefully
  // let's have a get_border_width() and 
  // let's have a get_border_height() methods
  // and let's force the data to be non-bordery (i.e. they will be added in)
  // And we need a way to put the data into the border
  // - need to tweak the read a bit for this - sadface
  // - or do we? HDF5 being smart and whatever.


  const double dx = input_file_.get_width() / get_xspan();
  const double dy = input_file_.get_depth() / get_yspan();
  const double dt = input_file_.get_sigma() * dx * dy / input_file_.get_nu();
  _cx = input_file_.get_nu() * dt / (dx * dx);
  _cy = input_file_.get_nu() * dt / (dy * dy); 
}

void Simulation::advance() {
  diffuse();
  update_boundaries();
  std::swap(_u0, _u1);
}

int Simulation::get_rows() const { return _rows; }
int Simulation::get_cols() const { return _cols; }
int Simulation::get_xmin() const { return 1; }
int Simulation::get_xmax() const { return _cols - 1; }
int Simulation::get_xspan() const { return get_xmax() - get_xmin(); }
int Simulation::get_ymin() const { return 1; }
int Simulation::get_ymax() const { return _rows - 1; }
int Simulation::get_yspan() const { return get_ymax() - get_ymin(); }

double Simulation::temperature() const {
  double temp = 0;
  for (int i = get_ymin(); i < get_ymax(); ++i) {
    for (int j = get_xmin(); j < get_ymax(); ++j) {
      const int position = INDEX2D(i, j, _rows, _cols);
      temp += _u0[position]; 
    }
  }
  return temp;
}

// TODO: A Snapshot function which extracts inner data

void Simulation::diffuse() {
  for (int i = get_ymin(); i < get_ymax(); ++i) {
    for (int j = get_xmin(); j < get_ymax(); ++j) {
      const int center = INDEX2D(i, j, _rows, _cols);
      const int north = INDEX2D(i-1, j, _rows, _cols);
      const int west = INDEX2D(i, j-1, _rows, _cols);
      const int south = INDEX2D(i+1, j, _rows, _cols);
      const int east = INDEX2D(i, j+1, _rows, _cols);
      _u1[center] = _u0[center] 
                  + _cx * (_u0[west] - 2 * _u0[center] + _u0[east]) 
                  + _cy * (_u0[north] - 2 * _u0[center] + _u0[south]);
    }
  }
}

void Simulation::update_boundaries() {
  // Horizontal (top/bottom) boundaries
  for (int j = get_xmin(); j < get_ymax(); ++j) {
    // Top
    const size_t top_outer = INDEX2D(0, j, _rows, _cols);
    const size_t top_inner = INDEX2D(1, j, _rows, _cols);
    _u1[top_outer] = _u1[top_inner];
    // Bottom
    const size_t bottom_outer = INDEX2D(_rows-1, j, _rows, _cols);
    const size_t bottom_inner = INDEX2D(_rows-2, j, _rows, _cols);
    _u1[bottom_outer] = _u1[bottom_inner];
  }
  // Vertical (Left/Right) boundaries
  for (int i = get_ymin(); i < get_ymax(); ++i) {
    // Left
    const size_t left_outer = INDEX2D(i, 0, _rows, _cols);
    const size_t left_inner = INDEX2D(i, 1, _rows, _cols);
    _u1[left_outer] = _u1[left_inner];
    // Right
    const size_t right_outer = INDEX2D(i, _cols-1, _rows, _cols);
    const size_t right_inner = INDEX2D(i, _cols-2, _rows, _cols);
    _u1[right_outer] = _u1[right_inner];
  }
}
