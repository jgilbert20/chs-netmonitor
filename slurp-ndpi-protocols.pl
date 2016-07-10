#!/usr/bin/perl

#define NDPI_PROTOCOL_SSDP					12
#define NDPI_PROTOCOL_BGP					13
#define NDPI_PROTOCOL_SNMP					14
#define NDPI_PROTOCOL_XDMCP					15


my $fn = "/tmp/ndpi-protocols.txt";
open FILE, "</Users/jgilbert/src/ndpi/src/include/ndpi_protocol_ids.h" or die;
open OUTFILE, ">$fn" or die;

while (<FILE>)
{
	if( /^\#define\s+([\w\_]+)\s+(\d+)/ )
	{
		print OUTFILE "$1\t$2\n";
	}
}


print "wrote: $fn\n";