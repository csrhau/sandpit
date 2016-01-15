#!/usr/bin/env python3

""" A simple parser for the Enron e-mail corpus """

import argparse
import json
import code
import operator
import pygraphviz as pgv
import networkx as nx
import igraph
import matplotlib.pyplot as plt

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
                if graph.has_edge(message['sender'], recipient):
                    graph[message['sender']][recipient]['weight'] += 1
                else:
                    graph.add_edge(message['sender'], recipient, weight=1)
    return graph

def pagerank_report(graph, n):
    """ Reports on the top n highest (Page)ranked individuals on the graph """
    pr = nx.pagerank(graph, alpha=0.8)
    nodes = sorted(pr.items(), key=operator.itemgetter(1), reverse=True)[:n]
    print("Page Rank - top {} individuals".format(n))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))

def degree_centrality_report(graph, n):
    """ Reports on the top n most central individuals on the graph """
    pr = nx.degree_centrality(graph)
    nodes = sorted(pr.items(), key=operator.itemgetter(1), reverse=True)[:n]
    print("Degree Centrality - top {} individuals".format(n))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))


def closeness_centrality_report(graph, n):
    """ reports on the top n most central individuals on the graph """
    pr = nx.closeness_centrality(graph)
    nodes = sorted(pr.items(), key=operator.itemgetter(1), reverse=True)[:n]
    print("degree centrality - top {} individuals".format(n))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))

def betweenness_centrality_report(graph, n):
    """ reports on the top n most central individuals on the graph """
    pr = nx.betweenness_centrality(graph)
    nodes = sorted(pr.items(), key=operator.itemgetter(1), reverse=True)[:n]
    print("degree centrality - top {} individuals".format(n))
    for n in nodes:
        print("  {:30}:\t{}".format(n[0], n[1]))

def main():
    """ Application entry point """
    args = process_arguments()
    print("Loading data...")
    graph = message_graph(json.load(args.infile))
    args.infile.close()
    print("Performing analysis...")
    print(len(graph))

    pagerank_report(graph, 25)
    degree_centrality_report(graph, 25)
    closeness_centrality_report(graph, 25)
    betweenness_centrality_report(graph, 25)

    drawer = nx.draw(graph)
    plt.draw()
    plt.show()

#    foo = igraph.Graph()
#    for u, v, in graph.edges():
#        foo.add_vertex(u)
#        foo.add_vertex(v)
#        foo.add_edge(u, v)
#
#    dendrogram = foo.community_edge_betweenness()
#    clusters = dendrogra.as_clustering()
#    print(clusters)
#    print(clusters.membership)
#

    
if __name__ == '__main__':
    main()
