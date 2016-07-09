#!/usr/bin/perl

my $t = time();

# sudo apt-get install avahi-utils
# avahi-browse -a --resolve -c -p > avahi-browse.example


open TOOL, "<last-arp" or die "$!";

while( <TOOL> )
{
	# print $_;
	my @a = /^([^\s]+)\s+\(([\d\.]+)\)\s+at\s+([^\s]+)/; # .*+on\s+([^\s]+)/;
	my $sname = $1;
	my $ip = $2;
	my $ether = $3;

	$etherSeen{$ether} = 1;
	$ipSeen{$ether} = 1;

	$etherForIP{$ip} = $ether;
	$ipForEther{$ether} = $ip;

	print join "\t", ( 'ARP', $t, $ip, $ether, $name ) ;
	print "\n";
}

close TOOL;

open TOOL, "<last-avahi-browse" or die "$!";
# =;eth0;IPv4;netmon0;Remote Disk Management;local;netmon0.local;192.168.1.132;22;

while( <TOOL> )
{
	chomp;
	my @a = split ';', $_;

	if( $a[0] eq '=' )
	{
		my( $ltype, $iface, $stack, $usersname, $sname, $domain, $fq, $ip, $port, $extra ) = @a;
		print join "\t", ( 'AVAHI', $t, $ip, $fq, $iface, $stack, $sname, $domain ) ;
		print "\n";
		$avahiNamesForIP{$ip} = $fq;
	}


}

close TOOL;





#open TOOL, "" or die "$!";
open TOOL, "<last-nmap" or die "$!";
my $x = `date`;
chomp $x;

while( <TOOL> )
{

	if( /^Nmap scan report for ([\d\.]+)/ )
	{
		$currentIP = $1;
		$mac = defined $etherForIP{$1} ?  $etherForIP{$1} : "<notfound>";
	}

	next unless defined $currentIP;

	chomp;

	my $raw = $_;

	if( $raw =~ /^(\d+)\/(\w+)\s+(\w+)\s+(.+)/ )
	{
		@curService = ($1,$2,$3,$4 );
		my @a = ('NMAP', $t, $currentIP, $mac, 'SERVICE', $1,$2,$3,$4 );
		my $port = $1;
		$serviceForIP{$currentIP}->{$port} = 1;
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^Service Info:\s+(.*)$/ )
	{
		my @a = ('NMAP', $t, $currentIP, $mac, 'OS', $1);
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^\|\_([^\:]+):(.+)/ )
	{	
		my @a = ('NMAP', $t, $currentIP, $mac, 'SERVICEINFO', $1, $2);
		print join "\t", @a;
		print "\n";
	}	

	# my @a = ('NMAP', $t, $currentIP, 'RAW', $raw );
	# print join "\t", @a;
	# print "\n";
}

foreach $ether (sort keys %etherSeen)
{
	my $ip = $ipForEther{$ether};
	my $avaname = $avahiNamesForIP{$ip} || "<noavahi>";
	my $ports = join ",", (keys %{$serviceForIP{$ip}});

	my @a = ('SUMMARY', $t, $ip, $ether, $savaname, $ports );
		print join "\t", @a;
		print "\n";


#	print "$ether\t$ip\t$avaname\t$ports\n";

}
