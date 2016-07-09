#!/usr/bin/perl

my $t = time();
my $x = `date`;
chomp $x;

open TOOL, "arp-scan --local|" or die "$!";
while( <TOOL> )
{
    # print $_;
    next if /DUP/;
	my @a = /^([\d\.]{6,})\s+([^\s]+)\s+(.+)$/;
	next unless @a;
	print join "\t", ( 'ARPSCAN', $t, $x, @a );
	print "\n";
}
