sub throw($error, $self, $value) {
    my $parsed-so-far = $self.target.substr(0, $self.pos + 1);
    my @lines = $parsed-so-far.lines;
    my $lineNum = @lines.elems;
    my $linePos = @lines[*-1].chars;
    note "Error at " ~ $lineNum ~ ":" ~ $linePos ~ " => " ~ $value;
    note $error;
    # die;
}

sub assert_float-has-decimal-digits($float, $self) {
    if $float.ends-with('.') {
        throw("A float must have digits after the decimal point.", $self, $float);
    }
}

sub assert_number-does-not-have-leading-zeros($number, $self) {
    if $number.chars > 1 &&
        (
            # Note: These checks could most likely be more succinct.
            ($number.starts-with('0')  && substr($number, 1, 1) ~~ /<digit>/) ||
            ($number.starts-with('-0') && substr($number, 2, 1) ~~ /<digit>/) ||
            ($number.starts-with('+0') && substr($number, 2, 1) ~~ /<digit>/)
        )
    {
        throw("A number cannot have leading zeros.", $self, $number);
    }
}

sub validate_float($float, $self) {
    assert_float-has-decimal-digits($float, $self);
    assert_number-does-not-have-leading-zeros($float, $self);
}

sub validate_integer($integer, $self) {
    assert_number-does-not-have-leading-zeros($integer, $self);
}

my $program = q:to/END/;
    0 +0 -0 1 +1 -1 12 +12 -12 .12 +.12 -.12 0.12 +0.12 -0.12
    12. +12. -12.
    00 +01 -01 000 +001 -001 00.1 +00.1 -00.1
    END

grammar Orfeo {
    token TOP { [ <.ws> <number> <.ws> ]* }
    token number {
        | <float>   { validate_float($<float>, self) }
        | <integer> { validate_integer($<integer>, self) }
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
