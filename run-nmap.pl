#!/usr/bin/perl

my $t = time();



open TOOL, "arp -a|" or die "$!";

while( <TOOL> )
{
	# print $_;
	my @a = /^([^\s]+)\s+\(([\d\.]+)\)\s+at\s+([^\s]+)/; # .*+on\s+([^\s]+)/;
	my $sname = $1;
	my $ip = $2;
	my $ether = $3;

	$etherForIP{$ip} = $ether;

	print join "\t", ( 'ARP', $t, $x, @a ) ;
	print "\n";
}

close TOOL;






#open TOOL, "" or die "$!";
open TOOL, "<pinetexample" or die "$!";
my $x = `date`;
chomp $x;

while( <TOOL> )
{

	if( /^Nmap scan report for ([\d\.]+)/ )
	{
		$currentIP = $1;
	}

	next unless defined $currentIP;

	chomp;

	my $raw = $_;

	if( $raw =~ /^(\d+)\/(\w+)\s+(\w+)\s+(.+)/ )
	{
		@curService = ($1,$2,$3,$4 );
		my @a = ('NMAP', $t, $currentIP, 'SERVICE', $1,$2,$3,$4 );
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^Service Info:\s+(.*)$/ )
	{
		my @a = ('NMAP', $t, $currentIP, 'OS', $1);
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^\|\_([^\:]+):(.+)/ )
	{	
		my @a = ('NMAP', $t, $currentIP, 'SERVICEINFO', $1, $2);
		print join "\t", @a;
		print "\n";
	}	

	# my @a = ('NMAP', $t, $currentIP, 'RAW', $raw );
	# print join "\t", @a;
	# print "\n";
}
