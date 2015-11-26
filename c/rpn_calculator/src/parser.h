#ifndef SHUNTING_PARSER_H
#define SHUNTING_PARSER_H

#define PARSE_FAILURE 1
#define PARSE_SUCCESS 0

#define COMMENT_DELIMITER "//"

int line_length(const char* line);
int parse(const char* line);

#endif
