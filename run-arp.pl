#!/usr/bin/perl

my $t = time();

open TOOL, "arp -a|" or die;
while( <TOOL> )
{
	# print $_;
	my @a = 	/^([^\s]+)\s+\(([\d\.]+)\)\s+at\s+([^\s]+).*+on\s+([^\s]+)/;
	print join "\t", ( 'ARP', $t, @a ) ;
	print "\n";
}