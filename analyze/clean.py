import os, re, sys

ansi_escape = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')

for file in sys.argv[1:]:
	with open(file, 'rb') as f:
		for line in f:
			line = bytes([c for c in line if c != 0]).decode('windows-1252')
			line = line.replace('\r', '')
			line = line.replace('\n', '')
			line = ansi_escape.sub('', line)
			print(line)

