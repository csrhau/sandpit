/* vim: set filetype=cpp: */

// Executes a vector addition of A and B, storing the result in C.



__kernel
void vecsum_accadd(__global const float *input_,
                   __global float *output_,
                   __local float *scratch_,
                   __const int length_) {

  int local_index = get_local_id(0);
  int global_index = get_global_id(0);
  int local_size = get_local_size(0);
  int global_size = get_global_size(0);

  float accumulator = 0;
  for (int offset = global_index; offset < length_; offset += global_size) {
     accumulator += input_[offset];
  }
  scratch_[local_index] = accumulator;
  barrier(CLK_LOCAL_MEM_FENCE);
  // Perform parallel reduction
  for (int s = local_size / 2; s > 0; s>>=1) {
    if (local_index < s) {
      scratch_[local_index] += scratch_[local_index + s];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
  } 
  if (local_index == 0) {
    output_[get_group_id(0)] = scratch_[0]; 
  }
}

__kernel
void vecsum_loadadd(__global const float *input_,
                    __global float *output_,
                    __local float *scratch_,
                    __const int length_) {
  int local_size = get_local_size(0); 
  int local_index = get_local_id(0);
  int global_index = get_global_id(0);
  int global_index2 = global_index * 2;

  scratch_[local_index] = input_[global_index] + global_index2 < length_ ?
                                                 input_[global_index2] : 0;
  barrier(CLK_LOCAL_MEM_FENCE);
  // Perform parallel reduction
  for (int s = local_size / 2; s > 0; s>>=1) {
    if (local_index < s) {
      scratch_[local_index] += scratch_[local_index + s];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
  } 
  if (local_index == 0) {
    output_[get_group_id(0)] = scratch_[0]; 
  }
}

__kernel
void vecsum_contiguous(__global const float *input_,
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
  for (int s = local_size / 2; s > 0; s>>=1) {
    if (local_index < s) {
      scratch_[local_index] += scratch_[local_index + s];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
  } 
  if (local_index == 0) {
    output_[get_group_id(0)] = scratch_[0]; 
  }
}

__kernel
void vecsum_nondiverge(__global const float *input_,
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
    int index = 2 * s * local_index;
    if (index < local_size) {
      scratch_[index] += scratch_[index + s];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
  } 
  if (local_index == 0) {
    output_[get_group_id(0)] = scratch_[0]; 
  }
}

__kernel
void vecsum_base(__global const float *input_,
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
