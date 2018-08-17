# https://stackoverflow.com/questions/1024847/add-new-keys-to-a-dictionary
# https://stackoverflow.com/questions/275018/how-can-i-remove-chomp-a-trailing-newline-in-python

import sys # for command line arguments
import pandas as pd # for file conversion
import re # for string substitutions
import os # for deleting a file

# convert xlsx to csv
excel_file = sys.argv[1] # take filename from 1st argument on command line
df = pd.read_excel(excel_file) # read excel into a dataframe
csv_file = re.sub('xlsx', 'csv', excel_file) # create outfile name
df.to_csv(csv_file, index=False) # write csv file

MCG = {}
tempKey = ()
fh = open(csv_file,'r')
lines = fh.readlines()
del lines[0] # delete header
for x in lines:
	x = x.rstrip() # remove all new line characters
	#print(x)
	columns = x.split(',')
	#print(columns)
	if columns[0] != '':
		MCG[columns[2] + ':' + columns[0]] = x # MCG[key] = value
		tempKey = columns[2] + ':' + columns[0]
		#print(tempKey)
	elif columns[0] == '':
		MCG[tempKey] = MCG[tempKey] + x # concatenate the line to the value of the key stored in the tempkeyvariable

# create outfile name
dict_file = re.sub('xlsx', 'dict', excel_file)

# delete previously printed dictionary if exists
try:
    os.remove(dict_file)
except OSError:
    pass

# print dictionary
for x in MCG:
	print(x + '\t' + MCG[x], file=open(dict_file, 'a')) # appending to file