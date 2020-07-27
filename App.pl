use strict;
use warnings;

use lib ".";

use DAO::DeveloperDAO;
use Model::Developer;
use Path::Dispatcher;
use Path::Dispatcher::Match;

use Plack::Request;
use Plack::Response;
use Controller::DeveloperController;
use feature qw( say );    # Requires Perl 5.10.

my $devController = Controller::DeveloperController->new();
my @controllers   = ($devController);

my $app = sub {
	my $env      = shift @_;
	my $request  = Plack::Request->new($env);
	my $response = Plack::Response->new();
	my $resp     = Plack::Response->new();
	foreach my $controller (@controllers) {
		my $dispatcher = $controller->getDispatcher();
		my $arg        = $request->method() . " " . $request->path_info();
		my $dispatch   = $dispatcher->dispatch($arg);
		if ( $dispatch->has_matches ) {
			my @matches        = $dispatch->matches;
			my $match          = shift @matches;
			my $rule           = $match->rule;
			my $controller_sub = $rule->block;
			my $plack_response =
			  $controller_sub->( $controller, $request, $response, $match );
			return $plack_response->finalize;
		}
	}
	return [
		'404', [ 'Content-Type' => 'text/html' ],
		['404 Controller Not Found'],
	];
};

