#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

import argparse
import json
import code
import networkx as nx

def process_arguments():
    """ Process command line arguments """
    parser = argparse.ArgumentParser(description="Enron Corpus Parser")
    parser.add_argument("-i", "--infile", type=argparse.FileType('r'), required=True,
                      help="Path to data file to process")
    return parser.parse_args()

def message_graph(messages):
    """ Builds a networkx graph based on messages sent between individuals """
    graph = nx.DiGraph()
    for message in messages:
        for recipient in message['recipients']:
            if message['sender'] != recipient:
                graph.add_edge(message['sender'], recipient)
    return graph

def main():
    """ Application entry point """
    args = process_arguments()
    graph = message_graph(json.load(args.infile))
    
if __name__ == '__main__':
    main()
