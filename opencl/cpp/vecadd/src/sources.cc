#include "sources.h"

#include <string>
#include <fstream>
#include <sstream>

namespace Tools {
  namespace Sources {

    std::string read_file(const std::string& filename) {
      std::ifstream instream (filename);
      std::stringstream text;
      if (instream.is_open()) {
        std::string line;
        while (getline(instream, line)) {
            text << line << "\n"; 
        }
      }
      return text.str();
    }

  } // namespace Sources
} // namespace Tools
