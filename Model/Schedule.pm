package Model::Schedule;

use Data::Dumper;


sub new {
	my $class = shift @_;
	my %map   = @_;         # (login=>cool,...)
	my $self  = {
		id          => $map{id},
		task        => $map{task},
		developer   => $map{developer},
		team        => $map{team},
		start_time  => $map{start_time},
		end_time    => $map{end_time}
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

sub getTask {
	my $self = shift @_;
	return $self->{task};
}

sub getDeveloper {
	my $self = shift @_;
	return $self->{developer};
}

sub getTeam {
	my $self = shift @_;
	return $self->{team};
}

sub getStartTime {
	my $self = shift @_;
	return $self->{start_time};
}

sub getEndTime {
	my $self = shift @_;
	return $self->{end_time};
}

sub toString {
	my $self = shift @_;
	return Data::Dumper::Dumper($self);
}

1;

