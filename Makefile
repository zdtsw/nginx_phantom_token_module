-include .build.info

# There is no `all` target in the NGINX Makefile, but it's a common default, so we add it. When this is used though,
# we always pass on `default` since `all` is unknown to the NGINX Makefile
default all: .build.info
	cd $(NGINX_SRC_DIR) && $(MAKE) -e default

build install modules upgrade: .build.info
	cd $(NGINX_SRC_DIR) && $(MAKE) -e $@

clean:
	cd $(NGINX_SRC_DIR) && $(MAKE) $@
	rm -rf .build.info nginx-$(NGINX_VERSION) nginx-$(NGINX_VERSION).tar.gz* unit_test_driver

.build.info:
	$(error You need to run the configure script in the root of this directory before building the source)

test:
	gcc \
		-DUNIT_TEST \
		-g \
		-I$(NGINX_SRC_DIR)/objs \
		-I$(NGINX_SRC_DIR)/src/{core,event,http,http/modules,os/unix} \
		-I/usr/local/include \
		-L/usr/local/lib \
		-lcriterion \
		-lpcre \
		-lz \
		-o unit_test_driver \
		-O0 \
		ngx_http_access_token_to_jwt.c \
		$(shell find $(NGINX_SRC_DIR)/objs -name 'ngx_http_access_token_to_jwt*.o' -prune -or -name '*.o' -print)
	./unit_test_driver