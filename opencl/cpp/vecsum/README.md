# VecSum

This project implements a parallel reduce (sum). 
It is based on the code found in [1] for CUDA (but still a very good resource)
and [2] for OpenCL. Example code from apple can be found at [3].


It relies on cmake to find OpenCL, and, optionally, to provision the c++ bindings
on Mac

[1][http://developer.download.nvidia.com/compute/cuda/1.1-Beta/x86_website/projects/reduction/doc/reduction.pdf]
[2][http://developer.amd.com/resources/documentation-articles/articles-whitepapers/opencl-optimization-case-study-simple-reductions/]
[3][https://developer.apple.com/library/mac/samplecode/OpenCL_Parallel_Reduction_Example/Introduction/Intro.html]
