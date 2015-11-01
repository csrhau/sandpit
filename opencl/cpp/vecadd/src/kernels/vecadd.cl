// Executes a vector addition of A and B, storing the result in C.
__kernel
void vecadd(__global int *A, __global int *B, __global int *C) {
  int tid = get_Global_id(0);
  C[tid] = A[tid] + B[tid];
}
