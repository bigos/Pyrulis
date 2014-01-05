#! /usr/bin/perl

use strict;
use warnings;

# http://codility.com/demo/take-sample-test/permmissingelem

sub solution {
    my (@a)=@_;
    @a = sort @a;
    my $al = (0 + @a);
    # print ">@a< \n";
    # print $al."\n";
    if ( $al == 0) {
        return 1;
    } else {
        foreach my $x (0..$al-1) {
            unless ($a[$x] == $x+1) {
                return $x+1;
            }
        }
        return $al+1
    }
}

print "\n";
print solution(3,2,1,5);
print "\n";
print solution();
print "\n";
print solution(1);
print "\n";
print solution(1,2);

print "\n";
print (3 == 2);
