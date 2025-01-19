#!/usr/bin/bash
#source /usr/sbin/secpam-addins
export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin
#PATH=/usr/sbin:/sbin:/usr/bin:/bin
#d=$(date +"%Y_%m_%d")
d=$(date +"%Y_%m_%d")
#filename=$(date +"%Y_%m_%d_%H_%M")
filename=$(date +"%Y_%m_%d_%H_%M")
#lasthour=$(date -d'1 hours ago' +"%Y_%m_%d-%H")
local_report=/home/cloud-user/reports/omc
pod_report=/var/opt/nokia/oss/global/pm/shared/content3/scheduler/export/omc
TAR_LOG=omc.tar.`date +%Y-%m%d-%H%M`.log
#kubecmd=oc nagcapi, skip tls
oc login -u <username> -p <password> --server https://api.nagcpnac.nac.tcc.net:6443 --insecure-skip-tls-verify
#------------tar files and copy from pod to local host-----------#
oc exec -it $(oc get pod -nnac-pm -l app=dp-dpl-svc -oname) -nnac-pm -- bash -c "tar czvpf $pod_report/$filename.tar.gz $pod_report/*$d*.zip > $pod_report/$TAR_LOG"
oc cp nac-pm/$(oc get pod -nnac-pm -l app=dp-dpl-svc --no-headers | awk '{print $1}'):$pod_report/$filename.tar.gz $local_report/$filename.tar.gz
#------------decompression the tar files-------------------------#
tar -zxvf $local_report/$filename.tar.gz -C $local_report --strip-components 11  >> /home/cloud-user/customized/rename_reports/log/kira_test.log
oc cp nac-pm/$(oc get pod -nnac-pm -l app=dp-dpl-svc --no-headers | awk '{print $1}'):$pod_report/$TAR_LOG /home/cloud-user/customized/rename_reports/log/tar/$TAR_LOG
#------------remove DN string and column-------------------------#
#cd /home/cloud-user/reports/ ; for i in `ls *combine*.zip | grep -oE "^[^\.]+"` ; do echo $i ; zcat $i.zip  | awk 'BEGIN{FS=OFS=";"} {gsub(/^;/,""); if (NR==1) sub(/;DN/,""); print}' > /home/cloud-user/reports/iconv_reports/$i.csv; done ;
#------------Rename and trasfer to lynx server-------------------#
/home/cloud-user/customized/rename_reports/script/5G_rename_zip.pl agc_omc_daily.csv
/home/cloud-user/customized/rename_reports/script/5G_rename_zip.pl agc_omc_weekly.csv
/home/cloud-user/customized/rename_reports/script/5G_rename_zip.pl agc_omc_combine.csv
#/home/cloud-user/customized/rename_reports/script/5G_rename_zip.pl agc_lynxserver_test.csv
#------------Clean temp tar/zip/csv files-------------------------#
oc exec -it $(oc get pod -nnac-pm -l app=dp-dpl-svc -oname) -nnac-pm -- find /var/opt/nokia/oss/global/pm/shared/content3/scheduler/export/  -name "*.tar.gz" -exec rm {} \;
oc exec -it  $(oc get pod -nnac-pm -l app=dp-dpl-svc -oname) -nnac-pm -- find /var/opt/nokia/oss/global/pm/shared/content3/scheduler/export/omc  -name "omc*.log" -exec rm {} \;
oc exec -it $(oc get pod -nnac-pm -l app=dp-dpl-svc -oname) -nnac-pm -- find /var/opt/nokia/oss/global/pm/shared/content3/scheduler/export/  -name "*.zip" -mtime +5 -exec rm {} \;
oc exec -it $(oc get pod -nnac-pm -l app=dp-dpl-svc -oname) -nnac-pm -- find /var/opt/nokia/oss/global/pm/shared/content3/scheduler/exportCustom/  -name "*.zip" -mtime +5 -exec rm {} \;
ls -lrt $local_report/*.*
find $local_report/ -name "*.tar.gz" -exec rm {} \;
find $local_report/ -name "*.zip" -exec rm {} \;
find $local_report/ -name "*.csv" -mtime +1 -exec rm {} \;
