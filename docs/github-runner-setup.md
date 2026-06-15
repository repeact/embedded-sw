# Setup a runner

Utility to set up a self-hosted GitHub Actions runner.

## Create a WSL runner

> [!NOTE]
> Linux users can skip step 1.

1. Install [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install).
2. Follow the official GitHub [self-hosted runner](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners) setup guide.

## Install runner dependencies

```bash
sudo apt-get update -qq && \
sudo apt-get install -y python3 python3-pip
```
