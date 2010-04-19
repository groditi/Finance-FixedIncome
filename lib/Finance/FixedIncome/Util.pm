package Finance::FixedIncome::Util;

use strict;
use warnings;
use Try::Tiny;
use Sub::Exporter -setup => {
  exports => [
    qw/cf_future_value cf_present_value cf_discount_rate periods_in_span/
  ]
};

our $VERSION = '0.001000';

sub cf_future_value {
  my($cashflow, $discount_rate, $periods) = @_;
  my $rate = (1 + $discount_rate)**$periods;
  return $cashflow * $rate * -1;
}

sub cf_present_value {
  my($cashflow, $discount_rate, $periods) = @_;
  my $rate = (1 + $discount_rate) ** $periods;
  return ($cashflow / $rate) * -1;
}

sub cf_discount_rate {
  my($cf1, $cf2, $periods) = @_;
  unless( abs($cf1) == $cf1 xor abs($cf2) == $cf2 ){
    die("One cashflow must be negative and the other positive");
  }
  my $rate = -1 * ($cf2 / $cf1);
  my $discount_rate = ($rate ** (1 / $periods)) - 1;
  return $discount_rate;
}

sub pv_of_perpetuity {
  my($cf, $rate) = @_;
  return $cf / $rate;
}

#use 'deltas' hash to do the thang
# #months, #days

sub periods_in_span{
  my($d1, $d2, $period_duration) = @_;
  my $periods = 0;
  return 0 if $d1 == $d2;
  my($beg_date, $end_date) = ($d1 < $d2 ? ($d1, $d2) : ($d2, $d1));

  my $period_beg = $beg_date;
  my $period_end = $beg_date->clone->add_duration( $period_duration );
  while( $period_end <= $end_date ){
    $periods++;
    $period_beg = $period_end->clone;
    $period_end->add_duration( $period_duration );
  }
  my $remaining_days = $period_beg->delta_days($end_date)->delta_days;
  my $period_days = $period_beg->delta_days($period_end)->delta_days;
  $periods = $periods + ( $remaining_days / $period_days);
  return $periods;
}


1;

__END__;

