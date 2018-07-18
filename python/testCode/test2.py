fh = open('PTEN.txt','r') 

lines = fh.readlines()
#print (lines)

del lines[0]
Seq = ''
for i in range (1,len(lines),++1):
	Seq += lines[i].replace('\n','').replace('\r','')

#print(lines)
#print len(Seq)/3
#################
#print(Seq)

D = {'val':['GTT','GTC','GTA','GTG'],
'met':['ATG'],
'lle': ['ATT','ATC','ATA'],
'leu':['TTA','TTG','CTT','CTC','CTA','CTG'],
'phe':['TTT','TTC'],
'ala':['GTC','GCC','GCA','GCG'],
'thr':['ACT','ACC','ACA','ACG'],
'PRO':['CCT','CCC','CCA','CCG'],
'ser':['TCT','TCC','TCA','TCG','AGT','AGC'],
'tyr':['TAT','TAC'],
'hys':['CAT','CAC'],
'Gln':['CAA','CAG'],
'asn':['AAT','AAC'],
'lys':['AAA','AAG'],
'asp':['GAT','GAC'],
'glu':['GAA','GAG'],
'cys':['TGT','TGC'],
'trp':['TGG'],
'arg':['CGT','CGC','CGA','CGG','AGA','AGG'],
'gly':['GGT','GGC','GGA','GGG'],
'stop':['TAA','TAG','TGA']}
#print (D)



#Seq = 'GTTAGCTTTCTGACGCTAATT'
#2 Dictionary ...
#D2 = {'Val':['GTT','GTC','GTA','GTG'],'ile':['ATT','ATC','ATA']}
#3 loop over DNA sequence while converting list of codons...
codons = []
for x in range (0,len(Seq),++3):
	try:
		codon = Seq[x]+ Seq[x+1]+ Seq[x+2]
		codons.append(codon)
	except:
		pass                                 
#print 'NOTICE:DNA sequence have %d codons'%len(codons)
#4 convert codons to amino acid sequence based on the above dictionary...
myamino_acids = []
for codon in codons:
	for AA, Codons in D.items(): 
		if codon in D[AA]:
			myamino_acids.append(AA)
pSeq = ''.join(myamino_acids)
print(pSeq)

pLen = len(pSeq)/3
print(pLen)