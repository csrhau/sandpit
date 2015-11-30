#ifndef CONTEXT_H
#define CONTEXT_H

#define VAR_NAME_MAXLEN 32

// This file defines a number of helper structs and functions.
// In essence, this provides a very simple map implementation based on a vector.
// This map stores the name/value pairs corresponding to temporary variables
// defined by the RPN calculator.

struct Variable {
  char name[VAR_NAME_MAXLEN];
  double value;
};

struct Context {
  struct Variable *lookup_table;
  int size;
  int capacity;
};

struct Context * createContext();

void storeVariable(struct Context *context, char * name, double value);

int containsVariable(struct Context *context, char *name);

double readVariable(struct Context *context, char *name);

void freeContext(struct Context *context);

#endif
