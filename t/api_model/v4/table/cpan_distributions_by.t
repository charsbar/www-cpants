use Mojo::Base -strict, -signatures;
use WWW::CPANTS::Test;
use WWW::CPANTS::Test::Fixture;
use Test::More;
use Test::Deep qw(cmp_deeply);

fixture {
    my @files = (
        'ISHIGAKI/Path-Extended-0.19.tar.gz',
        'ISHIGAKI/Pod-Perldocs-0.17.tar.gz',
    );
    my $testpan = setup_testpan(@files);
    load_task('Traverse')->run(qw/ISHIGAKI/);
    load_task('Analyze')->run(@files);
};

my $model = api_model('V4::Table::CPANDistributionsBy');

subtest 'some of mine' => sub {
    my $res = $model->load({ pause_id => 'ISHIGAKI' });
    cmp_deeply $res => {
        'data' => [{
                'date'    => '2011-05-31',
                'fails'   => [],
                'latest'  => 1,
                'name'    => 'Path-Extended',
                'score'   => 100,
                'version' => '0.19'
            },
            {
                'date'    => '2011-01-06',
                'fails'   => ['main_module_version_matches_dist_version'],
                'latest'  => 1,
                'name'    => 'Pod-Perldocs',
                'score'   => '96.88',
                'version' => '0.17'
            },
        ],
        'recordsTotal' => 2,
    };
};

done_testing;
