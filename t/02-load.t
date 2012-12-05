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

# override main conf file with local conf

# load list of conf files

# load files by wildcard match

done_testing;

