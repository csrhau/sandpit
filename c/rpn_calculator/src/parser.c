#include "parser.h"
#include "stdio.h"
#include "string.h"

int line_length(const char* line) {
  char * comment = strstr(line, COMMENT_DELIMITER);
  if (comment != NULL) {
    return comment - line;
  }
  // No comments. Just return length of the string
  return strlen(line);
}

int parse(const char* line) {
  char *tests[2] = {"hello", "hello// world"};
  for (int t = 0; t < 2; ++t) {
    printf("length of %s: %d\n", tests[t], line_length(tests[t])); 
  }

  return PARSE_SUCCESS;
}
