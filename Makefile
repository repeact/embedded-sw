# WARNING: Must run on linux (ubuntu, wsl...)
# WARNING: for specific target (amd64, arm64...) set an ARCH flag or hardcode it!

DEVICE_NAME ?= repeact
SUDO ?= repeact

.PHONY: build-pkg _deploy install uninstall reboot

build-pkg:
	./build

_deploy: build-pkg
	ssh $(DEVICE_NAME) "rm -f ~/repeact_*.deb"
	scp pkg/repeact_*_all.deb $(DEVICE_NAME):~/

install: _deploy
	echo "$(SUDO)" | \
	ssh $(DEVICE_NAME) "sudo -S apt update" && \
	echo "$(SUDO)" | \
	ssh $(DEVICE_NAME) "sudo -S apt install --reinstall -y ~/repeact_*_all.deb"

uninstall:
	echo "$(SUDO)" | \
	ssh $(DEVICE_NAME) "sudo -S apt remove -y repeact"

reboot:
	ssh $(DEVICE_NAME) "echo $(SUDO) | sudo -S reboot"