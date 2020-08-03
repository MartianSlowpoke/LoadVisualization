package DAO::ConnectionToDB;

sub new {
	my ( $class, $config ) = @_;
	my $dsn  = "dbi:mysql:LoadVisualization:$config->{host}:$config->{port}";
	my $dbi  = DBI->connect( $dsn, $config->{user}, $config->{password} );
	my $self = { connection => $dbi };
	bless $self, $class;
	return $self;
}