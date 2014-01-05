#! /usr/bin/perl

use strict;
use warnings;

sub solution {
    my ($x, $y, $d)=@_;
    my $dist = $y - $x;
    my $res = 0;
    my $res2;

    # for (my $i = $x; $i <$y; $i+= $d) {
    #     $res += 1;
    # }

    if ($dist % $d == 0) {
        $res2 = $dist / $d ;
    } else {
        $res2 = int ( $dist / $d) + 1 ;
    }


    # if ($res == $res2) {
    #     print 'success both are '.$res;
    # } else {
    #     print 'failure '.$res.'  '.$res2;
    # }
    # print "\n";
    $res2;
}


print solution(10,100,30);
solution(10,85,30);
solution(7,32,6);
