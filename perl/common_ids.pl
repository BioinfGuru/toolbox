# !/usr/bin/perl 
# Creates a list of genes that are present in every file in a folder
# Kenneth Condon Oct 2016
#################################################################################################################
use strict;
use warnings;
use List::Compare;

# store the files of interest in an array
opendir(DIR, ".");				# opens the current directory and creates a file handle
my @files = readdir(DIR);			# stores all file names contained in the directory in an array	
my @input_files;
foreach my $file(@files){if (($file =~ m/.gtf$|ens\d+.txt$/)){chomp $file; push (@input_files, $file);}} # Puts only the required files in an array
close DIR;					

# create a list of ids that are present in every file
my @common_ids;
foreach my $data_file(@input_files)
	{
	# store all ids in a temp array
	my @temp_array;
	open (IN, $data_file);
	while (<IN>){if ($_ =~ m/(ENSMUSG\d+)/){chomp $1, push @temp_array, $1;}}
	close IN;

	# get the intersection of the temp array and the common id array
	if (@common_ids) 										# if @common_ids is not empty ...
		{
    		my $lc = List::Compare->new(\@common_ids, \@temp_array);				# creates a list compare object called $lc
 		@common_ids = $lc->get_intersection;							# gets the intersection of all arrays in $lc
		} else {@common_ids = @temp_array;}							# @common_ids is empty => stores the contents of @temp_array in @common_ids
	}

# print the sorted gene list to an outfile
open OUT, ">common_ids.txt";
foreach my $id(@common_ids) {print OUT $id, "\n";}
close OUT;

#####################################################################
exit;

