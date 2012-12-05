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
{
  my $cfg = Config::Onion->add_default(foo => 3);
  $cfg->add_default(bar => 'baz');
  is($cfg->get->{foo}, 3, 'merge defaults preserves old values');
  is($cfg->get->{bar}, 'baz', 'merge defaults adds new values');
  $cfg->add_default(foo => 'new');
  is($cfg->get->{foo}, 'new', 'merge defaults overwrites old values');
}

# accept defaults as either hash or hashref(s)
{
  my $cfg = Config::Onion->add_default({ a => 1 });
  is($cfg->get->{a}, 1, 'set defaults with hashref');
  $cfg->add_default({ b => 2 }, { c => 3 }, d => 4);
  is_deeply( $cfg->get, { a => 1, b => 2, c => 3, d => 4 },
    'set defaults with mixed hashrefs and hash'
  );
}

done_testing;

