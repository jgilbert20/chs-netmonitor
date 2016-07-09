#!/usr/bin/perl

my $t = time();

open TOOL, "arp -a|" or die;
my $x = `date`;
chomp $x;

while( <TOOL> )
{
	# print $_;
	my @a = /^([^\s]+)\s+\(([\d\.]+)\)\s+at\s+([^\s]+)/; # .*+on\s+([^\s]+)/;
	print join "\t", ( 'ARP', $t, $x, @a ) ;
	print "\n";
}
