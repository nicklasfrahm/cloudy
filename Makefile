BOARD				?= nanopi-r5s
VERSION			?= $(shell git describe --always --tags --dirty)
ARMBIAN_DIR	?= third_party/armbian-build

build: output/$(BOARD)-$(VERSION).img

output/$(BOARD)-$(VERSION).img:
	mkdir -p output
	./scripts/build.sh $(BOARD) $(VERSION)

.PHONY: config
config:
	./$(ARMBIAN_DIR)/compile.sh BOARD=$(BOARD) BRANCH=edge kernel-config
	find $(ARMBIAN_DIR)/userpatches -name '*.config' -exec cp {} config/userpatches \;
