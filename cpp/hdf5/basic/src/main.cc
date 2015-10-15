#include <cstdlib>
#include <string>
#include <iostream>
#include <algorithm>

#include "H5Cpp.h"

const std::string file_name("data.h5");
const std::string dataset_name("int_array");

const int rank = 2;
const int border_width = 1;
const int data_rows = 10;
const int data_cols = 10;

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
  double input_data[data_rows][data_cols];
  H5::H5File file(file_name, H5F_ACC_RDWR);
  H5::DataSet dataset = file.openDataSet(dataset_name);
  dataset.read(input_data, H5::PredType::NATIVE_DOUBLE);
  std::cout << "Input Deck: " << std::endl;
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      std::cout << input_data[i][j] << ",";
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
