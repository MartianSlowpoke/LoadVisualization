package DAO::DeveloperDAO;

use DBI;
use Data::Dumper;
use feature qw( say );

my $SQL_GET_ALL = "SELECT id, name, team, routine FROM Developer;";
my $SQL_GET_BY_ID =
  "SELECT id, name, team, routine FROM Developer WHERE id = ?;";
my $SQL_INSERT_DEV =
  "INSERT INTO Developer (name, team, routine) VALUES (?,?,?);";

sub new {
	my ( $class, $config ) = @_;
	my $dsn  = "dbi:mysql:LoadVisualization:$config->{host}:$config->{port}";
	my $dbi  = DBI->connect( $dsn, $config->{user}, $config->{password} );
	my $self = { connection => $dbi };
	bless $self, $class;
	return $self;
}

# selects developers out of the database and returns a list
sub getAll {
	my $self = shift @_;
	my $stat = $self->{connection}->prepare($SQL_GET_ALL);
	$stat->execute();
	my @res = ();
	my ( $id, $name, $team, $routine );
	while ( ( $id, $name, $team, $routine ) = $stat->fetchrow() ) {
		my %map = (
			id      => $id,
			name    => $name,
			team    => $team,
			routine => $routine
		);
		my $dev = Model::Developer->new(%map);
		push( @res, $dev );
	}
	return @res;
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
