// Fastest
__kernel
void vecsum_vecadd(__global const float4 *input_,
                   __global float *output_,
                   __local float *scratch_,
                   __const int length_) {
  int local_index = get_local_id(0);
  int global_index = get_global_id(0);
  int local_size = get_local_size(0);
  int global_size = get_global_size(0);

  int length4 = length_ / 4; // To accomodate float4-yness

  float4 accumulator = 0;
  for (int offset = global_index; offset < length4; offset += global_size) {
     accumulator += input_[offset];
  }

  scratch_[local_index] = accumulator.x + accumulator.y + accumulator.z + accumulator.w;
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
