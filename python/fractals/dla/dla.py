#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

def display(field):
  ''' Displays result of DLA using matplotlib '''
  plt.imshow(field, cmap='Greys', interpolation='nearest')
  plt.show()


def adjacent(walker, field, rows, cols):
  ''' Returns true if walker is next to a filled point '''
  row = walker[0]
  col = walker[1]
  return (row > 1 and field[row-1, col] == 1) or\
         (row < rows -1 and field[row+1, col] == 1) or\
         (col > 1 and field[row, col-1] == 1) or\
         (col < cols -1 and field[row, col+1]) == 1

def main():
  ''' Application Entry Point '''
  ROWS = 400
  COLS = 400
  PIXELS = 4000

  field = np.zeros((ROWS, COLS))
  field[ROWS/2][COLS/2] = 1

  for pixel in range(PIXELS):
    walker = (ROWS/2, COLS/2)
    while field[walker[0], walker[1]] == 1:
      walker = [np.random.randint(ROWS), np.random.randint(COLS)]
    # Gotten a valid start pixel

    while not adjacent(walker, field, ROWS, COLS): 
      direction = np.random.randint(4)
      if direction == 0 and walker[0] < ROWS - 1:
        walker[0] += 1
      elif direction == 1 and walker[0] > 0:
        walker[0] -= 1
      if direction == 2 and walker[1] < COLS - 1:
        walker[1] += 1
      elif direction == 3 and walker[1] > 0:
        walker[1] -= 1
      else:
        pass # Can't happen
    field[walker[0], walker[1]] = 1
    print("ADDED PIXEL {}".format(pixel))

  display(field)




  


  print("Hello, world!")


if __name__ == '__main__':
  main()
