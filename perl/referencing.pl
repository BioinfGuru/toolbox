# !/usr/bin/perl 

# Referencing and de-referencing

use strict;use warnings;

###############################################################################################################
# HARD REFERENCES #############################################################################################
###############################################################################################################

#Scalar ref/deref
my $variable = "A string of text.";	
my $reference1 = \$variable;
print "$$reference1\n";				# dereferencing prints the scalar variable

#Array ref/deref
my @array = ("A".."G");
my $reference2 = \@array;
print "@$reference2\n";				# dereferencing prints all of the array
print "$reference2->[2]\n";			# dereferencing using the arrow operator, prints index 2 of the array, notice data type not needed

# Array of arrays ref/deref
my @array1 = ('a', 'b', 'c');
my @array2 = (1,2,3);
my @both = (\@array1, \@array2);		# creates an array of referenced arrays
print "@both->[0]->[0]\n";			# dereferencing using the arrow operator, prints the first element of the first


#Hash ref/deref
my %hash =
	(
	1	=>	'jon',
	2	=>	'mike',
	3	=>	'ken',
	);
my $reference3 = \%hash;
print "$$reference3{1}\n";			# dereferencing prints the value for hash key 1	
print "$reference3->{2}\n";			# dereferencing using the arrow operator, prints the value of KEY 2 of the hash, again notice data type not needed


#Subroutine ref/deref
sub subroutine
	{
	print "I'm a subroutine\n";	
	}
my $reference4 = \&subroutine;
&$reference4;					# dereferencing runs the subroutine
$reference4->();				# dereferencing using the arrow operator and empty brackets, runs the subroutine, again notice data type not needed







#Using references to pass arrays to sub routines:

my @letters = ('a', 'b', 'c'); 
my @numbers = (1, 2, 3); 
my $ref_letters = \@letters; 
my $ref_numbers = \@numbers; 
&print_args ($ref_letters,$ref_numbers);

sub print_args 
	{ 
	my $n=1;
	foreach my $ref (@_) {printf "Array %d: @$ref\n",$n++;} 
	} 



























################################################################################################################
exit;
