# !/usr/bin/perl 

# HASH tutorial
# perldoc on hash: http://perldoc.perl.org/perlfaq4.html#How-do-I-look-up-a-hash-element-by-value%3f 

use strict;use warnings;

#---------------------------------------------------------------
#creating a hash (there are another 2 ways, this is the most detailed)
#---------------------------------------------------------------
# Warning: keys must be unique
# so be careful if creating a hash by extracting from a regex
# if 2 lines produce identical keys (e.g. gene name), only one entry will be made in the hash
# the first line will be over written

my %atom1 = ();			# creates a hash called atom1
$atom1{xcor} = (13);		# Adds a key called xcor with the value 13 to the hash
$atom1{ycor} = (56);		
$atom1{zcor} = (78);

my %atom2 = ();			
$atom2{acor} = (45);		
$atom2{bcor} = (76);		
$atom2{ccor} = (34);

#--------------------------------------------------------------
#Printing hashes
#--------------------------------------------------------------

print"@{[%atom1]}\n";		# prints the entire hash as an array with variable names and values
print"$atom1{zcor}\n";		# prints out the value of the zcor key


#--------------------------------------------------------------
#Looping through a HASH
#--------------------------------------------------------------

#3 ways to loop through a hash
#first - list everything
while ((my $key, my $value) = each (%atom1))
	{
	print "$key - $value\n";
	}
#second - print the keys only
foreach my $key (keys %atom1) 
	{
	print "$key\n";
	}
#third - prints the values only
foreach my $value (values %atom1) 
	{
	print "$value\n";
	}


#--------------------------------------------------------------
#Exists, Defined and Delete functions
#--------------------------------------------------------------


#"exists" function - to see if a key exists
# THIS DOESNT WORK WITH DATABASES: USES "DEFINED" INSTEAD
if (exists ($atom1 {xcor}))
	{
	print "key does exist\n";	
	}
else
	{
	print "key does not exist\n";	
	}

#"defined" function - to see if a key has a value
if (defined ($atom1 {xcor}))
	{
	print "key is defined\n";	
	}
else
	{
	print "key is not defined\n";	
	}
#"delete" function - to delete a key and value
delete ($atom1 {xcor});
	if (exists ($atom1 {xcor}))
		{
		print "key does exist\n";	
		}
	else
		{
		print "key does not exist\n";	
		}


#---------------------------------------------------------------
#Reversing, sorting and merging hashes
#---------------------------------------------------------------

#reversing function - the values become the keys and the keys become the values
my %reversed = reverse %atom1;
foreach my $key (keys %reversed)
	{
	print "$key - $reversed{$key}\n";	
	}
#sorting function - will sort according to alphabetical order or numerical order
foreach my $key (sort keys %atom1)
	{
	print "$key\n";
	}
foreach my $value (sort values %atom1)
	{
	print "$value\n";
	}

#merge function - merges 2 hashes in to a new third hash
my %multiatom = (%atom1, %atom2);
print"$multiatom{zcor}\n";	


#---------------------------------------------------------------
exit;
