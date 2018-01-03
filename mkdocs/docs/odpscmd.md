
# ODPS 命令行工具

## 安装

### Redhat/CentOS 用户通过 YUM 安装

<div class="alert alert-info" role="alert">
<p>Redhat, CentOS 用户请根据<a href="/#yum">指导配置 YUM 远程仓库</a>。</p>
</div>


```
sudo yum -y install odpscmd
```

### Ubuntu/Debian 用户通过 APT 安装

<div class="alert alert-info" role="alert">
<p>Ubuntu, Debian 用户请根据<a href="/#apt">指导配置 APT 远程仓库</a>。</p>
</div>


```
sudo apt-get -y install odpscmd
```



### 下载压缩包
* [v0.28.0](/download/odpscmd/0.28.0/odpscmd_public.zip), (md5sum: 9a20f0a67d5003155fb80d11b4eb3cb4)
* [v0.27.1](/download/odpscmd/0.27.1/odpscmd_public.zip), (md5sum: 9a167fbb3c535dda9824e7c696516fd4)
* [v0.27.0](/download/odpscmd/0.27.0/odpscmd_public.zip), (md5sum: 4c74baf3f5b13708ee512218a386abe4)
* [v0.26.0](/download/odpscmd/0.26.0/odpscmd_public.zip), (md5sum: b528f514091fdd8a0de9724eb052a172)
* [v0.25.0](/download/odpscmd/0.25.0/odpscmd_public.zip), (md5sum: 330e26d07b5a9ed62d9942f90c3aa69c)
* [v0.24.2](/download/odpscmd/0.24.2/odpscmd_public.zip), (md5sum: 0407f858ac83a469aa085debfe0b3064)




## 配置和使用

1.成功安装以后，odpscmd 会在用户 home 目录下新建一个名字叫 `.odpscmd` 的目录，其中保存了 odpscmd 的配置文件 `~/.odpscmd/odps_config.ini`，打开它将看到：

```
project_name=
access_id=<accessid>
access_key=<accesskey>
end_point=http://service.odps.aliyun.com/api
tunnel_endpoint=http://dt.odps.aliyun.com
log_view_host=http://logview.odps.aliyun.com
https_check=true
```

2.在其中填入登录所需要的信息（包括项目名、accessId/Key），保存并退出。

3.在命令行中输入 `odpscmd` ，回车，将看到这样的提示：

```
> odpscmd
Aliyun ODPS Command Line Tool
Version 0.23.1
@Copyright 2015 Alibaba Cloud Computing Co., Ltd. All rights reserved.
odps@ proj_name>
```

4.其中 `proj_name` 代表你所在的项目名。输入 `list tables` 可以列出项目下的所有表名。

```
odps@ proj_name>list tables;

this_is_a_user_name:this_is_a_table_name
...
```

5.更多使用方法请参阅 [阿里云 ODPS 官方文档](https://help.aliyun.com/document_detail/odps/tools/console/console.html)


## Github

该项目已开源，更多信息请访问 [Github](https://github.com/aliyun/aliyun-odps-console) 
