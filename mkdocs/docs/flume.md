# Flume 插件


该项目已开源，更多信息请访问 [Github](https://github.com/aliyun/aliyun-odps-flume-plugin)


## 1. 安装
### Redhat/CentOS用户从YUM安装

- 配置YUM仓库，参考[配置YUM远程仓库](http://repo.aliyun.com/#yum)
- 安装odps-flume: 

```
$ yum -y install odps-flume-plugin
```

### Ubuntu/Debian用户从APT安装

- 配置APT仓库，参考[配置APT远程仓库](http://repo.aliyun.com/#apt)
- 安装odps-flume: 

```
$ apt-get -y install odps-flume-plugin
```

## 2. 使用示例

下面用一个简单的示例演示通过Flume将日志导入到Datahub的基本流程。

假设需要上传的日志文件格式路径为`/home/admin/data.txt`，内容如下(每行为一条记录，字段之间逗号分隔):

```
some,log,line1
some,log,line2
...
```
需要导入的Datahub表的建表语句如下:

```
CREATE TABLE hub_table_basic (col1 STRING, col2 STRING, col3 STRING) 
    PARTITIONED BY (pt STRING)
    INTO 1 SHARDS
    HUBLIFECYCLE 1;
```

### 创建Flume配置文件

创建配置文件`/home/admin/odps_basic.conf`，输入内容如下:

```
# odps_basic.conf
# A single-node Flume configuration for MaxCompute
# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Describe/configure the source
a1.sources.r1.type = exec
a1.sources.r1.command = cat /home/admin/data.txt

# Describe the sink
a1.sinks.k1.type = com.aliyun.odps.flume.sink.OdpsSink
a1.sinks.k1.accessID = {YOUR_ALIYUN_MaxCompute_ACCESS_ID}
a1.sinks.k1.accessKey = {YOUR_ALIYUN_MaxCompute_ACCESS_KEY}
a1.sinks.k1.odps.endPoint = http://service.odps.aliyun.com/api
a1.sinks.k1.odps.datahub.endPoint = http://dh.odps.aliyun.com
a1.sinks.k1.odps.project = testproj
a1.sinks.k1.odps.table = hub_table_basic
a1.sinks.k1.odps.partition = 20151212
a1.sinks.k1.batchSize = 100
a1.sinks.k1.serializer = DELIMITED
a1.sinks.k1.serializer.delimiter = ,
a1.sinks.k1.serializer.fieldnames = col1,col2,col3
a1.sinks.k1.serializer.charset = UTF-8
a1.sinks.k1.shard.number = 1
a1.sinks.k1.shard.maxTimeOut = 60
a1.sinks.k1.autoCreatePartition = true

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 1000

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

### 启动Flume

配置完成后，启动Flume并指定agent的名称和配置文件路径，-Dflume.root.logger=INFO,console选项可以将日志实时输出到控制台。

```
$ flume-ng agent -n a1 -c conf -f /home/admin/odps_basic.conf -Dflume.root.logger=INFO,console
```

写入成功，显示日志如下:

```
Write success. Event count: 2
```

大概5分钟后，实时导入数据会被同步到离线表。执行查询语句`select * from hub_table_basic`进行验证。

```
+------+------+-------+----+
| col1 | col2 | col3  | pt |
+------+------+-------+----+
| some | log  | line1 | 20151212 |
| some | log  | line2 | 20151212 |
+------+------+-------+----+
```

