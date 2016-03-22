
# ODPS ETL 工具


## 下载 & 安装

使用过程中遇到问题请联系：[onesuper](mailto:onesuperclark@gmail.com)

### TAR 包下载

* [tattoo-1.0.zip](/download/tattoo.zip)
* [tattoo-1.0.tar.gz](/download/tattoo.tar.gz)

### 从 YUM 安装

TBA

### 从 APT 安装

TBA

## 简介

tattoo 是一个命令行版的 ETL 工具。每一条 tattoo 命令可以从一个特定的数据源中提取数据、并加载到 ODPS （分区）表。


例如下面这条命令可以把 CSV 格式的 `file1` 和 `file2` 中的内容上传到 `test_table1`：

```
tattoo -t test_table1 read-csv file1 file2
```


### 基础选项


| Property Name    | Default       | Description                       |
| :---------------- |:-------------| :-------------------------------- |
| `--config`       | ``~/.odpscmd/odps_config.ini``   | ODPS 的配置文件路径   |
| `--table`, `-t`  | `null`  | ODPS 表 `[PROJ.TABLE/PARTITION]` |
| `--workers`, `-w`| `1`     | 上传所使用的 worker 数量 |
| `--dry-run`      | `false` | 将提取到的 record 打印到 STDOUT（不上传） |
| `--overwrite`    | `false` | 是否覆盖目标表（分区）中的内容 |
| `--log-level`    | `info`  | 日志的 level |
| `--quiet`        | `false` | 不打印进度信息 |
| `--charset`      | `UTF-8` | 编码 String 的字符集  |
| `--column`, `-c` | `[]`    | 指定某列进行上传     |
| `--charset`      | `UTF-8` | ODPS 字符串编码 | 
| `--time-format`  | `yyyy-MM-dd HH:mm:ss`    | 用来解析日期字符串的 SimpleDateFormat | 
| `--time-zone`    | `UTC`    | 用来解析日期的时区 | 
| `--head`         | `-1`    | 上传前 N 条数据，类似 UNIX 的 head 命令 | 





## 支持的数据源


* [文本流](#text): 从文本流中提取数据
* [CSV 文件](#csv): 从 CSV 文件中提取 record 
* [JDBC 数据源](#jdbc): 从 JDBC 结果集中提取数据 
* [ODPS 表](#odps): 从某个 ODPS 表（或分区）中提取 record 
* [Protobuf 文件](#protobuf): 从 Protobuf 格式的文件中提取 record 


### <a name="text"></a>文本流

`read-text` 命令可以帮助用户从一个文件或多个文件中抽取一行或多行数据。

使用范例：

```
tattoo -t table read-text file
```

`file` 替换成 `stdin` ，可以从标准输入流中提取 record。


| Property Name    | Default       | Description                       |
| :--------------- |:--------------| :-------------------------------- |
| `--charset`      | `UTF-8`       | 输入流的编码 |
| `--num-lines`    | `1`           | 每次提取多少行组装成一个 record |
| `--regex`        | `null`        | 用来提取多行数据的正则表达式。 e.g. `(.*\n){4}` |


### <a name="csv"></a> CSV 文件

从 CSV 文件中提取 record。

使用范例：

```
tattoo -t table1 read-text file1
```

`file` 替换成 `stdin` ，可以从标准输入流中提取 record。

| Property Name     | Default       | Description                                    |
| :----------------- |:-------------| :--------------------------------------------- |
| `--charset`       | `UTF-8`       | 输入流的编码                      |
| `--separator`     | `,`           | 分隔字符                         |
| `--quote-char`    | `"`           | 引用字符                         |
| `--ignore-first`  | `false`       | 是否跳过第一行                    |
| `--trim`          | `false`       | 是否删除每个字段前后的 whitespace   |
| `--column`, `-c`   | `[]`         | 为解析到的字段命名，默认为 c0,c1,c2...  |




### 使用范例

```
tattoo -t csv_test read-csv csv_file1 -c name -c intval -c floatval -c gender
```


CSV 文件内容：


```
Jack,12,1.4,male
Rose,123,4.4,female
"Jr, Peter",5,0.1,male
哈利,111,0.2,male
Sally,2333,99.0,female
```

结果：

```
================================================
intval              : Long           : 12
gender              : String         : "male"
floatval            : Double         : 1.4
name                : String         : "Jack"

================================================
intval              : Long           : 123
gender              : String         : "female"
floatval            : Double         : 4.4
name                : String         : "Rose"

================================================
intval              : Long           : 5
gender              : String         : "male"
floatval            : Double         : 0.1
name                : String         : "Jr, Peter"

================================================
intval              : Long           : 111
gender              : String         : "male"
floatval            : Double         : 0.2
name                : String         : "哈利"

================================================
intval              : Long           : 2333
gender              : String         : "female"
floatval            : Double         : 99.0
name                : String         : "Sally"
```

上传部分列

```
tattoo -t csv_test -c name -c gender \
read-csv csv_file1 -c name -c intval -c floatval -c gender
```


特殊字符分隔符


```
tattoo -t csv_test read-csv  csv_test2 --separator '\u0001'
```


### <a name="jdbc"></a> JDBC 数据源

`read-jdbc` 命令从 JDBC 数据源中抽取 record，使用前，请将 JDBC 的驱动 jar 放在 lib 目录下。


| Property Name   | Default       | Description                                    |
| :--------------- |:-------------| :--------------------------------------------- |
| `--url`         | `null`        | 建立 JDBC 连接的 URL    |
| `--username`    | `null`        | 连接用户名              |
| `--password`    | `null`        | 连接密码                |
| `--driver-class`| `null`        | JDBC driver 的完整类名  |
| `--query`       | `null`        | 用来提取数据的 SQL 语句  |


使用范例：

```
tattoo -t table1 read-jdbc --url 'jdbc:odps:...' \
--username db \
--password tiger \
--driver-class com.aliyun.odps.jdbc.OdpsDriver \
--jar JDBC_DRIVER.jar \
--query 'select * from dual'
```


### <a name="odps"></a> ODPS 表

`read-odps` 命令从 ODPS 抽取 record，用来快速检验上传以后的数据。


| Property Name    | Default       | Description                       |
| :---------------- |:-------------| :-------------------------------- |
| `--charset`      | `UTF-8`       | 用来 decode 字符串（byte array）的编码      |
| `--config`       | `~/.odpscmd/odps_config.ini`        | ODPS 配置文件  |
| `--byte-array`   | `false`       | 以 byte array 抽取 String 列的数据         |


使用范例：

```
tattoo -t table1 read-odps test1;
```

Dryrun 结果：

```
================================================
intval              : Long           : 12
gender              : String         : "male"
floatval            : Double         : 1.4
name                : String         : "Jack"

================================================
intval              : Long           : 123
gender              : String         : "female"
floatval            : Double         : 4.4
name                : String         : "Rose"
```

如果不指定 `--byte-array`，String 列会提取成十六进制：

```
================================================
intval              : Long           : 12
gender              : byte[] (HEX)   : 6D616C65
floatval            : Double         : 1.4
name                : byte[] (HEX)   : 4A61636B

================================================
intval              : Long           : 123
gender              : byte[] (HEX)   : 66656D616C65
floatval            : Double         : 4.4
name                : byte[] (HEX)   : 526F7365
```


### <a name="protobuf"></a> Protobuf 文件

`read-proto` 命令用来抽取Protobuf 序列化的文件，底层通过调用 `parseDelimitedFrom()` 从文件中抽取 message。

| Property Name    | Default       | Description                       |
| :---------------- |:-------------| :-------------------------------- |
| `--proto-class`    | `null`      | 包含所有 Message 定义的完整 Protobuf 类名  (required) |             
| `--extract-class`  | `null`      | 要抽取/反序列化的类名  (required)|
| `--property`        | `[]`        | 指定需要抽取的类中的某个具体属性的名字 |
| `--byte-array`     | `false`     | 以 byte array 抽取 Protobuf 对象  |
     
     
`protoc` 的 Protobuf schema 定义:

```
option java_package = "com.aliyun.odps.etl.protobuf";
option java_outer_classname = "Protos";
option java_generate_equals_and_hash = true;
option optimize_for = SPEED;

message RepeatedLongs {
  repeated sint64 longVal = 1;
}

enum Type {
  QUERY = 1;
  UPDATE = 2;
}

message Item {
  repeated string language = 1;
  required string name = 2;
  required float floatVal = 3;
  required uint64 longVal = 4;
  required Type type = 5;
  optional RepeatedLongs repeatedLongs = 6;
}
```

使用范例：

```
tattoo -t table read-proto test.pb \
--proto-class com.aliyun.odps.etl.protobuf.Protos \
--extract-class Item
```

Dryrun 的结果：
 
 
```
================================================
c0                  : String         : "language: "cn"
name: "Jack"
floatVal: 11.11
longVal: 110
type: QUERY
repeatedLongs {
longVal: 1
longVal: 2
longVal: 5
}
"

================================================
c0                  : String         : "language: "eng"
language: "fr"
name: "Marry"
floatVal: 22.22
longVal: 44
type: QUERY
repeatedLongs {
longVal: 2
longVal: 4
}
" 
```

使用范例(指定具体的 property)：

```
tattoo -t table read-proto test.pb \
--proto-class com.aliyun.odps.etl.protobuf.Protos \
--extract-class Item \
--property name \
--property floatVal \
--property type
```

Dryrun 的结果：

```
================================================
name                : String         : "Jack"
floatVal            : Float          : 11.11
type                : String         : "QUERY"

================================================
name                : String         : "Marry"
floatVal            : Float          : 22.22
type                : String         : "QUERY"

```

