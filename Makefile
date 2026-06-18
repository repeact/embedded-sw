# WARNING !!
# Default value are hardcoded, shall not be used in production !
DEVICE_NAME ?= repeact
SUDO ?= repeact


install:
	scp -r scripts config $(DEVICE_NAME):~/ && \
	ssh $(DEVICE_NAME) "chmod +x ~/scripts/install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/scripts/install.sh"

first-install:
	scp -r scripts config $(DEVICE_NAME):~/ && \
	ssh $(DEVICE_NAME) "chmod +x ~/scripts/install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/scripts/install.sh --update --upgrade"

test-install:
	scp test/test-install.sh $(DEVICE_NAME):~/scripts && \
	ssh $(DEVICE_NAME) "chmod +x ~/scripts/test-install.sh" && \
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/scripts/test-install.sh"