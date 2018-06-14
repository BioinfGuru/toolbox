#!/usr/bin/perl 
# Intersect 2 lists
# Kenneth Condon May 2017
# http://search.cpan.org/~jkeenan/List-Compare-0.53/lib/List/Compare.pm#Multiple_Case:_Compare_Three_or_More_Lists

###############################################################################
use strict;
use warnings;
use List::Compare;
use Getopt::Long;
###############################################################################
my $count;
open (OUT, ">/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/Macs_results_001/differential/out.txt");

#read files
open (ZT3, "/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/Macs_results_001/differential/diff_Zt3VsZt15_c3.0_cond1.bed.sorted.targetlist")or die("file1 not found\n");
open (ZT15, "/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/Macs_results_001/differential/diff_Zt3VsZt15_c3.0_cond2.bed.sorted.targetlist")or die("file1 not found\n");
open (COMMON, "/NGS/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results/Macs_results_001/differential/diff_Zt3VsZt15_c3.0_common.bed.sorted.targetlist")or die("file1 not found\n");


# create lists
my @zt3list;
foreach my $line(<ZT3>){$line =~ s/\n|\r|\s+$//g;push @zt3list, $line;}
my @zt15list;
foreach my $line(<ZT15>){$line =~ s/\n|\r|\s+$//g;push @zt15list, $line;}
my @commonlist;
foreach my $line(<COMMON>){$line =~ s/\n|\r|\s+$//g;push @commonlist, $line;}

# create list compare object
my $lcm = List::Compare->new('--unsorted', \@zt3list, \@zt15list, \@commonlist);

# get intersection
$count = 0;
my @intersection = $lcm->get_intersection;
foreach my $i(@intersection){$count++;}
#print "Intersection: $count\n";


# get union
$count = 0;
my @union = $lcm->get_union;
foreach my $u(@union){$count++;}
#print "Union: $count\n";

# get unique (to 1 list)
$count = 0;
my @unique = $lcm->get_unique(2);	# index starts at 0
foreach my $q(@unique){$count++;}
foreach my $q(@unique){print OUT "$q\n";}
print "Unique: $count\n";

# get complement (found in all except 1 list)
$count = 0;
my @complement = $lcm->get_complement(1); # index starts at 0
foreach my $c(@complement){$count++;}
#print "Complement: $count\n";