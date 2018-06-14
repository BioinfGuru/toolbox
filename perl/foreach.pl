# !/usr/bin/perl 

# foreach loops - for iterating through each element of an array, key of a hash, or line of a file, 

use strict;use warnings;

#iterating through an array---------------------------------------------------------------------------
my @array = qw(red orange blue green purple);
my $count;

foreach my $colour(@array)	#iterates through all array elements
	{			
	print"$colour\n";	#prints each element of the array
	$count ++;		#counts each element in the array
	}

print"there are $count numbers\n";


# To access a specific element of an array by index number
print $array[0], "\n"; # prints the first element


#iterating through lines of a file (each line stored as a variable)--------------------------------
open (IN, 'myfile.txt') or die "myfile.txt file doesn't exist in this folder!\n";

foreach my $line(<IN>)
	{
		print $line, "\n";
	}

#iterating through hash---------------------------------------------------------------------------
my %atom1 = ();			#creates the hash
$atom1{acor} = (13);		
$atom1{bcor} = (56);		# these 3 lines populate the hash with a key (e.g. xcor) and a value (e.g. 13)
$atom1{ccor} = (78);


#to iterate through the hash and print each key - the result is printed in random order!
foreach my $key (keys %atom1) 
	{
	print "$key\n";
	}
#to iterate through the hash and print each value - the result is printed in random order!
foreach my $value (values %atom1) 
	{
	print "$value\n";
	}

# to iterate through a hash and print both keys and values see the HASH tutorial.


#---------------------------------------------------------------
exit;
