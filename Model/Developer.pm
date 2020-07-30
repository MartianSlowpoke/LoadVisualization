package Model::Developer;

use Data::Dumper;

sub new {
	my $class = shift @_;
	my %map   = @_;
	my $self  = {
		id      => $map{id},
		name    => $map{name},
		team    => $map{team},
		routine => $map{routine}
	};
	bless $self, $class;
	return $self;
}

sub setId {
	my ( $self, $id ) = @_;
	$self->{id} = $id;
}

sub getName {
	my $self = shift @_;
	return $self->{name};
}

sub getTeam {
	my $self = shift @_;
	return $self->{team};
}

sub getRoutine {
	my $self = shift @_;
	return $self->{routine};
}

sub toString {
	my $self = shift @_;
	return Data::Dumper::Dumper($self);
}

1;
