#!/usr/bin/perl
# pdbdownloader.pl

use strict;
use warnings;

# load PDB module
use WWW::PDB qw(:all);

# test if no argument given
my $pdbid = '2ili';
unless ($ARGV[0]) {
    print "usage: pdbdownloader.pl <pdbid>\n - now in test mode ...\n"
}
$pdbid=$ARGV[0];
    
# now downloading pdb file and printing it
my $fh = get_structure('2ili');
print while <$fh>;
