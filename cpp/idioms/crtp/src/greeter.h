#ifndef SANDPIT_CPP_GREETER_H
#define SANDPIT_CPP_GREETER_H

#include <iostream>
template <typename Derived>
class Greeter {
  private:
    void world() {
      std::cout << " World";
    }
    void punctuation() {
      std::cout << "!" << std::endl;

    }

  public:
    void greet() {
      static_cast<Derived*>(this)->implementation(); // 'Pure virtual, no default impl'
      world(); // Only present in the base class
      // Could also do static_cast... ->world(); to allow overriding
      static_cast<Derived*>(this)->punctuation(); // Defaulted in base, specialized in some derived classe
    }

};

#endif
