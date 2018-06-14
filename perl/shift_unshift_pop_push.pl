# !/usr/bin/perl 
# Explains shift, unshift, push and pop

use strict;use warnings;

#################################################################################################################

my @array1 = ('car', 'bus', 'train', 'plane', 'boat');
print "@array1\n\n";							# prints: car bus train plain boat

#################################################################################################################
# SHIFT + UNSHIFT################################################################################################
#################################################################################################################

# SHIFT - Removes and returns the first element in an array (moves every element 1 position to the left)

my $deletedstart = shift @array1;
print "@array1\n";							# prints: bus train plain boat
print "$deletedstart was deleted from the start of the array\n";	# prints: car

# Unshift - Adds an element to the start of an array

unshift (@array1, 'car');					
print "@array1\n\n";							# prints: car bus train plain boat

#################################################################################################################
# POP + PUSH ####################################################################################################
#################################################################################################################

# Pop - Removes and returns an element from the end of an array

my $deletedend =  pop @array1;
print "@array1\n";							# prints: car bus train plain
print "$deletedend was deleted from the end of the array\n";		# prints: boat


# Adds an element to the end of an array

push (@array1, 'boat');
print "@array1\n";							# prints: bus train plain boat boat


#################################################################################################################
exit;



