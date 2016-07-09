scp -P 27182 root@192.168.1.2:last-chs2-assoc .
scp root@192.168.1.8:last-chs8-assoc .
arp -a > last-arp
avahi-browse -a --resolve -c -p > last-avahi-browse
nmap -A -T4 192.168.1.0/24 > last-nmap
perl run-nmap.pl >> strutured-log.tsv

