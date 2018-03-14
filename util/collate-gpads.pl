#!/usr/bin/perl -w
use strict;
use FileHandle;

# maps group names to filehandles;
# e.g. zfin => wrte filehandle for zfin.gpad
my %fhmap = ();
while(<>) {
    next if (m@^\!@);
    chomp;
    my @vals = split(/\t/, $_);
    write_line_to_file($vals[0], $_);
}
foreach my $fh (values %fhmap) {
    $fh->close();
}
exit 0;

sub write_line_to_file {
    my ($base, $line) = @_;
    if (!$base) {
        $base = 'other';
    }
    my @colvals = split(/\t/);
    my @props = split(/\|/, $colvals[11]);
    if (!grep {$_ eq 'model-state=production'} @props) {
        # skip non-production models
        return;
    }
    $base = lc($base);
    if (!$fhmap{$base}) {
        my $fh = FileHandle::new();
        $fh->open(">legacy/$base.gpad") || die $base;
        $fhmap{$base} = $fh;
    }
    my $fh = $fhmap{$base};
    print $fh "$line\n";
        
}
