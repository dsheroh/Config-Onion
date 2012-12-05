use strict;
use warnings;

use Test::More;

use Config::Onion;

# construct bare, then add/retrieve default values
{
  my $cfg = Config::Onion->new;
  isa_ok($cfg, 'Config::Onion', 'construct bare config');
  $cfg->add_default(foo => 1);
  is($cfg->get->{foo}, 1, 'retrieve single value');
  is_deeply($cfg->get, { foo => 1 }, 'retrieve full config');
}

# construct by adding default values
{
  my $cfg = Config::Onion->add_default(bar => 2);
  isa_ok($cfg, 'Config::Onion', 'construct with add_default');
  is($cfg->get->{bar}, 2, 'retrieve value after add_default construction');
}

# override existing defaults with new defaults

# accept defaults as either hash or hashref(s)

done_testing;

