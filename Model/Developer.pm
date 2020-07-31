package Model::Developer;

use Data::Dumper;
use feature qw( say );

sub new {
	my $class = shift @_;
	my %map   = @_;
	my $self  = {
		id         => $map{id},
		name       => $map{name},
		team       => $map{team},
		routine    => $map{routine},
		subsystems => $map{subsystems}
	};
	bless $self, $class;
	return $self;
}

sub setId {
	my ( $self, $id ) = @_;
	$self->{id} = $id;
}

sub setSubsystems {
	my ( $self, $list ) = @_;
	$self->{subsystems} = $list;
}

sub getId {
	my ($self) = @_;
	return $self->{id};
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

sub getSubsystems {
	my $self = shift @_;
	return $self->{subsystems};
}

sub toString {
	my $self = shift @_;
	return Data::Dumper::Dumper($self);
}

1;
