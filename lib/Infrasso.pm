package Infrasso;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.008001;
use Infrasso::DB::Schema;
use Infrasso::DB;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();

my $schema = Infrasso::DB::Schema->instance;

sub db {
    my $c = shift;
    if (!exists $c->{db}) {
        my $conf = $c->config->{DBI}
            or die "Missing configuration about DBI";
        $c->{db} = Infrasso::DB->new(
            schema       => $schema,
            connect_info => [@$conf],
            # I suggest to enable following lines if you are using mysql.
            # on_connect_do => [
            #     'SET SESSION sql_mode=STRICT_TRANS_TABLES;',
            # ],
        );
    }
    $c->{db};
}

1;
__END__

=head1 NAME

Infrasso - Infrasso

=head1 DESCRIPTION

This is a main context class for Infrasso

=head1 AUTHOR

Infrasso authors.

