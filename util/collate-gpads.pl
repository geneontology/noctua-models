#!/usr/bin/perl
use strict;
use FileHandle;
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
    $base = lc($base);
    if (!$fhmap{$base}) {
        my $fh = FileHandle::new();
        $fh->open(">legacy/$base.gpad") || die $base;
        $fhmap{$base} = $fh;
    }
    my $fh = $fhmap{$base};
    print $fh "$line\n";
        
}
