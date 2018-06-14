#!/usr/bin/perl 
# from: https://perlmaven.com/multi-dimensional-arrays-in-perl
###############################################################################
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my @matrix;
 
$matrix[0][0] = 'zero-zero';
$matrix[1][1] = 'one-one';
$matrix[1][2] = 'one-two';

print Dumper \@matrix;


# Should return:

# $VAR1 = [					# this set of brackets defines @matrix
#           [				# this set of bracket is for $matrix[0]
#             'zero-zero'	
#           ],
#           [				# this set of bracket is for $matrix[1]
#             undef,		# undef because $matrix[1][0] is undefined
#             'one-one',
#             'one-two'
#           ]
#         ];

