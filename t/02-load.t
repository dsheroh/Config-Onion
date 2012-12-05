use strict;
use warnings;

use Test::More;

use Config::Onion;

use FindBin;
my $test_dir = $FindBin::Bin;

# construct bare, then load conf file
{
  my $cfg = Config::Onion->new;
  isa_ok($cfg, 'Config::Onion', 'construct bare config');
  $cfg->load("$test_dir/conf/basic");
  is($cfg->get->{foo}, 'bar', 'retrieve value from single conf file');
}

# construct by loading conf file
{
  my $cfg = Config::Onion->load("$test_dir/conf/basic");
  isa_ok($cfg, 'Config::Onion', 'construct by loading config file');
  is($cfg->get->{xyzzy}, 'plugh', 'get value after constucting via load');
}

# override main conf file with local conf
{
  my $cfg = Config::Onion->load("$test_dir/conf/withlocal");
  is($cfg->get->{main}, 1, 'local config does not clear main values');
  is($cfg->get->{local}, 1, 'local config does override main values');
}

# load list of conf files

# load files by wildcard match

done_testing;

