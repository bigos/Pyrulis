#! /usr/bin/perl

use strict;
use warnings;

# http://codility.com/demo/take-sample-test/tapeequilibrium
sub sumarray{
    my @x = @_;
    print @x."aaa\n";
}

sub solution {
    my (@a)=@_;
    my $n = (scalar @a);
    my $head;
    my $tail;
    my $sum1;
    my $sum2;
    my $res;
    my $res2;
    for (my $p = 1; $p < $n; $p++) {
        print "\n".$p."  vvvvvvvvvvv\n";
        # How do I get part of an array in Perl ?????
        $sum1 = 0;
        map { $sum1 += $_ } @a[0 .. $p-1];
        print $sum1."\n";

        $sum2 = 0;
        map {$sum2 += $_} @a[$p .. (scalar(@a)-1)];
        print $sum2."\n";
        $res = abs($sum1 - $sum2);
        print $res;
        if ($p == 1) {
            $res2 = $sum1;
        } else {
            if ($res < $res2) {
                $res2 = $res;
            }
        }

    }
    $res2;
}

print "\n";

print solution (3, 1, 2, 4, 3);


print "\n";

my @rrr = (1,2,3,4,5,6,7);
print @rrr;
print "\n";
print @rrr[2 .. (scalar(@rrr) -2)];
print "\n";
