package DAO::DeveloperRepository;

use DBI;

# selects developer and team and lead
my $SQL_GET_ALL_DEVELOPERS =
"SELECT developers.developer_id, teams.team_id, users.user_id FROM developers INNER JOIN teams ON developers.team = teams.team_id INNER JOIN users ON teams.lead = users.user_id;";


sub new {
	my $class = shift @_;
	
}

1;
