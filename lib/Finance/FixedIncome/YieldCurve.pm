package Finance::FixedIncome::YieldCurve;

use Moose;
use DateTime;
use DateTime::Duration;

has base_date => (
  is => 'ro',
  isa => 'DateTime',
  required => 1,
  default => { DateTime->today; }
);

has points => (
  traits => ['Array'],
  isa => 'ArrayRef[Finance::FixedIncome::YieldCurve::Point]',
  required => 1,
  handles => {
    points => 'elements',
  },
  initializer => sub {
    my ( $self, $value, $set, $attr ) = @_;
    my $base_date = $self->base_date;
    my @sorted = sort {
      DateTime::Duration->compare( $a, $b, $base_date );
    } @$value;
    $set->( \@sorted );
  }
);

sub yield_for_maturity {
  my ($self, $maturity) = @_;

  my $base_date = $self->base_date;
  my @points = $self->points;
  if( $maturity < $points[0]->maturity ){
    confess("Maturity ${maturity} too short for yield curve");
  }
  for my $i ( 0 .. $#points ){
    my $point = $points[$i];
    my $cmp = DateTime::Duration->compare( $maturity, $point->maturity, $base_date );
    return $point->yield if $cmp == 0;

    #I will find a better way to do this soon, buut for now let's just hold tight
    if( $cmp > 0 ){
      my $last_point = $points[$i - 1];
      my $yield_diff = $point->yield - $last_point->yield;
      my $maturity_diff = $point->maturity - $last_point->maturity;
      my $slope = $yield_diff / $maturity_diff;
      my $est_yield = $slope * ( $maturity - $last_point->maturity );
      return $est_yield;
    }
  }
  #maturity is further than our furthest point. No estimates just yet, throw exception
  confess("Maturity ${maturity} too long for yield curve");
}


__PACKAGE__->meta->make_immutable;

1;

__END__;
