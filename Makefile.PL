use inc::Module::Install;

name     'WITH';
all_from 'lib/WITH.pm';
author   'Alex Efros <powerman-asdf@ya.ru>';
license  'perl';

requires        'version';
requires        'Sub::Uplevel';
test_requires   'Perl6::Export::Attrs';
test_requires   'Test::More';
test_requires   'Test::Exception';
test_requires   'Time::HiRes';

WriteAll;

