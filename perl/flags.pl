#!/usr/bin/perl
# Using Flags

use strict; use warnings;

################################################################
# Separating 1 sequence from a file of multiple sequences ######
################################################################
my $in="test.fasta"; 
my $ecoli="ecoli.fasta";
my $bac="bacsu.fasta"; 
my $others="others.fasta";


open (IN,"$in");
open (ECOLI,">$ecoli");
open (BAC,">$bac");
open (OTHERS,">$others"); 

my $flag='0'; # ecoli 1 bacsu 2 

while (<IN>) 
	{
	if ($_ =~ /^>(\S+)/)	#finds sequence identifier lines
		{ 			
		if ($1 =~ /_ECOLI$/) {print ECOLI $_; $flag='1';}
		elsif ($1 =~ /_BSUB$/) {print BAC $_; $flag='2';}
		else {print OTHERS $_; $flag='0';}

		}
	else 			# finds sequence lines
		{ 			
		if ($flag eq '1') {print ECOLI $_;}
		elsif ($flag eq '2') {print BAC $_;}
		else {print OTHERS $_;}
		}	
	}

close IN; close ECOLI; close BAC; close OTHERS;

################################################################
# Separating multiple sequences from a complex file ############
################################################################

my $faOut = "cns.fa";
my $flag = 0; # seqId = 1, seq = 2, quality header ("+") = 3, quality = 4

open (IN,"$ARGV[0]") or die("USAGE: perl fastq_kwc17.pl <filename.fq> <geneId>\n");
open (OUT, ">$faOut");
print "Success\n";

while (<IN>)
	{			
	if ($_ =~ /^@[\w,(,),-]+$/) {$flag = 1;}				
		elsif ($_ =~ /^[A,a,C,c,G,g,T,t,U,u,M,m,R,r,W,w,S,s,Y,y,K,k,V,v,H,h,D,d,B,b,N,n,-]+$/){$flag = 2;}
		elsif ($_ =~ /^\+/) {$flag = 3;} 
		else {$flag = 4;}


	if ($flag == 1) {$_ =~ s/@/>/; print OUT $_;}
		elsif ($flag == 2) {print OUT $_;}
		elsif ($flag == 3) {}
		elsif ($flag == 4) {}
		else {}
	}

close IN; close OUT;
################################################################
exit;
