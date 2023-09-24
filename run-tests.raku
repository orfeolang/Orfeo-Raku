#!/usr/bin/env raku

my $test-extension = 'orfeotest';
my @stack = 'Euridice/t'.IO;

sub MAIN() {
    my @test-files = get-all-test-files;
    .Str.say for @test-files;
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
