// Executes a vector addition of A and B, storing the result in C.

#if defined EXPERIMENT_ONE

#else
__kernel
void vecsum(__global const float *input_,
            __global float *output_,
            __local float *scratch_,
            __const int length_) {
  int local_size = get_local_size(0); 
  int local_index = get_local_id(0);
  int global_index = get_global_id(0);

  if (global_index < length_) {
    scratch_[local_index] = input_[global_index];
  } else {
    // Zero is the identity element for sum
    scratch_[local_index] = 0;
  }
  barrier(CLK_LOCAL_MEM_FENCE);
  // Perform parallel reduction
  for (int s=1; s < local_size; s *= 2) {
    if (local_index % (2 * s) == 0) {
      scratch_[local_index] += scratch_[local_index + s];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
  } 
  if (local_index == 0) {
    output_[get_group_id(0)] = scratch_[0]; 
  }
}
#endif
