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

sub toString {
	my $self = shift @_;
	Dumper($self);
}

1;
