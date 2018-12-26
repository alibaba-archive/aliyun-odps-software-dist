# MaxCompute CLI tool odpscmd

## Install odpscmd

### Install odpscmd by using YUM (Red Hat and CentOS)

<div class="alert alert-info" role="alert">
<p>For Red Hat and CentOS users, configure the Yellowdog Updater, Modified 
(YUM) remote repository. For more information, see <a href="/#yum">Configure YUM remote repository</a>.</p>
</div>

```
sudo yum -y install odpscmd
```

### Install odpscmd by using APT (Ubuntu and Debian)

<div class="alert alert-info" role="alert">
<p>For Ubuntu and Debian users, configure the Advanced Package Tool
 (APT) remote repository. For more information, see <a href="/#apt">Configure APT remote repository</a>.</p>
</div>

```
sudo apt-get -y install odpscmd
```

### Download one of the following packages to perform a local installation.
* [v0.29.6-oversea](/download/odpscmd/0.29.6-oversea/odpscmd_public.zip), (md5sum: a87aca8592fe8ed834f55e42999aa2cd)
* [v0.29.6](/download/odpscmd/0.29.6/odpscmd_public.zip), (md5sum: fd9c99f41ebcd9103256c725ba479023)
* [v0.29.5](/download/odpscmd/0.29.5/odpscmd_public.zip), (md5sum: df41d08d365e2a444a21ef7f2991ec8c)
* [v0.29.2](/download/odpscmd/0.29.2/odpscmd_public.zip), (md5sum: 5107220722e6f804fcb7216a07a0a4a4)
* [v0.28.0](/download/odpscmd/0.28.0/odpscmd_public.zip), (md5sum: 9a20f0a67d5003155fb80d11b4eb3cb4)
* [v0.27.1](/download/odpscmd/0.27.1/odpscmd_public.zip), (md5sum: 9a167fbb3c535dda9824e7c696516fd4)
* [v0.26.0](/download/odpscmd/0.26.0/odpscmd_public.zip), (md5sum: b528f514091fdd8a0de9724eb052a172)
* [v0.25.0](/download/odpscmd/0.25.0/odpscmd_public.zip), (md5sum: 330e26d07b5a9ed62d9942f90c3aa69c)
* [v0.24.2](/download/odpscmd/0.24.2/odpscmd_public.zip), (md5sum: 0407f858ac83a469aa085debfe0b3064)

## Configure and use odpscmd

1. After installation, odpscmd creates the `.odpscmd` directory in the home directory to store the odpscmd configuration file `~/.odpscmd/odps_config.ini`. The file contains the following settings:

```
project_name=
access_id=<accessid>
access_key=<accesskey>
end_point=http://service.odps.aliyun.com/api
tunnel_endpoint=http://dt.odps.aliyun.com
log_view_host=http://logview.odps.aliyun.com
https_check=true
```

2. Open the file, add the logon information, such as the project name, AccessId, and AccessKey, save the file, and then exit.

3. Enter `odpscmd` at the CLI, and press Enter. The output is as follows:

```
> odpscmd
Aliyun ODPS Command Line Tool
Version 0.29.1
@Copyright 2015 Alibaba Cloud Computing Co., Ltd. All rights reserved.
odps@ proj_name>
```

4. The `proj_name` parameter specifies the project name. Enter `list tables` to list all table names under the project.

```
odps@ proj_name>list tables;

this_is_a_user_name:this_is_a_table_name
...
```

5. For more information about using odpscmd, see [Client.](https://help.aliyun.com/document_detail/odps/tools/console/console.html)

## GitHub

Source code is now available for this project. For more information about managing the project with GitHub, see [GitHub.](https://github.com/aliyun/aliyun-odps-console)

