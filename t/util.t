
use strict;
use warnings;
use DateTime;
use DateTime::Duration;
use Test::More tests => 13;

BEGIN {
  use_ok(
    'Finance::FixedIncome::Util',
    qw/cf_future_value cf_present_value cf_discount_rate periods_in_span/
  );
}

is(
  cf_future_value(-100, 0.05, 13),
  (100 * (1.05**13)),
  'cf_future_value neg'
);

is(
  cf_future_value(100, 0.05, 13),
  (-100 * (1.05**13)),
  'cf_future_value'
);

is(
  cf_present_value(100, 0.05, 13),
  (-100 / (1.05**13)),
  'cf_present_value'
);

is(
  cf_present_value(-100, 0.05, 13),
  (100 / (1.05**13)),
  'cf_present_value neg'
);

is(
  cf_discount_rate(-100,cf_future_value(-100,0.05,15),15),
  0.05,
  'cf_rate_of_return neg'
);

is(
  cf_discount_rate(cf_present_value(100,0.05,15),100,15),
  0.05,
  'cf_rate_of_return'
);

{
  my $d1 = DateTime->new(year => 2001, day => 01, month => 01);
  my $d2 = DateTime->new(year => 2002, day => 01, month => 01);

  {
    my $duration = DateTime::Duration->new(months => 1);
    is(periods_in_span($d1, $d2, $duration), 12, 'monthlong span 1');
    is(periods_in_span($d2, $d1, $duration), 12, 'monthlong span 2');
  }
  {
    my $duration = DateTime::Duration->new(months => 1, days => 5);
    is(periods_in_span($d1, $d2, $duration), 10 + ( 11/36), 'monthlong span 1');
  }
  {
    my $duration = DateTime::Duration->new(days => 5);
    is(periods_in_span($d1, $d2, $duration), 73, '5day span');
  }
  {
    my $duration = DateTime::Duration->new(years => 1);
    is(periods_in_span($d1, $d2, $duration), 1, '1 year span');
  }
  {
    #it's basically a rounding error due to leap-years
    my $duration = DateTime::Duration->new(years => 10);
    ok((.1 - periods_in_span($d1, $d2, $duration)) < .0001, 'decade span');
  }

}
