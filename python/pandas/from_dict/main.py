#!/usr/bin/env python3
import numpy as np
import pandas as pd


data = {'john' : {'julie': 1, 'keith': 4},
        'kevin': {'julie': 2, 'john': 2},
        'julie': {'kevin': 1},
        'keith': {'julie':2, 'kevin':4, 'john':4}}

df = pd.DataFrame(data).fillna(0)
print(df)
print(df * df.transpose())
print(np.sqrt(df * df.transpose()))


#outbound = df.stack()
#outbound.name = 'outbound'
#outbound.index.names = ['sender', 'recipient']
#
