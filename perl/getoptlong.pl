#!/usr/bin/perl 
# How to use get opt long
# Kenneth Condon Aug 2017
###############################################################################
use strict;
use warnings;
use Getopt::Long;


my ($sample,$peakfile,$outdir,$mode, $help) = "" ;
GetOptions(
    'help' => \$help,
    's=s' => \$sample,
    'p=s' => \$peakfile,
    'o=s' => \$outdir,
    'm=s' => \$mode,
    
) or die "\n**********  Incorrect usage!  ***********\nrun with -help option to see the useage\n\n"; 

sub useage { die(qq/
	USAGE : perl <script> <arguments> <arguments> <arguments> <arguments>
	ARGUMENTS : 
                    REQUIRED
                    -s -> samplename
                    -p -> narrowPeak file
                    -o -> output directory
                    -m -> Analyse ALL (a) peaks or TOP1000 (t) peaks?

                    OPTIONAL
                    -help -> prints this message
                \n/);
}

if($help) { &useage ;}
if( !$sample || !$peakfile || !$outdir || !$mode) { print "\n MISSING ARGUMENTS : Give all the required options\n" ; &useage ;}


