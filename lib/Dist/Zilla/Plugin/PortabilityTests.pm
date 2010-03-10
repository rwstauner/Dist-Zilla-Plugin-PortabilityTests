use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::PortabilityTests;
# ABSTRACT: release tests for portability
use Moose;
use Test::Portability::Files ();
extends 'Dist::Zilla::Plugin::InlineFiles';

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=head1 SYNOPSIS

In C<dist.ini>:

    [PortabilityTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files

  xt/release/portability.t - a standard Test::Portability::Files test

=cut

__DATA__
___[ xt/release/portability.t ]___
#!perl

use Test::More;

eval "use Test::Portability::Files";
plan skip_all => "Test::Kwalitee required for testing kwalitee"
  if $@;
run_tests();
