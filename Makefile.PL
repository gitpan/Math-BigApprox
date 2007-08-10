#!/usr/bin/perl -w
use strict;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'              => 'Math::BigApprox',
    'VERSION_FROM'      => 'BigApprox.pm',
    'PREREQ_PM'         => {
        'POSIX' => 0,   # For floor()
    },
    (  $] < 5.005  ?  ()  :
    ( 'AUTHOR'          => 'Tye McQueen',
      'ABSTRACT_FROM'   => 'BigApprox.pm' )
    ),
);
