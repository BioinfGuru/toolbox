#!/usr/bin/perl -w
use strict; use warnings;
use Bio::Seq;

my $seqObj = Bio::Seq ->new(
				-seq => 'aaaatgggctgtag', 
				-alphabet => 'dna',
				-desc => 'example sequence'
				);

print "sequence=", $seqObj->seq(), "\n";

print "length= ", $seqObj->length(), "\n";

print "translation=", $seqObj->translate()->seq(), "\n";

print "reverse complement=", $seqObj->revcom()->seq(), "\n";

