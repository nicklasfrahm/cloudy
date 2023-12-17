BOARD		?= nanopi-r5s
VERSION	?= $(shell git describe --always --tags --dirty)

config:
	./third_party/armbian-build/compile.sh BOARD=$(BOARD) BRANCH=edge kernel-config

build: output/$(BOARD)-$(VERSION).img

output/$(BOARD)-$(VERSION).img:
	./scripts/build.sh $(BOARD) $(VERSION)
