# ETL SDK

### 简介

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
		   .equalTo("ds", "20160101"))
           .build()).build()
				   
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
  	.set("id", i).build());
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


