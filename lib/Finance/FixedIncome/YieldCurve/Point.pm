package Finance::FixedIncome::YieldCurve::Point;

use Moose;
use MooseX::Types::Moose;

has maturity => (
  is => 'ro',
  isa => Int,
  required => 1,
);

has yield => (
  is => 'ro',
  isa => Num,
  required => 1,
);

__PACKAGE__->meta->make_immutable;

1;

__END__;
