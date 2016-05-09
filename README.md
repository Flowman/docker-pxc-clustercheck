[![](https://badge.imagelayers.io/flowman/percona-xtradb-cluster-clustercheck:latest.svg)](https://imagelayers.io/?images=flowman/percona-xtradb-cluster-clustercheck:latest 'Get your own badge on imagelayers.io')

# What is Clustercheck?

Script to make a proxy (ie HAProxy) capable of monitoring Percona XtraDB Cluster nodes properly.

## Info

This container is not meant to be run standalone as it is part of a [Rancher](http://rancher.com) Catalog item. If it suites your purpose you are more then welcome to use it.

This image is based on the popular Alpine Linux project, available in the alpine official image. Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

## Usage

## ... via `docker-compose`

Example Rancher docker-compose stack

```yaml
pxc:
  image: flowman/percona-xtradb-cluster-confd:v0.2.0
  labels:
    io.rancher.sidekicks: pxc-clustercheck,pxc-server,pxc-data
    io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
  volumes_from:
    - 'pxc-data'
pxc-clustercheck:
  image: flowman/percona-xtradb-cluster-clustercheck:v2.0
  net: "container:pxc"
pxc-server:
  image: flowman/percona-xtradb-cluster:5.6.28-1
  net: "container:pxc"
  environment:
    MYSQL_ROOT_PASSWORD: "password"
    PXC_SST_PASSWORD: "password"
  volumes_from:
    - 'pxc-data'
  entrypoint: bash -x /opt/rancher/start_pxc
pxc-data:
  image: flowman/percona-xtradb-cluster:5.6.28-1
  net: none
  environment:
    MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
  volumes:
    - /var/lib/mysql
    - /etc/mysql/conf.d
    - /docker-entrypoint-initdb.d
  command: /bin/true
  labels:
    io.rancher.container.start_once: true
```

Example rancher-compose for monitoring pxc

```yaml
pxc:
  scale: 3
  health_check:
    port: 8000
    interval: 2000
    unhealthy_threshold: 3
    strategy: none
    request_line: GET / HTTP/1.1
    healthy_threshold: 2
    response_timeout: 2000  
  metadata:
    mysqld: |
      innodb_buffer_pool_size=512M
      innodb_doublewrite=0
      innodb_flush_log_at_trx_commit=0
      innodb_file_per_table=1
      innodb_log_file_size=128M
      innodb_log_buffer_size=64M
      innodb_support_xa=0
      query_cache_size=0
      query_cache_type=0
      sync_binlog=0
      max_connections=1000
      wsrep_sst_auth=sstuser:password
```      

## Build

For example, if you need to change anything, edit the Dockerfile and than build-it.

```bash
git clone git@github.com:Flowman/percona-xtradb-cluster-clustercheck.git
cd ./percona-xtradb-cluster-clustercheck
docker build --rm -t flowman/percona-xtradb-cluster-clustercheck .
```
