ZABBIX=server
# ZABBIX=agent
# ZABBIX=proxy

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

useradd -m -d /opt/zabbix/$ZABBIX -s /bin/bash -g zabbix zabbix-$ZABBIX

cat >/opt/zabbix/$ZABBIX/.bash_profile << 'EndOfMessage'
# Sources
if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi
 
# Settings
umask 077
 
# Variables (PATH, etc.)
 
# Exports
EndOfMessage
 
cat >/opt/zabbix/$ZABBIX_/.bashrc << 'EndOfMessage'
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

######################################################################

[ "$ZABBIX" == "agent" ] && ./configure --prefix=/opt/zabbix/agent --enable-agent \
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
 
 # or
 
[ "$ZABBIX" == "server" ] || [ "$ZABBIX" == "proxy" ] && ./configure --prefix=/opt/zabbix/server --enable-$ZABBIX \
--with-postgresql \
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

######################################################################

if [ "$ZABBIX" == "agent" ] ; then
  ZABBIX_TARGET="${ZABBIX}d"
elif [ "$ZABBIX" == "server" ] || [ "$ZABBIX" == "proxy" ] ; then
  ZABBIX_TARGET=$ZABBIX
fi

mv /opt/zabbix/$ZABBIX/etc/zabbix_$ZABBIX_TARGET.conf /opt/zabbix/$ZABBIX/etc/zabbix_$ZABBIX_TARGET.conf_BACKUP
cat /opt/zabbix/$ZABBIX/etc/zabbix_$ZABBIX_TARGET.conf_BACKUP | grep "Default:" -A 1 | grep -v "Default:" | grep -v "\-\-" > /opt/zabbix/$ZABBIX/etc/zabbix_$ZABBIX_TARGET.conf

mkdir -p /opt/zabbix/$ZABBIX/log
mkdir -p /opt/zabbix/$ZABBIX/tmp

chmod 750 /opt/zabbix

find /opt/zabbix -mindepth 1 -exec chmod g-rwx,o-rwx {} \;
find /opt/zabbix -exec chown -R zabbix:zabbix {} \;

for ITEM in agent server proxy ; do 
  find /opt/zabbix/$ITEM -exec chmod g-rwx,o-rwx {} \;
  find /opt/zabbix/$ITEM -exec chown -R zabbix-$ITEM {} \;
done
