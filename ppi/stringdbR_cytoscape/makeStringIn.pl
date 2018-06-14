# !/usr/bin/perl 
# Creates attribute file for identifying the experiment a gene id came from
# Kenneth condon Feb 2018

use strict;
use warnings;

# read infiles
open (CHIP,"$ARGV[0]") or die("CHIP file doesn't exist\nUSAGE: perl makeExperimentAttributeFile.pl <stringfile> <rnafile> <chipfile> <outputfile>\n");
my @chip = <CHIP>;
open (RNA,"$ARGV[1]") or die("RNA file doesn't exist\nUSAGE: perl makeExperimentAttributeFile.pl <stringfile> <rnafile> <chipfile> <outputfile>\n");
my @rna = <RNA>;

# create outfiles
open (LIST, ">$ARGV[2]") or die("Can't create outfile\nUSAGE: perl makeExperimentAttributeFile.pl <stringfile> <rnafile> <chipfile> <outputfile>\n");
open (ATTR, ">$ARGV[3]") or die("Can't create outfile\nUSAGE: perl makeExperimentAttributeFile.pl <stringfile> <rnafile> <chipfile> <outputfile>\n");
print ATTR "query_term\texp\n";

# populate hash
my %stringIn;
foreach my $chipline(@chip)
	{
		$chipline =~ s/\n|\r|\s+$//g;
 		$stringIn{$chipline} = ("chip");
	}
foreach my $rnaline(@rna)
	{
		$rnaline =~ s/\n|\r|\s+$//g;
		if (exists ($stringIn{$rnaline}))
			{
 				$stringIn{$rnaline} = ("both");				
			}
		else
			{
 				$stringIn{$rnaline} = ("rna");
			}
	} 

# print hash
while ((my $key, my $value) = each (%stringIn))
	{
		print LIST "$key\n";		
		print ATTR "$key\t$value\n";
	}