#!/usr/bin/env python3
import operator
import pandas as pd
import networkx as nx

web = nx.DiGraph()

web.add_edge(1, 'king')
web.add_edge(1, 'queen')
web.add_edge(1, 2)

web.add_edge(2, 'king')
web.add_edge(2, 'queen')
web.add_edge(2, 3)

web.add_edge(3, 'king')
web.add_edge(3, 4)

web.add_edge(4, 'king')
web.add_edge(4, 'queen')
web.add_edge(4, 1)

web.add_edge('king', 'queen')
web.add_edge('queen', 'king')

web.add_edge('king', 1)
web.add_edge('queen', 2)

pagerank = nx.pagerank(web)
gmatr = nx.google_matrix(web)

print("PageRanks: {}".format(sorted(pagerank.items(), key=operator.itemgetter(1), reverse=True)))

df = pd.DataFrame(gmatr, index=web.nodes(), columns=web.nodes()).stack().sort_values()

df.to_csv('data.out')
