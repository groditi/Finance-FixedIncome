package Finance::FixedIncome::Util;

use strict;
use warnings;
use Try::Tiny;
use Sub::Exporter -setup => {
  exports => [
    qw/cf_future_value cf_present_value cf_discount_rate/
  ]
};

our $VERSION = '0.001000';

sub cf_future_value {
  my($cashflow, $discount_rate, $periods) = @_;
  my $multiplier = $cashflow >= 0 ? 1 : -1;
  my $rate = (1 + $discount_rate)**$periods;
  return $cashflow * $rate * $multiplier;
}

sub cf_present_value {
  my($cashflow, $discount_rate, $periods) = @_;
  my $multiplier = $cashflow >= 0 ? -1 : 1;
  my $rate = (1 + $discount_rate) ** $periods;
  return ($cashflow / $rate) * $multiplier;
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

1;

__END__;

