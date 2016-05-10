#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

volatile int halted = 0;

void sig_handler(int signo) {
  if (signo == SIGINT) {
    halted = 1;
  }
}

int main(int argc, char *argv[]) {
  // Register Interrupt Handler
  if (signal(SIGINT, sig_handler) == SIG_ERR) {
    fprintf(stderr, "\ncan't catch SIGINT\n");
    return EXIT_FAILURE;
  }

  FILE *ofilePtr;
  if ((ofilePtr = fopen("file.txt", "w+")) == NULL) {
    fprintf(stderr, "Could not open file\n");
    return EXIT_FAILURE;
  }

  while (!halted) {
    sleep(1);
    fprintf(ofilePtr, "Hello world and all its %d furry animals\n", 1000);
  }

  fclose(ofilePtr);
  printf("o\nExiting!\n");
  return EXIT_SUCCESS;
}
