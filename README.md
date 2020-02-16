auto install cloudera and hortonworks cluster

# 使用说明

## install ansible

在使用本程序之前，确保ansible已经安装，请使用2.6.3以上版本

### 在线安装

```bash
yum install ansible
```
### 离线安装

首先使用yum下载ansible

```bash
yum install ansible --downloadonly --downloaddir=/root/ansible
```

将下载的文件拷贝至集群机器，进入文件夹，使用以下命令安装

```bash
yum localinstall ansible
```
### generate ssh key

在ansible所在机器产生公私钥对

```bash
ssh-keygen
```

### set ssh no passwd

确保本机到集群所有机器设置免密，免密用户可在inventroy文件中all:vars下修改ansible_user
```bash
ssh-copy-id root@server-ip-address
```

## paramater setting

### inventroy file

database

one host for non-ha, three hosts for maraidb galera ha

### universal parameter

定义group_vars/all.yml中的参数

ntpserver为集群中的ntp服务器，remotentp设置上层的ntp服务器

webserver为集群中某台提供http服务的服务器，主要用来做源

local_os_repo设置是否自建操作系统源

如果此参数设为true，需要修改相应操作系统文件的参数，选择ansible所在服务器的ios镜像位置ospath和远端的挂载点mountpoint

database_type为mariadb,mysql或者native, mariadb和mysql需要下载开源包，native使用操作系统自带的数据库

local_db_repo设置是否自建数据库源
如果此参数设为true，需要修改相应文件的参数，选择ansible所在服务器的数据库yum包文件夹地址，mariadb文件夹内容如下
如果不需要配置galera ha，则不需要percona-xtrabackup相关包

```bash
$ tree
.
├── repodata
│   ├── 39e648d9d734691fb3621bca3ab1194b948ff8234e4789b3425b90c33b123471-filelists.xml.gz
│   ├── 6b5fe80c46e4cb67e532bdf325ca6a8fd36ef6b644fd6243b1b88a3df5582138-other.sqlite.bz2
│   ├── 7e51cd47ce73fab825ffadb808d8c9fe74b224406fd69ba40db1f7a686301baa-primary.sqlite.bz2
│   ├── e0c841e86a78f9172fea7bdcc7bcca1cfc025b0a2004659cc7b26ca03bd24ef7-other.xml.gz
│   ├── ea5efe6abeb38217b6a5b721fd8e52693052e06ab540b2681d7996cc9235b915-filelists.sqlite.bz2
│   ├── f64ef8cd705a967ebed091aebe472174cdf2da1c23cb9f4ff0376a631031e2f3-primary.xml.gz
│   └── repomd.xml
└── rpms
    ├── MariaDB-10.0.34-centos73-x86_64-cassandra-engine.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-client.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-common.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-compat.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-connect-engine.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-devel.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-oqgraph-engine.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-server.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-shared.rpm
    ├── MariaDB-10.0.34-centos73-x86_64-test.rpm
    ├── MariaDB-Galera-10.0.34-centos73-x86_64-server.rpm
    ├── MariaDB-Galera-10.0.34-centos73-x86_64-test.rpm
    ├── galera-25.3.22-1.rhel7.el7.centos.x86_64.rpm
    ├── jemalloc-3.6.0-1.el7.x86_64.rpm
    ├── jemalloc-devel-3.6.0-1.el7.x86_64.rpm
    ├── libev-4.15-6.el7.x86_64.rpm
    ├── percona-xtrabackup-2.3.10-1.el7.x86_64.rpm
    ├── percona-xtrabackup-2.3.8-1.el7.x86_64.rpm
    ├── percona-xtrabackup-2.3.9-1.el7.x86_64.rpm
    ├── percona-xtrabackup-24-2.4.10-1.el7.x86_64.rpm
    ├── percona-xtrabackup-24-2.4.7-1.el7.x86_64.rpm
    ├── percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm
    └── qpress-11-1.el7.x86_64.rpm
```

haproxy and keepalived

配置haproxy和keepalived，配置主机在hosts里设置

### 数据库参数设置

定义group_vars/database.yml中的参数

包括root密码，是否启用ha，以及一些mysql的参数配置

### cloudera相关参数设置

只支持parcel安装方式

定义group_vars/cdh.yml中的参数

设置local_cdh_repo参数，如果此参数设为true，需要修改相应文件的参数，选择ansible所在服务器的cm和cdh数据地址，cm为tar.gz压缩包，cdh parcel文件夹结构如下

```bash
├── cdh
│   └── 5.14.2
│       ├── CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel
│       ├── CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel.sha1
│       └── manifest.json
└── kafka
    └── 3.1.0
        ├── KAFKA-3.1.0-1.3.1.0.p0.35-el7.parcel
        ├── KAFKA-3.1.0-1.3.1.0.p0.35-el7.parcel.sha1
        └── manifest.json
```

设置cm主机，用户名，密码，需要添加的parcels包地址

如果使用自定义Java，需要指定本地java路径，

设置需要建立的数据库名以及相应用户和密码

如果需要配置csd文件，如spark2，cdsw，则需要将相应的文件放入roles/cm-server/files/csd/下

## 执行脚本

安装脚本位于scripts文件夹下

### 全新安装

运行init-deploy.sh建立集群，然后打开cm界面，图形化建立集群

按照cloudera.yml，流程说明如下

1. 确认系统版本为redhat或者centos
2. 如果操作系统，数据库，cdh相关服务需要本地源，则搭建本地源
3. 设置所有节点的yum源
4. 配置操作系统，包括设置主机名，添加/etc/hosts解析文件，关闭防火墙，关闭selinux，安装一些常用系统包（安装列表可以在roles/oscommon/vars/redhat7.yml下设置），配置NTP服务，配置linux最大文件句柄数，设置交换内存，关闭透明大页
5. 安装数据库
6. 配置数据库高可用（按照配置要求）
7. 安装Java和mysql jdbc driver
8. 安装cloudera manager agent
9. 安装cloudera manager server
10. 安装haproxy和keepalived（按照配置要求）

### 新增节点或者刷新配置

在inventory中添加要新增的节点

运行refresh-setting.sh 刷新主机基本配置，包括操作系统配置，安装源配置以及安装CM相关服务

打开cm界面，图形化添加节点

# roles说明

cm-agents 安装cloudera-scm-agent

cm-server 安装cloudera-scm-server

java 安装jdk

localrepo 在无因特网时建立离线的操作系统源 或者 建立离线软件安装源

mariadb 安装maraidb实例

mariadb-galera 配置maraidb高可用

mitkdc 安装mit kerberos

oscommon 一些操作系统的基本设置，例如/etc/hosts 主机名 以及hadoop的优化配置

repo 为所有机器配置repo，如果需要配置本地源，先运行localrepo角色

db-replication 数据库主主同步 

# totally offline install with database ha

need following files to instal cdh

```bash
.
├── ansible
├── ansible-cdh
├── CentOS-7-x86_64-DVD-1804.iso
├── cm5.14.3-centos7.tar.gz
├── JDK
├── mariadb-centos7-10.0
├── parcels
```

# 使用说明