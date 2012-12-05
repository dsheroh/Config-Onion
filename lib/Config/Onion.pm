package Config::Onion;

use strict;
use warnings;

use Moo;

has cfg => ( is => 'lazy', clearer => '_reset_cfg' );
sub get { goto &cfg }

has default => ( is => 'rwp' );

sub add_default {
  my $self = shift;

  $self->_set_default({ @_ });
  $self->_reset_cfg;
}

sub _build_cfg {
  my $self = shift;
  $self->default;
}

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

