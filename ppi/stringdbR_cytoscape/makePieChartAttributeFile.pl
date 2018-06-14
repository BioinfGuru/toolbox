# !/usr/bin/perl 
# Creates attribute file for converting nodes to pie charts in cytoscape
# Kenneth condon Feb 2018

use strict;
use warnings;

# create outfile
open (OUT, ">$ARGV[1]") or die("Can't create outfile\nUSAGE: perl makePieChartAttributeFile.pl <inputfile> <outputfile>\n");
print OUT "query_term\tM1\tM2\tM3\n";

# read infile
open (IN,"$ARGV[0]") or die("Infile doesn't exist\nUSAGE: perl makePieChartAttributeFile.pl <infile> <outfile>\n");
my @infile = <IN>;


## To extract ENSEMBL ID
# populate a hash with targets (keys) and motifs (values)
my %hash;
foreach my $line(@infile)
	{
		$line =~ s/\n|\r|\s+$//g;
		my @array = split(/\t/,$line);
		unless ($array[24] eq "ensembl" | $array[24] eq "NA")
			{
				# For the first occurance of a target
				unless (exists ($hash{$array[24]})){$hash{$array[24]} = ($array[9]);}

				# For all subsequent occurances of a target
				else
					{
						my $string = $hash{$array[24]}; # store original value
						$string = $string.$array[9];	# append with new motif
						$hash{$array[24]} = ($string);	# replace original value
					}
			}
	}

## To extract GENE SYMBOL
# # populate a hash with targets (keys) and motifs (values)
# my %hash;
# foreach my $line(@infile)
# 	{
# 		$line =~ s/\n|\r|\s+$//g;
# 		my @array = split(/\t/,$line);
# 		unless (($array[23] eq "symbol") | ($array[23] eq "NA") | ($array[23] eq "a"))
# 			{
# 				# For the first occurance of a target
# 				unless (exists ($hash{$array[23]})){$hash{$array[23]} = ($array[9]);}

# 				# For all subsequent occurances of a target
# 				else
# 					{
# 						my $string = $hash{$array[23]}; # store original value
# 						$string = $string.$array[9];	# append with new motif
# 						$hash{$array[23]} = ($string);	# replace original value
# 					}
# 			}
# 	}

# Convert hash values to binary + write to outfile
while ((my $key, my $value) = each (%hash))
	{
		my $m1 = grep (/M1/, $value); # check if M1 present
		my $m2 = grep (/M2/, $value); # check if M2 present
		my $m3 = grep (/M3/, $value); # check if M3 present


		if ($key =~ m/;/) # to deal with lines with multiple ensembl IDs
			{
				my @array = split(/;/,$key);
				foreach my $x (@array)
					{
						#print "$x\t$value\n";
						print OUT "$x\t$m1\t$m2\t$m3\n";
					}

			}

		else{print OUT "$key\t$m1\t$m2\t$m3\n";}
	}

######
exit;
