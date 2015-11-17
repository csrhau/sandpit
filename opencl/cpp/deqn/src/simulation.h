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
    std::vector<double> _state;
    std::vector<cl::Device> _devices;
    cl::Context _context;
    cl::CommandQueue _queue;
    cl::Program _program;
    std::string _build_opts;
    cl::Kernel _boundary_kernel;
    cl::Kernel _diffusion_kernel;
    cl::Kernel _temp_kernel;
    cl::NDRange _temp_local;
    cl::NDRange _temp_global;
    cl::Buffer _u0; // State tNow
    cl::Buffer _u1; // State tNext
    cl::Buffer _ut; // Intermediate temps

  public:
    Simulation(const InputFile& infile_, const cl::Device& device_);
    ~Simulation() = default;
    Simulation(Simulation const&) = delete;
    Simulation& operator=(Simulation const&) = delete;
 
    void advance();
    double temp() const;
    int get_rows() const;
    int get_cols() const;
    
  private:
    int get_xmin() const;
    int get_xmax() const;
    int get_ymin() const;
    int get_ymax() const;
    double get_initial_temp() const;

    void diffuse(); 
    void update_boundaries(); 
    void synchronize_htod(); 
    void syncronize_dtoh(); 
};

#endif
