sub throw($error, $pos, $value) {
    note $error ~ " pos: " ~ $pos ~ ", value: " ~ $value;
    # die;
}

sub assert_float-has-decimal-digits($float, $pos) {
    if $float.ends-with('.') {
        throw("A float must have digits after the decimal point.", $pos, $float);
    }
}

sub assert_number-does-not-have-leading-zeros($number, $pos) {
    if $number.chars > 1 &&
        (
            # Note: These checks could most likely be more succinct.
            ($number.starts-with('0')  && substr($number, 1, 1) ~~ /<digit>/) ||
            ($number.starts-with('-0') && substr($number, 2, 1) ~~ /<digit>/) ||
            ($number.starts-with('+0') && substr($number, 2, 1) ~~ /<digit>/)
        )
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

my $program =
    ' 0 +0 -0 1 +1 -1 12 +12 -12 .12 +.12 -.12 0.12 +0.12 -0.12 ' ~ # Success.
    ' 12. +12. -12. ' ~ # Float without decimal digits error.
    ' 00 +01 -01 000 +001 -001 00.1 +00.1 -00.1 '; # Leading zero error.

grammar Orfeo {
    token TOP { [ <.ws> <number> <.ws> ]* }
    token number {
        | <float>   { validate_float($<float>, self.pos) }
        | <integer> { validate_integer($<integer>, self.pos) }
    }
    token float {
            # (-|+)?.d+ | (-|+)?d+.d+
        | <sign>? <integer-digits>? \. <decimal-digits>
            # (-|+)?d+.
        | <sign>? <integer-digits> \.
    }
    token integer        { <sign>? <digit>+ }
    token integer-digits { <digit>+ }
    token decimal-digits { <digit>+ }
    token sign { '+' | '-' }
}

say Orfeo.parse($program);

#`[
    Copyright © 2022 - Pierre-Emmanuel Lévesque, All Rights Reserved
    Unauthorized copying of this file via any medium is strictly prohibited
    Proprietary and confidential
    Written by Pierre-Emmanuel Lévesque, started on May 7th 2022
]
