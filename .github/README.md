# Github action

## Create a windows runner

Setup WSL2 using ``cmdline``.
Follow the official github [self hosted runner](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners) setup.

## Setup local runner dependencies

Install python dependency with
```bash
sudo apt-get update -qq && \
sudo apt-get install -y python3 python3-pip
```
