#!/usr/bin/python

import sys
from os import environ as env

def main():
	raw = ''.join(sys.stdin)
	for var in sys.argv[1:]:
		try:
			raw = raw.replace(var, env.get(var))
		except:
			print "failed to replace", var, "with", env.get(var)
			exit(1)
	sys.stdout.write(raw)

if __name__=="__main__":
	main()
