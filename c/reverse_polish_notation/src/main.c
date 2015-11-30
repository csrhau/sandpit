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

double interpret(struct Context * ctx, char* line_) {
  int stack_top = 0;
  double stack[MAX_TERMS];
  // Tokenize Program
  char *line = strdup(line_);
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
        free(line);
        exit(EXIT_FAILURE);
    }
    pptr = strtok(NULL, " ");
  }
  free(line);
  return stack[0];
}

size_t readLines(FILE *input, char **buffer) {
  rewind(input);
  char *line = NULL;
  size_t len;
  ssize_t read;
  size_t lines = 0;
  while ((read = getline(&line, &len, input)) != -1) {
    if (buffer) {
      // Strip newlines
      char *pos;
      if ((pos = strchr(line, '\n')) != NULL) {
        *pos = '\0';
      }
      buffer[lines] = strdup(line);
    }
    ++lines;
  }
  if (line) {
    free(line);
  }
  return lines;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
    return EXIT_FAILURE;
  }
  FILE *input_file = fopen(argv[1], "r");
  if (!input_file) {
    fprintf(stderr, "Unable to open file %s!\n", argv[1]);
    return EXIT_FAILURE;
  }

  // Count number of lines in file
  size_t lines = readLines(input_file, NULL);
  char **text = (char **) malloc(lines * sizeof (char*));
  readLines(input_file, text);

  // Process lines
  struct Context * ctx = createContext();
  for (size_t line = 0; line < lines; ++line) {
    printf("%f // %s\n", interpret(ctx, text[line]), text[line]);
    free(text[line]);
  }

  // Cleanup
  free(text);
  freeContext(ctx);
  fclose(input_file);
  return EXIT_SUCCESS;
}
