use strict;
use warnings;

use lib ".";
use Model::User;
use Model::Team;
use Model::Developer;
use feature qw( say );

my $user = Model::User->new(
	login    => 'slowpoke',
	password => '1111',
	name     => 'Skoryi Serhii',
	role     => 'team lead'
);

my $team = Model::Team->new(name=>'Mena Team', lead=>$user);

say $user->toString();

say $team->toString();
