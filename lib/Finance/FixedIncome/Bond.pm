package Finance::FixedIncome::Bond;

use Moose;
use DateTime;
use MooseX::Types::Moose qw(Num ArrayRef);

has par_value => (
  is => 'ro',
  isa => Num,
  required => 1,
);

has coupon => (
  is => 'ro',
  isa => Num,
  required => 1,
);

has coupon_dates => (
  is => 'ro',
  isa => ArrayRef['DateTime'],
  required => 1,
);

has issue_date => (
  is => 'ro',
  isa => 'DateTime',
);

has maturity_date => (
  is => 'ro',
  isa => 'DateTime',
);

sub coupon_rate {
  my $self = shift;
  return ($self->coupon * $self->coupons_per_year) / $self->par_value;
}

1;

__PACKAGE__->meta->make_immutable;

__END__;

has price => (
  is => 'ro',
  isa => 'Num',
  lazy_build => 1,
);

sub _build_price {
  my $self = shift;
}

sub current_yield {
  my $self = shift;
  return ( $self->coupons_per_year * $self->coupon) / $self->price;
}
