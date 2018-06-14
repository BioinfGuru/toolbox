# !/usr/bin/perl 
# opening, reading, closing, changing, making and deleting directories

use strict;use warnings;

#################################################################################################################
# OPENING and READING directories ###############################################################################
#################################################################################################################

#basic format:
#opendir (DIR, ".");			#opens the current directory
opendir(DIR, "testdirectory");		#opens a specified directory
my @files = readdir(DIR);
#closedir(DIR);
print "@files\n";

#To ask the user for the directory to be opened, and then open it.
#same as for opening files but using DIR as the filehandle
print"Please enter full path to the directory\n";
my $dir = <STDIN>;
chomp $dir; 
opendir(DIR, $dir);
@files = readdir(DIR);
closedir(DIR);
print "@files\n";

#################################################################################################################
# MAKING, CHANGING and DELETING directories #####################################################################
#################################################################################################################
opendir(DIR, "testdirectory");	# must have a directory open to do the following

chdir DIR;		# changes working directory to the DIR directory (doesnt show in the terminal)

mkdir "newdirectory"; 	# makes a new directory inside the working directoy

rmdir "newdirectory";	# removes a directory that is in the working directory (but only if it is empty);

chdir "..";		# moves up one directory

print "@files\n";	# proves the correct use of chdir bove

closedir(DIR);
#################################################################################################################
exit;
