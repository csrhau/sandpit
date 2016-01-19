#!/usr/bin/env python3

import pandas as pd
import numpy as np

def main():
    """ Application Entry Point """
    scores = pd.read_csv('scores.csv', index_col='year')
    print(scores)
    print(scores.rank(method='dense')) # Dense is like 'first', but each group only increments the count by one (as opposed to each element)



if __name__ == '__main__':
    main()
