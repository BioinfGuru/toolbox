#!/usr/bin/perl -w
use strict; use warnings;
use Bio::Seq;

my $seq_obj = Bio::Seq->new		#creates and names an objec
	(
	-seq => "aaaatgggggggggggccccgtt",	#assigns attriibutes (left side of =>) and values (right side of =>) to the object, just like a hash!
	-desc => "example 1",
	-display_id => "#12345",
	-alphabet => 'dna'
	);
print $seq_obj->seq . "\n";						#prints the attrubut "seq" of the object $seq_obj
 
