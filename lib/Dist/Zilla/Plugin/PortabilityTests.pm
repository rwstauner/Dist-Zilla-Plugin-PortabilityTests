use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::PortabilityTests;
# ABSTRACT: Release tests for portability
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::FileMunger';

has options => (
  is      => 'ro',
  isa     => 'Str',
  default => '',
);

sub munge_file {
  my ($self, $file) = @_;
  return unless $file->name eq 'xt/release/portability.t';

  # 'name => val, name=val'
  my %options = split(/\W+/, $self->options);

  if ( keys %options ) {
    my $content = $file->content;

    my $optstr = join ', ', map { "$_ => $options{$_}" } sort keys %options;

    # insert options() above run_tests;
    $content =~ s/^(run_tests\(\);)$/options($optstr);\n$1/m;

    $file->content($content);
  }
  return;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=begin :prelude

=for test_synopsis
1;
__END__

=end :prelude

=head1 SYNOPSIS

In C<dist.ini>:

    [PortabilityTests]
    ; you can optionally specify test options
    options = test_dos_length = 1, use_file_find = 0

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

  xt/release/portability.t - a standard Test::Portability::Files test

You can set options for the tests in the 'options' attribute:
Specify C<< name = value >> separated by commas.

See L<Test::Portability::Files/options> for possible options.

=cut

__DATA__
___[ xt/release/portability.t ]___
#!perl

use Test::More;

eval "use Test::Portability::Files";
plan skip_all => "Test::Portability::Files required for testing portability"
  if $@;
run_tests();
