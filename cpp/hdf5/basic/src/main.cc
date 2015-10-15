#include <cstdlib>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>

#include "H5Cpp.h"

const std::string file_name("data.h5");
const std::string dataset_name("int_array");

const int rank = 2;
const int border_width = 1;
const int data_rows = 11;
const int data_cols = 15;

void write() {
  double output_data[data_rows][data_cols];
  // Populate our data in a pyramid fashion
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      output_data[i][j] = std::min(std::min(i, j)+1, std::min(data_rows-i, data_cols-j));
    }
  }

  // Step zero - print out input for testing
  std::cout << "Output Deck: " << std::endl;
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      std::cout << output_data[i][j] << ",";
    }
    std::cout << std::endl;
  }
  H5::H5File file(file_name, H5F_ACC_TRUNC);
  hsize_t dims[rank] = {data_rows, data_cols};
  H5::DataSpace dataspace(rank, dims);
  H5::DataSet dataset = file.createDataSet(dataset_name, H5::PredType::NATIVE_DOUBLE, dataspace);
  dataset.write(output_data, H5::PredType::NATIVE_DOUBLE);
}

void read() {

  H5::H5File file(file_name, H5F_ACC_RDWR);
  H5::DataSet dataset = file.openDataSet(dataset_name);
  H5::DataSpace dataspace = dataset.getSpace();
  hsize_t dims_in[rank];

  if ( dataspace.getSimpleExtentDims(dims_in) != rank) {
    throw std::logic_error("Data size mismatch!");
  };
  std::vector<double> input_data(dims_in[0] * dims_in[1]);
  dataset.read(&input_data[0], H5::PredType::NATIVE_DOUBLE);

  std::cout << "Input Deck: " << std::endl;
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      std::cout << input_data[i * data_cols + j] << ",";
    }
    std::cout << std::endl;
  }
}

int main(int argc, char *argv[]) {
  try {
    write();
    read();
  } catch (const H5::FileIException& error) { // caused by H5File operations
    error.printError();
    return EXIT_FAILURE; 
  } catch(const H5::DataSetIException& error) { // caused by DataSet operations
    error.printError();
    return EXIT_FAILURE; 
  } catch(H5::DataSpaceIException error) { // caused by the DataSpace operations
    error.printError();
    return EXIT_FAILURE; 
  }  
  return EXIT_SUCCESS;
}
