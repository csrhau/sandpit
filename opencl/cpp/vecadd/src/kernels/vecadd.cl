// Executes a vector addition of A and B, storing the result in C.
__kernel
void vecadd(__global int *A, __global int *B, __global int *C) {
  int tid = get_global_id(0);
  C[tid] = A[tid] + B[tid];
}

// Executes a vector addition of A and B, storing the result in C.
__kernel
void vecadd4(__global int4 *A, __global int4 *B, __global int4 *C) {
  int tid = get_global_id(0);
  C[tid] = A[tid] + B[tid];
}
