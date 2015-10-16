#include <stdio.h>
#include <stdlib.h>

#include "hdf5.h"

#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))

#define RANK 2
const char* file_name = "data.h5";
const char* dataset_name = "int_array";


const int border_width = 1;
const int data_rows = 11;
const int data_cols = 15;

void write(void) {
  double output_data[data_rows][data_cols];
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      output_data[i][j] = MIN(MIN(i, j)+1, MIN(data_rows-i, data_cols-j));
    }
  }

  // Step zero - print out input for testing
  printf("Output Deck:\n");
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      printf("%.0f,", output_data[i][j]);
    }
    printf("\n");
  }

  // N.B. Proper error handling omitted for brevity
  herr_t status;
  hid_t file_id, dataset_id, dataspace_id;
  hsize_t dims[RANK] = {data_rows, data_cols};
  file_id = H5Fcreate(file_name, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
  dataspace_id = H5Screate_simple(RANK, dims, NULL);
  /* Create the dataset. */
  dataset_id = H5Dcreate2(file_id, dataset_name, H5T_NATIVE_DOUBLE, dataspace_id, 
                                 H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
  // Write the data to the dataset
  status = H5Dwrite(dataset_id, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, output_data);
  status = H5Fclose(file_id);
}

void read(void) {
  double input_data[data_rows][data_cols];
  herr_t status;
  hid_t file_id, dataset_id, dataspace_id;
  file_id = H5Fopen(file_name, H5F_ACC_RDWR, H5P_DEFAULT);
  dataset_id = H5Dopen(file_id, dataset_name, H5P_DEFAULT);
  status = H5Dread(dataset_id, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, input_data);
  status = H5Fclose(file_id);

  printf("Input Deck:\n");
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      printf("%.0f,", input_data[i][j]);
    }
    printf("\n");
  }
}
  
int main(int argc, char *argv[]) {
  printf("Hello, World!\n");
  write();
  read();
  return EXIT_SUCCESS;
}
