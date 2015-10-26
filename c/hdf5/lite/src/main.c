#include <stdio.h>
#include <stdlib.h>

#include "hdf5.h"
#include "hdf5_hl.h"

#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))

#define RANK 2
const char* file_name = "data.h5";
const char* dataset_name = "double_array";

const int border_width = 1;
const int data_rows = 11;
const int data_cols = 15;

void write(void) {
  double *output_data = malloc(data_rows * data_cols * sizeof(double));
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      output_data[i * data_cols + j] = MIN(MIN(i, j)+1, MIN(data_rows-i, data_cols-j));
    }
  }

  // Step zero - print out input for testing
  printf("Output Deck:\n");
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      printf("%.0f,", output_data[i * data_cols + j]);
    }
    printf("\n");
  }

  hid_t file_id;
  hsize_t dims[RANK] = {data_rows, data_cols};
  file_id = H5Fcreate(file_name, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
  H5LTmake_dataset(file_id, dataset_name, RANK, dims, H5T_NATIVE_DOUBLE, output_data);
  H5Fclose(file_id);
  free(output_data);
}

void read(void) {
  double *input_data = malloc(data_rows * data_cols * sizeof(double));
  herr_t status;
  hid_t file_id, dataset_id, dataspace_id;
  file_id = H5Fopen(file_name, H5F_ACC_RDWR, H5P_DEFAULT);
  H5LTread_dataset_double(file_id, dataset_name, input_data);
  printf("Input Deck:\n");
  for (int i = 0; i < data_rows; ++i) {
    for (int j = 0; j < data_cols; ++j) {
      printf("%.0f,", input_data[i * data_cols + j]);
    }
    printf("\n");
  }
  free(input_data);
  status = H5Fclose(file_id);
}
  
int main(int argc, char *argv[]) {
  printf("Hello, World!\n");
  write();
  read();
  return EXIT_SUCCESS;
}
