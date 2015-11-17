#include "input_file.h"

#include <string>
#include <vector>
#include <exception>

#include "H5Cpp.h"

InputFile::InputFile(std::string filename_) : _file(filename_, H5F_ACC_RDONLY) {
  _dataset = _file.openDataSet(DEQN_DATASET);
  _dataspace = _dataset.getSpace();
  if (_dataspace.getSimpleExtentDims(_dims) != NDIMS) {
    throw std::logic_error("Data size mismatch!");
  };
}

int InputFile::get_rows() const {
  return _dims[0];
}
  
int InputFile::get_cols() const {
  return _dims[1];
}

double InputFile::get_width() const {
  return _width;
}

double InputFile::get_depth() const {
  return _depth;
}

double InputFile::get_nu() const {
  return _nu;
}

double InputFile::get_sigma() const {
  return _sigma;
}

std::vector<double> InputFile::get_data() const {
  std::vector<double> state(get_rows() * get_cols());
  _dataset.read(state.data(), H5::PredType::NATIVE_FLOAT);
  return state;
}
