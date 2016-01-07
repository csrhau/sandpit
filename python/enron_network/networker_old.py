#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

from collections import namedtuple
import argparse
import codecs
import json
import os
import operator
import email.parser
import dateutil.parser
import networkx as nx

Message = namedtuple('Message', ['id', 'sender', 'recipients', 'timestamp', 'subject', 'body'])

def process_arguments():
    """ Process command line arguments """
    parser = argparse.ArgumentParser(description="Enron Corpus Parser")
    parser.add_argument("-p", "--path", help='Path to Enron corpus',
                        required=True)
    parser.add_argument("-u", "--unique", help="Remove Duplicate messages",
                        action="store_true")
    parser.add_argument("-r", "--records", help="Number of records to display",
                        type=int, default=5)
    parser.add_argument("-v", "--verbose", help="increase output verbosity",
                        action="store_true")
    return parser.parse_args()

def read_message(path):
    """ Reads an enron message file into a Message tuple """
    parser = email.parser.Parser()
    with codecs.open(path, 'r', 'Latin-1') as message_file:
        content = message_file.read()
        message = parser.parsestr(content)
        recipients = ()
        if message['To'] is not None:
            recipients = tuple(m.strip(',') for m in message['To'].split())
        return Message(message['Message-ID'],
                       message['From'],
                       recipients,
                       dateutil.parser.parse(message['Date']),
                       message['Subject'],
                       message.get_payload())

def load_messages(path, unique, verbose):
    """ Loads messages from the corpus and returns them as Message objects """
    messages = []
    signatures = set()
    for root, _, files in os.walk(path):
        if verbose:
            print("Processing {}".format(root))
        for message_file in files:
            message = read_message(os.path.join(root, message_file))
            if unique:
                sig = (message.sender, message.recipients, message.timestamp, message.subject, message.body)
                if sig in signatures:
                    continue
                signatures.add(sig)
            messages.append(message)
    return messages

def message_graph(messages):
    """ Builds a networkx graph based on messages sent between individuals """
    graph = nx.DiGraph()
    for message in messages:
        for recipient in message.recipients:
            if message.sender != recipient:
                graph.add_edge(message.sender, recipient)
    return graph

def degree_centrality(graph, records):
    """ Reports on the most central individuals in the graph """
    dc = nx.degree_centrality(graph)
    nodes = sorted(dc.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Degree Centrality - top {} individuals".format(records))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))

def pagerank(graph, records):
    """ Reports on the highest (Page)Ranked individuals in the graph """
    pr = nx.pagerank(graph)
    nodes = sorted(pr.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Page Rank - top {} individuals".format(records))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))

def main():
    """ Applicaion entry point """
    args = process_arguments()
    messages = load_messages(args.path, args.unique, args.verbose)
    messages.sort(key=operator.attrgetter('timestamp'))
    graph = message_graph(messages)
    # Degree Centrality - important guys
    degree_centrality(graph, args.records)
    pagerank(graph, args.records)

if __name__ == '__main__':
    main()
