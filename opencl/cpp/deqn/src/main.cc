#include <getopt.h>
#include <cstdlib>
#include <vector>
#include <iostream>
#include <chrono>
#include <algorithm>

#include "input_file.h"
#include "simulation.h"

#define GETOPTS "i:p:d:r:t:"
static char *progname;
static struct option long_opts[] = {
  {"infile", required_argument, NULL, 'i'},
  {"prefix", required_argument, NULL, 'p'},
  {"output-rate", required_argument, NULL, 'r'},
  {"timesteps", required_argument, NULL, 't'},
  {NULL, 0, NULL, 0}
};

void print_usage() {
  fprintf(stderr, "%s: A simple 2D simulation of the diffusion equation.\n", progname);
  fprintf(stderr, "Usage: %s [OPTIONS]\n", progname);
  fprintf(stderr, "  -i,  --infile            Path to input file       [required]\n"
                  "  -p,  --prefix            Output filename prefix   [required]\n"
                  "  -d,  --device            OpenCL Device Name       [required]\n"
                  "  -r,  --output-rate       Timesteps between output [optional]\n"
                  "  -t,  --timesteps         Simulation Timesteps     [optional]\n");
}


int main(int argc, char *argv[]) {
  using namespace std::chrono;
  progname = argv[0];
  int show_usage = 0;
  int outrate = 1, timesteps = 17;

  std::string infile, prefix, device_name; 
  int optc;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, NULL)) != -1) {
    switch (optc) {
      case 'i':
        infile = std::string(optarg);
        break;
      case 'p':
        prefix = std::string(optarg);
        break;
     case 'd':
        device_name = std::string(optarg);
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
  if (show_usage == 1 
      || optind < argc 
      || infile.empty() 
      || prefix.empty() 
      || device_name.empty()) {
    print_usage();
    return EXIT_FAILURE;
  }

  // Retreive platform devices
  cl::Platform platform = cl::Platform::getDefault();
  std::vector<cl::Device> devices;
  platform.getDevices(CL_DEVICE_TYPE_ALL, &devices);

  cl::Device device;
  bool device_found = false;
  for (const cl::Device& dev : devices) {
    std::string name(dev.getInfo<CL_DEVICE_NAME>());
    // Remove non-printable ascii characters
    name.erase(std::remove_if(name.begin(), name.end(), [](char x){ return !(x >= 32 && x < 126); } ));
    if (name == device_name) {
      device = dev;
      device_found = true;
    }
  }

  if (!device_found) {
    std::cout << "Could not find device " << device_name << ", please choose from one of the following:\n";
    for (const cl::Device& dev : devices) {
      std::cout << "   \"" << dev.getInfo<CL_DEVICE_NAME>() << "\"" << std::endl;
    }
    return EXIT_FAILURE;
  }

  InputFile input_file(infile);
  Simulation sim(input_file, device);

  std::chrono::steady_clock::time_point t_start = std::chrono::steady_clock::now();
  for (int ts = 0; ts < timesteps; ++ts) {
    sim.advance();
    std::cout << "Timestep " << ts << " temperature: " << sim.temp() 
              << std::endl;
  }
  std::chrono::steady_clock::time_point t_end = std::chrono::steady_clock::now();
  std::chrono::duration<double> runtime = std::chrono::duration_cast<std::chrono::duration<double>>(t_end - t_start);
  std::cout << "App Runtime: " << runtime.count() << " seconds." << std::endl;

  return EXIT_SUCCESS;
}
