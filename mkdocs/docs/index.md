# 阿里云 ODPS 工具

欢迎使用阿里云 ODPS 生态工具，如果遇到请联系 [Li Ruibo](mailto:ruibo.lirb@alibaba-inc.com) 。


## 配置 YUM 远程仓库

### 添加远程仓库信息

1.新建 `/etc/yum.repos.d` 目录下新建一个叫 `aliyun.repo` 的文件

```
touch /etc/yum.repos.d/aliyun.repo
```

2.编辑它的内容，保存并退出

```
[aliyun-yum]
name=aliyun-yum
baseurl=http://repo.aliyun.com/yum/
enabled=1
gpgcheck=0
gpgkey=
```

### 安装 ODPS 工具


```
yum -y install odpscmd
```


## 配置 APT 远程仓库


### 下载并添加仓库的公钥

```
$ curl -s http://repo.aliyun.com/deb.gpg.key | sudo apt-key add -
```


### 添加 Aliyun 的 deb 源


1.修改源列表：

```
$ sudo vi /etc/apt/sources.list
```


2.在文件的末尾添加以下内容，保存并退出

```
deb http://repo.aliyun.com/apt/debian/ /
```

### 安装 ODPS 工具


```
$ apt-get -y install odpscmd
```
