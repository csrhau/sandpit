#!/usr/bin/env python3
from collections import namedtuple
from enum import Enum
import numpy as np
import argparse
import csv

States = Enum('States', 'black white unknown')

BOARD_SIZE = 25

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

    def overlap(self, span):
        a = set(range(self.start, self.end))
        b = set(range(span.start, span.end))
        overlap = a & b
        return overlap

class Constraint:
    def __init__(self, length, line):
        self._length = length
        self._line = line
        self._feasible_span = Span(0, len(line))

    @property
    def length(self):
        return self._length

    @property
    def feasible_span(self):
        return self._feasible_span

    @property
    def known_span(self):
        if self.length * 2 <= self.feasible_span.length:
            return None
        span_start = self.feasible_span.end - self.length+1
        while span_start > 0 and States(self._line[span_start - 1]) == States.black:
            span_start -= 1
        span_end = self.feasible_span.start+self.length-1
        while span_end < (len(self._line) - 1) and States(self._line[span_end + 1]) == States.black:
            span_end += 1
        return Span(span_start, span_end)

    @property
    def solved(self):
        if self.known_span == None:
            return False
        return  self.known_span.start == self.feasible_span.start and self.known_span.end == self.feasible_span.end


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

def print_square(value):
    lightcodes = {States.black: '\033[90m',
                  States.white: '\033[97m', 
                  States.unknown: '\033[93m'}
    charcodes = {States.black: '0',
                 States.white: '1', 
                 States.unknown: '?'}

    print('{}{} \033[0m'.format(lightcodes[value], charcodes[value]), end='') 

def print_line(line):
    for square in line:
        print_square(States(square))
    print()

def basic_block(constraints, linesize):
    offset = 0
    for cid in range(len(constraints)):
        constraint = constraints[cid]
        constraint.feasible_span.start = max(constraint.feasible_span.start, offset)
        offset = offset + constraint.length + 1
    offset = linesize - 1
    for cid in reversed(range(len(constraints))):
        constraint = constraints[cid]
        constraint.feasible_span.end = min(constraint.feasible_span.end, offset)
        offset = offset - constraint.length - 1

def main():
    args = process_arguments()
    with open(args.boardfile, 'r') as boardfile:
        reader = csv.reader(boardfile, delimiter=',')
        lookup = {'0': States.black.value,
                  '1': States.white.value,
                  '?': States.unknown.value}
        board = np.array([[lookup[c] for c in row] for row in reader], dtype=int)
    with open(args.rowfile, 'r') as rowfile:
        reader = csv.reader(rowfile, delimiter=',')

        rowspec = [[Constraint(int(val), board[rid,:]) for val in row] for rid, row in enumerate(reader)]
        assert(len(rowspec) == board.shape[0]) # One constraint per row
    with open(args.colfile, 'r') as colfile:
        reader = csv.reader(colfile, delimiter=',')
        colspec = [[Constraint(int(val), board[:,cid]) for val in col] for cid, col in enumerate(reader)]
        assert(len(colspec) == board.shape[1]) # One constraint per col

    # Initialize constraints to something sensible
    for line_constraints in rowspec:
        basic_block(line_constraints, board.shape[1])
    for line_constraints in colspec:
        basic_block(line_constraints, board.shape[0])

    for i in range(10):
        print('looping')
        for row in board:
            print_line(row)

        # Limit the feasibles of each 
        for line_constraints in rowspec + colspec:
            for cid, constraint in enumerate(line_constraints):
                if cid > 0:
                    last = line_constraints[cid - 1]
                    if last.known_span is not None:
                        current = constraint.feasible_span.start
                        limit = last.known_span.end + 1
                        if limit > current:
                            print('Updating!')
                        constraint.feasible_span.start = max(current, limit)
                if cid <  len(line_constraints) - 1:
                    succ = line_constraints[cid + 1]
                    if succ.known_span is not None:
                        current = constraint.feasible_span.end
                        limit = succ.known_span.start - 1
                        if limit < current:
                            print('Updating!')
                        constraint.feasible_span.end = min(current, limit)

        # Apply
        for rid, line_constraints in enumerate(rowspec):
            for constraint in line_constraints:
                known = constraint.known_span
                if known is not None:
                    board[rid, known.start:known.end+1] = States.black.value
                    if constraint.solved:
                        board[rid, known.start-1] = States.white.value
                        if known.end+1 < board.shape[1]:
                            board[rid, known.end+1] = States.white.value

        for cid, line_constraints in enumerate(colspec):
            for constraint in line_constraints:
                known = constraint.known_span
                if known is not None:
                    board[known.start:known.end+1, cid] = States.black.value
                    if constraint.solved:
                        board[known.start-1, cid] = States.white.value
                        if known.end+1 < board.shape[0]:
                            board[known.end+1, cid] = States.white.value
     
        for line_constraints in rowspec + colspec:
          for constraint in line_constraints:
            print('solved: {}, contains white: {}'.format(constraint.solved, constraint.contains_white()))
if __name__ == '__main__':
    main()
