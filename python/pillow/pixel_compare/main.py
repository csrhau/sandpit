#!/usr/bin/env python

from __future__ import print_function
from PIL import Image
import argparse


def process_arguments():
  parser = argparse.ArgumentParser(description="Outlier Detection Utility",
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("-i", "--infile", type=argparse.FileType('r'), required=True,
                      help="File to compare for a match")
  parser.add_argument("-c", "--candidates", type=argparse.FileType('r'), required=True, nargs='+',
                      help="Candiates to check for a match against")
  parser.add_argument("-x", "--col", type=int, required=True, help="x-coordinate of pixel to compare")
  parser.add_argument("-y", "--row", type=int, required=True, help="y-coordinate of pixel to compare")
  return parser.parse_args()

def main():
  # Process Arguments
  args = process_arguments()
  print('done')
  in_img = Image.open(args.infile).load()
  a = in_img[args.row, args.col]

  for candidate in args.candidates:
    c_img = Image.open(candidate).load()
    if a == c_img[args.row, args.col]:
      print ("{} Matches!".format(candidate.name))

  args.infile.close()
  for candidate in args.candidates:
    candidate.close()

if __name__ == '__main__':
  main()
 
