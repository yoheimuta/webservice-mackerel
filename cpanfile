requires 'perl', '5.008001';
requires 'JSON', '>= 2.90';
requires 'HTTP::Tiny', '>= 0.050';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Data::Util', '0.63';
    requires 'Test::Double', '0.05';
    requires 'Test::Fatal', '0.013';
};

