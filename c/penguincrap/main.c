#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include "sampling.h"

#define GETOPTS "f:h"
static char *progname;
static int show_help = 0;
static struct option long_opts[] = {
  {"file", required_argument, NULL, 'f'},
  {"help", no_argument, &show_help, 1},
  {0, 0, 0, 0}
};

void showHelp() {
  fprintf(stderr, "%s: A data gathering tool for PowerInsight.\n", progname);
  fprintf(stderr, "Usage: %s [OPTIONS]\n", progname);
  fprintf(stderr, "   --help         Show this message\n"
                  "   --file, -f <filename>  File to write data to MANDATORY\n");
}

volatile int halted = 0;
void sig_handler(int signo) {
  if (signo == SIGINT) {
    halted = 1;
  }
}

int main(int argc, char *argv[]) {
  progname = argv[0];
  char *outfile = NULL;
  int optc, optid;
  int required_args = 1;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, &optid)) != -1) {
    switch (optc) {
      case 0: {
        if (long_opts[optid].flag == 0) {
          show_help = 1;
       } 
        break;
      }
      case 'f': {
        required_args--;
        outfile = strdup(optarg);
        break;
      }
      default: {
        show_help = 1;
        break;
      }
    }
  }
  if (show_help || optind < argc || required_args > 0) {
    showHelp();
    return EXIT_FAILURE;
  }

  // Register Interrupt Handler
  if (signal(SIGINT, sig_handler) == SIG_ERR) {
    fprintf(stderr, "\ncan't catch SIGINT\n");
    return EXIT_FAILURE;
  }

  // Open output file
  FILE * output_file;
  output_file = fopen(outfile, "w");
  if (output_file == NULL) {
    fprintf(stderr, "Unable to open file %s for writing!\n", outfile);
    return EXIT_FAILURE;
  }
  free(outfile);

  // Print header
  fprintf(output_file, "Timestamp,");
  for (int port = 1; port < 16; ++port) {
    fprintf(output_file, "Ch%d milliamps,Ch%d Millivolts,Ch%d Milliwatts,", port, port, port);
  }
  fprintf(output_file, "\n");

  struct timeval t_start, t_now;
  // Main sampling loop
  gettimeofday( &t_start, NULL );
  while (!halted) {
    // hack something shitty, CBA with unix timers.
    usleep(100000); // 1/10th of a second, vaguely, ish
    gettimeofday( &t_now, NULL );
    fprintf(output_file, "%ld.%d,", (long int) (t_now.tv_sec - t_start.tv_sec), (int) t_now.tv_usec); 
    for (int port = 1; port < 16; ++port) {
      reading_t result = read_channel(port);
      fprintf(output_file, "%d,%d,%d,", result.miliamps, result.milivolts, result.miliwatts);
    }
    fprintf(output_file, "\n");
  }

  // Tidy up
  fclose(output_file);
  printf("o\nExiting!\n");
  return EXIT_SUCCESS;
}
