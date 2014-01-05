#! /usr/bin/perl

use strict;
use warnings;

# http://codility.com/demo/take-sample-test/tapeequilibrium

sub solution {
    my (@a)=@_;
    my $n = (scalar @a);
    print $n."\n";
    for (my $p = 1; $p < $n; $p++) {
        print $p."  vvvvvvvvvvv\n";
        # How do I get part of an array in Perl ?????
        print @a[0 .. $p]."\n";
        print @a[$p+1 .. -1]."\n";
        print "zzzz\n";
    }
}

print "\n";

print solution (3, 1, 2, 4, 3);


print "\n";
