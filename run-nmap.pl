#!/usr/bin/perl

my $t = time();

# sudo apt-get install avahi-utils
# avahi-browse -a --resolve -c -p > avahi-browse.example
# scp -P 27182 root@192.168.1.2:arplog.txt .
# scp root@192.168.1.8:arplogi.8.txt .

# Station 28:cf:da:1a:2f:de (on wlan1)
# 	inactive time:	2080 ms
# 	rx bytes:	268392570
# 	rx packets:	2272935
# 	tx bytes:	558160048
# 	tx packets:	6262974
# 	tx retries:	302031
# 	tx failed:	34
# 	signal:  	-62 [-67, -67, -67] dBm
# 	signal avg:	-62 [-68, -66, -67] dBm
# 	tx bitrate:	58.5 MBit/s MCS 6
# 	rx bitrate:	65.0 MBit/s MCS 7


# TYPE, TIMESTAMP, OBSERVER, IP, ETHER, NAME, IFACE, SSID


open TOOL, "<last-chs2-assoc" or die "$!";

while( <TOOL> )
{
	if( /Station\s+([^\s]+)\s+\(on\s+(\w+)\)/ )
	{
		$etherBase = uc $1;
		my $iface = $2;
		my $ssid = '438';
		print join "\t", ( 'CHS2', $t, 'chs2', undef, $etherBase, undef, $iface, $ssid ) ;
		$etherSeen{uc $etherBase} = 1;
		$etherToAssoc{uc $etherBase} = $ssid; 
		print "\n";
	}
}

close TOOL;

 # # INTERFACE           RADIO-NAME       MAC-ADDRESS       AP  SIGNAL... TX-RATE
 # 0 CambridgeHackspace                   0C:2A:69:00:04:4F no  -67dBm... 36.0...
 # 1 CambridgeHackspace                   10:4A:7D:86:2B:4E no  -61dBm... 240....
 # 2 CambridgeHackspace                   10:9A:DD:AC:7B:CA no  -53dBm... 115....
 # 3 CambridgeHackspace                   AC:5F:3E:E2:EA:D1 no  -61dBm... 39.0...
 # 4 CambridgeHackspace                   78:9F:70:BA:D7:44 no  -66dBm... 57.7...



open TOOL, "<last-chs4-assoc" or die "$!";

while( <TOOL> )
{
	if( /\d+\s+(\w+)\s+([^\s]+)/ )
	{
		$etherBase = $2;
		my $ssid = $1;
			$etherSeen{uc $etherBase} = 1;
		$etherToAssoc{uc $etherBase} = $ssid; 
		print join "\t", ( 'CHS4', $t, 'chs4', undef,  $etherBase, undef, undef, $ssid ) ;
		print "\n";
	}
}

close TOOL;




open TOOL, "<last-arp" or die "$!";

while( <TOOL> )
{
	# print $_;
	my @a = /^([^\s]+)\s+\(([\d\.]+)\)\s+at\s+([^\s]+)/; # .*+on\s+([^\s]+)/;
	my $sname = $1;
	my $ip = $2;
	my $ether = uc $3;

	$etherSeen{uc $ether} = 1;
	$ipSeen{$ip} = 1;

	$etherForIP{$ip} = $ether;
	$ipForEther{uc $ether} = $ip;

	$ssid = $etherToAssoc{uc $ether};

	print join "\t", ( 'ARP', $t, 'netmon', $ip, $ether, $name, $ssid) ;
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
		print join "\t", ( 'AVAHI', $t, 'netmon', $ip, $fq, $iface, $stack, $sname, $domain ) ;
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
		$ssid = $etherToAssoc{uc $mac};
	}

	next unless defined $currentIP;

	chomp;

	my $raw = $_;

	if( $raw =~ /^(\d+)\/(\w+)\s+(\w+)\s+(.+)/ )
	{
		@curService = ($1,$2,$3,$4 );
		my @a = ('NMAP', $t, 'netmon', $currentIP, $mac, undef, $ssid, 'SERVICE', $1,$2,$3,$4 );
		my $port = $1;
		$serviceForIP{$currentIP}->{$port} = 1;
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^Service Info:\s+(.*)$/ )
	{
		my @a = ('NMAP', $t, 'netmon', $currentIP, $mac, undef, $ssid, 'OS', $1);
		print join "\t", @a;
		print "\n";
	}

	if( $raw =~ /^\|\_([^\:]+):(.+)/ )
	{	
		my @a = ('NMAP', $t, 'netmon', $currentIP, $mac, undef, $ssid, 'SERVICEINFO', $1, $2);
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
	my $ssid = $etherToAssoc{$ether};
	my @a = ('SUMMARY', $t, 'netmon', $ip, $ether, $ssid, $avaname, $ports );
		print join "\t", @a;
		print "\n";


#	print "$ether\t$ip\t$avaname\t$ports\n";

}
