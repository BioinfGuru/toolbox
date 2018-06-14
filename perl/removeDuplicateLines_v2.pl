#!/usr/bin/perl
# To remove duplicate lines from a file, EXTENSION: you can give multiple column numbers
#Author: Sid 

use Getopt::Long;
use Cwd ;

my ($path,$help,$out,$in,$col,$whole) = "" ;
GetOptions(
    'help'   => \$help,
    'path=s' => \$path ,
    'i=s' => \$in ,
    'c=s' => \$col ,
    'o=s' => \$out ,
    'w' => \$whole ,
    
) or die "\n**********  Incorrect usage!  ***********\nrun with -help option to see the useage\n "; 


sub useage { die(qq/
	USAGE : perl <script> <arguments>
	ARGUMENTS : 
                    REQUIRED
                    -i -> input file
                    -o -> name of the output files\/directory
                    -c -> column numbers to be used for removing dupliactes (seperate by comma)
                    -w -> use the complete line [ not implemented yet ]
                    OPTIONAL
                    -p -> OUTPUT path where the files need to be saved
                    -help -> prints this help message
               \n/);
}
if($help) { &useage ;}
if(!$in || !$col || !$out) { print "\n MISSING ARGUMENTS : Give all the required options\n" ; &useage ;}
if( !$path || $path =~ /\./ ) { $cwd = getcwd ; $path = "$cwd" ; }


my %lines;
open DATA, $in or die "Couldn't open $in: $!\n";
open(out1,">$path/$out.uniq") ;
open(out2,">$path/$out.duplic") ;

if($col) {
my @cols = split(",",$col) ;
while (<DATA>) {
	$_ =~ s/\r|\n|\s+$//g ;
	my(@array) = split("\t",$_) ;
	my @values ;
	foreach my $c(@cols) {
		my $colNum = $c - 1 ;
		my $value = $array[$colNum] ;
		push(@values,$value) ;
	}
	my $newLine = join("\t",@values) ;

	if(exists $lines{$newLine}) {
		print out2 "$newLine\n" ;
	}
	else {
		print out1 "$_\n" ;
	}
	$lines{$newLine} = $_ ;
}

close DATA ; close out1 ;
}

if($whole) {
while (<DATA>) {
	$_ =~ s/\r|\n|\s+$//g ;
	if(exists $lines{$_}) {
		print out2 "$newLine\n" ;
	}
	else {
		print out1 "$_\n" ;
	}
	$lines{$_} = $_ ;
}

close DATA ; close out1 ;
}


















