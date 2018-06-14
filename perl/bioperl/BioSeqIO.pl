#!/usr/bin/perl -w
use strict;
use Bio::SeqIO; # this class has routines for reading and writing sequences to files
my $infile = $ARGV[0];
# creates a seqIO object for reading
my $seqioObj = Bio::SeqIO->new(
					-file => $infile,
					-format => 'fasta'
);
# step through the file and print the header for each sequence
while(my $seq = $seqioObj->next_seq()) {
	print $seq->display_id();
 	print $seq->seq();
	print "\n";
}

