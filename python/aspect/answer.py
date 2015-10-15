#!/usr/bin/python

import argparse
from math import sqrt
from collections import deque

def process_arguments():
  parser = argparse.ArgumentParser(description="Outlier Detection Utility",
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("-if", "--infile", type=argparse.FileType('r'), required=True,
                      help="Path to data file to process")
  parser.add_argument("-of", "--outfile", type=argparse.FileType('w'), required=True,
                      help="Path to data file to write to")
  parser.add_argument("-w", "--window", type=int, default=10,
                      help="Length of the sample window")
  parser.add_argument("-s", "--sigma", type=float, default=2.5,
                      help="Standard deviations about mean tolerance")
  return parser.parse_args()

def main():
  # Process Arguments
  args = process_arguments()
  # Construct Buffer
  window = deque(maxlen=args.window)
  # Copy over header
  args.outfile.write(args.infile.readline())
  for line in args.infile:
    # Extract Price
    price = float(line.strip().split(',')[1])
    # Advance fixed-width Window
    window.append(price)
    # Classify Price
    mean = sum(window) / len(window)
    std_dev = sqrt(sum([(x - mean)**2 for x in window]) / max(1, len(window)-1))
    if (abs(price - mean) > args.sigma * std_dev):
      print "Outlier: " + line.strip()
    else:
      args.outfile.write(line)
  # Cleanup
  args.infile.close()
  args.outfile.close()

if __name__ == "__main__":
    main()
