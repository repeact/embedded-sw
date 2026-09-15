# Repeact recorder (embedded-sw)

HDMI recorder for movie script supervisors.

## Project commit ruleset

[Project commit convention](commits-style.md).  

> [!WARNING]
> Each commit on this repo **shall** follow/comply with this ruleset. 

## Project layout

| Folder / file         | Content                                         |
| --------------------- | ----------------------------------------------- |
| `docs/`               | Project documentation and architecture diagrams |
| `config/`             | Project configuration files                     |
| `scripts/`            | Runtime scripts and shared library              |
| `deploy/`             | System integration units *(udev/systemd...)*    |
| `debian/`             | Debian packaging files                          |
| `Makefile` && `build` | Build toolchain                                 |

## Setup project

[Project HW and SW setup](setup.md).

## Build and install

[Debian package documentation](package.md).

## GitHub Actions runner

[GitHub Actions self-hosted runner setup](github-runner-setup.md).

> [!WARNING]
> Complete runner setup before triggering any CI/CD job.  
> Misconfigured runners will cause pipeline failures !
