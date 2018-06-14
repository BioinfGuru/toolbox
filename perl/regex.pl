# !/usr/bin/perl 

# Using regular expressions for string manipulation



###############################################################################################################
# REGEX #######################################################################################################
###############################################################################################################

#	//		= limits of regex			
#	|		= alternatives (not sure how to use this)	/a|b|c/
#	[]		= alternatives					[A-z]	
#	^		= anchor start of line				/^		
#	$ 		= anchor end of line				$/
#	/^@+$/		= ensures every position on a line must be "@"
#	+		= multiple occurances of a regex		\s+
#	()		= to select for extraction
# 	. 		= any character except new line (use \. to match a full stop)
# 	\w 		= alphanumeric and underscore 
#	[\p{alpha}\pN]	= alphanumeric but no underscore
#	\pN		= any numeric character
#	\p{alpha}	= any alphabetic character
#	\d		= any digit
#	\s		= whitespace
#	\t		= tab
#	\n		= new line

#	?	= match 0 or 1 times
#	*	= match 0 or more times
#	+	= match 1 or more times
#	{n}	= match exactly n times
#	{n,}	= match at least n times
#	{n,m}	= match n to m times


#	/^[A,a,C,c,G,g,T,t,U,u,M,m,R,r,W,w,S,s,Y,y,K,k,V,v,H,h,D,d,B,b,N,n,-]+$/	
#	= matches only IUPAC nucleic acid notation

#NB: Uppercase letters perform opposite function e.g. \D = anything except a digit

################################################################################################################
# MODIFIERS (FLAGS) ############################################################################################
################################################################################################################

#	Flags modifiy the behaviour of the matching operator:
#	i	= makes a search case insensitive
#	s	= modifies "." to also find the new line character (usually it doesn')
#	a	= modifies \d to only find ASCII numbers (which are 0-9) 



################################################################################################################
# STRING SEARCHING 1: to return a boolean: found or not found ##################################################
################################################################################################################

#returns a boolean true or false for the presence of a match in the string
#format:	if ($string =~ m/searchterm/i) {}		# m = find a match, i = case insensitive

my $string = "the ball is in the park";
if ($string =~ m/ball/i)
	{
	print "$string\n";
	print "String contains the word: ball\n";	
	}


################################################################################################################
# STRING SEARCHING 2: for extraction ###########################################################################
################################################################################################################

my $string2 = "1   unknown exon 1 5 . - .	gene_id Xkr4;	gene_name Xkr4;";
if ($string2 =~ /^\d\s+\w+\s(\w+)\s(\d)\s(\d)\s\.\s\W\s\.\s\w+\_\w+\s(\w+)/)
	{
	my $feature = $1;				#extracts the data in the first bracket data
	my $start = $2;					#extracts the data in the second bracket data
	my $end = $3;					#extracts the data in the third bracket data
	my $geneid = $4;				#extracts the data in the fourth bracket data
	print "Feature: $feature, Start Position: $start, End Position: $end, Gene ID: $geneid\n"; 
	}


################################################################################################################
# STRING SEARCHING 3: passing variabls #########################################################################
################################################################################################################

my $string3 = "Bcan,Kcns2,Kcna2,Shc3,Grik3,Wdr59,Ntn3,Fbl";
my $gene = "Kcna2";
if ($string3 =~ /$gene/)
	{
		print "Found it!\n";
	}

# NB: If the contents of the variable comes from an input file always consider the hidden characters at the end of the line!
# 		chomp($gene);			
#		$gene =~ s/\r//g;		# Windows files create new lines with \r (the return character) --> try this even if file was created in R


################################################################################################################
# STRING SUBSTITUTION ##########################################################################################
################################################################################################################

#changes the first occurance of a specified substring to something else
#format:	$string =~ s/changefrom/changeto/i;

$string = "the ball is in the park";
print "$string\n";

$string =~ s/the/a/i;
print "$string\n";

#To remove multiple repeats of the same letter
$string = "the ball is yelllllllllllllllllllllllllllllllow";
print "$string\n";
$string =~ s/l+/ll/g;						#g = applies it globally i.e. to entire string
print "$string\n";	

#To remove extra leading whitespace

$string = "            the ball is in the park";
print "$string\n";
$string =~ s/^\s+//i;				#for lagging whitespace chaged to s/\s+$/i
print "$string\n";



















###############################################################################################################
# TRANSILITERATION MODIFIER ###################################################################################
###############################################################################################################

#format: 	$string = ~ tr///;
#changes all occurances of a specified substring to something else - and counts total occurances.
#BE CAREFUL: each letter is treated seperately, and is case sensitive (cant make it case insensitive)

$string = "the ball is in the park";
print "$string\n";	
$string =~ tr/lnp/rzy/;
print "$string\n";	

################################################################################################################
exit;
