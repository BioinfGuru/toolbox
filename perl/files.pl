# !/usr/bin/perl 
# Opening, reading, closing, writing, appending, renaming, copying and deleting files.

use strict;use warnings;

#################################################################################################################
# OPENING, READING AND CLOSING FILES ############################################################################
#################################################################################################################

#Basic format:
open (FILE, "testfile.txt") or die("File not found\n");
flock (FILE,2); #locks the file so 2 users can't simoultaneously edit the file
print <FILE>;
close FILE;

#Reading a file to an array
open (FILE, "testfile.txt") or die("File not found\n");
flock (FILE,2);
my @array = <FILE>;
close FILE;
print @array;

#To ask the user for the file to be opened, and then open it.
print"Please enter full path to the file\n";
my $file = <STDIN>;
chomp $file; #removes the final character (return key) from the input
open (FILE, "$file") or die("$file not found\n");
flock (FILE,2);
print "Success\n";
close FILE;


#iterating through lines of a file + removing hidden characters
open (IN, 'testfile.txt') or die "testfile.txt file doesn't exist in this folder!\n";

foreach my $line(<IN>) # stores each line as a variable --> it is better to read the file to an array and close the file, then iterate through the array!!!
	{
		# Remove newline characters, windows characters and spaces at the end of a variable
		$line =~ s/\n|\r|\s+$//g;
		print $line, "\n";
	}

#################################################################################################################
# WRITING or APPENDING A TEXT FILE ##############################################################################
#################################################################################################################

open (FILE, ">testfile2.txt");	# > = write file  operator
flock (FILE,2);
print FILE "hello\n";		# writes hello on first line of new file - doesn't print anything in terminal
close FILE;

open (FILE, ">>testfile2.txt");	# >> = append file  operator (adds to end of file that already exists)
flock (FILE,2);
print FILE "How are you\n";	
close FILE;

#################################################################################################################
# RENAMING, MOVING, COPYING AND DELETING A TEXT FILE ############################################################
#################################################################################################################

#renaming
rename ("testfile2.txt", "testfile3.txt");

#moving
#rename ('./filname', './subdirectory/filename');

#copying - perl doesn;t have a copy function so the "Copy" function in a module called "File" must be used.
use File::Copy;
copy("testfile3.txt", "testfile3copy.txt");

#deleting
unlink ("testfile3.txt", "testfile3copy.txt");

#################################################################################################################
# Convert space separated file to tab separated file ############################################################
#################################################################################################################
# this also shows how to store each 

open (OUT, ">my_file_result.tsv");
open (IN, "testfile.txt");
foreach my $line(<IN>)
	{
		chomp $line;
		my @array = split(/\|+/,$line);		# stores each space separated value as an element in an array
		my $string = join ("\t",@array);	# creates a tab separated string of the array values
		print OUT $string, "\n";
	}
close IN;

#################################################################################################################
exit;
