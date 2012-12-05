use strict;
use warnings;

use Test::More;

use Config::Onion;

use FindBin;
my $conf_dir = $FindBin::Bin . '/conf';

# construct bare, then load conf file
{
  my $cfg = Config::Onion->new;
  isa_ok($cfg, 'Config::Onion', 'construct bare config');
  $cfg->load("$conf_dir/basic");
  is($cfg->get->{foo}, 'bar', 'retrieve value from single conf file');
}

# construct by loading conf file
{
  my $cfg = Config::Onion->load("$conf_dir/basic");
  isa_ok($cfg, 'Config::Onion', 'construct by loading config file');
  is($cfg->get->{xyzzy}, 'plugh', 'get value after constucting via load');
}

# override main conf file with local conf
{
  my $cfg = Config::Onion->load("$conf_dir/withlocal");
  is($cfg->get->{main}, 1, 'local config does not clear main values');
  is($cfg->get->{local}, 1, 'local config does override main values');
}

# load list of conf files
{
  my $cfg = Config::Onion->load("$conf_dir/basic", "$conf_dir/withlocal");
  is_deeply([ $cfg->get->{xyzzy}, $cfg->get->{main}, $cfg->get->{local} ],
    [ 'plugh', 1, 1 ], 'multiple config files loaded correctly');
}

# load files by wildcard match

done_testing;

