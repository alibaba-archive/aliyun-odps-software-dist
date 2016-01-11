# Logstash 插件


### 安装插件

使用 gem 安装，并在 logstash 中安装插件。

```
$ gem install logstash-output-datahub
$ {YOUR_LOGSTASH_DIRECTORY}/bin/plugin install logstash-output-datahub
```

### 配置文件

```
input{
	stdin{ }
}
filter {
  alter {
    add_field => { "data" => "%{message}, from %{host}" }
	add_field => { "place" => "usa" }
	add_field => { "biginttest" => "55555" }
	add_field => { "doubletest" => "3.5" }
	add_field => { "datetimetest" => "2015-12-04 23:45:06" }
  }
}
output{
	datahub{
		shard_number=>1
		aliyun_access_id=>"************"
		aliyun_access_key=>"************"
		aliyun_odps_endpoint=>"http://service.odps.aliyun.com/api"
		aliyun_odps_hub_endpoint=>"http://dh.odps.aliyun.com"
		project=>"your_projectName"
		table=>"your_tableName"
		partition=>"time=${datetimetest.strftime('%Y-%m-%d')},place=${place}"
		partition_time_format=>"%Y-%m-%d %H:%M:%S"	
		value_field=>["data","biginttest","doubletest","datetimetest"]
	}	
}
```

### 参数说明


- aliyun_access_id(Required):your aliyun access id.
- aliyun_access_key(Required):your aliyun access key.
- aliyun_odps_hub_endpoint(Required):if you are using ECS, set it as http://dh-ext.odps.aliyun-inc.com, otherwise using http://dh.odps.aliyun.com.
- aliyunodps_endpoint(Required):if you are using ECS, set it as http://odps-ext.aiyun-inc.com/api, otherwise using http://service.odps.aliyun.com/api .
- project(Required):your project name.
- table(Required):your table name.
- value_field(Required): must match the keys in source.
- partition(Optional)£ºset this if your table is partitioned.
    - partition format:
        - fix string: partition ctime=20150804
        - key words: partition ctime=${remote}
        - key words int time format: partition ctime=${datetime.strftime('%Y%m%d')}
- partition_time_format(Optional):
    - if you are using the key words to set your <partition> and the key word is in time format, please set the param <time_format>. example: source[datetime] = "29/Aug/2015:11:10:16 +0800", and the param <time_format> is "%d/%b/%Y:%H:%M:%S %z"
- shard_number(Optional): will write data to shards between [0,shard_number-1], this config must more than 0 and less than the max shard number of your table.
- batch_size(Optional)£ºbatch send message to dhs service, default 100.
- batch_timeout(Optional)£ºforce to send message interval. Send messages even the queue size not reach batch size, default 1s.