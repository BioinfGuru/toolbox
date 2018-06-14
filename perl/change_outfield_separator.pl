# !/usr/bin/perl 
# When printing a array, this changes the separator between the arrays to what ever you want
# change it back at the end

# store the default separator
print "separator:", $","|", "\n";
my $original = $";
print "separator:", $original,"|", "\n";

# change the default separator
local $" = "\t";
print "separator:", $","|", "\n";

# restore the default separator
$" = $original;
print "separator:", $","|", "\n";



