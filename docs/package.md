# Debian package

Build, deploy, verify and remove the `repeact` Debian package.

- [Debian package](#debian-package)
  - [Dependencies](#dependencies)
  - [Build and install](#build-and-install)


> [!IMPORTANT]
> Build must run on MacOS/Linux *(Ubuntu, WSL2...)* due to incompatible script execution policy on windows. 
<!-- > (`chmod +x`) -->

## Dependencies

Ensure you have a [working setup](setup.md) and download the below software dependencies.
```bash
sudo apt-get update && \
sudo apt-get install -y build-essential dpkg-dev debhelper rsync make openssh-client
```

## Build and install

Run any below command from project root folder.  

| Commands         |
| ---------------- |
| `make install`   |
| `make reboot`    |
| `make uninstall` |
| `make build-pkg` |

> [!NOTE]
> Package artifacts are written to untracked `pkg/` folder.  

> [!NOTE]
> Install bypass package version (call to `--reinstall`, no backrolling)
