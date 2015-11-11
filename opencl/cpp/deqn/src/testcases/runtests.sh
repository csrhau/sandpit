#/bin/bash

TEST_CASES=*.h5


for TC in $TEST_CASES; do
  echo testing $TC;
  mkdir -p test_results/$TC;
  ./cldeqn -i $TC -p test_results/$TC/test -r 10 -t 100 > /dev/null



done
