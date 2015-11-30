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

int main(int argc, char *argv[]) {
  // Use stdin as input if no filename given
  FILE *input_file = stdin;
  // Use a single file if one argument is given
  if (argc == 2) {
    input_file = fopen(argv[1], "r");
    if (!input_file) {
      fprintf(stderr, "Unable to open file %s!\n", argv[1]);
      return EXIT_FAILURE;
    }
  }
  // 
  if (argc > 2) {
    fprintf(stderr, "Usage: %s [filename]\nToo many arguments!", argv[0]);
    return EXIT_FAILURE;
  }

  size_t len;
  ssize_t read;
  char *line = NULL;
  struct Context * ctx = createContext();
  while ((read = getline(&line, &len, input_file)) != -1) {
    // Remove trailing newline
    char *pos;
    if ((pos = strchr(line, '\n')) != NULL) {
        *pos = '\0';
    }
    char *line_copy = strdup(line);
    printf("%f // %s\n", interpret(ctx, line_copy), line);
    free(line_copy);
  }
  // Cleanup
  free(line);
  freeContext(ctx);
  return EXIT_SUCCESS;
}
