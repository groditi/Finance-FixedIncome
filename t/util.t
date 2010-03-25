
use strict;
use warnings;
use Test::More tests => 5;

BEGIN {
  use_ok(
    'Finance::FixedIncome::Util',
    qw/cf_future_value cf_present_value cf_discount_rate/
  );
}

is(
  cf_future_value(-100, 0.05, 13),
  (100 * (1.05**13)),
  'cf_future_value'
);

is(
  cf_present_value(100, 0.05, 13),
  (-100 / (1.05**13)),
  'cf_present_value'
);

is(
  cf_discount_rate(-100,cf_future_value(-100,0.05,15),15),
  0.05,
  'cf_rate_of_return'
);

is(
  cf_discount_rate(cf_present_value(100,0.05,15),100,15),
  0.05,
  'cf_rate_of_return'
);
