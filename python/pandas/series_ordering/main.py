#!/usr/bin/env python3

import pandas as pd

def main():
    senders = {'tom': 1,
               'dick': 5,
               'harold': 2}
    recipients = {'dick': 1,
                  'gerald': 3,
                  'tom': 2}
    scores = {'tom': 1,
              'dick': 1,
              'harry': 1}

    print('Pandas intelligently reorders from dicts')
    df = pd.DataFrame({'senders': senders,
                       'recipients': recipients,
                       'scores': scores}).fillna(0)
    print(df)


    print('Pandas intelligently reorders from series')
    ssend = pd.Series(senders, name='senders')
    srecv = pd.Series(recipients, name='recipients')
    sscor = pd.Series(scores, name='scores')
    df = pd.DataFrame({'senders' : ssend, 'recipients': srecv, 'score': sscor})
    print(df)


    print('If you just do an array of series, they become records (rows) due to the from record constructor:')
    df = pd.DataFrame([ssend, srecv, sscor])
    print(df)





if __name__ == '__main__':
    main()
