#!/usr/bin/python

import sys
from os import environ as env

def main():
	raw = ''.join(sys.stdin)
	print sys.argv[1:]
	for var in sys.argv[1:]:
		raw = raw.replace(var, env.get(var))
	sys.stdout.write(raw)

if __name__=="__main__":
	main()
