my $program = ' 1  23 ';

grammar Orfeo {
    token TOP { [ <.ws> <int> <.ws> ]* }
    token int { \d+ }
}

say Orfeo.parse($program);

#`[
    Copyright © 2022 - Pierre-Emmanuel Lévesque, All Rights Reserved
    Unauthorized copying of this file via any medium is strictly prohibited
    Proprietary and confidential
    Written by Pierre-Emmanuel Lévesque, May 7th 2022
]
