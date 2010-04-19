
use strict;
use warnings;
use DateTime;
use Test::More tests => 5;

BEGIN{ use_ok('Finance::FixedIncome::Cashflow') }

my $positive_cf = Finance::FixedIncome::Cashflow->new(
  date => DateTime->new( year => 2001, month => 1, day => 1),
  amount => 1000
);

my $negative_cf = Finance::FixedIncome::Cashflow->new(
  date => DateTime->new( year => 2001, month => 1, day => 1),
  amount => -1000
);

my $past = DateTime->new( year => 2000, month => 1, day => 1);
my $future = DateTime->new( year => 2002, month => 1, day => 1);
{
  my $past_value = $positive_cf->value_at_date($past, 0.0001);
  ok( $past_value < 0 && $past_value > -1000, 'past of pos');

  my $future_value = $positive_cf->value_at_date($future, 0.0001);
  ok( $future_value < 0 && $future_value < -1000, 'future of pos');
}
{
  my $past_value = $negative_cf->value_at_date($past, 0.0001);
  ok( $past_value > 0 && $past_value < 1000, 'past of neg');

  my $future_value = $negative_cf->value_at_date($future, 0.0001);
  ok( $future_value > 0 && $future_value > 1000, 'future of neg');
}
