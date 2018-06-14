# !/usr/bin/perl 
# Pre-processes files for tau.R script
# Requirements: Place the input files and  in the working directory
# Usage: perl /NGS/users/Kenneth/scripts/tissue_specificity/tau_prep.pl <working directory> <ensembl version >
# Kenneth Condon Oct 2016
#################################################################################################################
use strict;
use warnings;
use File::Path 'make_path';
use List::Compare;

#################################################################################################################
# Prepare data structures #######################################################################################
#################################################################################################################
# Store working directory
my $wd = $ARGV[0];

# read in the tissue files
opendir(DIR, $wd);				
my @files = readdir(DIR);			
my @input_files;
foreach my $file(@files){if (($file =~ m/.gtf$|ens\d+.txt$/)){chomp $file; push (@input_files, $wd.$file);}}
close DIR;

# Create directory tree
make_path($wd.'intermediate_files/R', $wd.'intermediate_files/perl/rpkm_replicates', $wd.'intermediate_files/perl/meanrpkm', $wd.'intermediate_files/perl/log2', $wd.'results', $wd.'results/images');
#system"chmod -R 777 $wd";
#system'chmod -R 777 intermediate_files/';
#system'chmod -R 777 results/';


#################################################################################################################
# Parse the ensembl_79.txt file to:
# 1) create a full list of all ensembl 79 ids
# 2) create a filtered list of ensembl 79 ids that are: 1) known genes and 2) protein_coding or lincRNA or miRNA (these are the only ids we are interested in)

my $ensemblfile = "/NGS/users/Kenneth/scripts/tissue_specificity/ensembl_versions/ensembl_".$ARGV[1].".txt";
print "$ensemblfile\n";
my %all_ids;
my @filtered_ids;
open (IN, $ensemblfile) or die "Can't open the ensembl file!\n";
while (<IN>)
	{
	if (($_ =~ m/^(ENSMUSG\d+)\t(.+)\t(.+)\t(.+)/) or ($_ =~ m/^(ENSMUSG\d+)\t()\t(.+)\t(.+)/))
		{
		chomp $1;
		$all_ids{$1} = ($2);
		if ((($3 eq "miRNA") or ($3 eq "lincRNA") or ($3 eq "protein_coding")) and ($4 eq "KNOWN")){push @filtered_ids, $1;}
		}
	}
close IN;

# count the number of ensembl 79 ids
my $count_all = 0;
foreach my $key (keys %all_ids) {$count_all++;}
print "Number of ensembl 79 IDs: $count_all\n";

# count the number of ensembl 79 ids of interest
my $count_int = 0;
foreach my $i (@filtered_ids){$count_int++}
print "Number of ensembl 79 IDs of interest: $count_int\n";

# ################################################################################################################
# Parse every tissue file to:
# 1) create a list of retired ids (these are ids that, until updated, can't be included)
# 2) create a list of ids that are present in every tissue file (these are the only ids that can be compared)
my %retired_ids;
my @common_ids;
foreach my $data_file(@input_files)
	{
	# create an array to store every id in the file
	my @temp_array;
	open (IN, $data_file);
	while (<IN>){if ($_ =~ m/(ENSMUSG\d+)/){chomp $1, push @temp_array, $1;}}
	close IN;

	# identify the ids in the file that are retired
	foreach my $id(@temp_array){unless (exists ($all_ids {$id})){$retired_ids{$id} = (1);}}

	# identify the ids that are in all files
	if (@common_ids) 										# if @common_ids is not empty ...
		{
	  	my $lc = List::Compare->new(\@common_ids, \@temp_array);				# creates a list compare object called $lc
		@common_ids = $lc->get_intersection;							# gets the intersection of the 2 arrays in $lc
		} else {@common_ids = @temp_array;}							# @common_ids is empty (i.e. when the first file is read) => stores the contents of @temp_array in @common_ids
	}

# count the number of common ids
my $count_com = 0;
foreach my $c (@common_ids){$count_com++}
print "Number of comparable IDs: $count_com\n";

# count + print out the retired ids
my $count_ret = 0;
open OUT, ">$wd/results/retired_id_list.txt";
foreach my $key (keys %retired_ids) { print OUT $key, "\n"; $count_ret++;}
print "Number of retired IDs: $count_ret\n";
close OUT;

################################################################################################################
# create a list of ids that: 1) are present in every tissue file and 2) are ids that we are interested in
my $lc = List::Compare->new(\@common_ids, \@filtered_ids);
my @common_filtered_ids = $lc->get_intersection;

# convert the array to a hash: 1) allows faster searching later 2) allows printing of a background gene set for motif discovery
my %common_filtered_ids;
my $count_final = 0;

foreach my $cf_id(@common_filtered_ids)	
	{
	$count_final++;
	
	# identify the gene name for that id
	my $gene_name = $all_ids{$cf_id};

	# populate the hash: keys = gene ids, values = gene names	
	$common_filtered_ids{$cf_id} = ($gene_name);
	}

# print the background gene set for motif discovery
open OUT, ">$wd/results/meme_background_genes.txt";
foreach my $gene_name (values %common_filtered_ids) {print OUT "$gene_name\n";}
close OUT;

print "Number of high confidence IDs: $count_final\n";

# #################################################################################################################
# # Process the files #############################################################################################
# #################################################################################################################
foreach my $input_file(@input_files)						
	{
	# Handle CSHL lab gtf files
	if ($input_file =~ m/^$wd(.+)_cshl_ens65.gtf$/)   
		{
			
		# Prepare the outfiles
		my %printed;
		chomp $1;
		open OUT1, ">$wd/intermediate_files/perl/rpkm_replicates/$1.txt";
		open OUT2, ">$wd/intermediate_files/perl/meanrpkm/$1.txt";
		print OUT2 "ID", "\t", $1, "\n";
		open OUT3, ">$wd/intermediate_files/perl/log2/$1.txt";
		print OUT3 "ID", "\t", $1, "\n";	

		
		# Parse the file
		open (IN, $input_file);
		while (<IN>)
			{
			chomp $_;
			if ($_ =~ m/^.+(ENSMUSG\d+)".+RPKM1 "(.+)"; RPKM2 "(.+)"; iIDR/i)
				{
				# only process ids that zare in the common_filtered_id list				
				if (exists ($common_filtered_ids {$1}))
					{
					# only process ids that are not already printed (avoids duplications)				
					unless (exists ($printed {$1}))
						{
						# Calculate meanrpkm and log2rpkm + print to outfiles					
						print OUT1 $1, "\t", $2, "\t", $3, "\n";
						my $meanrpkm = (($2+$3)/2);
						print OUT2 $1, "\t", $meanrpkm, "\n";
						if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
						my $log2rpkm = log2($meanrpkm);
						if ($log2rpkm<0) {$log2rpkm = 0}		# sets all genes with rpkm <1 as not expressed (because log2(1)=0)					
						print OUT3 $1, "\t", $log2rpkm, "\n";


						# add the id to the printed list
						$printed{$1} = (1);
						}
					}
				}
			}
		close IN;
		close OUT1;
		close OUT2;
		close OUT3;
		}

	# Handle LICR lab txt files
	elsif ($input_file =~ m/$wd(.+)_licr_ens67.txt$/)
		{

		# Prepare the outfiles
		my %printed;
		chomp $1;
		open OUT1, ">$wd/intermediate_files/perl/rpkm_replicates/$1.txt";
		open OUT2, ">$wd/intermediate_files/perl/meanrpkm/$1.txt";
		print OUT2 "ID", "\t", $1, "\n";
		open OUT3, ">$wd/intermediate_files/perl/log2/$1.txt";
		print OUT3 "ID", "\t", $1, "\n";
		
		# Parse the file
		open (IN, $input_file);
		while (<IN>)
			{
			chomp $_;
			if ($_ =~ m/.+\|(ENSMUSG\d+)\t(.+)\t(.+)/gi)
				{
				# only process ids that are in the common_filtered_id list				
				if (exists ($common_filtered_ids {$1}))
					{
					# only process ids that are not already printed (avoids duplications)				
					unless (exists ($printed {$1}))
						{
						# Calculate meanrpkm and log2rpkm + print to outfiles				
						print OUT1 $1, "\t", $2, "\t", $3, "\n";
						my $meanrpkm = (($2+$3)/2);
						print OUT2 $1, "\t", $meanrpkm, "\n";
						if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
						my $log2rpkm = log2($meanrpkm);
						if ($log2rpkm<0) {$log2rpkm = 0}							
						print OUT3 $1, "\t", $log2rpkm, "\n";

						# add the id to the printed list
						$printed{$1} = (1);
						}
					}
				}
			}
		close IN;
		close OUT1;
		close OUT2;	
		close OUT3;
		}

	# Handle SCN txt file
	elsif ($input_file =~ m/$wd(scn)_harwell_ens79.txt$/)
		{

		# Prepare the outfiles
		my %printed;
		chomp $1;
		open OUT1, ">$wd/intermediate_files/perl/rpkm_replicates/$1.txt";
		open OUT2, ">$wd/intermediate_files/perl/meanrpkm/$1.txt";
		print OUT2 "ID", "\t", $1, "\n";
		open OUT3, ">$wd/intermediate_files/perl/log2/$1.txt";
		print OUT3 "ID", "\t", $1, "\n";

		# Parse the file
		open (IN, $input_file);
		while (<IN>)
			{
			chomp $_;
			if ($_ =~ m/^.+\|(ENSMUSG\d+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)/i)
				{
				# only process ids that are in the common_filtered_id list				
				if (exists ($common_filtered_ids {$1}))
					{
					# only process ids that are not already printed (avoids duplications)				
					unless (exists ($printed {$1}))
						{
						# Calculate meanrpkm and log2rpkm + print to outfiles					
						print OUT1 $1, "\t", $2, "\t", $3, "\t", $4, "\t", $5, "\t", $6, "\t", $7, "\t", $8, "\t", $9, "\t", $10, "\t", $11, "\t", $12, "\t", $13, "\n";
						my $meanrpkm = (($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13)/12);
						print OUT2 $1, "\t", $meanrpkm, "\n";
						if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
						my $log2rpkm = log2($meanrpkm);
						if ($log2rpkm<0) {$log2rpkm = 0}						
						print OUT3 $1, "\t", $log2rpkm, "\n";

						# add the id to the printed list
						$printed{$1} = (1);
						}
					}
				}
			}
		close IN;
		close OUT1;	
		close OUT2;
		close OUT3;
		}

	# Handle bgee txt files
	elsif ($input_file =~ m/$wd(.+)_bgee_ens75.txt$/)
		{

		# Prepare the outfiles
		my %printed;
		chomp $1;
		open OUT1, ">$wd/intermediate_files/perl/rpkm_replicates/$1.txt";
		open OUT2, ">$wd/intermediate_files/perl/meanrpkm/$1.txt";
		print OUT2 "ID", "\t", $1, "\n";
		open OUT3, ">$wd/intermediate_files/perl/log2/$1.txt";
		print OUT3 "ID", "\t", $1, "\n";

		# Parse the file
		open (IN, $input_file);
		while (<IN>)
			{
			chomp $_;

			# For tissues with 9 replicates (e.g. whole brain)
			if ($_ =~ m/^(ENSMUSG\d+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)$/i)
				{
				# only process ids that are in the common_filtered_id list				
				if (exists ($common_filtered_ids {$1}))
					{
					# only process ids that are not already printed (avoids duplications)				
					unless (exists ($printed {$1}))
						{
						# Calculate meanrpkm and log2rpkm + print to outfiles
						print OUT1 $1, "\t", $2, "\t", $3, "\t", $4, "\t", $5, "\t", $6, "\t", $7, "\t", $8, "\t", $9, "\t", $10, "\n";
						my $meanrpkm = (($2+$3+$4+$5+$6+$7+$8+$9+$10)/9);
						print OUT2 $1, "\t", $meanrpkm, "\n";
						if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
						my $log2rpkm = log2($meanrpkm);
						if ($log2rpkm<0) {$log2rpkm = 0}						
						print OUT3 $1, "\t", $log2rpkm, "\n";

						# add the id to the printed list
						$printed{$1} = (1);
						}
					}
				}

			# For tissues with 4 replicates (e.g. skeletal muscle) # what is gion on here!
			elsif ($_ =~ m/^(ENSMUSG\d+)\t(.+)\t(.+)\t(.+)\t(.+)$/i)
				{
				# only process ids that are in the common_filtered_id list				
				if (exists ($common_filtered_ids {$1}))
					{
					# only process ids that are not already printed (avoids duplications)				
					unless (exists ($printed {$1}))
						{
						# Calculate meanrpkm and log2rpkm + print to outfiles					
						print OUT1 $1, "\t", $2, "\t", $3, "\t", $4, "\t", $5, "\n";
						my $meanrpkm = (($2+$3+$4+$5)/4);
						print OUT2 $1, "\t", $meanrpkm, "\n";
						if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
						my $log2rpkm = log2($meanrpkm);
						if ($log2rpkm<0) {$log2rpkm = 0}						
						print OUT3 $1, "\t", $log2rpkm, "\n";

						# add the id to the printed list
						$printed{$1} = (1);
						}
					}
				}
			}
		close IN;
		close OUT1;	
		close OUT2;
		close OUT3;
		}

	# Handle other inhouse processed txt files with variable number of replicates
	elsif ($input_file =~ m/$wd(.+)_ens\d\d.txt$/)
		{

		# Prepare the outfiles
		my %printed;
		chomp $1;
		open OUT1, ">$wd/intermediate_files/perl/rpkm_replicates/$1.txt";
		open OUT2, ">$wd/intermediate_files/perl/meanrpkm/$1.txt";
		print OUT2 "ID", "\t", $1, "\n";
		open OUT3, ">$wd/intermediate_files/perl/log2/$1.txt";
		print OUT3 "ID", "\t", $1, "\n";

		# count number of replicates
		my @columns = `awk '{print NF}' $input_file`;
		$columns[0] =~ s/\n//g;
		my $replicates = $columns[0]-1;

		# For tissues with 2 replicates
		if ($replicates == 2)
			{
			open (IN, $input_file);
			while (<IN>)
				{
				chomp $_;
				if ($_ =~ m/^.+\|(ENSMUSG\d+)\t(.+)\t(.+)$/i)
					{
					# only process ids that are in the common_filtered_id list				
					if (exists ($common_filtered_ids {$1}))
						{
						# only process ids that are not already printed (avoids duplications)				
						unless (exists ($printed {$1}))
							{
							# Calculate meanrpkm and log2rpkm + print to outfiles					
							print OUT1 $1, "\t", $2, "\t", $3, "\n";
							my $meanrpkm = (($2+$3)/2);
							print OUT2 $1, "\t", $meanrpkm, "\n";
							if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
							my $log2rpkm = log2($meanrpkm);
							if ($log2rpkm<0) {$log2rpkm = 0}						
							print OUT3 $1, "\t", $log2rpkm, "\n";

							# add the id to the printed list
							$printed{$1} = (1);
							}
						}
					}
				}
			}		

		# For tissues with 4 replicates
		if ($replicates == 4)
			{
			open (IN, $input_file);
			while (<IN>)
				{
				chomp $_;
				if ($_ =~ m/^.+\|(ENSMUSG\d+)\t(.+)\t(.+)\t(.+)\t(.+)$/i)
					{
					# only process ids that are in the common_filtered_id list				
					if (exists ($common_filtered_ids {$1}))
						{
						# only process ids that are not already printed (avoids duplications)				
						unless (exists ($printed {$1}))
							{
							# Calculate meanrpkm and log2rpkm + print to outfiles					
							print OUT1 $1, "\t", $2, "\t", $3, "\t", $4, "\t", $5, "\n";
							my $meanrpkm = (($2+$3+$4+$5)/4);
							print OUT2 $1, "\t", $meanrpkm, "\n";
							if ($meanrpkm == 0) {$meanrpkm = 0.0000000001}
							my $log2rpkm = log2($meanrpkm);
							if ($log2rpkm<0) {$log2rpkm = 0}						
							print OUT3 $1, "\t", $log2rpkm, "\n";

							# add the id to the printed list
							$printed{$1} = (1);
							}
						}
					}
				}
			}
		}
	}

# ################################################################################################################
# # SUBROUTINES ##################################################################################################
# ################################################################################################################

# For calculating log2
sub log2
	{
        my $n = shift;
        return log($n)/log(2);
	}

# #################################################################################################################
# # Use a system call to run tau.R
# print "tau_prep.pl complete\nRunning tau.R...\n";
# exec 'Rscript /NGS/users/Kenneth/scripts/tissue_specificity/tau.R; exit'; 
# #################################################################################################################
