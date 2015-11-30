#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stddef.h>

#include "context.h"
#include "operators.h"

#define MAX_TERMS 2048

enum token_type {
  VALUE,
  OPERATOR,
  COMMENT,
  ASSIGNMENT,
  VARIABLE,
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

enum token_type typeOf(char *input, struct Context * ctx) {
  if (isNumeric(input)) {
    return VALUE;
  }
  if (strlen(input) == 1) {
    return OPERATOR;
  }
  if (strcmp(input, "//") == 0) {
    return COMMENT;
  }
  if (strlen(input) > 1 && input[0] == ';' && input[1] != ';') {
    return ASSIGNMENT;
  }
  if (containsVariable(ctx, input)){
    return VARIABLE; 
  }
  return INVALID;
}

double interpret(struct Context * ctx, char* _line) {
  int stack_top = 0;
  double stack[MAX_TERMS];
  char *line = (char *) malloc(strlen(_line) * sizeof(char));
  strcpy(line, _line);
  // Tokenize Program
  char *pptr = strtok(line, " ");
  int finished = 0;
  while (pptr != NULL && !finished) {
    switch (typeOf(pptr, ctx)) {
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
            exit(EXIT_FAILURE);
          }
          // Pop two values from the stack
          double lhs, rhs, result;
          rhs = stack[--stack_top];
          lhs = stack[--stack_top];
          // Apply the operator
          result = op(lhs, rhs);
          // Push result back to the stack
          stack[stack_top] = result;
          stack_top++;
          break;
      }
      case COMMENT: {
        finished = 1;
        break;
      }
      case ASSIGNMENT: {
        // pptr+1 to skip semicolon, stack_top - 1 to peek at top item on stack
        storeVariable(ctx, pptr+1, stack[stack_top - 1]);
        break;
      }
      case VARIABLE: {
        // Push value onto stack
        stack[stack_top] = readVariable(ctx, pptr);
        stack_top++;
        break;
      }
      case INVALID: // Fall through
      default:
        fprintf(stderr, "Invalid token: '%s'. Terminating!\n", pptr);
        exit(EXIT_FAILURE);
    }
    pptr = strtok(NULL, " ");
  }
  return stack[0];
}

int main(void) {
  char *program[] = {
    "1 1 + ;two",  // 1 + 1 = 2
    "two two + ;four // A rather narly string",  // 
    "four two ^ ;big",
  };

  struct Context * ctx = createContext();
  for (int line = 0; line < 3; ++line) {
    printf("'%s' evaluates to %f \n", program[line], interpret(ctx, program[line]));
  }

  storeVariable(ctx, "alpha", 42);
  storeVariable(ctx, "bravo", 12);
  storeVariable(ctx, "gamma", 12);
  storeVariable(ctx, "delta", 12);
  printf("The value of alpha is %f\n", readVariable(ctx, "alpha"));
  printf("The value of two is %f\n", readVariable(ctx, "two"));

  freeContext(ctx);

  return EXIT_SUCCESS;
}
