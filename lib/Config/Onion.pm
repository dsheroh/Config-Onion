package Config::Onion;

use strict;
use warnings;

use Config::Any;
use Hash::Merge::Simple 'merge';
use Moo;

has cfg => ( is => 'lazy', clearer => '_reset_cfg' );
sub get { goto &cfg }

has default => ( is => 'rwp' );
has main    => ( is => 'rwp' );
has local   => ( is => 'rwp' );

sub add_default {
  my $self = shift;
  $self = $self->new unless ref $self;

  my $default = $self->default;
  $default = merge $default, shift while ref $_[0] eq 'HASH';
  $default = merge $default, { @_ } if @_;

  $self->_set_default($default);
  $self->_reset_cfg;
  return $self;
}

sub load {
  my $self = shift;
  $self = $self->new unless ref $self;

  my $main  = Config::Any->load_stems({ stems => \@_ , use_ext => 1 });
  my $local = Config::Any->load_stems({ stems => [ map { "$_.local" } @_ ],
    use_ext => 1 });

  $self->_set_main( merge $self->main,  map { values %$_ } @$main );
  $self->_set_local(merge $self->local, map { values %$_ } @$local);
  $self->_reset_cfg;
  return $self;
}

sub _build_cfg {
  my $self = shift;
  merge $self->default, $self->main, $self->local;
}

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

