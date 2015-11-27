#ifndef OPERATORS_H
#define OPERATORS_H

// typedef function pointer type
typedef double (*operator) (double lhs, double rhs);

double opPlus(double lhs, double rhs);
double opMinus(double lhs, double rhs);
double opTimes(double lhs, double rhs);
double opDivide(double lhs, double rhs);
double opPower(double lhs, double rhs);

operator getOperator(char *op);

#endif
