#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

import argparse
import json
import operator
import dateutil.parser
import itertools
import pandas as pd
import numpy as np
from collections import Counter, defaultdict

def process_arguments():
    """ Process command line arguments """
    parser = argparse.ArgumentParser(description="Enron Corpus Parser")
    parser.add_argument('-i', '--infile', type=argparse.FileType('r'), required=True,
                      help='Path to data file to process')
    parser.add_argument('-o', '--outfile', type=argparse.FileType('w'), required=True,
                      help='Path to output data to')
    parser.add_argument('-r', '--records', default=10, help='Number of employees to output', type=int)
    return parser.parse_args()

def load_data(infile):
    """ Load enron data from file """
    data = json.load(infile)
    for datum in data:
      datum['timestamp'] = dateutil.parser.parse(datum['timestamp'])
    return sorted(data, key = operator.itemgetter('timestamp'))

def main():
    """ Application entry point """
    args = process_arguments()
    print('Loading data...')
    data = load_data(args.infile)
    people = list(set(m['sender'] for m in data) | set(r for m in data for r in m['recipients']))

    counts = defaultdict(Counter)
    for message in data:
        counts[message['sender']].update(message['recipients'])
    for person in people:
        counts[person][person]=0
    df = pd.DataFrame(counts).fillna(0)
    for person in people:
      print(df[person][person])
    pairwise = (df * df.T).stack().rank(method='dense', ascending=False)


    pairwise.index.names=['sender', 'recipient']
    pairwise.name = 'count'
    print(pairwise)

    args.infile.close()
    args.outfile.close()

    
if __name__ == '__main__':
    main()
