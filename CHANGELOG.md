# Changelog
## 0.4.0 (2026-07-28)

### Feat

- **deploy**: implement lock-src-signal service unit
- **tools**: implements lock-src-signal scripts
- **deploy**: add source available unit
- **scripts**: implement src-avail-daemon
- **lib**: add a dispatch utility
- **lib**: extend logging to journald
- **deploy**: implement video0 units
- **tools**: implement load-edid script
- **tools**: add unit removal to uninstall script
- **tools**: add unit deployment to install script
- **tools**: implement uninstall script
- add deployment targets

### Fix

- fix daemon script and lock-src unit deadlock
- add missing pipefail rule for tools (un/install) and test scripts
- fix script location of first-install make recipe
- **tools**: patch variable expansion bug on symlink removal

### Refactor

- add v4l2 wrapper stdout suppression
- **lib**: migrate local parse_args function to a global one
- **targets**: update make recipes w/ new tooclchain setup
- **toolchain**: group all toolchain related script

## 0.3.0 (2026-06-21)

### Feat

- **install**: add upgrade and update flags

### Fix

- **install**: patch function declaration and call conflict
- **dependencies**: fix recursive dependencies sourcing

### Refactor

- **targets**: update make recipes w/ new tooclchain setup
- **toolchain**: group all toolchain related script
- **test-install**: extract sections into functions
- **install**: extract sections into functions
- **lib**: remove shebangs from sourced files
- **lib**: strengthen constants declaration and naming
- **install**: make install flag straight
- **google-guideline**: match exec/lib name convention
- **google-guidelines**: match safety guidelines
- **errors**: reorder and group error codes by script ranges

## 0.2.0 (2026-03-24)

### Feat

- add project configuration
- add edid deployement, code refactoring
- implement ending script user report
- implement OS/packages upgrade
- implement symlinks creation function
- first step of arch implementation
- create a common library shared across project.
- implement script errors

### Fix

- patch minor issues
- patch file name and script paths
- add ANSI colors w/ terminal conditions
- add project git config (patch CRLF/LF conversion)
- patch uncommented line
- patch file name path
- patch file paths

## 0.1.0 (2026-03-19)

### Feat

- **arch**: create stop process architecture
- **arch**: create recording process architecture
- **arch**: create start process architecture
- **arch**: create setup process architecture
- **arch**: create install process architecture
- **arch**: add system high level architecture

### Refactor

- **arch-layout**: minor layout update
- **arch-layout**: minor layout update
- **arch-layout**: update drawio arch display layout
- update folder architecture
- **arch-layout**: update architecture drawing convention
