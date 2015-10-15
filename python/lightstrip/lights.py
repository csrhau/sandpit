#!/usr/bin/env python

from __future__ import print_function
import random

class LightSets:
	set1 = 0xffffffff 			# 000000000000000000000000000000011111111111111111111111111111111
	set2 = 0xffff0000ffff 		# 000000000000000111111111111111100000000000000001111111111111111
	set3 = 0xff00ff00ff00ff 	# 000000011111111000000001111111100000000111111110000000011111111
	set4 = 0xf0f0f0f0f0f0f0f 	# 000111100001111000011110000111100001111000011110000111100001111
	set5 = 0x3333333333333333 	# 011001100110011001100110011001100110011001100110011001100110011
	set6 = 0x5555555555555555 	# 101010101010101010101010101010101010101010101010101010101010101
	group = [set1, set2, set3, set4, set5, set6]

class LightStates:
    LIT = '\033[93m' 
    OFF = '\033[90m'
    ENDC = '\033[0m'

def parityOf(int_type):
    parity = 0
    while (int_type):
        parity = ~parity
        int_type = int_type & (int_type - 1)
    return 1 + parity

def display(num, bits, desc):
	print('{:17s}'.format(desc), end = '')
	for i in reversed(xrange(bits)):
  		state = LightStates.LIT if num & 1 << i > 0 else LightStates.OFF
  		print('{0}o{1}'.format(state, LightStates.ENDC), end='')
  	print()

def alice(start_state, send):
	print('Communications Process - Alice Sends')
	parity_string = ''.join(map(str, [parityOf(start_state & LightSets.group[i]) for i in xrange(6)]))
	send_string = ''.join(map(str, reversed([1 if send & 1 << i > 0 else 0 for i in xrange(6)])))
	delta = int(send_string, 2) ^ int(parity_string, 2)
	# Strictly, we should right-shift 2^32 to find the correct bit to invert, but given
	 # the bit patterns are inverse symmetric, we can do this and reverse the parity for recieve
	new_state = start_state ^ (1 << delta)
	display(start_state, 64, 'Starting State:')
	display(new_state, 64, 'Updated State:')
	display(start_state ^ new_state, 64, 'Change:')
	print('Send value: {0}, Send Bits: {1}, Parity Bits: {2}, Parity xor Send: {3}'.format(send, send_string, parity_string, bin(delta)))
	return new_state

def bob(new_state):
	print('Communications Process - Bob Receives')
	display(new_state, 64, 'Observed State:')
	parity_string = ''.join(map(str, [1-parityOf(new_state & LightSets.group[i]) for i in xrange(6)]))
	receive = int(parity_string, 2)
	print('Parity bits: {0}, Receied Value: {1}'.format(parity_string, receive))
	return receive

def main():
	print('Parity Set Membership Table')
	display(LightSets.set1, 64, 'Set1:')
	display(LightSets.set2, 64, 'Set2:')
	display(LightSets.set3, 64, 'Set3:')
	display(LightSets.set4, 64, 'Set4:')
	display(LightSets.set5, 64, 'Set5:')
	display(LightSets.set6, 64, 'Set6:')
	send = random.randint(0, 63)
	start_state = random.getrandbits(64)
	new_state = alice(start_state, send)
	receive = bob(new_state)
	assert(send == receive)

if __name__ == '__main__':
	main()