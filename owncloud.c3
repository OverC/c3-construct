# Transform a basic OverC installation which only has cube-essential and
# cube-dom0 into a home server with Debian (to provide ddclient and
# sshd services for example) and OwnCloud.
#
# References:
#   https://github.com/owncloud-docker/server#launch-with-plain-docker
#

# Add the debian container
c3-ctl add -n debian docker://debian:stable

# Setup debian as the network prime
c3-ctl netprime debian
c3-cfg -n debian set autostart:dom0
c3-cfg gen debian

# Add OwnCloud server container along with support containers
c3-ctl add -n owncloud docker://owncloud/server:10.0
c3-ctl add -n owncloud-db docker://webhippie/mariadb:latest
c3-ctl add -n owncloud-redis docker://webhippie/redis:latest

# Add persistent data directories. In a real deployment
# these might be created in a separate data partition or
# even on a dedicated drive.
mkdir /var/lib/cube/pdata/
mkdir /var/lib/cube/pdata/owncloud_mysql
mkdir /var/lib/cube/pdata/owncloud_backup
mkdir /var/lib/cube/pdata/owncloud_redis
mkdir /var/lib/cube/pdata/owncloud_files

# Setup owncloud-redis env, mounts and autostart:
c3-cfg set -n owncloud-redis  cube.env:REDIS_DATABASES=1
c3-cfg -n owncloud-redis mount bind:/var/lib/cube/pdata/owncloud_redis:/var/lib/redis
c3-cfg -n owncloud-redis set cube.network.ip:192.168.42.11/24
c3-cfg -n owncloud-redis set cube.network.type:static
c3-cfg -n owncloud-redis set autostart:dom0
c3-cfg gen owncloud-redis:oci

# Setup owncloud-db env, mounts and autostart:
c3-cfg set -n owncloud-db  cube.env:MARIADB_ROOT_PASSWORD=owncloud
c3-cfg set -n owncloud-db  cube.env:MARIADB_USERNAME=owncloud
c3-cfg set -n owncloud-db  cube.env:MARIADB_PASSWORD=owncloud
c3-cfg set -n owncloud-db  cube.env:MARIADB_DATABASE=owncloud
c3-cfg -n owncloud-db mount bind:/var/lib/cube/pdata/owncloud_mysql:/var/lib/mysql
c3-cfg -n owncloud-db mount bind:/var/lib/cube/pdata/owncloud_backup:/var/lib/backup
c3-cfg -n owncloud-db set cube.network.ip:192.168.42.10/24
c3-cfg -n owncloud-db set cube.network.type:static
c3-cfg -n owncloud-db set autostart:dom0
c3-cfg gen owncloud-db:oci

# Setup owncloud env and mounts:
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DOMAIN=localhost
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DB_TYPE=mysql
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DB_NAME=owncloud
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DB_USERNAME=owncloud
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DB_PASSWORD=owncloud
c3-cfg set -n owncloud  cube.env:OWNCLOUD_ADMIN_USERNAME=admin
c3-cfg set -n owncloud  cube.env:OWNCLOUD_ADMIN_PASSWORD=admin
c3-cfg set -n owncloud  cube.env:OWNCLOUD_REDIS_ENABLED=true
c3-cfg set -n owncloud  cube.env:OWNCLOUD_DB_HOST=192.168.42.10
c3-cfg set -n owncloud  cube.env:OWNCLOUD_REDIS_HOST=192.168.42.11
c3-cfg -n owncloud mount bind:/var/lib/cube/pdata/owncloud_files:/mnt/data
c3-cfg -n owncloud set autostart:dom0 # shouldn't be needed (set when made netprime)
c3-cfg gen owncloud:oci

# Setup links for http and https between the netprime and owncloud
c3-cfg link debian:80 owncloud:80
c3-cfg link debian:443 owncloud:443

c3-cfg gen debian:oci
c3-cfg gen owncloud:oci

c3-ctl start owncloud
c3-ctl start owncloud-redis
c3-ctl start owncloud-db
c3-ctl stack debian

