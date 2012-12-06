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

  my %ca_opts = $self->_ca_opts;
  my $main  = Config::Any->load_stems({ stems => \@_ , %ca_opts });
  my $local = Config::Any->load_stems({ stems => [ map { "$_.local" } @_ ],
    %ca_opts });

  $self->_add_loaded($main, $local);
  return $self;
}

sub load_glob {
  my $self = shift;
  $self = $self->new unless ref $self;

  my (@main_files, @local_files);
  for my $globspec (@_) {
    for (glob $globspec) {
      if (/\.local\./) { push @local_files, $_ }
      else             { push @main_files,  $_ }
    }
  }

  my %ca_opts = $self->_ca_opts;
  my $main  = Config::Any->load_files({ files => \@main_files,  %ca_opts });
  my $local = Config::Any->load_files({ files => \@local_files, %ca_opts });

  $self->_add_loaded($main, $local);
  return $self;
}

sub _add_loaded {
  my $self = shift;
  my ($main, $local) = @_;

  $self->_set_main( merge $self->main,  map { values %$_ } @$main )
    if @$main;
  $self->_set_local(merge $self->local, map { values %$_ } @$local)
    if @$local;

  $self->_reset_cfg;
}

sub _build_cfg {
  my $self = shift;
  merge $self->default, $self->main, $self->local;
}

sub _ca_opts { ( use_ext => 1 ) }

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

