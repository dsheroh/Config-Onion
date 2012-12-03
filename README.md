Config-Onion
============

Layered configuration, because configs are like ogres


Basic design
------------

Three configuration layers:
- Defaults (set by application code)
- Main (set by reading standard config files)
- Local (set by reading `.local` config files)

Multiple settings can be made in any layer (e.g., reading some config files at
startup, then setting defaults and reading in more config files) with later
settings overriding earlier settings of the same value.

Main overrides Defaults and Local overrides both of the others, regardless of
when settings are made.  (e.g., If a config file sets the `DBName` in Main and
code later sets a `DBName` in Defaults, the value in Main will still take
precedence even though it was set earlier.)

Config files for Main and Defaults will be loaded using
`Config::Any->load_stems`, allowing a wide range of configuration formats to be
used.


Draft API
---------

    my $cfg = Config::Onion->new;
    my $cfg = Config::Onion->set_default(db => {name => 'foo', password => 'bar'});
    my $cfg = Config::Onion->load('/etc/my_app', './my_app', '~/.my_apprc');

    $cfg->set_default(font => 'Comic Sans');
    $cfg->load('./plugins/*');

    my $dbname = $cfg->get->{db}{name};
    my $plain_hashref_conf = $cfg->get;
    my $dbpassword = $plain_hashref_conf->{db}{password};

Note that there is no `load_local` method.  Instead, whenever `load` looks for
a config file, it also looks for a corresponding `.local` version, whether the
standard file was found or not.  e.g., In the first `load` example, if the main
config was in `/etc/my_app.yml` and local overrides were in
`~/.my_apprc.local.js`, that would Just Work.

