use strict;
use warnings;

use Test::DZil;
use Path::Tiny;
use Test::More 0.88;

# build fake dist
my $tzil = Builder->from_config({
    dist_root => path(qw(t foo)),
});
$tzil->build;

# check module & script
my $build_dir = path($tzil->tempdir)->child('build');
check_top_of_file( $build_dir->child('lib', 'Foo.pm'), 0 );
check_top_of_file( $build_dir->child('bin', 'foobar'), 1 );
check_top_of_file( $build_dir->child('bin', 'foobarbaz'), 1 );

is $tzil->slurp_file(path(qw(build t support.pl))),
   "# only used during tests\nuse strict;\n1;\n",
   'file ignored according to configuration';

done_testing;
exit;

sub check_top_of_file {
    my ($path, $offset) = @_;

    # slurp file
    open my $fh, '<', $path or die "cannot open '$path': $!";
    my @lines = split /\n/, do { local $/; <$fh> };
    close $fh;

    is( $lines[0+$offset], '#' );
    is( $lines[1+$offset], '# This file is part of Foo' );
    is( $lines[2+$offset], '#' );
    is( $lines[3+$offset], '# This software is copyright (c) 2009 by foobar.' );
    is( $lines[4+$offset], '#' );
    is( $lines[5+$offset], '# This is free software; you can redistribute it and/or modify it under' );
    is( $lines[6+$offset], '# the same terms as the Perl 5 programming language system itself.' );
    is( $lines[7+$offset], '#' );
    is( $lines[8+$offset], 'use strict;' );
    is( $lines[9+$offset], 'use warnings;' );
}
