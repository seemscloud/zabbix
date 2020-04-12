```bash
ZABBIX=agentd

mv zabbix_$ZABBIX.conf zabbix_$ZABBIX.conf_BACKUP

cat zabbix_$ZABBIX.conf_BACKUP | grep "Default:" -A 1 | grep -v "Default:" | grep -v "\-\-" \
  > zabbix_$ZABBIX.conf
```
