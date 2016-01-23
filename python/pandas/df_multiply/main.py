#!/usr/bin/env python3

import numpy as np
import pandas as pd


data = np.indices((5, 4))

data = data[0] + data[1]

#introduce some asymmetry
data[4][0] = 2

df = pd.DataFrame(data, index = [ l for l in 'abcde'], columns=[l for l in 'abde'])


print(df)
print("Pandas does the right thing w.r.t multiplying missing bobbinses")
print("df * df.T:")
print(df * df.T)

print("whereas numpy does the mathsy thing and errors")

print((df * df.T).dropna(axis=(0,1),how='all'))
