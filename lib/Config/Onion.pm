package Config::Onion;

use strict;
use warnings;

use Hash::Merge::Simple 'merge';
use Moo;

has cfg => ( is => 'lazy', clearer => '_reset_cfg' );
sub get { goto &cfg }

has default => ( is => 'rwp' );

sub add_default {
  my $self = shift;
  $self = $self->new unless ref $self;

  $self->_set_default(merge $self->default, { @_ });
  $self->_reset_cfg;
  return $self;
}

sub _build_cfg {
  my $self = shift;
  $self->default;
}

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

