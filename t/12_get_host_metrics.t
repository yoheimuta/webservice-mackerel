use strict;
use Test::More;
use Test::TCP qw(test_tcp);
use Plack::Loader;
use JSON qw/encode_json/;

use WebService::Mackerel;

my $endpoint = 'http://localhost';
my $host_id  = '2RnaLGypmBJ';
my $path     = "/api/v0/hosts/$host_id/metrics";
my $response_content = encode_json({
    "metrics" => [{
        "time" => 1478995200,"value" => 1.3820763888888887
    },{
        "time" => 1479081600,"value" => 1.4007222222222226
    }]
});

subtest 'get_host_metrics' => sub {
    my $params = { name => 'loadavg5', from => '1478744400', to => '1479303590' };

    test_tcp(
        server => sub {
            my $port = shift;
            Plack::Loader->load('Standalone', port => $port)->run(
                sub {
                    my $env = shift;
                    my $req_path = $env->{PATH_INFO};
                    is $req_path, $path;

                    my $query = $env->{QUERY_STRING};
                    my %qparams = map { split '=', $_ } (split '&', $query);
                    is_deeply \%qparams, $params;

                    return [200, [], [$response_content]];
                }
            );
        },
        client => sub {
            my ($port, $server_pid) = @_;
            my $mackerel = WebService::Mackerel->new(
                api_key  => 'testapikey',
                service_name => 'test',
                mackerel_origin => "$endpoint:$port",
            );

            my $res = $mackerel->get_host_metrics($host_id, $params);
            is_deeply $res, $response_content, 'get_host_metrics: response success';
        },
    );
};

done_testing;
