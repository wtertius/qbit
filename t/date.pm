use Test::More tests => 8;

use qbit;

is(trdate(db => norm => 0), undef, 'Check bad date');

is_deeply(trdate(norm => norm => [2013, 12, 31, 23, 59, 59]), [2013, 12, 31, 23, 59, 59], 'Check trdate norm => norm');

is_deeply(trdate(norm => db => [2013, 12, 31, 23, 59, 59]), '2013-12-31', 'Check trdate norm => db');
is_deeply(trdate(db => norm => '2013-12-31'), [2013, 12, 31, 0, 0, 0], 'Check trdate db => norm ');

is_deeply(trdate(norm => db_time => [2013, 12, 31, 23, 59, 59]), '2013-12-31 23:59:59', 'Check trdate norm => db');
is_deeply(trdate(db_time => norm => '2013-12-31 23:59:59'), [2013, 12, 31, 23, 59, 59], 'Check trdate db => norm ');

is(trdate(norm => sec => trdate(sec => norm => 1375808504)), 1375808504, 'Check trdate sec => norm => sec');

is(trdate(norm => days_in_month => [2012, 02, 15]), 29, 'Check trdate norm => days_in_month');
