# WARNING !!
# Default value are hardcoded, shall not be used in production !
DEVICE_NAME ?= repeact
SUDO ?= repeact

install:
# Deploy "package" life files only.
# Deploy install "toolchain" with its own copy of dependencies (lib)
	scp -r scripts config $(DEVICE_NAME):~/ && \
	scp -r tools $(DEVICE_NAME):~/ && \
	scp -r scripts/lib $(DEVICE_NAME):~/tools && \
	ssh $(DEVICE_NAME) "chmod +x ~/tools/install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/install.sh"

first-install:
	scp -r scripts config $(DEVICE_NAME):~/ && \
	ssh $(DEVICE_NAME) "chmod +x ~/scripts/install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/scripts/install.sh --update --upgrade"

test-install:
	scp -r tools $(DEVICE_NAME):~/ && \
	scp -r scripts/lib $(DEVICE_NAME):~/tools && \
	ssh $(DEVICE_NAME) "chmod +x ~/tools/test-install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/test-install.sh"