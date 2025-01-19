#!/bin/sh vm vnic5 or ens33 port(ip link show) get pcap file to wireshark
sudo /sbin/tcpdump -i vnic5 'host <vmip>' -w /home/cloud-user/customized/rename_reports/tcpdump/tcpdump_`date '+%Y-%m%d-%H%M-%S'`.pcap & 
pid=$!
sleep 360
kill $pid
sudo /bin/chown cloud-user:cloud-user /home/cloud-user/customized/rename_reports/tcpdump/*.pcap
