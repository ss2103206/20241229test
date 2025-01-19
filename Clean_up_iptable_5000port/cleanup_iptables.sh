#less /opt/commissioning/bin/container_asregistry_iptables_cleanup.sh
#!/bin/bash
LOG_FILENAME="/var/log/mis/mis.log"
function log()
{
  echo "`date` `hostname`: $1" | tee -a  $LOG_FILENAME
}
function container_id_clean()
{
All_container_ID=$(grep -E "dualstack|podman" /etc/sysconfig/iptables | grep NETAVARK | grep -w 5000 | awk -F ':' '{print $3}' | awk -F '"' '{print $1}' | sed 's/^[[:space:]]*//')
for i in $All_container_ID; do
        sed -i "/$i/d" /etc/sysconfig/iptables
done
}
if [ -f /opt/misserver/scripts/ipv6_node_status.sh ]
then
        source /opt/misserver/scripts/ipv6_node_status.sh
else
        log "File /opt/misserver/scripts/ipv6_node_status.sh not present"
        exit 1
fi
iptable_chains=("CNI-FORWARD")
#exclude_chains=("CNI-FORWARD" "CNI-HOSTPORT-DNAT" "CNI-HOSTPORT-SETMARK" "CNI-HOSTPORT-MASQ" "CNI-HOSTPORT-DNAT")
delete_flag=false
delete_flag_ipv6=false
chain_names=$(iptables-save | awk '!/^:?(INPUT|FORWARD|OUTPUT|POSTROUTING|PREROUTING|CNI-ADMIN)/ && /^:/ {sub(/:/, ""); print $1}')
for chain_name in $chain_names; do
  log "---------------------------------------------------------------------------------------------------"
  log "$chain_name"
  log "---------------------------------------------------------------------------------------------------"
 rules=$(iptables-save | grep -P "^(-A\s.*${chain_name}.*)" | grep -P "5000$")
  #echo "${rules[@]}"
  while IFS= read -r rule; do
          log "rule :  $rule"
    if [[ ! " ${iptable_chains[*]} " =~ " ${chain_name} " ]]; then
        log "Rule to be deleted: $rule"
        sed -i "/$rule/d" /etc/sysconfig/iptables
        log "Rule deleted:$rule"
        delete_flag=true
    fi
  done <<< "$rules"
  log "calling for v4 container_id_clean"
  container_id_clean
 done
if $delete_flag; then
  systemctl restart iptables.service
  service iptables save
  log "iptables saved"
fi
if $delete_flag || ; then
   if [ $(/opt/misserver/scripts/check_rhel_version.sh) == "rhel7" ]; then
        systemctl restart docker
        log "docker restarted successfully"
   else
        podman network reload --all
        log "podman network reloaded"
   fi
fi


