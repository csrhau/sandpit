#ifndef CSRHAU_CFD_BATTERY_SIMULATION_H
#define CSRHAU_CFD_BATTERY_SIMULATION_H

#include "input_file.h"

#define INDEX2D(row, col, rows, cols) ((row) * (cols) + (col))

class Simulation {
  private:
    int _rows;
    int _cols;
    double _cx;
    double _cy;
    double *_u0;
    double *_u1;

  public:
    Simulation(int rows_, int cols_);
    ~Simulation();
    void setup(const InputFile& input_file_);
    void advance();
    int get_rows() const;
    int get_cols() const;
    int get_xmin() const;
    int get_xmax() const;
    int get_xspan() const;
    int get_ymin() const;
    int get_ymax() const;
    int get_yspan() const;
    double temperature() const;

  private:
    void diffuse();
    void update_boundaries();
};

#endif
