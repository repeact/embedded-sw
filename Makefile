# WARNING !!
# Default value are hardcoded, shall not be used in production !
DEVICE_NAME ?= repeact
SUDO ?= repeact

_deploy-pkg:
	scp -r scripts config deploy $(DEVICE_NAME):~/

_deploy-toolchain:
	scp -r tools $(DEVICE_NAME):~/ && \
	scp -r scripts/lib $(DEVICE_NAME):~/tools && \
	ssh $(DEVICE_NAME) "chmod +x ~/tools/install.sh" && \
	ssh $(DEVICE_NAME) "chmod +x ~/tools/test-install.sh" && \
	ssh $(DEVICE_NAME) "chmod +x ~/tools/uninstall.sh"

first-install: _deploy-pkg _deploy-toolchain
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/install.sh --update --upgrade"

install: _deploy-pkg _deploy-toolchain
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/install.sh"

test-install: _deploy-toolchain
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/test-install.sh"

uninstall: _deploy-toolchain
	echo "$(SUDO)" | ssh $(DEVICE_NAME) "sudo -S ~/tools/uninstall.sh"

reboot:
	ssh $(DEVICE_NAME) "echo $(SUDO) | sudo -S reboot"