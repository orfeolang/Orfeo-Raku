#!/usr/bin/env raku

my $test-extension = 'orfeotest';
my @stack = 'Euridice/t'.IO;
my $test-header-prefix = '-' x 70;

sub MAIN() {
    my @test-files = get-all-test-files;
    say count-tests(@test-files);
}

sub get-all-test-files() {
    my @test-files = gather while @stack {
        with @stack.pop {
            when :d { @stack.append: .dir }
            .take when .extension.lc eq $test-extension;
        }
    }
    return @test-files;
}

sub count-tests(@test-files) {
    my $count = 0;
    for @test-files -> $test-file {
        for $test-file.lines -> $line {
            $count++ if $line eq $test-header-prefix;
        }
    }
    return $count;
}
