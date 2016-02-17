ROOT = $(shell pwd)
DEB_DIR = $(ROOT)/apt/debian
RPM_DIR = $(ROOT)/yum
USER = $(shell whoami)
WEBHOME = /var/www/repo.aliyun.com
CP = cp -rf

rpm_dir:
	mkdir -p $(RPM_DIR)

deb_dir:
	mkdir -p $(DEB_DIR)

deploy: deb.gpg.key gen_repos.sh
	$(CP) $(DEB_DIR)/ $(WEBHOME)/apt/debian
	$(CP) $(RPM_DIR)/ $(WEBHOME)/yum
	$(CP) deb.gpg.key $(WEBHOME)/
	$(CP) gen_repos.sh $(WEBHOME)/
	cd $(WEBHOME)/
	sh gen_repos.sh

deploy-web: docs
	$(CP) $(ROOT)/mkdocs/site/* $(WEBHOME)/ 

%.deb: % deb_dir
	cd $< && fpm-cook clean && fpm-cook --no-deps -t deb -p linux && mv -vf pkg/*.deb $(DEB_DIR)/ 

%.rpm: % rpm_dir
	cd $< && fpm-cook clean && fpm-cook --no-deps -t rpm -p linux && mv -vf pkg/*.rpm $(RPM_DIR)/

docs:
	cd mkdocs && mkdocs build --clean

clean:
	rm -rf yum
	rm -rf apt
	rm -rf $(wildcard */pkg)
	rm -rf $(wildcard */cache)
	rm -rf $(wildcard */tmp-build)
	rm -rf $(wildcard */tmp-dest)
