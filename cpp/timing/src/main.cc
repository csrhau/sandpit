#include <getopt.h>
#include <cstdlib>
#include <iostream>
#include <chrono>

float standard_candle(int size_, int iterations_) {
  float *a = new float[size_ * size_];
  float *b = new float[size_ * size_];
  float *c = new float[size_ * size_];
  for (int iter = 0; iter < iterations_; ++iter) {
    std::cout << "Iterate\n";
    //Initialize numbers to some arbitrary value
    for (int i = 0; i < size_ * size_; ++i) {
      a[i] = float(i) / (float(i)+1.0);
    }
    for (int i = 0; i < size_; ++i) {
      for (int j = 0; j < size_; ++j) {
        float acc = 0;
        for (int k = 0; k < size_; ++k) {
          acc += a[i * size_ + k] + b[k * size_ + j];
        }
        c[i*size_+j] = acc;
      }
    }
  }

  float accumulator;
  for (int i = 0; i < size_ * size_; ++i) {
    accumulator += c[i];
  }

  delete [] a;
  delete [] b;
  delete [] c;
  return accumulator;
}


int main(int argc, char *argv[]) {
  std::chrono::steady_clock::time_point t_start = std::chrono::steady_clock::now();
  float result = standard_candle(500, 10);
  std::chrono::steady_clock::time_point t_end = std::chrono::steady_clock::now();
  std::chrono::duration<double> runtime = std::chrono::duration_cast<std::chrono::duration<double>>(t_end - t_start);
  std::cout << "App Runtime: " << runtime.count() << " seconds." << std::endl;
  std::cout << "App result (to prevent optimisation): " << result << std::endl;

  return EXIT_SUCCESS;
}
