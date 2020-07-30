package Model::Subsystem;

use Data::Dumper;

sub new {
	my $class = shift @_;
	my %map   = @_;
	my $self  = {
		id   => $map{id},
		name => $map{name}
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

sub toString {
	my $self = shift @_;
	return Data::Dumper::Dumper($self);
}

1;
