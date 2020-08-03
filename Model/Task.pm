package Model::Task;

use Data::Dumper;

sub new {
	my $class = shift @_;
	my %map   = @_;
	my $self  = {
		id             => $map{id},
		name           => $map{name},
		priority       => $map{priority},
		start_time     => $map{start_time},
		estimated_time => $map{estimated_time},
		asignee        => $map{asignee}

	};
	bless $self, $class;
	return $self;
}

sub setId {
	my ( $self, $id ) = @_;
	$self->{id} = $id;
}

sub getId {
	my $self = shift @_;
	return $self->{id};
}

sub getName {
	my $self = shift @_;
	return $self->{name};
}

sub getPriority {
	my $self = shift @_;
	return $self->{priority};
}

sub getStartTime {
	my $self = shift @_;
	return $self->{start_time};
}

sub getEstimatedTime {
	my $self = shift @_;
	return $self->{estimated_time};
}

sub getAsignee {
	my $self = shift @_;
	return $self->{asignee};
}

sub toString {
	my $self = shift @_;
	Data::Dumper::Dumper($self);
}

1;
