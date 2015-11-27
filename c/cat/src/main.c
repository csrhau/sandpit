#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>


#define GETOPTS "f:h"
static char *progname;
static int show_help = 0;
static struct option long_opts[] = {
  {"file", required_argument, NULL, 'f'},
  {"help", no_argument, &show_help, 1},
  {0, 0, 0, 0}
};

void showHelp() {
  fprintf(stderr, "%s: A simple file reader.\n", progname);
  fprintf(stderr, "Usage: %s [OPTIONS]\n", progname);
  fprintf(stderr, "   --help         Show this message\n"
                  "   --file, -f <filename>  File to read from (defaults to stdin)\n");
}

void printLines(FILE *input) {
  char *line;
  ssize_t read;
  size_t len;
  int l = 0; 
  while ((read = getline(&line, &len, input)) != -1) {
    printf("%d:\t%s", l++, line); 
  } 
  if (line != NULL) {
    free(line);
  }
}

int main(int argc, char *argv[]) {
  progname = argv[0];
  char *infile = NULL;
  int optc, optid;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, &optid)) != -1) {
    switch (optc) {
      case 0: {
        if (long_opts[optid].flag == 0) {
          show_help = 1;
        } 
        break;
      }
      case 'f': {
        infile = strdup(optarg);
        break;
      }
      default: {
        show_help = 1;
        break;
      }
    }
  }
  if (show_help || optind < argc) {
    printf("%d %d %d\n", show_help, optind, argc);
    showHelp();

    return EXIT_FAILURE;
  }

  FILE *input_file = stdin;
  if (infile != NULL) {
    input_file = fopen(infile, "r");
    if (input_file == NULL) {
      fprintf(stderr, "Unable to open file %s!\n", infile);
      return EXIT_FAILURE;
    }
    free(infile);
  } 

  printLines(input_file);

  return EXIT_SUCCESS;
}
