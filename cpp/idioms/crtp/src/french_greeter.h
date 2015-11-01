#ifndef SANDPIT_CPP_FRENCH_GREETER_H
#define SANDPIT_CPP_FRENCH_GREETER_H

#include "greeter.h"

struct FrenchGreeter : public Greeter<FrenchGreeter> {
  void implementation();
  void punctuation(); //overrides base template
};


#endif
