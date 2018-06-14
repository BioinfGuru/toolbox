# !/usr/bin/perl 

# conditionals: if, unless, while, until

use strict;use warnings;

#NB: 	"=" assigns the rightside value to the leftside variable
#	"==" checks if rightside value is equal to the value of the leftside variable

#If------------------------------------------------------------------------------------------------------------------------------

my $number = 10;

if ($number > 10)	#to add additional conditions: if ((x)and(y)){}		
	{
	print "the number is greater than 10\n";	#do this when the "if ()" is true
	}

	elsif ($number < 10) 	
		{
		print "the number is less than 10\n";	#do this when the "if ()" is false and the "elseif ()" is true
		}

	else 			
		{
		print "the number is 10\n";		#do this when both "if ()" and "elsif ()" are false
		}

#unless--------------------------------------------------------------------------------------------------------------------------


unless ($number <= 10) 				
	{
	print "the number is greater than 10\n";	#do this when the "unless ()" is false (so "unless" is opposite to "if")
	}

	elsif ($number < 10) 				#the rest of the loop is identical to the if loop
		{
		print "the number is less than 10\n";
		}

	else 			
		{
		print "the number is 10\n";	
		}

#while---------------------------------------------------------------------------------------------------------------------------
#executes an action repeatedly ad infinitum until the condition is FALSE (if only does the action once)
my $count = 1;

while ($count <= 5) 
	{
	print "hello\n";
	$count++;		#without auto-incrementing the count, there would be an inifite loop	
	}

			
#until---------------------------------------------------------------------------------------------------------------------------
#executes an action repeatedly ad infinitum until the condition is TRUE (unless only does the action once)

$count = 1;

until ($count == 5) 
	{
	print "hi\n";
	$count++;		
	}

#---------------------------------------------------------------
exit;
