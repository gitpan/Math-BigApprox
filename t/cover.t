#!/usr/bin/perl -w
use strict;

use Test qw( plan ok );

plan(
    tests => 189,
    todo => [169],
);

sub NV
{
    return unpack "F", pack "F", shift @_;
}

require Math::BigApprox;
ok(1);

Math::BigApprox->import( qw( c Prod Fact ) );
ok(1);

my %n;
for(
    0, 0.5, 1, 1.25, 2, 2.5, 5, 52,
    -1, -0.1, -1234,
    1e+100, -1e-100, 1.05e-100
) {
    $n{$_}= Math::BigApprox->new( $_ );
    ok( $n{$_}, $_, "new $_" );
}
ok( $n{"1e+400"}= $n{1e+100}**4, "1e+400",      '1e+100**4 eq 1e+400' );

# Multiplication
ok( $n{0}*$n{1},                0,              'zero*one eq 0' );
ok( $n{1}*$n{2},                2,              'one*two eq 2' );
ok( $n{52}*$n{5},               52*5,           'cards*five eq 260' );
ok( $n{-1}*$n{0},               0,              'neg*zero eq 0' );
ok( $n{-1}*$n{-1},              1,              'neg*neg eq 1' );
ok( $n{5}*$n{-1234},            -5*1234,        'five*n234 eq -6170' );
ok( $n{1.25}*2,                 $n{2.5},        'quart*2 eq half' );
ok( 1.25*$n{2}*2,               5,              '1.25*two*2 eq 5' );
ok( $n{1e+100}*$n{-1e-100},     -1,             'big*tiny eq -1' );
ok( $n{1e+100}*$n{1e+100},      1e+200,         'big*big eq 1e200' );
ok( $n{1e+100}*1e+300,          "1e+400",       'big*1e300 eq 1e400' );
ok( 6*$n{1.05e-100},            6*1.05e-100,    '6*tq eq 6*1.05e-100' );
ok( $n{'1e+400'}*$n{'1e+400'},  "1e+800",       'huge*huge eq 1e+800' );

# Division
ok( $n{0}/$n{1},                0,              'zero/one eq 0' );
ok( $n{-1234}/$n{1},            -1234,          'n1234/one eq -1234' );
ok( $n{-1234}/$n{-1},           1234,           'n1234/neg eq 1234' );
ok( $n{52}/$n{-1},              -52,            'cards/neg eq -52' );
ok( $n{5}/2/$n{2},              $n{1.25},       'five/2/two eq quart' );
ok( -5/$n{2},                   -2.5,           '-5/two eq -2.5' );
ok( eval { 5/$n{0} },           undef,          "5/zero dies" );
ok( $n{1e+100}/$n{1e+100},      1,              'big/big eq 1' );
ok( $n{1e+100}/$n{-1e-100},     -1e+200,        'big/tiny eq -1e200' );
ok( $n{1e+100}/1e-300,          "1e+400",       'big/1e-300 eq 1e400' );
ok( $n{-1e-100}/1e+300,         "-1e-400",      'tiny/1e300 eq -1e-400' );
ok( $n{1.05e-100}/5,            1.05e-100/5,    'tq/5 eq 1.05e-100/5' );

# Addition
ok( $n{0}+$n{52},               52,             'zero+cards eq 52' );
ok( $n{52}+0,                   52,             'cards+0 eq 52' );
ok( $n{52}+$n{1},               53,             'cards+one eq 53' );
ok( 0.52+$n{52},                52.52,          '0.52+cards eq 52.52' );
ok( $n{1e+100}+$n{-1e-100},     1e+100,         'big+tiny eq 1e100' );
ok( $n{1e+100}+$n{1e+100},      2e+100,         'big*big eq 2e100' );
ok( $n{1e+100}+1e+300,          1e+300,         'big+1e+300 eq 1e300' );
ok( 19+$n{-1e-100},             19,             '19+tiny eq 19' );
ok( $n{1.05e-100}+$n{-1e-100},  5e-102,         'qt+tiny eq 5e-102' );

# Subtraction
ok( $n{0}-$n{-1234},            1234,           'zero-n1234 eq 1234' );
ok( $n{1.05e-100}-1e-100,       5e-102,         'qt-1e-100 eq 5e-102' );
ok( -1234-$n{-1234},            0,              '-1234-n1234 eq 0' );
ok( $n{1.05e-100}-1.05e-100,    0,              'qt-1.05e-100 eq 0' );

# Negation
ok( -$n{0},                     0,              '-zero eq 0' );
ok( -$n{-1234},                 1234,           '-n1234 eq 1234' );
ok( -$n{1e+100},                -1e+100,        '-big eq -1e+100' );

# Exponentiation
ok( $n{0}**0,                   1,              'zero**0 eq 1' );
ok( 0**$n{0},                   1,              '0**zero eq 1' );
ok( 0**$n{-1234},               0,              '0**x eq 0' );
ok( $n{0}**-12.67,              0,              'zero**-12.67 eq 0' );
ok( $n{1}**$n{1e+100},          1,              '1**1e+100 eq 1' );
ok( $n{'1e+400'}**-1234,        '1e-493600',    'huge**-1234 eq 1e-493600' );
ok( $n{'1e+400'}**1e10,     "1e+4000000000000", 'huge**1e10 eq 1e+4e12' );
ok( $n{'1e+400'}**1e100,        "1e+4e+102",    'huge**1e100 eq 1e4e102' );
ok( $n{'1e+400'}**1e300,        "1e+4e+302",    'huge**1e100 eq 1e4e302' );
ok( $n{-1}**0,                  1,              'neg**1 eq 1' );
ok( $n{-1}**1,                  -1,             'neg**1 eq -1' );
ok( $n{-1}**2,                  1,              'neg**2 eq 1' );
ok( $n{-1}**3,                  -1,             'neg**3 eq -1' );
ok( $n{-1}**-1,                 1,              'neg**-1 eq 1' );
ok( $n{-1}**1e100,              1,              'neg**1e100 eq 1' );
ok( $n{-1234}**11,              c(-(1234**11)), 'n1234**11 eq -(1234**11)' );

# max exponent is likely 7.80728208626062e+307,
# aka 1.79769313486231574e308/log(10)
ok( $n{'1e+400'}**1e305,        "1e+4e+307",    'huge**1e305 eq 1e4e307' );
# This would fail on a system with bigger-than-typical "double" data type:
#ok($n{'1e+400'}**2e305,        exp(1e300),     'huge**2e305 eq inf' );
ok( $n{'1e+400'}**1e300**1e300, exp(1e300),     'huge**1e300**1e300 eq inf' );

my $notzero= $n{-1e-100}**9e305;
ok( $notzero,                   0,              'tiny**9e305 eq 0' );
# TBD:  Perhaps $notzero should be a real zero?
# Or perhaps 1/0 should always return infinity rather than dying?
ok( 1/$notzero,                 exp(1e300),     '1/notzero eq inf' );
ok( 1/-$notzero,                -exp(1e300),    '1/notzero eq -inf' );

# Product of sequence
my $deals= 48^$n{52};
ok( $deals,                     48*49*50*51*52, '48^cards eq 48*..*52' );
ok( Prod(48,52),                $deals,         'Prod(48,52) eq deals' );
ok( $n{52}^$n{5},               1,              'cards^five eq 1' );
ok( Prod(52,5),                 1,              'Prod(52,5) eq 1' );

# Factorial
ok( !$n{-1},                    1,              '!neg eq 1' );
ok( !$n{0},                     1,              '!zero eq 1' );
ok( !$n{1},                     1,              '!one eq 1' );
ok( !$n{2},                     2,              '!two eq 2' );
ok( !$n{5},                     120,            '!five eq 120' );
ok( Fact(-1),                   1,              '!neg eq 1' );
ok( Fact(0),                    1,              '!zero eq 1' );
ok( Fact(1),                    1,              '!one eq 1' );
ok( Fact(2),                    2,              '!two eq 2' );
ok( Fact(5),                    120,            '!five eq 120' );
ok( !$n{52},            '/^8\.0658\d*e\+67$/',  '!cards =~ 8.0658...e+67' );
my $fact= !-$n{-1234};
ok( $fact,              '/^5.108\d*e\+3280$/',  '!-n1234 eq 5.108...e+3280' );
ok( Fact(1234),                 $fact,          '!1234 eq !-n1234' );

# Shift
ok( $n{0}<<30,                  0,              'zero<<30 eq 0' );
ok( $n{0}>>30,                  0,              'zero>>30 eq 0' );
ok( $n{-1234}>>11,          '/^-0\.60\d*$/',    'n1234>>11 =~ -0.60...' );
ok( $n{-1234}<<2,               -4936,          'n1234<<2 eq -4936' );
ok( $n{1}<<30,                  1<<30,          'one<<30 eq 1<<30' );
ok( $n{5}>>2,                   $n{1.25},       'five>>2 eq quart' );
ok( 16<<$n{52},             '/^7\.2\d*e\+16$/', '16<<cards =~ 7.2...e+16' );
ok( $n{1}<<0.5,                 c(sqrt(2)),     'one<<.5 eq sqrt 2' );
ok( $n{2}>>1.5,                 c(sqrt(0.5)),   'two>>.5 eq sqrt .5' );

# Comparison
ok( $n{-1} < $n{0},             1,              'neg < zero' );
ok( $n{0} < $n{5},              1,              'zero < five' );
ok( $n{2} < 5,                  1,              'two < 5' );
ok( -$n{5} < $n{-1},            1,              '-five < neg' );
ok( $n{-1} >= $n{0},            !1,             'not neg >= zero' );
ok( $n{0} >= $n{5},             !1,             'not zero >= five' );
ok( 2 >= $n{5},                 !1,             'not 2 >= five' );
ok( -$n{5} >= $n{-1},           !1,             'not -five >= neg' );

ok( $n{-1} <= $n{0},            1,              'neg <= zero' );
ok( $n{0} <= $n{5},             1,              'zero <= five' );
ok( $n{2} <= 5,                 1,              'two <= 5' );
ok( -$n{5} <= $n{-1},           1,              '-five <= neg' );
ok( $n{-1} > $n{0},             !1,             'not neg > zero' );
ok( $n{0} > $n{5},              !1,             'not zero > five' );
ok( 2 > $n{5},                  !1,             'not 2 > five' );
ok( -$n{5} > $n{-1},            !1,             'not -five > neg' );

ok( $n{0} == 0,                 1,              'zero == 0' );
ok( 1 == $n{1},                 1,              '1 == one' );
ok( -1 == $n{-1},               1,              '-1 == neg' );
ok( $n{0} < 0,                  !1,             'not zero < 0' );
ok( 1 < $n{1},                  !1,             'not 1 < one' );
ok( -1 < $n{-1},                !1,             'not -1 < neg' );
ok( $n{0} > 0,                  !1,             'not zero > 0' );
ok( 1 > $n{1},                  !1,             'not 1 > one' );
ok( -1 > $n{-1},                !1,             'not -1 > neg' );

ok( $notzero == 0,              1,              'notzero == 0' );
ok( $notzero <= 0,              1,              'notzero <= 0' );
ok( $notzero >= 0,              1,              'notzero >= 0' );
ok( $notzero < 0,               !1,             'not notzero < 0' );
ok( $notzero > 0,               !1,             'not notzero > 0' );


# Numification
ok( 0|$n{0},                    0,              '0|zero eq 0' );
ok( 0|$n{-1},                   0|-1,           '0|neg eq 0|-1' );
ok( 0|$n{52},                   52,             '0|cards eq 52' );
ok( NV($n{0}),                  0,              'NV zero eq 0' );
ok( NV($n{-1}),                 -1,             'NV neg eq -1' );
ok( NV($n{52}),                 52,             'NV cards eq 52' );
ok( NV($n{-0.1}),               -0.1,           'NV tenth eq -0.1' );
ok( NV($n{-1234}),              -1234,          'NV n1234 eq -1234' );
ok( NV($n{1e+100}**100),        exp(1e100),     'NV big**100 eq inf' );
ok( NV($n{-1e-100}**100),       0,              'NV tiny**100 eq 0' );
ok( NV(1/$n{-1e-100}**101),     -exp(1e100),    'NV tiny**-100 eq -inf' );

# Stringification (covered in previous cases)

# Auto cloning
my $count= $n{0};
$count += 1;
ok( $count,                     1,              '++zero eq 1' );
ok( $n{0},                      0,              'zero++ eq 0' );

# abs()
ok( abs($n{0}),                 0,              'abs zero eq 0' );
ok( abs($n{-1234}),             1234,           'abs n1234 eq 1234' );
ok( abs($n{'1e+400'}),          '1e+400',       'abs huge eq 1e+400' );
ok( abs(-$n{'1e+400'}),         '1e+400',       'abs -huge eq 1e+400' );

# log()
ok( eval { log($n{0}) },        undef,          'log zero dies' );
ok( eval { log($n{-1}) },       undef,          'log neg dies' );
ok( log($n{52}),                log(52),        'log cards == log 52' );

# sqrt()
ok( sqrt($n{0}),                0,              'sqrt zero == 0' );
ok( sqrt($n{1}),                1,              'sqrt one == 1' );
ok( eval { sqrt($n{-1}) },      undef,          'sqrt neg dies' );
ok( c(sqrt($n{52})),            c(sqrt(52)),    'c sqrt cards == c sqrt 52' );

# bool
ok( eval { 1 if $n{0}; 1 },     undef,          'if zero dies' );

# Fall-back functions: (atan2, cos, sin, exp, and int)
ok( cos($n{0}),                 1,              'cos zero eq 1' );
ok( sin($n{0}),                 0,              'sin zero eq 0' );
ok( sin(atan2($n{1},$n{0})),    1,              'sin atan2(one,zero) eq 1' );
ok( c(exp($n{52})),             c(exp(52)),     'c exp cards eq c exp 52' );
ok( int($n{1.25}),              1,              'int quart eq 1' );

# Sign
ok( $n{0}->Sign(),              0,              'Sign zero eq 0' );
ok( $n{5}->Sign(),              1,              'Sign five eq 1' );
ok( $n{-1234}->Sign(),          -1,             'Sign n1234 eq -1' );
# To-do! (#??)
ok( $notzero->Sign(),           0,              'Sign notzero eq 0' );

++$count;
ok( $count->Sign(-9),           1,              'count->Sign(-9) eq 1' );
ok( $count->Sign(),             -1,             'Sign count eq -1' );
ok( $count,                     -2,             'count eq -1' );
ok( $count->Sign(19),           -1,             'count->Sign(19) eq -1' );
ok( $count->Sign(),             1,              'Sign count eq -1' );
ok( $count,                     2,              'count eq -1' );
ok( $count->Sign(0),            1,              'count->Sign(0) eq 1' );
ok( $count->Sign(),             0,              'Sign count eq 0' );
ok( $count,                     0,              'count eq 0' );

# Get
ok( $n{0}->Get(),               0,              'Get zero eq 0' );
ok( $n{1}->Get(),               0,              'Get one eq 0' );
ok( $n{5}->Get(),               log(5),         'Get 5 eq log(5)' );
ok( $n{-1234}->Get(),           log(1234),      'Get n1234 eq log(1234)' );
ok( $n{-1e-100}->Get(),         log(1e-100),    'Get tiny eq log(1e-100)' );
ok( ( $n{5}->Get() )[0],        log(5),         '(Get 5)[0] eq log(5)' );
ok( ( $n{0}->Get() )[1],        0,              '(Get zero)[1] eq 0' );
ok( ( $n{5}->Get() )[1],        1,              '(Get five)[1] eq 1' );
ok( ( $n{-1234}->Get() )[1],    -1,             '(Get n1234)[1] eq -1' );
ok( @{[ $n{2}->Get() ]},        2,              '@(Get 2) eq 2' );

# croaks
ok( eval { c(); 1 },            undef,          "Empty c'tor dies" );

