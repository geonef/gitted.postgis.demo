# Sysconf profile sysconf.gitted.postgresql -- Installer script  -*- shell-script -*-

. /usr/lib/sysconf.base/common.sh


################################################################################
# Install required Debian packages
#

if ! dpkg -l | grep -q " postgresql-9.3 "; then
    curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    apt-get update
fi

_packages=
_packages="$_packages postgresql-9.3"
sysconf_require_packages $_packages


for file in postgresql.conf environment; do
    local _pg_config=/etc/postgresql/9.3/main/$file
    if [ ! -h $_pg_config ]; then
        rm -f $_pg_config
        echo "Setting symlink for: $_pg_config"
        ln -s ../../../postgresql-common/$file $_pg_config
    fi
done

service postgresql restart
# postgres / postgres
echo "ALTER ROLE postgres ENCRYPTED PASSWORD 'md53175bce1d3201d16594cebf9d7eb3f9d'" | sudo -u postgres psql
