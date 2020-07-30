package Model::User;

use Data::Dumper;

my $user = new(
	id       => 1,
	login    => 'slowpoke',
	password => '1111',
	name     => 'Skoryi Serhii',
	role     => 'team lead'
);

sub new {
	my $class = shift @_;
	my %map   = @_;         # (login=>cool,...)
	my $self  = {
		id       => $map{id},
		login    => $map{login},
		password => $map{password},
		name     => $map{name},
		role     => $map{role}
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

sub getLogin {
	my $self = shift @_;
	return $self->{login};
}

sub getPassword {
	my $self = shift @_;
	return $self->{password};
}

sub getName {
	my $self = shift @_;
	return $self->{name};
}

sub getRole {
	my $self = shift @_;
	return $self->{role};
}

sub toString {
	my $self = shift @_;
	return Data::Dumper::Dumper($self);
}

1;

