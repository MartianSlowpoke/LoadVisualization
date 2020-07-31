package DAO::DeveloperDAO;

use DBI;
use Data::Dumper;
use feature qw(say);

# joins developer, team, user
my $SQL_GET_ALL_DEVELOPERS_WITH_LIMIT =
  "SELECT developers . developer_id, developers.name, developers.routine,
  teams.team_id, teams.name, users . user_id, users.name, roles.role_id, roles.tag FROM developers INNER JOIN teams ON developers . team =
  teams . team_id INNER JOIN users ON teams . lead INNER JOIN roles ON users.role = roles.role_id = users . user_id LIMIT ?, ?;
";

# joins developer, team, user
my $SQL_GET_ALL_DEVELOPERS =
  "SELECT developers . developer_id, developers.name, developers.routine,
  teams.team_id, teams.name, users . user_id, users.name, roles.role_id, roles.tag FROM developers INNER JOIN teams ON developers . team =
  teams . team_id INNER JOIN users ON teams . lead INNER JOIN roles ON users.role = roles.role_id = users . user_id;
";

# joins specs, subsystems
my $SQL_GET_SUBSYSTEMS_OF_DEVELOPER =
"SELECT subsystems.subsystem_id, subsystems.name FROM specs INNER JOIN subsystems ON specs.subsystem = subsystems.subsystem_id WHERE developer = ?;
  ";

my $SQL_GET_BY_ID =
  " SELECT id, name, team, routine FROM Developer WHERE id = ?;";
my $SQL_INSERT_DEV =
  "INSERT INTO Developer (name, team, routine) VALUES (?, ?,? );
";

sub new {
	my ( $class, $config ) = @_;
	my $dsn  = "dbi:mysql:load_visualization:$config->{host}:$config->{port}";
	my $dbi  = DBI->connect( $dsn, $config->{user}, $config->{password} );
	my $self = { connection => $dbi };
	bless $self, $class;
	return $self;
}

# page index is the first page is accessible by 0 index
# per_page is the count of returned records
sub getAll {
	my $self      = shift @_;
	my %param_map = @_;
	my ( $statement, $subsystem_statement );
	$subsystem_statement =
	  $self->{connection}->prepare($SQL_GET_SUBSYSTEMS_OF_DEVELOPER);
	if ( defined( $param_map{page} ) && defined( $param_map{per_page} ) ) {
		$statement =
		  $self->{connection}->prepare($SQL_GET_ALL_DEVELOPERS_WITH_LIMIT);
		$statement->execute( $param_map{page}, $param_map{per_page} );
	}
	else {
		$statement = $self->{connection}->prepare($SQL_GET_ALL_DEVELOPERS);
		$statement->execute();
	}
	my @developers = ();
	my ( $dev, $team, $lead, @row );
	while ( @row = $statement->fetchrow() ) {
		my (
			$dev_id,  $dev_name,  $dev_routine, $team_id, $team_name,
			$user_id, $user_name, $role_id,     $role_tag
		) = @row;
		$lead = Model::User->new(
			id   => $user_id,
			name => $user_name,
			role => $role_tag
		);
		$team =
		  Model::Team->new( id => $team_id, name => $team_name, lead => $lead );
		$dev = Model::Developer->new(
			id      => $dev_id,
			name    => $dev_name,
			team    => $team,
			routine => $dev_routine
		);
		$subsystem_statement->execute( $dev->getId() );
		my @subs = ();
		while ( @row = $subsystem_statement->fetchrow() ) {
			my ( $id, $name ) = @row;
			my $sub = Model::Subsystem( id => $id, name => $name );
			push( @subs, $sub );
		}
		$dev->setSubsystems( \@subs );
		push( @developers, $dev );
	}
	$statement->finish();
	$subsystem_statement->finish();
	return @developers;
}

sub getById {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_BY_ID);
	$stat->execute( shift @_ );
	if ( my ( $id, $name, $team, $routine ) = $stat->fetchrow() ) {
		my %map = (
			id      => $id,
			name    => $name,
			team    => $team,
			routine => $routine
		);
		my $dev = Model::Developer->new(%map);
		return $dev;
	}
	undef;
}

sub put {
	my ( $self, $dev ) = @_;
	my $stat = $self->{connection}->prepare($SQL_INSERT_DEV);
	$stat->execute( $dev->{name}, $dev->{team}, $dev->{routine} );
	$dev->setId( $stat->{msql_insertid} );
	return $dev;
}
1;
