#!/bin/bash

if [[ $DOCKER_IMAGE == centos* ]]; then
  docker run $DOCKER_IMAGE /bin/bash -c "curl -s http://repo.aliyun.com/aliyun.repo > /etc/yum.repos.d/aliyun.repo && yum -y install $PROG  && $PROG --version"
  exit
fi


if [[ $DOCKER_IMAGE == ubuntu* ]]; then
  docker run $DOCKER_IMAGE /bin/bash -c "apt-get -y install curl && curl -s http://repo.aliyun.com/deb.gpg.key | sudo apt-key add - && echo 'deb http://repo.aliyun.com/apt/debian/ /' | tee -a /etc/apt/sources.list && apt-get update -qq && apt-get -y install $PROG && $PROG --version"
  exit
fi

exit 1
