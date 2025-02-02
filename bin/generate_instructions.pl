#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use FuseBead::From::PNG;

use Data::Debug;

my $file = shift @ARGV || die "PNG required";

my $png = FuseBead::From::PNG->new({ filename => $file, whitelist => [ whitelist() ], imperial => 1 });

# HTML
my $result = $png->process(view => HTML);
print $result;
exit;

# Text
my $result = $png->process;

my @list = sort map {
 $png->bead_colors->{ $_->{'color'} }{'name'} . ' - ' . $_->{'quantity'} . ' ' . ($_->{'quantity'} > 1 ? 'beads' : 'bead')
} values %{ $result->{'beads'} };

my $row = 0;
my @plan = map {
 my $txt = '';
 $txt = "\n\n".$_->{'meta'}{'y'}.': ' and $row = $_->{'meta'}{'y'} if $row != $_->{'meta'}{'y'};
 $txt .= '[ ' . $png->bead_colors->{ $_->{'color'} }{'name'} . ' ] ';
 $txt;
} @{ $result->{'plan'} };


my $total = 0;
for my $bead (values %{ $result->{'beads'} }) {
    $total += $bead->{'quantity'};
}

print $total . " Total Beads\n\n";
print "Shopping List\n-------------------------------------------------------------------------\n";
print $_,"\n" for @list;
print "\nPlan\n-------------------------------------------------------------------------\n";
print '0: ';
print $_ for @plan;

sub whitelist {
    return qw(
WHITE
BLACK
    );
}
