package Config::Onion;

use strict;
use warnings;

use Moo;

has cfg => ( is => 'lazy' );

sub get    { my $self = shift; $self->cfg; }
sub conf   { my $self = shift; $self->cfg; }
sub config { my $self = shift; $self->cfg; }

sub _build_cfg {
  my $self = shift;
  $self->{default};
}

sub add_default {
  my $self = shift;

  $self->{default} = { @_ };
  delete $self->{cfg};
}

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

