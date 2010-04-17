package Finance::FixedIncome::YieldCurve::EstimateMethod::StraightLine;

use Moose::Role;

#memoizable ...
sub yield_at_maturity {
  my($self, $days_to_maturity) = @_;

  my @points = $self->points;
  if( $days_to_maturity < $points[0]->days_to_maturity ){
    my($m, $b) = pairs_to_mb(
      [$points[0]->days_to_maturity, $points[0]->yield],
      [$points[1]->days_to_maturity, $points[1]->yield],
    );
    return ($m * $days_to_maturity) + $b;
  } elsif ( $days_to_maturity > $points[-1]->days_to_maturity ){
    my($m, $b) = pairs_to_mb(
      [$points[-2]->days_to_maturity, $points[-2]->yield],
      [$points[-1]->days_to_maturity, $points[-1]->yield],
    );
    return ($m * $days_to_maturity) + $b;
  }

  #yes, a binary search would be better, but its fine for now
  for my $i ( 0 .. $#points ){
    my $cmp = $days_to_maturity <=> $points[$i]->days_to_maturity;
    if( $cmp < 0 ){
      next;
    } elsif( $cmp == 0 ){
      return $points[$i]->yield;
    } else {
      my($m, $b) = pairs_to_mb(
        [$points[$i-1]->days_to_maturity, $points[$i-1]->yield],
        [$points[$i]->days_to_maturity, $points[$i]->yield],
      );
      return ($m * $days_to_maturity) + $b;
    }
  }
}

sub pairs_to_mb {
  my($a, $b) = @_;
  my $m = ($a->[1] - $b->[1]) / ($a->[0] - $b->[0]);
  my $b = $a->[1] - ( $a->[0] * $m );
  return ($m, $b);
}

1;

__END__;
