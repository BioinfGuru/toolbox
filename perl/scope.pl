# !/usr/bin/perl 
# Explains the scope of variables

use strict;use warnings;

#################################################################################################################
# MY ############################################################################################################
#################################################################################################################
# When declared outside a block:		"my" variables are global - they exist in memory while the script is running, so can be used anywhere in the script
# When declared inside a block:			"my" variables are local - they don't exist in memory unless the block is running so can't be used outside the block				

my $name = 'jon';
sub printit
	{
	print "$name\n";	# $name refers to the "my" variable declared outside the block - jon is printed
	$name = 'mike';		# changes the value of $name to mike
	print "$name\n";	# mike is printed
	}

sub printit2
	{
	my $name = 'fred';	# The use of "my" limits the variable $name to exist only while the subroutine is called
	print "$name\n";	# $name now refers to the "my" variable declared inside the block
	}

print "$name\n";
printit;
printit2;
print "$name\n";		# notice the origonal was changed to mike by printit

#################################################################################################################
# OUR #########################################################################################################
#################################################################################################################
# This is simply a variable that is visible by a different script so...
# If script1 declares an "our" variable and script2 "uses" script1....
# Then script2 can use any "our" variable declared in script1 as though it were a "my" variable declared outside any blocks in script2
# "Our" variable names are written in UPPERCASE
# http://stackoverflow.com/questions/845060/what-is-the-difference-between-my-and-our-in-perl 

#################################################################################################################
# LOCAL #########################################################################################################
#################################################################################################################
# Same scope as "my" but... 
# Creates a local variable with the same name as an already existing global variable that can be passed to other subroutines instead of the global variable
# Usage: "our $variablename" followed by "local $variablename" - you must use "our" first, "local" wont work on "my"

our $number = 1;
sub first
	{
	print "first subroutine: $number\n";
	}

sub second
	{
	my $number = 2;	
	print "second subroutine: $number\n";
	first;					# the first subroutine uses the global variable created at line 37
	}

sub third
	{
	local $number = 3;
	print "third subroutine: $number\n";
	first;					# now the first subroutine uses the local variable created here
	}

print "$number\n";	# prints "1" (the global variable created at line 26)
first;			# prints "1" (the global variable created at line 26) 
second;			# prints "2" (the local variable created at line 35), then prints "1" (the global variable created at line 26)
third;			# prints "3" (the local variable copy (line 49) of the global variable (line 35)) 
print "$number\n";	# prints "1" (the global variable created at line 26) - notice the original is not altered

#################################################################################################################
exit;
