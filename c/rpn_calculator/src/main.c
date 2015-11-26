#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

#include "parser.h"

#define GETOPTS "i:"
static char *progname;
static struct option long_opts[] = {
  {"input-file", required_argument, NULL, 'i'},
  {NULL, 0, NULL, 0}
};

void print_usage() {
  printf("%s: A simple mathematical expression parser written in C\n", progname);
  printf("    -i,    --input-file    Path to input file [required]\n"); 
}

int main(int argc, char *argv[]) {
  progname = argv[0];
  char *infile = NULL;
  int optc, show_usage = 0;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, NULL)) != -1) {
    switch (optc) {
      case 'i':
        infile = strdup(optarg);
        break;
     default:
        show_usage = 1;
    }
  }
  if (show_usage || optind < argc || infile == NULL) {
    print_usage();
    return EXIT_FAILURE;
  }

  parse("whatever");

  return EXIT_SUCCESS;
}

