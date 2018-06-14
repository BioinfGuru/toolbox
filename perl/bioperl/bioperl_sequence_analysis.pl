# !/usr/bin/perl 
# Bioperl pipeline for sequence analysis: Read a FASTA file -> BLAST search -> Parse blast report -> Retrieve hit sequences -> System calls: MSA using MUSCLE + Veiw alignment with ClustalX.
# Input: Fasta file with a single sequence + header
# This script takes a FASTA file with a single seq ID and sequence inside and runs a blastp search on it. It then parses the blast report and retrieves the sequences of top ten hits and aligns them using muscle
# The final alignment is then displayed as a popup window in clustalx
#
#
# Kenneth Condon: 6th May 2016

use strict;
use warnings;
use Bio::Seq;											# For setting the blast parameters
use Bio::Tools::Run::RemoteBlast;								# For running the blast search
use Bio::SearchIO;										# For parsing the blast report
use Bio::DB::GenBank;										# For retrieving hit sequences

#################################################################
# Initialisation (setting) of the BLAST search parameters #######
#################################################################

									
my $infile = shift or die "Usage: perl $0 filename.fasta\n";					# Assigns a .fasta file defined in the command line as the infile or gives a usage message 
my $prog = 'blastp';										# |\	 
my $db   = 'swissprot';										# | > Assigns blast type, database and e-value threshold to scalar variables
my $e_val= '1e-10';										# |/	
 
my @params =											# |\
	( 											# | \
	'-prog' => $prog,									# |  \
	'-data' => $db,										# |   > Sets the parameters of the blast search as the variables created above
	'-expect' => $e_val,									# |  /
	'-readmethod' => 'SearchIO'								# | /
	);											# |/
 
my $factory = Bio::Tools::Run::RemoteBlast->new(@params);					# Remote-blast "factory object" creation and blast-parameter initialization

#################################################################
# Run the BLAST search and save to an output file ###############
#################################################################
print "Running $prog of $infile against $db...\n";						# Status report printed to terminal

my $str = Bio::SeqIO->new(-file=> $infile, -format => 'fasta' );				# $str object created to store fasta contents of the infile
 
while (my $input = $str->next_seq)								# Iteration through the $str object to extract the sequence and store it as $input
	{
	my $r = $factory->submit_blast($input);							# Submission of the sequence (in $input) to blastp using the object $factory (with the parameters defined above)
	print STDERR "Searching...";
  	while (my @rids = $factory->each_rid) 							#rid = read id --> the hit IDs found in the blast search
		{			
    		foreach my $rid (@rids) 				
			{						
      			my $rc = $factory->retrieve_blast($rid);				#Retrieves the blast search results for each hit
     			if(!ref($rc)) 
				{
        			if($rc < 0) 
					{
	          			$factory->remove_rid($rid);
        				}
        			print STDERR ".";
        			sleep 5;
      				} 
			else 
				{
        			my $result = $rc->next_result;
        			my $filename = "blast.out";					# Storing the blast report as a text file called "blast.out" --> constant filename allows the use of this pipeline on diferent fasta input files 			
        			$factory->save_output($filename);
        			$factory->remove_rid($rid);
      				}
    			}
  		}
	}

#################################################################
# Parsing the BLAST results #####################################
#################################################################

																
my $blastreport = Bio::SearchIO->new(-format => 'blast',-file   => 'blast.out');						# Creates a new object called $blastreport for storing the contents of blast.out
my $parsedreport = "hits.txt"; open (OUT, ">$parsedreport");									# Writes an empty file called hits.txt and assigns it to a variable called $parsedreport
my @hits = "";															# Creates an array which will contain all of the accession numbers for retrieving sequences from GenBank
print OUT "Top Ten Best Hits:\n\nQuery_ID\t\t\tHit_Sequence_Identifier\t\tScore\t\tE-value\t\t\% Identity\n";			# Writes the header and tab delimited columns in the hits.txt file							
print "\nParsing...\n";														# Status report printed to terminal

												
while (my $result = $blastreport->next_result) 							# Recursively iterates through the blast report
	{
	my $count = 1;										# Counter to store number of hits printed so far (only need top ten) 
     	while (my $hit = $result->next_hit)
		{			
		while ((my $hsp = $hit->next_hsp) and ($count <=10))				# Iterates through each high-scoring segment pairing (HSP) to write the following from the top ten hits to the hits.txt file
			{             		
			print OUT $result -> query_name."\t";					# Query sequence identifier					|\
			print OUT "\t". $hit -> name . "\t";					# Hit sequence identifier					| \	Although these were the attributes asked for, many other
			print OUT "\t". $hit -> bits . "\t";					# Hit score							|  >    attributes of the hits can be extracted at this point:
			print OUT "\t". $hsp -> evalue . "\t";					# E-value							| /	e.g. length, start position, stop position etc...
			printf OUT "\t". "%2.1f" , ($hsp -> percent_identity);			# % sequence identity between hsp and query sequence		|/	
			print OUT "\n";
			push @hits, $hit -> accession;						# Adds the hit sequence accession number to the end of the @hits array
			$count++;								# Counts +1 for each hit
         		}
     		}
 	}

close OUT;											# Closes the hits.txt file

#################################################################
# Creating a multi-FASTA file of top ten hits ###################
#################################################################
print "Creating Multi-FASTA file...\n";								# Status report printed to terminal
my $multifasta = "hits.fasta"; open (OUT, ">$multifasta");					# Writes an empty file called hits.fasta and assigns it to a variable called $multifasta
my $gb = Bio::DB::GenBank->new(-retrievaltype => 'tempfile', -format => 'Fasta');		# $gb object created to store fasta results of the genbank search of each accesion number in the @hit array
my $seqio = $gb->get_Stream_by_acc([@hits]);							# Creation of a $seqio variable to store each result of the genbank search
while (my $clone = $seqio->next_seq)								# Iteration through each result in $seqio to write the following to the hits.fasta file: 
	{
	print OUT ">". $clone-> display_id . "\n";						# >Sequence identifier
	print OUT $clone-> seq . "\n";								# Amino acid sequence
    	}

close OUT;											# Closes hits.fasta file

#################################################################
# Multiple sequence alignment using MUSCLE ######################
#################################################################
print "Aligning with MUSCLE...\n";								# Status report printed to terminal
exec 'muscle -in hits.fasta -out hits.aln; clustalx hits.aln; exit'; 				# see below

################################################################




# MUSCLE was installed (http://www.drive5.com/muscle/downloads.htm) and the .bashrc file was edited correctly ('which muscle' provides the PATH:/home/kwc17/bin/muscle)
# The allignment folder downloaded from blackboard was copied to /usr/local/share/perl/5.18.2/Bio/Tools/Run/ using sudo
# However muscle.pm will not work with the latest version of muscle (3.8.31)
# So a system call was used instead:

# The exec command executes three system commands in the command line and then exits the perl script (so there is no need for 'exit' command at the end of the script.
# 1: Uses MUSCLE to align the sequences stored in hits.fasta and stores the alignment in a file caled hits.aln in the default ClustalW output
# 2: The hits.aln file is opened by ClustalX GUI for veiwing the alignment 
# 3: The command line exits on closure of ClustalX

