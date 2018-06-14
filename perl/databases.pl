# !/usr/bin/perl 
# Perl DBM databases

use strict;use warnings;

#################################################################################################################
# WRITE AND READ A DBM DATABASE #################################################################################
#################################################################################################################

my $id;
my %DATA = (); 													#declares special hash for databases (upper case)

open (IN,"$ARGV[0]") or die("USAGE: perl fastq_kwc17.pl <filename.fq> <geneId>\n");
dbmopen (%DATA, "databasename", 0644) or die ("Cannot create databasename: $!"); 		# if not already created, will create a new database and stores it on the disk as .dir and .pag
print "$ARGV[0] opened and new database created \n";

while (<IN>) {
	chomp;
	if ($_ =~ /^>(\S+)/){
		$id=$1;		
		if ($id =~ /_ECOLI$/) {$flag='1';}
		else  {$flag='2';}				
	}
	else { # sequence line
		if ($flag eq '1') {$DATA{$id}.=$_} #stores ecoli data from file in new database
	}	
}

dbmclose;
#################################################################################################################
exit;
