#ifndef SANDPIT_CPP_ENGLISH_GREETER_H
#define SANDPIT_CPP_ENGLISH_GREETER_H

#include "greeter.h"

struct EnglishGreeter : Greeter<EnglishGreeter> {
  void implementation();
};


#endif
