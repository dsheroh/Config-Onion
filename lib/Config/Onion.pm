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

sub set_default {
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
  merge $self->default || {}, $self->main, $self->local;
}

sub _ca_opts { ( use_ext => 1 ) }

1;

__END__

# ABSTRACT: Layered configuration, because configs are like ogres

=head1 SYNOPSIS

  my $cfg = Config::Onion->new;
  my $cfg = Config::Onion->set_default(db => {name => 'foo', password => 'bar'});
  my $cfg = Config::Onion->load('/etc/myapp', './myapp');
  my $cfg = Config::Onion->load_glob('./plugins/*');

  $cfg->set_default(font => 'Comic Sans');
  $cfg->load('config');
  $cfg->load_glob('conf.d/myapp*');

  my $dbname = $cfg->get->{db}{name};
  my $plain_hashref_conf = $cfg->get;
  my $dbpassword = $plain_hashref_conf->{db}{password};

=head1 DESCRIPTION

All too often, configuration is not a universal or one-time thing, yet most
configuration-handling treats it as such.  Perhaps you can only load one config
file.  If you can load more than one, you often have to load all of them at the
same time or each is stored completely independently, preventing one from being
able to override another.  Config::Onion changes that.

Config::Onion stores all configuration settings in three layers: Defaults,
Main, and Local.  Each layer can be added to as many times as you like.
Within each layer, settings which are given multiple times will take the last
specified value, while those which are not repeated will remain untouched.

  $cfg->set_default(name => 'Arthur Dent', location => 'Earth');
  $cfg->set_default(location => 'Magrathea');
  # In the Default layer, 'name' is still 'Arthur Dent', but 'location' has
  # been changed to 'Magrathea'.

Regardless of the order in which they are set, values in Main will always
override values in the Default layer and the Local layer always overrides both
Default and Main.

=head1 METHODS

=head2 new

Returns a new, empty configuration object.

=head2 load(@file_stems)

Loads files matching the given stems using C<Config::Any->load_stems> into the
Main layer.  Also concatenates ".local" to each stem and loads matching files
into the Local layer.  e.g., C<$cfg->load('myapp')> would load C<myapp.yml>
into Main and C<myapp.local.js> into Local.  All filename extensions supported
by C<Config::Any> are recognized along with their corresponding formats.

=head2 load_glob(@globs)

Uses the Perl C<glob> function to expand each parameter into a list of
filenames and loads each file using C<Config::Any>.  Files whose names contain
the string ".local." are loaded into the Local layer.  All other files are
loaded into the Main layer.

=head2 set_default([\%settings,...,] %settings)

Imports C<%settings> into the Default layer.  Accepts settings both as a plain
hash and as hash references, but, if the two are mixed, all hash references
must appear at the beginning of the parameter list, before any non-hashref
settings.

=head1 PROPERTIES

=head2 cfg

=head2 get

Returns the complete configuration as a hash reference.

=head2 default

=head2 main

=head2 local

These properties each return a single layer of the configuration.  This is
not likely to be useful other than for debugging.  For most other purposes,
you probably want to use C<get> instead.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests at
L<https://github.com/dsheroh/Config-Onion/issues>
