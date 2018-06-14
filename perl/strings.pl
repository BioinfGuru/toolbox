# !/usr/bin/perl 

# Split, join, length, substring, and index tutorial - also see regex.pl

use strict;
use warnings;


#use uc($string) or lc($string) to change the case of the entire string


#SPLIT-----------------------------------------------------------------------------------------------------
#splits the string of words in a scalar variable into an array listing each of the words
#format:	my @result=split (" ",$tobesplit);	
#NOTE: there is a space between the quotation marks --> leave it there to space the words in the string


my $string = "the cat is white";
my @words = split (" ", $string);	 


print "string: $string\n";		# prints the string
print "words: @words\n";		# prints each word on one line
foreach my $words (@words)
	{
	print "$words\n";		#prints each word on a new line
	}


#JOIN-------------------------------------------------------------------------------------------------------
#joins the list of all elements in an array and puts the string into a scalar variable
#format:	$result=join (" ", @tobejoined);
#NOTE: there is a space between the quotation marks --> leave it there to space the words in the string


@words = ("the", "cat", "is", "black");
$string = join (" ",@words);		

		
print "words: @words\n";
print "string: $string\n";


#SPLIT, JOIN and MAP combined-------------------------------------------------------------------------------
#This is shorthand for when you want to do something to each word in a string
#format:	$string= 	join " ", 	map {ucfirst lc}		(split(/\s/, $string));
#precedence:			done last	done second		   		done first

$string = "the cat is black";
$string = join " ", map {ucfirst} split " ", $string;	#join and split don't need brackets
print "string: $string\n";


#LENGTH----------------------------------------------------------------------------------------------------
#calculates the number of characters including spaces in a string


$string = "the cat is black";
my $length = length($string);

print "length: $length\n";

#SUBSTRING------------------------------------------------------------------------------------------------
#extracts a substring from a string but remember: the first position in a string is always index 0 
#see grep to extract elements from an array

# Usage:  substr($string, start position, sum of positions to extract)

my $substring;
$string = "the cat is black!";

$substring = substr($string, 11);	#returns position 11 and everthing after it
print "substring: $substring\n";	

$substring = substr($string, -4) = '';   # returns everything before the 4th last character
print "substring: $substring\n";

$substring = substr($string, -6);	#returns the last 6 positions
print "substring: $substring\n";

$substring = substr($string, 11, 5);	#returns position 15 and the next 4 positions, so 5 in total
print "substring: $substring\n";

#INDEX + RINDEX-------------------------------------------------------------------------------------------------
#finds the position of the first/last occurance of a search term in a string
#NB: first position of a string is index 0

my $index;
my $rindex;
$string = "he was there and he was everwhere!";

$index = index($string, "here");		#returns position of first occurence
print "first position of 'here': $index\n";

$index = index($string, "here", 10);		#returns position of first occurence after position 10
print "first position of 'here': $index\n";

$rindex = rindex($string, "here");
print "last position of 'here': $rindex\n";	#returns position of last occurence

#---------------------------------------------------------------
exit;
