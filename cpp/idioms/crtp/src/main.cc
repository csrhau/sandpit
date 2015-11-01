#include <cstdlib>

#include "english_greeter.h"
#include "french_greeter.h"

int main(int argc, char *argv[]) {
  EnglishGreeter greeter_e;
  FrenchGreeter greeter_f;
  greeter_e.greet();
  greeter_f.greet();

  return EXIT_SUCCESS;
}
