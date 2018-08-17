fh = open('filename.txt','r') # r refers to read mode
lines = fh.readlines()
print (lines)

del lines[0] # delete header
Seq = ''
for i in range (1,len(lines),++1):
	Seq += lines[i].replace('\n','').replace('\r','') # \n and \r are both new line characters


# to remove all new line characters
for i in range (1,len(lines),++1):
	line = line.rstrip()
	print(line)

# to use command line arguments
import sys
fh = open(sys.argv[1],'r') # first argument on command line is file name