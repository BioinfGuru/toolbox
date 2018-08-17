import os
import sys

# data structures
Seq = 'GTTAGCTTTCTGACGCTAATT'
D = {'Val':['GTT','GTC','GTA','GTG'],'Ile':['ATT','ATC','ATA']}
codons = []

# iterate
for x in range (0,len(Seq),++3): # ++ is incrementing
	#print(len(Seq))
	#print(Seq[x]+'Roween')
	print(Seq[x] + Seq[x+1] + Seq[x+2])
	#print(codons)
	try:
		codon = Seq[x]+ Seq[x+1]+ Seq[x+2] # + is concatinating strings
		codons.append(codon) # adds the new codon to the array "codons"
	except:
		pass # pass means don't exit for any non-fatal error

# myamino_acids = []
# for codon in codons:
# 	for AA, codons in D.items(): 
# 		if codon in D[AA]:
# 			myamino_acids.append(AA)
# print(', '.join(myamino_acids))

print 'NOTICE:DNA sequence have %d codons'%len(codons)
# #4 convert codons to amino acid sequence based on the above dictionary...
# for codon in codons:
# 	for AA, Codons in D.iteritems(): # what iteritems means? how u mean by aa and codons # replace iteritems with items in python3
# 		if codon in D[AA]:
# 			print 'NOTICE:%s converted to %s...'%(codon,AA)
# 		else:
# 			continue