# !/usr/bin/perl 
# to identify which ensembl version was used to annotate a file, place the file of interest in this folder

use strict;
use warnings;

# Take in the file of interest + put all ids into a hash (prevents duplication)
open (MYFILE,"$ARGV[0]") or die("USAGE: perl which_enembl_version.pl <filname>\n");
print "Checking which ensembl version was used to annotate $ARGV[0]...\n";
my %my_ids;
while (<MYFILE>){if ($_ =~ m/(ENSMUSG\d+)/){chomp $1; $my_ids{$1} = (1);}}
close MYFILE;

# create an result file:
open OUT, ">results.txt";

# Create an array of all ensembl files
my $file_count = 0;
opendir(DIR, ".");				
my @all_files = readdir(DIR);				
my @ensembl_versions;
foreach my $file(@all_files){if (($file =~ m/^ensembl/)){$file_count++; push (@ensembl_versions, $file);}}
close DIR;

# Find the version that annotated the file
my $progress_count = 0;
foreach my $ensembl_file(@ensembl_versions)
	{
	# Progress report
	$progress_count++;
	print "Processing ... $progress_count/$file_count\n";

	# create an array of the IDs in the ensembl file
	open (IN, $ensembl_file);
	my @ensembl_ids;
	while (<IN>){if ($_ =~ m/^(ENSMUSG\d+)\t/){chomp $1;push (@ensembl_ids, $1);}}
	close IN;

	# check if every id in %my_ids is in @ensembl_ids
	my $count = 0;

	foreach my $key (keys %my_ids) 
		{
		# count occurances of the id in the ensembl file
		my $occurances = grep { $_ eq $key } @ensembl_ids;

		# count the number of ids not found in the ensembl file
		if ($occurances == 0) {$count++;}
		}

	print OUT "IDs not found in $ensembl_file:\t$count\n";
	}

