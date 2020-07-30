package Model::Team;

use Data::Dumper;

sub new {
	my $class = shift @_;
	my %map   = @_;
	my $self  = {
		id   => $map{id},
		name => $map{name},
		lead => $map{lead}
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

sub getLead {
	my $self = shift @_;
	return $self->{lead};
}

sub toString {
	my $self = shift @_;
	return Data::Dumpler::Dumper($self);
}

1;
