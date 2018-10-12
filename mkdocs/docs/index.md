# Aliyun MaxCompute tools

Welcome to Aliyun MaxCompute tools, if you have any questions, please contact [Lyman](mailto:lymanrb@gmail.com) or [Michelle](mailto:0716michelle@gmail.com) 。


## Configure YUM remote repository

### Add yum repository

1. Create `/etc/yum.repos.d` directory and add a `aliyun.repo` file

```
touch /etc/yum.repos.d/aliyun.repo
```

2. Edit content, save and exit

```
[aliyun-yum]
name=aliyun-yum
baseurl=http://repo.aliyun.com/yum/
enabled=1
gpgcheck=0
gpgkey=
```

### Install MaxCompute CLI tool


```
yum -y install odpscmd
```


## Configure APT remote repository


### Download and add the public key

```
$ curl -s http://repo.aliyun.com/deb.gpg.key | sudo apt-key add -
```


### Add Aliyun deb source


1. Edit sources.list：

```
$ sudo vi /etc/apt/sources.list
```


2. Append new line to file, save and exit

```
deb http://repo.aliyun.com/apt/debian/ /
```

### Install MaxCompute CLI tool


```
$ apt-get -y install odpscmd
```
