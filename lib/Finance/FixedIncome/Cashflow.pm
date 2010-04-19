package Finance::FixedIncome::Cashflow;

use Moose;
use DateTime;
use DateTime::Duration;
use Finance::FixedIncome::Util qw(cf_future_value cf_present_value);
use MooseX::Types::Moose qw(Num ArrayRef);

has amount => (
  is => 'ro',
  isa => 'Num',
  required => 1,
);

has date => (
  is => 'ro',
  isa => 'DateTime',
  required => 1,
);


#will have to rename later
sub value_at_date {
  my($self, $pricing_date, $periodic_rate, $period_duration) = @_;
  #TODO param checking
  my $cf_date = $self->date;
  if( $pricing_date == $cf_date ){
    return $self->amount * -1;
  }



  if( $cmp > 0 ){
    #period_duration shorter than discount_period
    $iterator = $pricing_date->add( $period_duration );
    $periods++
  } elsif( $cmp < 0) {
    #period_duration longer than discount_period
  } else {
    #period_duration equal to discount_period
    $periods = 1;
  }

  my $remaining_duration = $p;
  if( $period_duration->delta_years ){
  }


  if( $pricing_date > $cf_date ){
    #future value
    return cf_future_value($self->amount, $periodic_rate, $periods);
  } else {
    #past present value
    return cf_present_value($self->amount, $periodic_rate, $periods);
  }
}

__PACKAGE__->meta->make_immutable;

1;

__END__;
