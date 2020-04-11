useradd -m -d /opt/zabbix/agent -s /bin/bash -g zabbix zabbix-agent

cat >/opt/zabbix/agent/.bash_profile << 'EndOfMessage'
# Sources
if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi
 
# Settings
umask 077
 
# Variables (PATH, etc.)
 
# Exports
EndOfMessage
 
cat >/opt/zabbix/agent/.bashrc << 'EndOfMessage'
# Sources
 
# Variables
PS1="[\[\e[36m\]\u\[\e[m\]][\l]@[\[\e[1;34m\]\h\[\e[m\]][\[\e[1;36m\]\W\[\e[m\]]# "
HISTTIMEFORMAT="%d/%m/%Y %T "
 
# Path Variables
 
# Aliases
alias ls='ls --color=auto --hide=".*"'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rmdir='rmdir -v'
 
# Exports
export PS1
export HISTTIMEFORMAT
 
# Path Exports
EndOfMessage
 
./configure --prefix=/opt/zabbix/agent --enable-agent \
--with-libxml2 \
--with-unixodbc \
--with-net-snmp \
--with-ssh2 \
--with-openipmi \
--with-zlib \
--with-libpthread \
--with-libevent \
--with-openssl \
--with-ldap \
--with-libcurl \
--with-libpcre \
--with-iconv
 
make
make install
 
mv /opt/zabbix/agent/etc/zabbix_agentd.conf /opt/zabbix/agent/etc/zabbix_agentd.conf_BACKUP
cat /opt/zabbix/agent/etc/zabbix_agentd.conf_BACKUP | grep "Default:" -A 1 | grep -v "Default:" | grep -v "\-\-" > /opt/zabbix/agent/etc/zabbix_agentd.conf
 
mkdir -p /opt/zabbix/agent/log
mkdir -p /opt/zabbix/agent/tmp

find /opt/zabbix/agent -exec chmod g-rwx,o-rwx {} \;
find /opt/zabbix/agent -exec chown -R zabbix-agent:zabbix {} \;
