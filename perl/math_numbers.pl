# !/usr/bin/perl 

# Math operator precedence, checking for equality, auto-increment/decrement, random number generation and rounding

use strict;use warnings;

#Order of precedence:---------------------------------------------
#Brackets --> powers --> multiplication + division --> addition + subtraction

my $sum = 4*(2+4);	
print $sum, "\n";

$sum = 2**-0.1;		#raises 2 to the power of -0.1
print $sum, "\n";

$sum = 2**3*10;		#power is calculated before multiplication
print $sum, "\n";

$sum = 10%3;		#returns the modulus (remainder) of 10/3
print $sum, "\n";

use integer;		#now every equation below will return only integers without rounding.
$sum = 20/3;		#returns 6 instead of 6.6666....notice it hasn't rounded up to 7
print $sum, "\n";




#checking if one value equals another-----------------------------

$sum = 10;
if ($sum==10) 		#checks if the right side value is equal to the value of the leftside variable
	{		#use != to check if they are not equal
	print "the number is 10", "\n";
	}

my $word = "perl";	
if ($word eq "perl")	#same as above but for words instead of numbers
	{		#use ne to check if they are not equal
	print "the word is perl", "\n";	
	}

#auto-increment (++) and auto-decrement (--) ---------------------
my $num1 = 10;
my $num2 = 10;

$num1++;	#automatically adds 1 to $num1
print $num1, "\n";
$num1--;	#automatically subtracts 1 from $num1
print $num1, "\n";

print $num1++, "\n";	#autoincrement suffix ==> 10 is printed then 1 added
print $num1, "\n";	#proves 1 added after printing (11 is printed)
print ++$num2, "\n";	#autoincremet preffix ==> 11 is printed

my $letter = "a";
print $letter, "\n";
$letter++;		#returns next letter in alphabet, if "z" returns "aa"
print $letter, "\n";
$letter--;		#this doesnt work!! returns "-1"
print $letter, "\n";



#RAND-----------------------------------------------------------------------------------------------------

my $random1 = rand(4);		#picks a random number between 0 and 4, (returns 16 characters in total)
print "$random1\n";

my $random2 = int rand(4);	#returns only an interger	
print "$random2\n";

my @array1 = ("hat", "cat", "mat", "rat", "fat");	
print "$array1[$random2]\n";	#returns the element that has the index equal to the random number generated


#ROUNDING---------------------------------------------------------------------------------------------------

my $random = rand(4);	
print "$random\n";

my $rounded = sprintf("%.4f", $random);		# random number rounded to 4 decimal places
print "$rounded\n";

#---------------------------------------------------------------
print time - $^T;
exit;
