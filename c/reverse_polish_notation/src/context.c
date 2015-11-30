#include "context.h"

#include <stdlib.h>
#include <string.h>


struct Context * createContext() {
  // Create an empty context with initial capacity of a single variable.
  struct Context * context = (struct Context *) malloc(sizeof(struct Context));
  context->size = 0;
  context->capacity = 1;
  context->lookup_table = (struct Variable *) malloc(sizeof(struct Variable));
  return context;
}

void storeVariable(struct Context *context, char * name, double value) {
  if (containsVariable(context, name)) {
    // We already have storage reserved for this variable
    for (int i = 0; i < context->size; ++i) {
      if (strcmp(context->lookup_table[i].name, name) == 0) {
        context->lookup_table[i].value = value;
        break;
      }
    }
  } else {
    if (context->size == context->capacity) {
      // context is full! We must enlarge it
      int new_capacity = context->capacity * 2;
      context->lookup_table = realloc(context->lookup_table, new_capacity * sizeof(struct Variable));
      context->capacity = new_capacity;
    }
    // Guaranteed to have enough space, populate new variable
    strcpy(context->lookup_table[context->size].name, name);
    context->lookup_table[context->size].value = value;
    context->size += 1;
  }
}

int containsVariable(struct Context *context, char *name) {
  int found = 0;
  for (int i = 0; i < context->size && !found; ++i) {
    if (strcmp(context->lookup_table[i].name, name) == 0) {
      found = 1;
    }
  }
  return found;
}

double readVariable(struct Context *context, char *name) {
  for (int i = 0; i < context->size; ++i) {
    if (strcmp(context->lookup_table[i].name, name) == 0) {
      return context->lookup_table[i].value;
    } 
  }
  // Fails silently
  return 0.0;
}

void freeContext(struct Context *context) {
  free(context->lookup_table);
  free(context);
}
