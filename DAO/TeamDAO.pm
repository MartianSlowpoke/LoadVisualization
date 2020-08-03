package DAO::TeamDAO;

use DBI;
use Data::Dumper;
use feature qw( say );

#to inherit from connection ot database class
use ConnectionToDB;
our @ISA = qw(ConnectionToDB);

#SQL requests
my $SQL_GET_ALL = "SELECT team_id, name, lead FROM Team;";
my $SQL_GET_BY_ID = "SELECT team_id, name, lead FROM Team WHERE team_id = ?;";
my $SQL_INSERT_TEAM = "INSERT INTO Team (name, lead) VALUES (?,?);";
my $SQL_UPDATE_TEAM = "UPDATE Team SET name = ? WHERE team_id = ?";
my $SQL_DELETE_TEAM_BY_ID = "DELETE FROM Team WHERE team_id = ?";

# selects teams out of the database and returns a list
sub getAll {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_ALL);
	$stat->execute();
	my @res = ();
	my ( $team_id, $name, $lead );
	while ( ( $team_id, $name, $lead ) = $stat->fetchrow() ) {
		my %map = (
			team_id => $team_id,
			name    => $name,
			team    => $lead
		);
		my $team = Model::Team->new(%map);
		push( @res, $dev );
	}
	return @res;
}

#get team by team_id
sub getById {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_BY_ID);
	$stat->execute( shift @_ );
	if ( my ( $team_id, $name, $lead ) = $stat->fetchrow() ) {
		my %map = (
			team_id => $team_id,
			name    => $name,
			team    => $lead
		);
		my $team = Model::Team->new(%map);
		return $team;
	}
	undef;
}

#to update team name by team_id
sub update {
	my ( $self, $team_id, $name ) = @_;
	my $stat = $self->{connection}->prepare{$SQL_UPDATE_TEAM};
	return $stat->execute($name, $team_id);
}

#add new team in database
sub put {
	my ( $self, $team ) = @_;
	my $stat = $self->{connection}->prepare($SQL_INSERT_TEAM);
	$stat->execute( $team->{name}, $team->{lead} );
	$team->setId( $stat->{msql_insertid} );
	return $team;
}

#delete team by team_id
sub delete {
	my ($self, $id) = @_;
	my $stat = $self->{onnection}->prepare($SQL_DELETE_TEAM_BY_ID);
	return $stat->execute($id);
}

1;