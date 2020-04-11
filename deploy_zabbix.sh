groupadd zabbix
useradd -m -d /opt/zabbix -s /bin/bash -g zabbix zabbix

cat >/opt/zabbix/.bash_profile << 'EndOfMessage'
# Sources
if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi
 
# Settings
umask 077
 
# Variables (PATH, etc.)
 
# Exports
EndOfMessage
 
cat >/opt/zabbix/.bashrc << 'EndOfMessage'
# Sources
 
# Variables
PS1="[\[\e[35m\]\u\[\e[m\]][\l]@[\[\e[1;34m\]\h\[\e[m\]][\[\e[1;36m\]\W\[\e[m\]]# "
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

find /opt/zabbix -exec chmod g-rwx,o-rwx {} \;
find /opt/zabbix -exec chown -R zabbix:zabbix {} \;
