#include <getopt.h>
#include <cstdlib>
#include <iostream>

#include "input_file.h"
#include "simulation.h"

#define GETOPTS "i:p:r:t:"
static char *progname;
static struct option long_opts[] = {
  {"infile", required_argument, NULL, 'i'},
  {"prefix", required_argument, NULL, 'p'},
  {"output-rate", required_argument, NULL, 'r'},
  {"timesteps", required_argument, NULL, 't'},
  {NULL, 0, NULL, 0}
};

void print_usage(void) {
  fprintf(stderr, "%s: A simple 2D simulation of the diffusion equation.\n", progname);
  fprintf(stderr, "Usage: %s [OPTIONS]\n", progname);
  fprintf(stderr, "  -i,  --infile            Path to input file       [required]\n"
                  "  -p,  --prefix            Output filename prefix   [required]\n"
                  "  -r,  --output-rate       Timesteps between output [optional]\n"
                  "  -t,  --timesteps         Simulation Timesteps     [optional]\n");
}

int main(int argc, char *argv[]) {
  using namespace std::chrono;
  progname = argv[0];
  int show_usage = 0;
  int outrate = 1, timesteps = 17;
  std::string infile, prefix;
  int optc;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, NULL)) != -1) {
    switch (optc) {
      case 'i':
        infile = std::string(optarg);
        break;
      case 'p':
        prefix = std::string(optarg);
        break;
      case 'r':
        outrate = atoi(optarg);
        break;
      case 't':
        timesteps = atoi(optarg);
        if (timesteps < 1) {
          std::cerr << "Invalid value for timesteps: " << optarg 
                    << " - requires a non-zero integer." << std::endl;
          show_usage = 1;
        }
        break;
      default:
          show_usage = 1;
    }
  }
  if (show_usage == 1 || optind < argc || infile.empty() || prefix.empty()) {
    print_usage();
    return EXIT_FAILURE;
  }

  InputFile input_file(infile);
  Simulation sim(input_file.get_rows(), input_file.get_cols());
  sim.setup(input_file);
  for (int ts = 0; ts < timesteps; ++ts) {
    sim.advance();
    std::cout << "Timestep " << ts << " temperature: " << sim.temperature() 
              << std::endl;
  }

  return EXIT_SUCCESS;
}
