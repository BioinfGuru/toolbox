#!/usr/bin/perl

sub Average
	{
	my @array = @_; 	# save the array passed to this function
	my $sum=0; 		# create a variable to hold the sum of the array's values
	foreach (@array) 
		{ 
		$sum += $_; 	# add each element of the array to the sum
		} 

	return $sum/@array; 	# divide sum by the number of elements in the array to find the mean
	}

@dataArray = (1, 2, 3, 4, 5, 6, 7, 8, 9);
$avgOfArray = Average(@dataArray);
print "$avgOfArray\n"
# here the average will be 5





####################################################################################
exit;
