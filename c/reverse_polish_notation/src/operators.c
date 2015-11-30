#include "operators.h"

#include <math.h>
#include <stddef.h>

double opPlus(double lhs, double rhs) { return lhs + rhs; }
double opMinus(double lhs, double rhs) { return lhs - rhs; }
double opTimes(double lhs, double rhs) { return lhs * rhs; }
double opDivide(double lhs, double rhs) { return lhs / rhs; }
double opPower(double lhs, double rhs) { return pow(lhs, rhs); }

operator getOperator(char *op) {
  switch (op[0]) {
    case '+': return opPlus; 
    case '-': return opMinus; 
    case '*': return opTimes; 
    case '/': return opDivide; 
    case '^': return opPower;
    default: {
      return NULL;
    }
  }
}
