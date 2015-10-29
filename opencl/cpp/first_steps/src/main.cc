#include <cstdlib>
#include <iostream>
#include <vector>

int main() {
  std::vector<int> digits{1,2,3,4,5,6,7,8,9};
  for (int i : digits) {
    std::cout << i << ", ";
  }
  std::cout << std::endl;

  return EXIT_SUCCESS;

}
