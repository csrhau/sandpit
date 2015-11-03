#ifndef TOOLS_SOURCES_H
#define TOOLS_SOURCES_H

#include <string>
#include <vector>

namespace cl {
  class Context;
  class Device;
  class Program;
}

namespace Tools {
  namespace Sources {

    std::string read_file(const std::string& filename_);

    cl::Program build_program(const std::string& source_, 
                              const cl::Context& context_,
                              const std::vector<cl::Device>& device_,
                              const std::string& options_);
  } // namespace Sources
} // namespace Tools


#endif
