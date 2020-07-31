use strict;
use warnings;

use lib ".";

use Path::Dispatcher;
use Path::Dispatcher::Match;
use Plack::Request;
use Plack::Response;
use DAO::DeveloperDAO;
use Model::User;
use Model::Team;
use Model::Developer;

#use Controller::DeveloperController;
use feature qw( say );    # Requires Perl 5.10.

use Crypt::JWT;
use Try::Tiny;

use JSON;

my $signature_key = "secret";

# WORKFLOW
# 1. start this webservice
# 2. go to any HTTP rest client
# 3. paste the test token inside Authorization header
# 4. send a request
# test token is eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IlNrb3JpeSBTZXJnZXkiLCJyb2xlIjoiYmFjay1lbmQgZGV2ZWxvcGVyIiwiZXhwaXJlc19kYXRldGltZSI6IjI2LzAzLzIwMDEifQ.KNFda0ffJRbHJ8Xe7qBTVeQa4wZNCLH_4spiVBmHTiA
# {"username":"Skoriy Sergey","role":"back-end developer","expires_datetime":"26/03/2001"}

my $devDAO = DAO::DeveloperDAO->new(
	{
		host     => "localhost",
		port     => "3306",
		user     => "root",
		password => "1111"
	}
);
say "first coderef = " . \$devDAO;

my $app = sub {
	my $env      = shift @_;
	my $request  = Plack::Request->new($env);
	my $response = Plack::Response->new();
	say "coderef = " . \$devDAO;
	try {
		my $encodedToken = $request->header('Authorization');
		my $decodedToken = Crypt::JWT::decode_jwt(
			token          => $encodedToken,
			key            => $signature_key,
			decode_payload => 0
		);
		my $user = JSON::decode_json($decodedToken);
		$response->code(200);
		$response->body();
		$response->content_type('application/json');
		my $response_json = {
			status => "200",
			message =>
"Hello, $user->{username}. You are nice $user->{role}! Your token expires on $user->{expires_datetime}"
		};
		$response->body( JSON::encode_json($response_json) );
		return $response->finalize();
	}
	catch {
		say "caught error: $_";
		$response->code(401);
		$response->content_type('application/json');
		my $json = {
			"status" => "401",
			"message" =>
"your token has been expired or you don't have access permission to this resource"
		};
		$response->body( JSON::encode_json($json) );
		return $response->finalize();
	};
};

#my $devController = Controller::DeveloperController->new();
#my @controllers   = ($devController);

#&test();

#sub test {
#	my $payload = {
#		username         => "Skoriy Sergey",
#		role             => "back-end developer",
#		expires_datetime => "26/03/2001"
#	};
#	my $jwt = Crypt::JWT::encode_jwt(
#		payload => $payload,
#		alg     => 'HS256',
#		key     => $signature_key
#	);
#	say "encoded: " . $jwt;
#	try {
#		my $data = Crypt::JWT::decode_jwt(
#			token          => $jwt,
#			key            => $signature_key,
#			decode_payload => 0
#		);
#		my $user = JSON::decode_json($data);
#		say "decoded: " . $data;
#	}
#	catch {
#		warn "caught error: $_";
#	};
#
#}

#my $app = sub {
#	my $env      = shift @_;
#	my $request  = Plack::Request->new($env);
#	my $response = Plack::Response->new();
#	my $resp     = Plack::Response->new();
#
#	foreach my $controller (@controllers) {
#		my $dispatcher = $controller->getDispatcher();
#		my $arg        = $request->method() . " " . $request->path_info();
#		my $dispatch   = $dispatcher->dispatch($arg);
#		if ( $dispatch->has_matches ) {
#			my @matches        = $dispatch->matches;
#			my $match          = shift @matches;
#			my $rule           = $match->rule;
#			my $controller_sub = $rule->block;
#			my $plack_response =
#			  $controller_sub->( $controller, $request, $response, $match );
#			return $plack_response->finalize;
#		}
#	}
#	return [
#		'404', [ 'Content-Type' => 'text/html' ],
#		['404 Controller Not Found'],
#	];
#};

