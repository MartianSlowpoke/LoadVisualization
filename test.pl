use strict;
use warnings;

use lib ".";
use DAO::DeveloperDAO;
use Model::User;
use Model::Team;
use Model::Developer;
use feature qw( say );

my $devDAO = DAO::DeveloperDAO->new(
	{
		host     => "localhost",
		port     => "3306",
		user     => "root",
		password => "1111"
	}
);
map { say $_->toString() } $devDAO->getAll( page => 0, per_page => 3 );
