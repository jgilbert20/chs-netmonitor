#!/usr/bin/perl

my $t = time();

open TOOL, "arp-scan --local|" or die "$!";
while( <TOOL> )
{
	# print $_;
	my @a = /^([\d\.]{6,})\s+([^\s]+)\s+(.+)$/;
	next unless @a;
	print join "\t", ( 'ARPSCAN', $t, @a ) ;
	print "\n";
}