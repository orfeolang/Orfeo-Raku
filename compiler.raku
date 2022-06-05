sub throw($error, $pos, $value) {
    note $error ~ " pos: " ~ $pos ~ ", value: " ~ $value;
    # die;
}

sub assert_float-has-decimal-digits($float, $pos) {
    if $float.ends-with('.') {
        throw("A float must have digits after the decimal point.", $pos, $float);
    }
}

# Warning: Only works for unsigned numbers.
sub assert_number-does-not-have-leading-zeros($number, $pos) {
    if $number.chars > 1 &&
       $number.starts-with('0') &&
       substr($number, 1, 1) ~~ /<digit>/
    {
        throw("A number cannot have leading zeros.", $pos, $number);
    }
}

sub validate_float($float, $pos) {
    assert_float-has-decimal-digits($float, $pos);
    assert_number-does-not-have-leading-zeros($float, $pos);
}

sub validate_integer($integer, $pos) {
    assert_number-does-not-have-leading-zeros($integer, $pos);
}

my $program = ' 0 1 12 .12 12.12 0.12 01 01.1 1. ';

grammar Orfeo {
    token TOP { [ <.ws> <number> <.ws> ]* }
    token number {
        | <float>   { validate_float($<float>, self.pos) }
        | <integer> { validate_integer($<integer>, self.pos) }
    }
    token float {
            # .d+ | d+.d+
        | <integer-digits>? \. <decimal-digits>
            # d+.
        | <integer-digits> \.
    }
    token integer        { <digit>+ }
    token integer-digits { <digit>+ }
    token decimal-digits { <digit>+ }
}

say Orfeo.parse($program);

#`[
    Copyright © 2022 - Pierre-Emmanuel Lévesque, All Rights Reserved
    Unauthorized copying of this file via any medium is strictly prohibited
    Proprietary and confidential
    Written by Pierre-Emmanuel Lévesque, May 7th 2022
]
