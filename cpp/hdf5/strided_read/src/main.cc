#include <cstdlib> 
#include <string> 
#include <iostream>
#include <algorithm>

#include "H5Cpp.h"

const std::string file_name("data.h5");
const std::string dataset_name("int_array");

const int rank = 2;
const int border_width = 1;
const int inner_rows = 10;
const int inner_cols = 10;
const int outer_rows = border_width + inner_rows + border_width;
const int outer_cols = border_width + inner_cols + border_width;


// Note: inner means the core, unpadded data
//      outer means inner surrounded by a border_width border

void gather_write() {
  // Allocate space to hold padded output data
  double outer_data[outer_rows][outer_cols];
  // Populate our data in a pyramid fashion
  std::cout << "Outer (padded) data before write:" << std::endl;
  for (int i = 0; i < outer_rows; ++i) {
    for (int j = 0; j < outer_cols; ++j) {
      outer_data[i][j] = std::min(std::min(i, j), std::min(outer_rows-i, outer_cols-j)-1);
      std::cout << outer_data[i][j] << ",";
    }
    std::cout << std::endl;
  }

  H5::H5File file(file_name, H5F_ACC_TRUNC);
  hsize_t inner_dims[rank] = {inner_rows, inner_cols};
  H5::DataSpace filespace(rank, inner_dims);
  H5::DataSet dataset = file.createDataSet(dataset_name, H5::PredType::NATIVE_DOUBLE, filespace);

  // Create a dataspace which maps onto the array
  hsize_t outer_dims[rank] = {outer_rows, outer_cols};
  H5::DataSpace memspace(rank, outer_dims);
  // Create a hyperslab which maps to the inner core
  hsize_t offset[rank] = {border_width, border_width};
  hsize_t count[rank] = {inner_rows, inner_cols};
  hsize_t stride[rank] = {1, 1};
  hsize_t block[rank] = {1, 1};
  memspace.selectHyperslab(H5S_SELECT_SET, count, offset, stride, block);
  dataset.write(outer_data, H5::PredType::NATIVE_DOUBLE, memspace, filespace); 
}

void scatter_read() {
  // Allocate space to hold padded input data
  double outer_data[outer_rows][outer_cols];
  // fill with known values - to validate
  std::cout << "Outer (padded) data before read:" << std::endl;
  for (int i = 0; i < outer_rows; ++i) {
    for (int j = 0; j < outer_cols; ++j) {
      outer_data[i][j] = 9;
      std::cout << outer_data[i][j] << ",";
    }
    std::cout << std::endl;
  }

  H5::H5File file(file_name, H5F_ACC_RDWR);
  H5::DataSet dataset = file.openDataSet(dataset_name);
  H5::DataSpace filespace = dataset.getSpace();
  
  // Create a dataspace which maps onto the array
  hsize_t outer_dims[rank] = {outer_rows, outer_cols};
  H5::DataSpace memspace(rank, outer_dims);
  // Create a hyperslab which maps to the inner core
  hsize_t offset[rank] = {border_width, border_width};
  hsize_t count[rank] = {inner_rows, inner_cols};
  hsize_t stride[rank] = {1, 1};
  hsize_t block[rank] = {1, 1};

  memspace.selectHyperslab(H5S_SELECT_SET, count, offset, stride, block);

  // Read from the file to the inner hyperslab
  dataset.read(outer_data, H5::PredType::NATIVE_DOUBLE, memspace, filespace); 

  std::cout << "Outer (padded) data after read:" << std::endl;
  for (int i = 0; i < outer_rows; ++i) {
    for (int j = 0; j < outer_cols; ++j) {
      std::cout << outer_data[i][j] << ",";
    }
    std::cout << std::endl;
  }
}

int main(int argc, char *argv[]) {
  try {
    gather_write();
    scatter_read();
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
