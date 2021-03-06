-include .build.info

# There is no `all` target in the NGINX Makefile, but it's a common default, so we add it. When this is used though,
# we always pass on `default` since `all` is unknown to the NGINX Makefile
default all: .build.info
	cd $(NGINX_SRC_DIR) && $(MAKE) -e default

build install modules upgrade: .build.info
	cd $(NGINX_SRC_DIR) && $(MAKE) -e $@

clean:
	test -d "$(NGINX_SRC_DIR)" && $(MAKE) -C $(NGINX_SRC_DIR) $@ || true
	rm -rf .build.info nginx-$(NGINX_VERSION) nginx-$(NGINX_VERSION).tar.gz*

.build.info:
	$(error You need to run the configure script in the root of this directory before building the source)
