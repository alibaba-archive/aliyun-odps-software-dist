# Fluentd 插件

## 安装

以下示例代码均为 root 用户。

### 安装 ruby

#### CentOS 7+

```
yum groupinstall 'Development Tools'
yum install ruby ruby-devel
```

#### CentOS 5.x/6.x

CentOS 5/6 的 yum 源中自带的 ruby 版本低于 Fluent 的最低要求，需要手动安装高版本 ruby

```
yum install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel wget tar

cd ~/
wget https://ruby.taobao.org/mirrors/ruby/ruby-2.2.3.tar.gz
tar xvf ruby-2.2.3.tar.gz
cd ruby-2.2.3
./configure
make
make install
```

#### Ubuntu 14.04+

```
apt-get install ruby build-essential
```

#### Ubuntu 12.04

```
apt-get install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 build-essential
```

### 配置 /etc/gemrc（可选）

因为 rubygems 的官方站点在国内访问困难，可以使用淘宝提供的镜像来加速后续的安装过程。在 `/etc/gemrc` 文件中增加如下内容（如果没有这个文件需创建）

```
---
:backtrace: false
:bulk_threshold: 1000
:sources:
- https://ruby.taobao.org/
:update_sources: true
:verbose: true
install: --no-rdoc --no-ri
update: --no-rdoc --no-ri
gem: "--user-install"
```

### 安装插件

以下示例代码可以切换为需要执行 fluentd 的账号

```
gem install fluent-plugin-aliyun-odps
```

插件所需的依赖，包括 fluentd、protobuf 等会自动安装

运行如下命令将 gem 的 bin 路径添加到 PATH 中（建议添加到 `~/.bashrc` 中以重新登录后依然有效）

```
export PATH="$PATH:$(ruby -rubygems -e 'puts Gem.user_dir')/bin"
```

## 运行 & 验证

假设需要导入 MaxCompute 的日志文件位于 `/var/log/nginx/nginx.log`，其格式为

```
42.233.239.113 - - [08/Nov/2015:07:50:59 +0800] "GET http://odps.aliyun.com/ HTTP/1.1" 200 179 "-" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
```

假设需要导入的 MaxCompute 表为 demo_access_log，其建表语句为

```
create table demo_access_log(
       remote STRING,
       method STRING,
       path STRING,
       code STRING,
       size STRING,
       agent STRING)
partitioned by (ctime STRING);
```

### 编辑配置文件 fluent_nginx_odps.conf

```
<source>
   type tail
   path /opt/log/in/in.log
   pos_file /opt/log/in/in.log.pos
   refresh_interval 5s
   tag in.log
   format /^(?<remote>[^ ]*) - - \[(?<datetime>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*) "-" "(?<agent>[^\"]*)"$/
   time_format %Y%b%d %H:%M:%S %z
</source>

<match in.**>
  type aliyun_odps
  aliyun_access_id ************
  aliyun_access_key *********
  aliyun_odps_endpoint http://service.odps.aliyun.com/api
  aliyun_odps_hub_endpoint http://dh.odps.aliyun.com
  buffer_chunk_limit 2m
  buffer_queue_limit 128
  flush_interval 5s
  project your_projectName
  <table in.log>
    table your_tableName
    fields remote,method,path,code,size,agent
    partition ctime=${datetime.strftime('%Y%m%d')}
    time_format %d/%b/%Y:%H:%M:%S %z
    shard_number 5
  </table>
</match>
```

### 启动 fluent

```
fluentd -c fluent_nginx_odps.conf
```

大概 5 分钟后，实时导入数据会被同步到离线表，介时可以使用诸如 `select count(*) from demo_access_log` 这样的 sql 语句进行验证。

## Github

该项目已开源，更多信息请访问 [Github](https://github.com/aliyun/aliyun-odps-fluentd-plugin).

## Doc

[https://help.aliyun.com/document_detail/odps/dhs/plugin/fluentd.html](https://help.aliyun.com/document_detail/odps/dhs/plugin/fluentd.html)
