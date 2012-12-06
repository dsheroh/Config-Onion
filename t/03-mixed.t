use strict;
use warnings;

use Test::More;

use Config::Onion;

use FindBin;
my $test_dir = $FindBin::Bin;

# construct with set_default, then load conf files over the defaults
{
  my $cfg = Config::Onion->set_default(foo => 'default');
  $cfg->load("$test_dir/conf/basic");
  is($cfg->get->{foo}, 'bar', 'main config file overwrites defaults');

  $cfg->load("$test_dir/conf/withlocal");
  is($cfg->get->{local}, 1, 'local config file overwrites defaults and main');
}

done_testing;

