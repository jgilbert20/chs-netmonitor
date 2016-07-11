#!/bin/sh


** CREATE TABLE `flowsv4` (
**   `idx` int(11) NOT NULL AUTO_INCREMENT,
**   `VLAN_ID` smallint(5) unsigned DEFAULT NULL,
**   `L7_PROTO` smallint(5) unsigned DEFAULT NULL,
**   `IP_SRC_ADDR` int(10) unsigned DEFAULT NULL,
**   `L4_SRC_PORT` smallint(5) unsigned DEFAULT NULL,
**   `IP_DST_ADDR` int(10) unsigned DEFAULT NULL,
**   `L4_DST_PORT` smallint(5) unsigned DEFAULT NULL,
**   `PROTOCOL` tinyint(3) unsigned DEFAULT NULL,
**   `IN_BYTES` int(10) DEFAULT '0',
**   `OUT_BYTES` int(10) DEFAULT '0',
**   `PACKETS` int(10) unsigned DEFAULT NULL,
**   `FIRST_SWITCHED` int(10) unsigned DEFAULT NULL,
**   `LAST_SWITCHED` int(10) unsigned DEFAULT NULL,
**   `INFO` varchar(255) DEFAULT NULL,
**   `JSON` blob,
**   `NTOPNG_INSTANCE_NAME` varchar(256) DEFAULT NULL,
**   `INTERFACE_ID` smallint(5) DEFAULT NULL,
**   KEY `idx` (`idx`,`IP_SRC_ADDR`,`IP_DST_ADDR`,`FIRST_SWITCHED`,`LAST_SWITCHED`,`INFO`(200)),
**   KEY `ix_flowsv4_4_ntopng_instance_name` (`NTOPNG_INSTANCE_NAME`(255)),
**   KEY `ix_flowsv4_ntopng_first_src_dst` (`FIRST_SWITCHED`,`IP_SRC_ADDR`,`IP_DST_ADDR`)
** ) ENGINE=MyISAM AUTO_INCREMENT=567550 DEFAULT CHARSET=utf8
** /*!50100 PARTITION BY HASH (`FIRST_SWITCHED`)
** PARTITIONS 32 */;
** /*!40101 SET character_set_client = @saved_cs_client */;




rsync pi@108.7.147.14:src/chs-netmonitor/strutured-log.tsv .
grep SUMMARY strutured-log.tsv > summary.tsv


sudo rm -rf /tmp/ntopng-export.txt
mysql -u root ntopng
select IDX, IP_SRC_ADDR,L4_SRC_PORT,IP_DST_ADDR,L4_DST_PORT,PROTOCOL,L7_PROTO, IN_BYTES,OUT_BYTES,PACKETS,FIRST_SWITCHED,LAST_SWITCHED,info,INTERFACE_ID from flowsv4 order by idx into outfile '/tmp/ntopng-export.txt';


rsync -z pi@108.7.147.14:/tmp/ntopng-export.txt . 

# mysql -u root test --local-infile=1

drop table summary;
create table summary (ltype char, datesecs int, observer varchar(30), ip char(30), mac varchar(50), ssid varchar(20), avahi varchar(200), ports varchar(100));
LOAD DATA LOCAL INFILE '/Users/jgilbert/src/chs-netmonitor/summary.tsv' INTO table summary;

select distinct ip,mac from summary order by ip;

drop table flows; 
CREATE TABLE `flows` (
  `idx` int(11) NOT NULL,
  `src` int(10) unsigned DEFAULT NULL,
  `src_port` smallint(5) unsigned DEFAULT NULL,
  `dest` int(10) unsigned DEFAULT NULL,
  `dest_port` smallint(5) unsigned DEFAULT NULL,
  `protocol` tinyint(3) unsigned DEFAULT NULL,
  `L7_PROTO` smallint(5) unsigned DEFAULT NULL,
  `bin` int(10) DEFAULT '0',
  `bout` int(10) DEFAULT '0',
  `pkts` int(10) unsigned DEFAULT NULL,
  `first` int(10) unsigned DEFAULT NULL,
  `last` int(10) unsigned DEFAULT NULL,
  `INFO` varchar(255) DEFAULT NULL,
  `INTERFACE_ID` smallint(5) DEFAULT NULL );

LOAD DATA LOCAL INFILE '/Users/jgilbert/src/chs-netmonitor/ntopng-export.txt' INTO table flows;

# perl slurp-ndpi-protocols.pl

drop table l7_protocols;
create table l7_protocols ( `l7_name` varchar(255) ,  `l7_number` int(10) );
LOAD DATA LOCAL INFILE '/Users/jgilbert/src/chs-netmonitor/ndpi-protocols.txt' INTO table l7_protocols;



alter table flows add column srcip varchar(20);
alter table flows add column destip varchar(20);
alter table flows add column l7p varchar(40);
update flows set destip = INET_NTOA(dest);
update flows set srcip = INET_NTOA(src);






drop table hostnames; 
create table hostnames as select distinct info from flows;
alter table hostnames add column category varchar(20);
create index hostname_idx on hostnames (info);


update hostnames set category='porn' where info like '%porn%';
update hostnames set category='porn' where info like '%tube8%';
update hostnames set category='porn' where info like '%redtube%';
update hostnames set category='porn' where info like '%gaytube%';
update hostnames set category='porn' where info like '%xtube%';
update hostnames set category='porn' where info like '%tubemogul.com';
update hostnames set category='spotify' where info like '%spotify%';
update hostnames set category='video' where info like '%youtube%';
update hostnames set category='video' where info like '%googlevideo%';
update hostnames set category='social' where info like '%facebook%';
update hostnames set category='social' where info like '%instagram%';
update hostnames set category='social' where info like '%plus.google.com';
update hostnames set category='social' where info like '%fbcdn%';
update hostnames set category='social' where info like '%snapchat%';
update hostnames set category='video' where info like '%adap.tv';
update hostnames set category='video' where info like '%hbo%';
update hostnames set category='video' where info like '%ipvod%';
update hostnames set category='work' where info like '%dropbox%';
update hostnames set category='work' where info like '%drive.google.com';
update hostnames set category='work' where info like '%docs.google.com';
update hostnames set category='video' where info like '%vimeocdn%';
update hostnames set category='software' where info like '%download.cdn.mozilla.net%';
update hostnames set category='software' where info like '%apple.com';
update hostnames set category='ad' where info like '%doubleclick.net';
update hostnames set category='ad' where info like '%adsafeprotected.com';
update hostnames set category='ad' where info like '%spotxchange.com';
update hostnames set category='ad' where info like '%advertising.com';
update hostnames set category='ad' where info like '%adsrvr.org';
update hostnames set category='ad' where info like '%static.innovid.com';
update hostnames set category='ad' where info like '%taboola.com';
update hostnames set category='ad' where info like '%adroll.com';
update hostnames set category='ad' where info like '%moatads.com';
update hostnames set category='ad' where info like '%rubiconproject.com';
update hostnames set category='ad' where info like '%googlesyndication.com';
update hostnames set category='software' where info like '%samsungdm.com';
update hostnames set category='software' where info like '%samsapps%';
update hostnames set category='software' where info like '%microsoft.com';
update hostnames set category='sports' where info like '%nfl%' and category is null;
update hostnames set category='porn' where info like '%porn%' and category is null;
update hostnames set category='sports' where info like '%sport%' and category is null;
update hostnames set category='video' where info like '%video%' and category is null;
update hostnames set category='news' where info like '%cbsnews%' and category is null;
update hostnames set category='news' where info like '%.nyt.com' and category is null;
update hostnames set category='news' where info like '%abcnews%' and category is null;
update hostnames set category='news' where info like '%boston.com%' and category is null;
update hostnames set category='news' where info like '%nymag.com%' and category is null;
update hostnames set category='news' where info like '%bostonglobe.com%' and category is null;
update hostnames set category='news' where info like '%fox.com' and category is null;
update hostnames set category='video' where info like '%akamaihd.net' and category is null;
update hostnames set category='search' where info like 'www.google.com' and category is null;
update hostnames set category='cdn' where info like '%cdn%' and category is null;
update hostnames set category='cdn' where info like '%cloudfront%' and category is null;
update hostnames set category='software' where info like '%play.google.com' and category is null;
update hostnames set category='shopping' where info like '%ebay%' and category is null;
update hostnames set category='shopping' where info like '%craigslist.org%' and category is null;

update hostnames set category='mail' where info like '%mail.google.com' and category is null;
update hostnames set category='fileshare' where info like '%mediafire.com' and category is null;
update hostnames set category='blogs' where info like '%tumblr.com' and category is null;
update hostnames set category='blogs' where info like '%kinja-img.com' and category is null;
update hostnames set category='blogs' where info like '%reddit%' and category is null;
update hostnames set category='blogs' where info like '%imgur.com' and category is null;
update hostnames set category='blogs' where info like '%blogspot.com' and category is null;
update hostnames set category='video' where info like '%comcast.net' and category is null;
update hostnames set category='video' where info like '%ytimg%' and category is null;
update hostnames set category='ad' where info like '%flashtalking.com' and category is null;


update hostnames set category='ads' where info like '%ads%' and category is null;
update hostnames set category='googleother' where info like '%google.com%' and category is null;
update hostnames set category='googleother' where info like '%ggpht.com%' and category is null;
update hostnames set category='googleother' where info like '%2mdn.net%' and category is null;






select distinct INET_NTOA(src) src from flows where inet_ntoa(src) LIKE '192.168.1%' order by src;

select * from flows where INET_NTOA(src) = '192.168.1.171' or INET_NTOA(dest) = '192.168.1.171' limit 5;


select *, INET_NTOA(src), INET_NTOA(dest) from flows where INET_NTOA(src) = '192.168.1.171' and INET_NTOA(dest) not like '192.168.1.%';


select *, INET_NTOA(src), INET_NTOA(dest) from flows where INET_NTOA(src) = '192.168.1.171' and INET_NTOA(dest) not like '192.168.1.%';


select INET_NTOA(src) srcip, info, sum(bin), sum(bout) from flows where INET_NTOA(src) = '192.168.1.171' and INET_NTOA(dest) not like '192.168.1.%' group by srcip, info;


select info, sum(bin) sbin, sum(bout) sbout from flows group by info order by sbin desc limit 100;





select flows.info, sum(bin) sbin, sum(bout) sbout from flows,hostnames where flows.info = hostnames.info group by info order by sbout desc limit 100;
select flows.info, sum(bin) sbin, sum(bout) sbout from flows,hostnames where flows.info = hostnames.info and category is null group by info order by sbout desc limit 100;
select category, sum(bin) sbin, sum(bout) sbout from flows,hostnames where flows.info = hostnames.info  group by category order by sbout desc limit 100;

select INET_NTOA(src) src_ip,category, sum(bin) sbin, sum(bout) sbout from flows,hostnames where INET_NTOA(src) like '192.168.1.%' and flows.info = hostnames.info group by src_ip,category order by src_ip,category,sbout desc;


-- Check l7_protocols outside

select l7_name,l7_proto, sum(bin) sbin, sum(bout) sbout from flows,l7_protocols where INET_NTOA(src) like '192.168.1.%' and INET_NTOA(dest) not like '192.168.1.%' and l7_proto=l7_number by l7_name,l7_proto order by sbout;

-- Create analysis table:

create table newflows as select INET_NTOA(src) src, INET_NTOA(dest) dest, info, INET_NTOA(src) like '192.168.1.%' and INET_NTOA(dest) not like '192.168.1.%' outbound, INET_NTOA(src) not like '192.168.1.%' and INET_NTOA(dest) like '192.168.1.%' inbound, src_port,dest_port, protocol ip_prot, l7_name l7_prot, bin/1024 kin, bout/1024 kout, from_unixtime(first) first, from_unixtime(last) last from flows, l7_protocols where l7_proto=l7_number;
delete from newflows where src like '10.0.1.%' or dest like '10.0.1.%';

-- Traffic by protocol

select l7_prot, sum(kin), sum(kout) from newflows group by l7_prot;




