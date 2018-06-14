#!/usr/bin/perl
#finding common stuff between two files
#Author: Sid

use Getopt::Long;
use Cwd ;

my ($path,$help,$out,$file1,$file2,$col1,$col2,$quiet,$pr1,$pr2,$pf1,$pf2,$pi) = "" ;
GetOptions(
    'help'   => \$help,
    'o=s' => \$out ,
    'i1=s' => \$file1 ,
    'i2=s' => \$file2 ,
    'c1=i' => \$col1 ,
    'c2=i' => \$col2 ,
    'p=s' => \$path ,
    'q' => \$quiet ,
    'pr1' => \$pr1 ,
    'pr2' => \$pr2 ,
    'pf1' => \$pf1 ,
    'pf2' => \$pf2 ,
    'pi' => \$pi ,
) or die "\n**********  Incorrect usage!  ***********\nrun with -help option to see the useage\n ";

sub useage { die(qq/
	USAGE : perl <script> <arguments>
	ARGUMENTS :
                    REQUIRED
                    -i1 -> input file 1
                    -i2 -> input file 2
                    -c1 -> column number of file 1 for key to match
                    -c2 -> column number of file 2 for key to match
                    -o -> name of the output files\/directory
                    OPTIONAL
                    -pr2 -> print output from file2 [ default : prints from file1 ]
                    -q -> quiet , do not print not found items
                    -p -> OUTPUT path where the files need to be saved
                    -pf1 -> print only file 1 unique
                    -pf2 -> print only file 2 unique
                    -pi -> print only intersection (default)
                    -help -> prints this help message
               \n/);
}

if($help) { &useage ;}
if(!$file1 || !$file2 || !$col1 || !$col2) { print "\n MISSING ARGUMENTS : Give all the required options\n" ; &useage ;}
#unless( ) { print "\n \n" ; &useage ;}
if( !$path || $path =~ /\./ ) { $cwd = getcwd ; $path = "$cwd" ; }


if(!$pf1 && !$pf2 || $pi) {
	print "INTERSECTION OF FILES : $out\n" ;
	open(out, "> $path/$out");
}
elsif($pf1) {
	print "UNIQUE VALUES in File 1 : $out\n" ;
	open(out3, "> $path/$out");
}
elsif($pf2) {
	print "UNIQUE VALUES in File 2 : $out\n" ;
	open(out2, "> $path/$out");
}



my (%hash1,%hash2) = ();

### table 1
open (file1, $file1)or die "Cannot open file $file1 \n";
my $colNum1 = $col1 - 1 ;
foreach(<file1>) {
	$_ =~ s/\r|\n//g ;
 	my(@a) = split("\t",$_);
 	$a[$colNum1] =~ s/\r|\n|\s+$//g ;
 	$hash1{lc($a[$colNum1])}= $_ ;
}
close file1 ;


open(file2,$file2)or die "Cannot open file $file2 \n\n";
my $colNum2 = $col2 - 1 ;
my $lineNum = 0 ;
foreach(<file2>) {
	$lineNum++ ;
	$_ =~ s/\r|\n|\s+$//g ;
	my(@a) = split(/\t/,$_) ;
	$a[$colNum2] =~ s/\r|\n|\s+$//g ;
	#print "$a[$colNum2]\n" ;
	if(exists $hash1{lc($a[$colNum2])}) {
		if($pr2) {
			print out "$_\n" ;
		}
		else{
			my $value = $hash1{lc($a[$colNum2])} ;
			print out "$value\n" ;
		}
	}
	else {
		#print "$a[$colNum2]\n" ;
		#print "$a[$colNum2]\tline $lineNum\tNOT FOUND in $file1\n" ;
		if($quiet) {}
		else {
			#print "$a[$colNum2]\tline $lineNum\tNOT FOUND in $file1\n" ;
			print out2 "$_\n" ;
      #print out "$a[$colNum2]\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\n" ;
		}
	}
}
close file2 ; close out ; close out2 ;




### table 2
open (file2, $file2)or die "Cannot open file $file2 \n";
my $colNum2 = $col2 - 1 ;
foreach(<file2>) {
	$_ =~ s/\r|\n//g ;
 	my(@a) = split("\t",$_);
 	$a[$colNum2] =~ s/\r|\n|\s+$//g ;
 	$hash2{lc($a[$colNum2])}= $_ ;
}
close file2 ;

#open(out3, "> $path/$out.uniq.file1");
open (file1, $file1)or die "Cannot open file $file1 \n";
foreach(<file1>) {
	$_ =~ s/\r|\n//g ;
 	my(@a) = split("\t",$_);
 	$a[$colNum1] =~ s/\r|\n|\s+$//g ;
	if ( !exists $hash2{lc($a[$colNum1])}) {
			print out3 "$_\n" ;
	}
}

close file1 ; close out3 ;
