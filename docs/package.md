# Debian package

Build, deploy, verify and remove the `repeact` Debian package.

- [Debian package](#debian-package)
  - [Dependencies](#dependencies)
  - [Build and install](#build-and-install)


> [!IMPORTANT]
> Build **must run on Linux** *(Ubuntu, WSL2...)*.  
> Due to incompatible script execution policy on windows and dependencies issues.

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
| `make build-pkg` |
| `make install`   |
| `make reboot`    |
| `make uninstall` |

> [!NOTE]
> 1. Package artifacts are written to untracked `pkg/` folder.  
> 2. Install bypasses package version (call to `--reinstall`, no backrolling)
