#!/usr/bin/env python3

import argparse
import string 

def process_arguments():
  parser = argparse.ArgumentParser(description="Simple Ceaser Solver",
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("-w", "--wordlist", type=argparse.FileType('r'), required=True,
                      help="Path to word list file")
  parser.add_argument("-c", "--cyphertext", type=argparse.FileType('r'), required=True,
                      help="Path to cyphertext file")
  return parser.parse_args()

def decypher(cyphertext, shift): 
  alphabet = string.ascii_lowercase
  shifted_alphabet = alphabet[shift:] + alphabet[:shift]
  table = str.maketrans(alphabet, shifted_alphabet)
  return cyphertext.translate(table)

def main():
  ''' Application Entry Point '''
  args = process_arguments()
  words = set(" {} ".format(w.rstrip()) for w in args.wordlist)
  args.wordlist.close()
  cyphertext = " {} ".format(args.cyphertext.read().rstrip().lower())
  args.cyphertext.close()

  best_shift = 0
  best_matches = 0
  for shift in range(0, 27):
    plaintext = decypher(cyphertext, shift)
    print('Trying plaintext {}'.format(plaintext))
    matches = sum(1 for word in words if word in plaintext)
    for word in words:
      if word in plaintext:
        print(word)
    print('Matches: {}'.format(matches))
    if matches > best_matches:
      best_shift = shift
      best_matches = matches
  print('Best Match Found: Shift = {}'.format(best_shift))
  print(cyphertext)
  print(decypher(plaintext, best_shift))
 

if __name__ == '__main__': 
  main()
