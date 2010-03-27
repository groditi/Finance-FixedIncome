package Finance::FixedIncome::Bond::Util;

use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [
      qw(discount_to_bond_equivalent_yield apr_to_ear),
    ],
  };


#adjust for leap year
sub discount_to_bond_equivalent_yield {
  my ($discount_yield, $days_to_maturity) = @_;
  return ( 365 x $discount_yield ) / ( (360 - $days_to_maturity ) * $discount_yield);
}

sub apr_to_ear {
  my( $apr, $periods) = @_;
  return ( 1 + ($apr / $periods) ** $periods ) - 1;
}


#sub yield_to_maturity {
#  my($price, $price_date, $maturity_date) = @_;
#  
#}

1;

__END__;
