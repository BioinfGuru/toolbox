# !/usr/bin/perl 

# array merging reversing and sorting arrays 


use strict;use warnings;


#merge----------------------------------------------------------
my @array1 = ("one","two","three");
my @array2 = ("four","five","six");
my @array3 = (@array1, @array2);
print "@array3\n";

#reverse--------------------------------------------------------
my @reverse = reverse (@array3);
print "@reverse \n";

#sort-----------------------------------------------------------
my @array4 = (3,5,6,1,2,4);
my @array5 = ("bob", "dec", "ann", "carl", "eoin", "finn");

#numbers
#my @sortednum = sort (@array4);
#or to sort them in reverse numerical order:
my @sortednum = sort {$b<=>$a} (@array4);

#characters
#my @sortedchar = sort (@array5);
#or to sort in reverse alphabetical order:
my @sortedchar = sort {$b cmp $a} (@array5);

print "@sortednum\n@sortedchar\n";




#---------------------------------------------------------------
exit;
