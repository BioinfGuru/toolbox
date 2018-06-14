# !/usr/bin/perl 

# Subroutines and referencing tutorial

use strict;use warnings;

#################################################################
# VARIABLES #####################################################
#################################################################


my $message;
my $value = 5;
my $final_value;

#################################################################
#PASSING TO A SUBROUTINE ########################################
#################################################################

#Format:	&subroutinename(first variable to be passed, second variable to be passed);

if($value<10)
	{
	$message = "value less than 10!";
	$final_value = &doit($message,$value);	#everything in the brackets becomes an element of an array passed to the subroutine for access by $_
	}

elsif ($value>10)
	{
	$message = "value greater than 10!";
	$final_value = &doit();
	}
else
	{
	$message = "value is 10!";
	$final_value = &doit();
	}


print "$final_value\n";

#################################################################
# SUBROUTINE ####################################################
#################################################################
# subroutines are usually defined at the end of a script
# This is because local variables ("my") used by a subroutine must be declared higher up in the script

sub doit2
	{
	print"$_[0]\n";
	my $result = $_[1] *10;
		return "$result\n";
	}


sub doit
	{
	foreach (@_)	
		{
		print"$_\n";
		}
	}

sub CalculateGCcontent 
	{
	my ($seq) = @_;
	$seq = uc($seq);
	my $g = $seq =~ tr/G/G/;
	my $c = $seq =~ tr/C/C/;
	my $gc = ($g + $c) / length($seq);
	return $gc;
	}

###############################################################
# Calculatiing log2rpkm #######################################
###############################################################

# In the main script:
my $rpkm = 100;
my $log2rpkm =  &log2($rpkm);
print $log2rpkm, "\n";

# In the subroutine section:
sub log2
	{
        my $n = shift;			# takes the value stored by $rpkm and assigns it to $n
        return log($n)/log(2);
	}

###############################################################
# Try Catch blocks ############################################
###############################################################
# Notice that no & is used to call the subrountine

# In main script:
try
	{
	# See if something works.
  	}
catch 
	{
	# Ok do this instead.
  	}

# In the subroutine section:
sub try (&$)
	{
   	my($try, $catch) = @_;
   	eval { $try };
   	if ($@)
		{
      		local $_ = $@;
      		&$catch;
   		}
	}

sub catch (&)
	{
	$_[0]
	}

##################################################################
exit;


