#!/usr/bin/env python

def inner_iter(iterations):
    for i in range(0, iterations):
        yield i * iterations


def outer_iter(iterations):
    for i in range(0, iterations):
        yield from inner_iter(i)

if __name__ == '__main__':
    for i in outer_iter(10):
        print(i)
