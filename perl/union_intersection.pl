# !/usr/bin/perl 
# get the union or interesection of 2 lists using Cpan module List::Compare

use strict;
use warnings;
use List::Compare;

my @Llist = qw(abel abel baker camera delta edward fargo golfer);
my @Rlist = qw(baker camera delta delta edward fargo golfer hilton);
my $lc = List::Compare->new(\@Llist, \@Rlist);
my @intersection = $lc->get_intersection;
my @union = $lc->get_union;
print "@intersection\n";
print "@union\n";
