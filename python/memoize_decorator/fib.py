#!/usr/bin/env python

import collections
import functools 

# Based on the following code: 
# https://wiki.python.org/moin/PythonDecoratorLibrary#Memoize

class memoized(object):
   '''Decorator. Caches a function's return value each time it is called.
   If called later with the same arguments, the cached value is returned
   (not reevaluated).
   '''
   def __init__(self, func):
      self.func = func
      self.cache = {}
   def __call__(self, *args):
      if not isinstance(args, collections.Hashable):
         # uncacheable. a list, for instance.
         # better to not cache than blow up.
         return self.func(*args)
      if args in self.cache:
         return self.cache[args]
      else:
         value = self.func(*args)
         self.cache[args] = value
         return value
   def __repr__(self):
      '''Return the function's docstring.'''
      return self.func.__doc__
   def __get__(self, obj, objtype):
      '''Support instance methods.'''
      return functools.partial(self.__call__, obj)

@memoized
def fibonacci(n):
   "Return the nth fibonacci number."
   if n in (0, 1):
      return n
   return fibonacci(n-1) + fibonacci(n-2)

def slow_fibonacci(n):
   "Return the nth fibonacci number."
   if n in (0, 1):
      return n
   return slow_fibonacci(n-1) + slow_fibonacci(n-2)



if __name__ == "__main__":
  print ("fast: (memoized)")
  print(fibonacci(32))
  print ("slow: (not memoized")
  print(slow_fibonacci(32))
