#ifndef CSRHAU_CFD_BATTERY_SIMULATION_H
#define CSRHAU_CFD_BATTERY_SIMULATION_H

#include "input_file.h"

#include "OpenCL.h"

#include <vector>

#define INDEX2D(row, col, rows, cols) ((row) * (cols) + (col))

class Simulation {
  private:
    int _rows;
    int _cols;
    double _width;
    double _depth;
    double _nu;
    double _sigma;
    double _cx;
    double _cy;
    double _initial_temp;
    std::vector<float> _state;
    std::vector<cl::Device> _devices;
    cl::Context _context;
    cl::CommandQueue _queue;
    cl::Kernel _temperature_kernel;
    cl::Kernel _diffusion_kernel;
    cl::Kernel _boundary_kernel;
    cl::Buffer _u0;
    cl::Buffer _u1;

  public:
    Simulation(const InputFile& infile_, const cl::Device& device_);
    ~Simulation() = default;
    Simulation(Simulation const&) = delete;
    Simulation& operator=(Simulation const&) = delete;
 
    void advance();
    double temperature() const;
    int get_rows() const;
    int get_cols() const;
    

  private:
    int get_xmin() const;
    int get_xmax() const;
    int get_ymin() const;
    int get_ymax() const;

    void diffuse();
    void update_boundaries();
    void syncronize_htod();
    void syncronize_dtoh();
};

#endif
