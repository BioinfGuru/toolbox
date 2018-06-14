#!/usr/bin/perl -w

use strict;
use warnings;

use Bio::SeqIO;

my $infile = $ARGV[0];

my $in  = Bio::SeqIO->newFh(-file => $infile , '-format' => 'Fasta');
my $out = Bio::SeqIO->newFh('-format' => 'EMBL');

# World's shortest Fasta<->EMBL format converter:
print $out $_ while <$in>;
