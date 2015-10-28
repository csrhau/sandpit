#include <getopt.h>
#include <cstdlib>

#include <iostream>
#include <fstream>
#include <string>

#define GETOPTS "i:o:"
static char *progname;
static struct option long_opts[] = {
  {"input-file", required_argument, NULL, 'i'},
  {"output-file", required_argument, NULL, 'o'},
  {NULL, 0, NULL, 0}
};

void print_usage() {
  std::cerr << progname << ": A simple example showing how to read files in C++\n"
            "     -i,     --input-file        Path to input file [required]\n"
            "     -o,     --output-file       Path to output file [required]\n";
}

int main(int argc, char *argv[]) {
  progname = argv[0];
  std::string infile, outfile;
  int optc, show_usage = 0;
  while ((optc = getopt_long(argc, argv, GETOPTS, long_opts, NULL)) != -1) {
    switch (optc) {
      case 'i':
        infile = std::string(optarg);
        break;
      case 'o':
        outfile = std::string(optarg);
        break;
      default:
        show_usage = 1;
    }
  }
  if (show_usage || optind < argc || infile.empty() || outfile.empty()) {
    print_usage();
    return EXIT_FAILURE;
  }

  std::ifstream istream (infile);
  if (!istream.is_open()) {
    std::cerr << "Unable to open input file " << infile << "!\n";
    print_usage();
    return EXIT_FAILURE; 
  }

  std::ofstream ostream (outfile);
  if (!ostream.is_open()) {
    std::cerr << "Unable to open output file " << outfile << "!\n";
    print_usage();
    return EXIT_FAILURE; 
  }

  std::string line;
  while (getline(istream, line)) {
    ostream << line << "\n";
  }
}
