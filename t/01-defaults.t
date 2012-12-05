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

# accept defaults as either hash or hashref

# construct by adding default values

# override existing defaults with new defaults

done_testing;

