# !/usr/bin/perl 
# Create, add and print a hash of arrays

#################################################################################################################
# create a hash of arrays
my %HoA =
	(
    	flintstones    => [ "fred", "barney" ],
    	jetsons        => [ "george", "jane", "elroy" ],
    	simpsons       => [ "homer", "marge", "bart" ],
	);

# add a new key with an array 
$HoA{teletubbies} = [ "tinky winky", "dipsy", "laa-laa", "po" ];

# to append to the end of one of the arrays
push @{ $HoA{flintstones} }, "wilma", "pebbles";

# to alter a value in one of the rows
$HoA{flintstones}[0] = "FRED";

# printing the entire hash:
for my $family ( keys %HoA ) 
	{
    	print "$family: @{ $HoA{$family} }\n";
	}
##################################################################################################################

