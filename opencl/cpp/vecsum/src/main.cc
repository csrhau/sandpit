#include <cstdlib>
#include <iostream>
#include <numeric>
#include <vector>

#include "OpenCL.h"
#include "fpcompare.h"
#include "accumulator.h"
#include "vecsum_config.h"

int main(int argc, char *argv[]) {

  const int elements = 2048 << 8; // You will get errors much higher than this, because floats can't precisely hold ints over 2^24 + 1
  std::cout << elements << std::endl;
  std::vector<float> A(elements);
  for (int i = 0; i < elements; ++i) {
    A[i] = 16 - i % 32;
  }

  Accumulator acc(A);
  float expected, observed;
  expected = std::accumulate(A.begin(), A.end(), 0.f);
  observed = acc.sum();
  if (Tools::FloatCompare::not_equal(expected, observed)) {
    std::cerr << "Mismatch detected between expected: " << static_cast<long>(expected) 
              << " and observed: " << static_cast<long>(observed) << " values" << std::endl;

    return EXIT_FAILURE;
  } else {
    std::cout << "Succeeded to sum a large array!" << std::endl;
  }

  return EXIT_SUCCESS;
}
