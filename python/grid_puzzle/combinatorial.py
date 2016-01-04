#!/usr/bin/env python3
from collections import namedtuple
from enum import Enum
import numpy as np
import argparse
import csv

State = Enum('State', 'black white unknown')

class Board:
    def __init__(self, board_csv):
        with open(board_csv, 'r') as boardfile:
            reader = csv.reader(boardfile, delimiter=',')
            lookup = {'0': State.black.value,
                      '1': State.white.value,
                      '?': State.unknown.value}
            self._grid = np.array([[lookup[c] for c in row] for row in reader])

    @property
    def grid(self):
        return self._grid

    def render(self):
        lightcodes = {State.black: '\033[90m',
                      State.white: '\033[97m', 
                      State.unknown: '\033[93m'}
        charcodes = {State.black: '0',
                     State.white: '1', 
                     State.unknown: '?'}
        for line in self.grid:
            for square in line:
                value = State(square)
                print('{}{} \033[0m'.format(lightcodes[value], 
                                            charcodes[value]), 
                                            end='') 
            print()

class Span:
    def __init__(self, start, end):
        self._start = start
        self._end = end

    @property
    def start(self):
        return self._start
    
    @start.setter
    def start(self, value):
        self._start = value

    @property
    def end(self):
        return self._end
    
    @end.setter
    def end(self, value):
        self._end = value

    @property
    def length(self):
        return self._end - self._start + 1

    def contains(self, point):
        return point >= self.start and point <= self.end

    def overlap(self, span):
        start = max(self.start, span.start)
        end = min(self.end, span.end)
        if start > end:
            return None
        return Span(start, end)

    def overlaps(self, span):
        return self.overlap(span) != None

class Constraint:
    def __init__(self, length, candidates):
        self._length = length
        self._candidates = candidates

    @property
    def length(self):
        return self._length

    @property
    def candidates(self):
        return self._candidates

    @property
    def solved(self):
        return len(self._candidates) == 1
    
def process_arguments():
  parser = argparse.ArgumentParser(description="Board Solver",
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("-bf", "--boardfile", required=True,
                      help="Path to board initial conditions")
  parser.add_argument("-rf", "--rowfile", required=True,
                      help="Path to row constraints")
  parser.add_argument("-cf", "--colfile", required=True,
                      help="Path to col constraints")
  return parser.parse_args()

def load_constraints(cons_file):
    with open(cons_file, 'r') as cons_file:
        constraints = []
        reader = csv.reader(cons_file, delimiter=',')
        for line in reader:
            cons_lengths = [int(c) for c in line]
            constraint_starts = []
            constraint_ends = []
            offset = 0
            for length in cons_lengths:
                constraint_starts.append(offset)
                offset = offset + length + 1
            offset = 24 # NB: last index of a line (size - 1)
            for length in reversed(cons_lengths):
                constraint_ends.append(offset)
                offset = offset - length - 1
            constraint_ends.reverse()
            for start, end, length in zip(constraint_starts, constraint_ends, cons_lengths):
                candidates = end - start - length + 2
                span = length - 1
                for i in range(candidates):
                    print("{}-{} len {}, candidates:{}".format(start, end, length, candidates))




    return constraints

def main():
    args = process_arguments()
    board = Board(args.boardfile)
    row_cons = load_constraints(args.rowfile)
    col_cons = load_constraints(args.colfile)


    # Algorithms:
        # for each constraint, replace its feasible_start and feasible_end with
        # the max and min values found in candidates - this handles splitting on white

if __name__ == '__main__':
    main()
