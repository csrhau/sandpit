#include <stdio.h>
#include <stdlib.h>

#include "hdf5.h"

#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))

#define RANK 2

const char* file_name = "data.h5";
const char* dataset_name = "double_array";

const int inner_rows = 15;
const int inner_cols = 11;
const int border_width = 1;

// Note: inner means the core, unpadded data
//       outer means inner surrounded by a border_width border

void gather_write(void) {
  herr_t status;
  hsize_t dims_inner[RANK] = {inner_rows, inner_cols};
  hsize_t dims_outer[RANK] = {dims_inner[0] + 2 * border_width,
                              dims_inner[1] + 2 * border_width};
  double* outer_data = malloc(dims_outer[0] * dims_outer[1] * sizeof(double));

  printf("Output (write) deck:\n");
  for (int i = 0; i < dims_outer[0]; ++i) {
    for (int j = 0; j < dims_outer[1]; ++j) {
      outer_data[i * dims_outer[1] + j] = MIN(MIN(i, j), MIN(dims_outer[0]-i, dims_outer[1]-j)-1);
      printf("%.0f,",outer_data[i * dims_outer[1] + j]);
    }
    printf("\n");
  }

  hid_t file, dataset, filespace, memspace;
  file = H5Fcreate(file_name, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
  filespace = H5Screate_simple(RANK, dims_inner, NULL);
  // Create the dataset. 
  dataset = H5Dcreate(file, dataset_name, H5T_NATIVE_DOUBLE, filespace, 
                            H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
  // Create a dataspace which maps onto the array

  printf("Status at %d is %d\n", __LINE__, status);
  memspace = H5Screate_simple(RANK, dims_outer, NULL);
  // Create a hyperslab which maps to the inner core
  hsize_t offset[RANK] = {border_width, border_width};
  hsize_t stride[RANK] = {1, 1};
  hsize_t block[RANK] = {1, 1};
  H5Sselect_hyperslab(memspace, H5S_SELECT_SET, offset, stride, dims_inner, block);

  status = H5Dwrite(dataset, H5T_NATIVE_DOUBLE, memspace, filespace, H5P_DEFAULT, outer_data);
  status = H5Sclose(memspace);
  status = H5Sclose(filespace);
  status = H5Dclose(dataset);
  status = H5Fclose(file);
  free(outer_data);
}

void scatter_read(void) {
  herr_t status;
  hid_t file, dataset, filespace, memspace;
  file = H5Fopen(file_name, H5F_ACC_RDWR, H5P_DEFAULT);
  dataset = H5Dopen(file, dataset_name, H5P_DEFAULT);
  filespace = H5Dget_space(dataset);

  hsize_t dims_inner[RANK];
  H5Sget_simple_extent_dims(filespace, dims_inner, NULL); 
  printf(" Got an %llux%llu space\n", dims_inner[0], dims_inner[1]);

  hsize_t dims_outer[RANK] = {dims_inner[0] + 2 * border_width,
                              dims_inner[1] + 2 * border_width};
  // Create a dataspace which maps onto the array
  memspace = H5Screate_simple(RANK, dims_outer, NULL);
  // Create a hyperslab which maps to the inner core
  hsize_t offset[RANK] = {border_width, border_width};
  hsize_t stride[RANK] = {1, 1};
  hsize_t block[RANK] = {1, 1};
  H5Sselect_hyperslab(memspace, H5S_SELECT_SET, offset, stride, dims_inner, block);
  double* outer_data = malloc(dims_outer[0] * dims_outer[1] * sizeof(double));
  for (int i = 0; i < dims_outer[0] * dims_outer[1]; ++i) {
    outer_data[i] = 9;
  }

  // Read data from file to hyperslab
  status = H5Dread(dataset, H5T_NATIVE_DOUBLE, memspace, filespace, H5P_DEFAULT, outer_data);
  printf("Input (Read) Deck:\n");
  for (int i = 0; i < dims_outer[0]; ++i) {
    for (int j = 0; j < dims_outer[1]; ++j) {
      printf("%.0f,", outer_data[i * dims_outer[1] + j]);
    }
    printf("\n");
  }
  status = H5Sclose(memspace);
  status = H5Sclose(filespace);
  status = H5Dclose(dataset);
  status = H5Fclose(file);
  free(outer_data);
}
  
int main(int argc, char *argv[]) {
  gather_write();
  scatter_read();
  return EXIT_SUCCESS;
}
