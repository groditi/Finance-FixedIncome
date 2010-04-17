package Finance::FixedIncome::YieldCurve;

use Moose;

#more than one point
has points => (
  traits => ['Array'],
  isa => 'ArrayRef[Finance::FixedIncome::YieldCurve::Point]',
  required => 1,
  handles => {
    points => 'elements',
  },
  initializer => sub {
    my ( $self, $value, $set, $attr ) = @_;
    my @sorted = sort { $a->days_to_maturity <=> $b->days_to_maturity } @$value;
    $set->( \@sorted );
  }
);


__PACKAGE__->meta->make_immutable;

1;

__END__;
