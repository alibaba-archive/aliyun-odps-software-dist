
# ODPS ETL 命令行工具


## 下载

使用过程中遇到问题请联系：[onesuper](mailto:onesuperclark@gmail.com)


### Redhat/CentOS 用户通过 YUM 安装

<div class="alert alert-info" role="alert">
<p>Redhat, CentOS 用户请根据<a href="/#yum">指导配置 YUM 远程仓库</a>。</p>
</div>


```
sudo yum -y install tattoo
```

### Ubuntu/Debian 用户通过 APT 安装

<div class="alert alert-info" role="alert">
<p>Ubuntu, Debian 用户请根据<a href="/#apt">指导配置 APT 远程仓库</a>。</p>
</div>


```
sudo apt-get -y install tattoo
```

### TAR 包下载

* [tattoo-1.0.zip](/download/tattoo.zip)
* [tattoo-1.0.tar.gz](/download/tattoo.tar.gz)


## 简介

tattoo(take anything to odps) 是一个命令行版的 ETL 工具。每一条 tattoo 命令可以从一个特定的数据源中提取数据、并加载到 ODPS （分区）表。


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





### 支持的数据源


* [文本流](#text): 从文本流中提取数据
* [CSV 文件](#csv): 从 CSV 文件中提取 record 
* [JDBC 数据源](#jdbc): 从 JDBC 结果集中提取数据 
* [ODPS 表](#odps): 从某个 ODPS 表（或分区）中提取 record 
* [Protobuf 文件](#protobuf): 从 Protobuf 格式的文件中提取 record 


##文本流

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


## CSV 文件

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


## <a name="jdbc"></a> JDBC 数据源

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


## ODPS 表

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


## Protobuf 文件

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



# ODPS ETL 开发套件

ETL SDK 包含两个部分：

**ETL API**: 提供了一种在用户代码中方便地将文本流、CSV、JDBC、Protobuf 等文件中的内容上传到 ODPS 的方法，简化了二次开发。

**Dataset API**: Dataset API 提供了一套 High Level 数据集的编程接口，和 ODPS 的 SDK 相比，它隐藏了很多细节，使用它可以方便地管理、上传、下载 ODPS 中的数据。


### Maven 依赖

```
<dependency>
    <groupId>com.aliyun.odps</groupId>
    <artifactId>odps-etl-core</artifactId>
    <version>1.0-SNAPSHOT</version>
</dependency>
```

## ETL API

### 多线程上传文本中的内容



```
Datasets.init(odps);
String tablename = "test_table";
TableSchema schema = new SchemaBuilder().col("uuid", "STRING").build();
Dataset dataset = Datasets.create(tablename, schema);

List<String> paths = new ArrayList<String>();
paths.add("./test_file.txt");

// string 编码、日期格式、日期时区、指定上传的列名
LoadODPSContext context = LoadODPSContext("UTF-8", "yyyy-MM-dd HH:mm:ss", "UTC", null);

Pipeline pipe = new Pipeline.Builder()
    .extract(new ReadText(paths, "UTF-8"))
    .load(new LoadODPSSingleSinkFactory(dataset, context), 2)  // 线程数 2
    .build();
pipe.execute();

Datasets.delete(tablename);
```


## Dataset API


### 基本概念


Tattoo API 使用 URI（字符串） 来表示 ODPS 表中的数据。类似于「统一资源标识符」的概念，URI 是一个用来表示一个或多个数据集（dataset）的字符串，它的模式为：

```
project.table/partition_spec
```

数据集（dataset）可以是 ODPS 分区表中的一个分区，或一张非分区表。当 `partition_spec` 为非末级分区时，URI 表示多个数据集（dataset）。

例如下面这个 URI 表示 `clothes/color=Red/size=XXL` 目录下的分区：

```
String uri = "shop.clothes/color='Red',size='XXL'";
```

可视化以后，像这样：

```
shop/
└── clothes/
    └── color=Red/
        ├── size=XXL/
        │   ├── ds=20151224/  [*]
        │   ├── ...           [*]
        │   └── ds=20160211/  [*]
        ├──size=L/
        │   ├── ds=20151224/
        │   ├── ...
```



### 查看


当我们想查看一个 URI 具体表示哪些数据集时，可以通过 `Datasets.list()` 接口将返回 URI 表示的所有数据集（ dataset）或分区。例如 `"shop.clothes/color='Red',size='XXL'"`将返回：

```
"shop.clothes/color='Red',size='XXL', ds='20151224'"
"shop.clothes/color='Red',size='XXL', ds='20151223'"
"shop.clothes/color='Red',size='XXL', ds='20151222'"
"shop.clothes/color='Red',size='XXL', ds='20151221'"
...
```


### 创建

使用 `Datasets.create()` 接口可以根据 URI 快速创建某个具体的数据集（dataset）或分区。例如`Datasets.create("shop.clothes/color='Red',size='XXL',ds='20160101'")`


URI 本身也可以用通过 Builder Pattern 来构造：

```
String uri = DatasetDescriptor.Builder()
       .project("shop")
       .table("clothes")
       .partitionSpec(
           PartitionSpecBuilder()
	           .equalTo("color", "Red")
		           .equalTo("size", "XXL")
			           .equalTo("ds", "20160101")
				   ).build()
				   
Datasets.create(uri);
```


`Datasets.create()` 也可以从 schema 用来创建 ODPS 表，可通过 Builder Pattern 来构造：

```
TableSchema schema = new SchemaBuilder()
    .col("id", "STRING")
    .col("numbers", "BIGINT")
    .parCol("color", "STRING")
    .parCol("size", "STRING")
    .parCol("ds", "STRING")
    .build();
    
Datasets.create("shop.clothes", schema);
```

`Datasets.create()` 将返回给用户一个 Dataset 类型的对象，用户可以在它上面打开相应的 reader 和 writer 进行读写。


### 加载

也可以通过 `Datasets.load()` API 来加载一个已经存在的 dataset，例如：

```
Dataset products = Datasets.load(...);
System.out.println(products.getURI());
```

### 读取

对于一个加载完毕的 dataset，可以通过 DatasetReader 来获取某个 dataset 中的记录

```
DatasetReader reader = null;

try {
  reader = products.newReader();
  for (Record product : reader) {
    System.out.println(product);
  }
} finally {
  if (reader != null) {
    reader.close();
  }
}
```

### 更新

可以通过 writer 对一个 dataset 进行更新记录的操作。

```
DatasetWriter writer = null;

try {
  int i = 0;  
  writer = products.newWriter();
  for (String item : items) {
    writer.write(dataset.recordBuilder()
	.set("name", item)
  	 	     .set("id", i)
  		      		.build());
    i += 1;
  }
} finally {
  if (writer != null) {
    writer.close();
  }
}
```



### 删除

删除这些分区中的数据。

```
for (String uri : Datasets.list("shop.clothes/color='Red',size='XXL'")) {
    Datasets.delete(uri);
}
```


