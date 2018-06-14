#!\usr\bin\perl
# nested.pl 

use strict; 
use warnings; 

# Each replicate contains a gene list
my @rep1 = qw(cdk2 cdk4 cycd1);
my @rep2 = qw(cdk2 cdk4 cycd1); 
my @rep3 = qw(cdk2 cdk6 cycd1); 
my @rep4 = qw(cdk2 cdk6);

# Two conditions, with a brief description
my @cond1 = ("6weeks", \@rep1, \@rep2);
my @cond2 = ("3days" , \@rep3, \@rep4);

# One experiment
my @exp = (\@cond1, \@cond2);

# use print statements to print out data
# access data via dereferencing the nested arrays


#print '$exp[1]'; 
#print "\t$exp[1]  # array reference of \@cond2\n\n";

#print '@{$exp[1]}';
#print "\t@{$exp[1]} # \@cond2\n\n";

#print '${$exp[1]}[0]';
#print "\t${$exp[1]}[0] # 3days\n\n"; 

#print '${$exp[1]}[1]';
#print "\t${$exp[1]}[1] # array reference to \@rep3\n\n";

#print '@{${$exp[1]}[1]}';
#print "\t@{${$exp[1]}[1]} # \@rep3\n\n";

#print '${${$exp[1]}[1]}[0]';
#print "\t${${$exp[1]}[1]}[0] # cdk2\n\n";

#print '$exp[1]->[1]->[0]';
#print "\t$exp[1]->[1]->[0] # cdk2\n\n";

#print '$exp[1][1][0]';
#print "\t$exp[1][1][0] # cdk2,even easier\n\n";

