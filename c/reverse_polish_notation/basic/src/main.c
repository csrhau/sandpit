#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_TERMS 2048

enum token_type {
  VALUE,
  OPERATOR,
  INVALID
};

int isNumeric(const char * s)
{
    if (s == NULL || *s == '\0' || isspace(*s)) {
      return 0;
    }
    char * p;
    strtod (s, &p);
    return *p == '\0';
}

enum token_type typeOf(char *input) {
  if (isNumeric(input)) {
    return VALUE;
  }
  if (strlen(input) == 1) {
    return OPERATOR;
  }
  return INVALID;
}

double opPlus(double lhs, double rhs) { return lhs + rhs; }
double opMinus(double lhs, double rhs) { return lhs - rhs; }
double opTimes(double lhs, double rhs) { return lhs * rhs; }
double opDivide(double lhs, double rhs) { return lhs / rhs; }
double opPower(double lhs, double rhs) { return pow(lhs, rhs); }

typedef double (*operator) (double lhs, double rhs);
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

int main(void) {
  int stack_top = 0;
  double stack[MAX_TERMS];
  char program[] = "1 1 1 + +";

  // Tokenize Program
  char *pptr = strtok(program, " ");
  while (pptr != NULL) {
    switch (typeOf(pptr)) {
      case VALUE: {
        // Push value onto stack
        stack[stack_top] = strtod(pptr, NULL); 
        stack_top++;
        break;
      }
      case OPERATOR: {
          // Get the correct operator
          operator op = getOperator(pptr);
          if (op == NULL) {
            fprintf(stderr, "Unsupported operator: %s. Terminating!\n", pptr);
            return EXIT_FAILURE;
          }
          // Pop two values from the stack
          double lhs, rhs, result;
          lhs = stack[--stack_top];
          rhs = stack[--stack_top];
          // Apply the operator
          result = op(lhs, rhs);
          // Push result back to the stack
          stack[stack_top] = result;
          stack_top++;
          break;
      }
      case INVALID: // Fall through
      default:
        fprintf(stderr, "Invalid token: '%s'. Terminating!", pptr);
        return EXIT_FAILURE;
    }
    pptr = strtok(NULL, " ");
  }

  printf("The Answer is: %f\n", stack[0]);
  return EXIT_SUCCESS;
}
