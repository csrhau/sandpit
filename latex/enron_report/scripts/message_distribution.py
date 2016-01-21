#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

import argparse
import json
import operator
import dateutil.parser
import itertools
import pandas as pd
from collections import Counter

def process_arguments():
    """ Process command line arguments """
    parser = argparse.ArgumentParser(description="Enron Corpus Parser")
    parser.add_argument('-i', '--infile', type=argparse.FileType('r'), required=True,
                      help='Path to data file to process')
    parser.add_argument('-o', '--outfile', type=argparse.FileType('w'), required=True,
                      help='Path to output data to')
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
    senders = Counter(m['sender'] for m in data)
    recipients = Counter(r for m in data for r in m['recipients'])
    people = list(set(p for p in senders) | set(p for p in recipients))
    df = pd.DataFrame({ 'Employee': people,
                        'Sent': [senders[p] for p in people],
                        'Received': [recipients[p] for p in people]})\
          .set_index('Employee')
    df['Total'] = df[['Sent', 'Received']].sum(axis=1)
    df['Product'] = df['Sent'] * df['Received']
    df.to_csv(args.outfile)

    args.infile.close()
    args.outfile.close()

    
if __name__ == '__main__':
    main()
