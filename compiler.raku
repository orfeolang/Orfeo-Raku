sub validate-int(@digit, $pos) {
        # Refuse leading zeros.
    if @digit[0] == 0 {
        note "No leading zero for an Int. pos: " ~ $pos ~ ", value: " ~ [~] @digit;
        die;
    }
}

my $program = ' 1  023 ';

grammar Orfeo {
    token TOP { [ <.ws> <int> <.ws> ]* }
    token int { <digit>+ { validate-int(@<digit>, self.pos) }}
}

say Orfeo.parse($program);

#`[
    Copyright © 2022 - Pierre-Emmanuel Lévesque, All Rights Reserved
    Unauthorized copying of this file via any medium is strictly prohibited
    Proprietary and confidential
    Written by Pierre-Emmanuel Lévesque, May 7th 2022
]
