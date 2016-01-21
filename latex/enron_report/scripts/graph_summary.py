#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

import argparse
import json
import code
import operator
import networkx as nx

def process_arguments():
    """ Process command line arguments """
    parser = argparse.ArgumentParser(description="Enron Corpus Parser")
    parser.add_argument("-i", "--infile", type=argparse.FileType('r'), required=True,
                      help="Path to data file to process")
    parser.add_argument("-o", "--outfile", type=argparse.FileType('w'), required=True,
                      help="Path to output data to")
    parser.add_argument("-a", "--analysis", choices=['pagerank', 'degree-centrality', 'betweenness-centrality', 'closeness-centrality', 'summary'], required=True,
                      help="The analysis to perform")

    return parser.parse_args()

def message_graph(messages):
    """ Builds a networkx graph based on messages sent between individuals """
    graph = nx.DiGraph()
    for message in messages:
        for recipient in message['recipients']:
            if message['sender'] != recipient:
                if graph.has_edge(message['sender'], recipient):
                    graph[message['sender']][recipient]['weight'] += 1
                else:
                    graph.add_edge(message['sender'], recipient, weight=1)
    return graph

def graph_summary(graph, outfile):
    print("Metric,Value", file=outfile)
    print("Order (Nodes),{}".format(graph.order()), file=outfile)
    print("Size (Edges),{}".format(graph.size()), file=outfile)
    print("Size (Edges),{}".format(graph.size()), file=outfile)
    print("Components,{}".format(nx.number_strongly_connected_components(graph)), file=outfile)
 
def degree_centrality(graph, outfile, records=10):
    """ Perform a degree centrality analysis on graph """
    ranking = nx.degree_centrality(graph)
    ordering = sorted(ranking.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Employee,Degree Centrality", file=outfile)
    for employee, rank in ordering:
      print("{},{}".format(employee, rank), file=outfile)

def betweenness_centrality(graph, outfile, records=10):
    """ Perform a betweenness centrality analysis on graph """
    print("waggawoo")
    ranking = nx.betweenness_centrality(graph)
    ordering = sorted(ranking.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Employee,Betweenness Centrality", file=outfile)
    for employee, rank in ordering:
      print("{},{}".format(employee, rank), file=outfile)


def closeness_centrality(graph, outfile, records=10):
    """ Perform a closeness centrality analysis on graph """
    ranking = nx.closeness_centrality(graph)
    ordering = sorted(ranking.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Employee,Degree Centrality", file=outfile)
    for employee, rank in ordering:
      print("{},{}".format(employee, rank), file=outfile)

def pagerank(graph, outfile, records=10):
    """ Perform a pagerank analysis on graph """
    ranking = nx.pagerank(graph)
    ordering = sorted(ranking.items(), key=operator.itemgetter(1), reverse=True)[:records]
    print("Employee,PageRank", file=outfile)
    for employee, rank in ordering:
      print("{},{}".format(employee, rank), file=outfile)

def main():
    """ Application entry point """
    args = process_arguments()
    print("Loading data...")
    graph = message_graph(json.load(args.infile))
 
    if args.analysis == 'pagerank':
        pagerank(graph, args.outfile)
    if args.analysis == 'degree-centrality':
        degree_centrality(graph, args.outfile)
    if args.analysis == 'betweenness-centrality':
        betweenness_centrality(graph, args.outfile)
    if args.analysis == 'closeness-centrality':
        closeness_centrality(graph, args.outfile)
    elif args.analysis == 'summary':
      graph_summary(graph, args.outfile)
    args.infile.close()
    args.outfile.close()

    
if __name__ == '__main__':
    main()
