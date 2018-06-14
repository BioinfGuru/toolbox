# !/usr/bin/perl 

# Using map and grep tutorial

use strict; use warnings;


#MAP-------------------------------------------------------------------------------------------------
#to do something to every element in an array e.g. applying an equation or a function

my @array = (1..10);
print @array, "\n";
map {$_ = $_*2} @array;	#every scalar variable ($_) in the array is multiplied by 2
print @array, "\n";


@array = ("apple", "orange", "banana", "pear");
print @array, "\n";
map {$_ = uc($_)} @array;	#every scalar variable ($_) in the array is changed to upper case
print @array, "\n";


#GREP------------------------------------------------------------------------------------------------
#to grab elements out of an array that match a certain criteria

my @array1 = (0..10);
my @array2 = grep{$_ > 5} @array1; # using greater than
my @array3 = grep{$_ =~ /8/} @array1; # using pattern matching
print "@array1\n", "@array2\n", "@array3\n";

my @array3 = ("apple", "orange", "banana", "pear");
my @array4 = grep {$_ =~ /an/} @array3;		# grabs all words containing "an"
print "@array3\n", "@array4\n";

# to count occurances of an element in an array
my @array = qw(foo ufoo bar food foofighters kung-foo);

my $count_foo = grep (/foo/, @array);		# counts all occurance of words that contain the element
print "$count_foo\n";

my $count_foo = grep { $_ eq 'foo' } @array;	# counts the occurance of only exact matchs
print "$count_foo\n";

#---------------------------------------------------------------
exit;
