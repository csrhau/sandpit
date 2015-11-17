#include "sources.h"

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>

#include "OpenCL.h"

namespace Tools {
  namespace Sources {

    std::string read_file(const std::string& filename_) {
      std::ifstream instream (filename_);
      std::stringstream text;
      if (instream.is_open()) {
        std::string line;
        while (getline(instream, line)) {
            text << line << "\n"; 
        }
      }
      return text.str();
    }

    cl::Program build_program(const std::string& filename_,
                              const cl::Context& context_,
                              const std::vector<cl::Device>& devices_,
                              const std::string& options_) {
      std::string source = read_file(filename_);
      cl::Program program = cl::Program(context_, source);
      try {
        program.build(devices_, options_.c_str());
      } catch (cl::Error& error) {
        if (error.err() == CL_BUILD_PROGRAM_FAILURE) { 
          for (const cl::Device& device : devices_) {
            std::cerr << "Build Status: " << program.getBuildInfo<CL_PROGRAM_BUILD_STATUS>(device)
                      << "\nBuild Options: " << program.getBuildInfo<CL_PROGRAM_BUILD_OPTIONS>(device)
                      << "\nBuild Log:\n" << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(device)
                      << "\n---End---" << std::endl;
          }
        } 
        throw;
      }
      return program;
    }

  } // namespace Sources
} // namespace Tools
