package Controller::DeveloperController;

# constructor
sub new {
	my $class      = shift @_;
	my $dispatcher = Path::Dispatcher->new;
	$dispatcher->add_rule(
		Path::Dispatcher::Rule::Regex->new(
			regex => qr/^GET \/developers$/,
			block => \&getAllDevelopers,
		)
	);

	$dispatcher->add_rule(
		Path::Dispatcher::Rule::Regex->new(
			regex => qr/^GET \/developers\/\d+$/,
			block => \&getDeveloperById,
		)
	);

	my $devDAO = DAO::DeveloperDAO->new(
		{
			host     => "localhost",
			port     => "3306",
			user     => "root",
			password => "1111"
		}
	);
	my $self = { dispatcher => $dispatcher, devDAO => $devDAO };
	bless $self, $class;
	return $self;
}

sub getAllDevelopers {
	my ( $self, $request, $response, $match ) = @_;
	my @developers = $self->{devDAO}->getAll();
	$response->status(200);
	$response->content_type('application/json');
	my $result;
	foreach my $developer (@developers) {
		$result .= $developer->toString();
	}
	$response->body($result);
	return $response;
}

sub getDeveloperById {

	# $match - use Path::Dispatcher::Match;
	my ( $self, $request, $response, $match ) = @_;

	# if GET /api/developers/23 then id = 23
	my ($id) = $match->path =~ /(\d+)/;
	my $dev = $self->{devDAO}->getById($id);
	if ( defined($dev) ) {
		$response->status(200);
		$response->body( $dev->toString() );
		$response->content_type('application/json');
		return $response;
	}
	$response->status(404);
	$response->body("a developer with id [$id] doesn't exist");
	$response->content_type('application/json');
	return $response;
}

sub getDispatcher {
	my $self = shift @_;
	return $self->{dispatcher};
}

1;
