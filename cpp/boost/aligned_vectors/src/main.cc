#include <cstdlib>
#include <iostream>

#include <vector>
#include <boost/align/aligned_allocator.hpp>

template <class T, std::size_t Alignment = 1>
using aligned_vector = std::vector<T, 
      boost::alignment::aligned_allocator<T, Alignment> >;

int main(int argc, char *argv[]) {
  std::cout << "Hello, World!" << std::endl;
  aligned_vector<double, 64> data_a(100);
  std::cout << &data_a[0] << std::endl; 
  aligned_vector<double, 128> data_b(100);
  std::cout << &data_b[0] << std::endl; 
  aligned_vector<double, 256> data_c(100);
  std::cout << &data_c[0] << std::endl; 
  return EXIT_SUCCESS;
}
