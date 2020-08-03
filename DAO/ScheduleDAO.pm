package DAO::ScheduleDAO;

use DBI;
use Data::Dumper;
use feature qw( say );

#to inherit from connection ot database class
use ConnectionToDB;
our @ISA = qw(ConnectionToDB);

#SQL requests
my $SQL_GET_ALL = "SELECT record_id, task, developer, team, start_time, end_time FROM Schedule;";
my $SQL_GET_BY_ID = "SELECT record_id, task, developer, team, start_time, end_time FROM Schedule WHERE record_id = ?;";
my $SQL_INSERT_SCHEDULE = "INSERT INTO Schedule (task, developer, team, start_time, end_time) VALUES (?,?,?,?,?);";
my $SQL_DELETE_SCHEDULE_BY_ID = "DELETE FROM Schedule WHERE record_id = ?";



# selects schedules out of the database and returns a list
sub getAll {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_ALL);
	$stat->execute();
	my @res = ();
	my ( $record_id, $task, $developer, $team, $start_time, $end_time );
	while ( ( $record_id, $task, $developer, $team, $start_time, $end_time ) = $stat->fetchrow() ) {
		my %map = (
			record_id    => $record_id,
			task    	 => $task,
			developer    => $developer,
			team         => $team,
			start_time   => $start_time,
			end_time     => $end_time,
		);
		my $schedule = Model::Schedule->new(%map);
		push( @res, $schedule );
	}
	return @res;
}

#get schedule by record_id
sub getById {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_BY_ID);
	$stat->execute( shift @_ );
	if ( my ( $record_id, $task, $developer, $team, $start_time, $end_time ) = $stat->fetchrow() ) {
		my %map = (
			record_id    => $record_id,
			task    	 => $task,
			developer    => $developer,
			team         => $team,
			start_time   => $start_time,
			end_time     => $end_time,
		);
		my $schedule = Model::Schedule->new(%map);
		return $schedule;
	}
	undef;
}


#add new schedule in database
sub put {
	my ( $self, $schedule ) = @_;
	my $stat = $self->{connection}->prepare($SQL_INSERT_SCHEDULE);
	$stat->execute( $schedule->{task}, $schedule->{developer}, $schedule->{team}, $schedule->{start_time}, $schedule->{end_time} );
	$schedule->setId( $stat->{msql_insertid} );
	return $schedule;
}

#delete schedule by record_id
sub delete {
	my ($self, $id) = @_;
	my $stat = $self->{onnection}->prepare($SQL_DELETE_SCHEDULE_BY_ID);
	return $stat->execute($id);
}

1;