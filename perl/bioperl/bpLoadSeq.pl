#!/usr/bin/perl
# Perl script to load sequences from RefSeq with BioPerl
# usage: bpLoadSeq.pl <refseq ID>
use warnings; use strict;

# load the necessary packages
use Bio::DB::RefSeq;
use Bio::SeqIO;

# get refseq entry code from command line - NM_007294 (BRCA1)
my $id = $ARGV[0];
# create new database download object
my $db_object = Bio::DB::RefSeq->new();
# download complete sequence
my $seq_object = $db_object->get_Seq_by_id($id);
# create new output object in fasta format
my $out_object = Bio::SeqIO->new( '-file' => ">$id.fasta",
				      '-format' => 'fasta');
# create the file
$out_object->write_seq($seq_object);
