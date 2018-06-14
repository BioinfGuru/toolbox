# From http://www.uniprot.org/faq/28 
# This script maps uniprot IDs to REFSEQ IDs

use strict;
use warnings;
use LWP::UserAgent;

my $base = 'http://www.uniprot.org';
my $tool = 'mapping';

my $params = {											#curly brackets indicates $params is a reference to a hash	
  from => 'ACC',										#uniprot id
  to => 'P_REFSEQ_AC',										#refseq id
  format => 'tab',
  query => 'P13368 P20806 Q9UM73 P97793 Q17192'							#this is where you enter your scalar variable. your scalar variable is a list of all query IDsd
};

my $contact = ''; 										# Please set your email address here to help us debug in case of problems.
my $agent = LWP::UserAgent->new(agent => "libwww-perl $contact");				#creates an object called agent using lwp agent class to generate a new objecit where in the brakets are the key values)
push @{$agent->requests_redirectable}, 'POST';							#add to end of the array

my $response = $agent->post("$base/$tool/", $params);						#post (a method) is used on agent (an object)

while (my $wait = $response->header('Retry-After')) {
  print STDERR "Waiting ($wait)...\n";
  sleep $wait;											#avoids overloading the server
  $response = $agent->get($response->base);							
}

$response->is_success ?										#if loop: if ($response is successfule) {print or die}
  print $response->content :
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";

