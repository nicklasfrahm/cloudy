BOARD				?= nanopi-r5s
VERSION			?= $(shell git describe --always --tags --dirty)
ARMBIAN_DIR	?= third_party/armbian-build

build: output/$(BOARD)-$(VERSION).img

output/$(BOARD)-$(VERSION).img:
	./scripts/build.sh $(BOARD) $(VERSION)

.PHONY: config
config:
	./$(ARMBIAN_DIR)/compile.sh BOARD=$(BOARD) BRANCH=edge kernel-config
	find $(ARMBIAN_DIR)/userpatches -name '*.config' -exec cp {} config/userpatches \;

.PHONY: update
update:
	git submodule update --remote $(ARMBIAN_DIR)

.PHONY: reset
reset:
	git reset --hard
	git clean -fd
	git submodule foreach --recursive git reset --hard
	git submodule foreach --recursive git clean -fd
