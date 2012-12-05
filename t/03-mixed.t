use strict;
use warnings;

use Test::More;

use Config::Onion;

use FindBin;
my $test_dir = $FindBin::Bin;

# construct with add_default, then load conf files over the defaults
{
  my $cfg = Config::Onion->add_default(foo => 'default');
  $cfg->load("$test_dir/conf/basic");
  is($cfg->get->{foo}, 'bar', 'main config file overwrites defaults');

  TODO: {
    local $TODO = 'local configs not implemented yet';

  $cfg->load("$test_dir/conf/withlocal");
  is($cfg->get->{local}, 1, 'local config file overwrites defaults and main');

  } # end TODO block
}

done_testing;

