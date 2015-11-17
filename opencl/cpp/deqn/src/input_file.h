#ifndef CASTLE_INPUT_FILE_H
#define CASTLE_INPUT_FILE_H

#include <string>
#include <vector>


#include "H5Cpp.h"

#define DEQN_DATASET "/temperature"
#define NDIMS 2

class InputFile {
  private:
    H5::H5File _file;
    H5::DataSet _dataset;
    H5::DataSpace _dataspace;
    hsize_t _dims[2];

    double _width;
    double _depth;
    double _nu;
    double _sigma;

  public:
    InputFile(std::string filename_);
    ~InputFile() = default;

    int get_rows() const;
    int get_cols() const;
    double get_width() const;
    double get_depth() const;
    double get_nu() const;
    double get_sigma() const;

    std::vector<double> get_data() const;
};

#endif
