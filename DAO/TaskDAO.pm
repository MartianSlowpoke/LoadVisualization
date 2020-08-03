package DAO::TaskDAO;

use DBI;
use Data::Dumper;
use feature qw( say );

#to inherit from connection ot database class
use ConnectionToDB;
our @ISA = qw(ConnectionToDB);

#SQL requests
my $SQL_GET_ALL = "SELECT task_id, name, priority, start_time, estimated_time, assignee FROM Task;";
my $SQL_GET_BY_ID = "SELECT task_id, name, priority, start_time, estimated_time, assignee FROM Task WHERE task_id = ?;";
my $SQL_INSERT_TASK = "INSERT INTO Task (name, priority, start_time, estimated_time, assignee) VALUES (?,?,?,?,?);";
my $SQL_UPDATE_TASK = "UPDATE Team SET assignee = ? WHERE task_id = ?";
my $SQL_DELETE_TASK_BY_ID = "DELETE FROM Task WHERE task_id = ?";


# selects tasks out of the database and returns a list
sub getAll {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_ALL);
	$stat->execute();
	my @res = ();
	my ( $task_id, $name, $priority, $start_time, $estimated_time, $assignee );
	while ( ( $task_id, $name, $priority, $start_time, $estimated_time, $assignee ) = $stat->fetchrow() ) {
		my %map = (
			task_id        => $task_id,
			name           => $name,
			priority       => $priority,
			start_time     => $start_time,
			estimated_time => $estimated_time,
			assignee       => $assignee
		);
		my $task = Model::Task->new(%map);
		push( @res, $task );
	}
	return @res;
}

#get task by task_id
sub getById {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_BY_ID);
	$stat->execute( shift @_ );
	if ( my ( $task_id, $name, $priority, $start_time, $estimated_time, $assignee ) = $stat->fetchrow() ) {
		my %map = (
			task_id        => $task_id,
			name           => $name,
			priority       => $priority,
			start_time     => $start_time,
			estimated_time => $estimated_time,
			assignee       => $assignee
		);
		my $task = Model::Task>new(%map);
		return $task;
	}
	undef;
}

#to update asignee of task by task_id
sub update {
	my ( $self, $task_id, $asignee ) = @_;
	my $stat = $self->{connection}->prepare{$SQL_UPDATE_TASK};
	return $stat->execute($asignee, $task_id);
}

#add new task in database
sub put {
	my ( $self, $task) = @_;
	my $stat = $self->{connection}->prepare($SQL_INSERT_TASK);
	$stat->execute( $task->{name}, $task->{priority}, $task->{start_time}, $task->{estimated_time}, $task->{asignee} );
	$task>setId( $stat->{msql_insertid} );
	return $task;
}

#delete task by task_id
sub delete {
	my ($self, $id) = @_;
	my $stat = $self->{onnection}->prepare($SQL_DELETE_TASK_BY_ID);
	return $stat->execute($id);
}

1;