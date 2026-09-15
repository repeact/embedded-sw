# Setup project

- [Setup project](#setup-project)
  - [Install make](#install-make)
  - [Generate an SSH RSA key](#generate-an-ssh-rsa-key)
  - [RPi OS setup](#rpi-os-setup)
  - [SSH host/remote link](#ssh-hostremote-link)
  - [Setup validation](#setup-validation)
  - [Installation and deployment, from host to remote](#installation-and-deployment-from-host-to-remote)
  - [Make autocompletion *(optionnal)*](#make-autocompletion-optionnal)

## Install make

To use deployment/test toolchain, ``make`` is required and shall be downloaded.

## Generate an SSH RSA key

Open Git Bash or PowerShell and run:

```bash
ssh-keygen -t rsa
```

When prompted for a destination, enter: `~/.ssh/repeact-PI[IDENTIFIER]_id-rsa`

## RPi OS setup

> [!WARNING]
> Flash 64-bit version
> Flashing 32-bit version will cause `apt-get update` to fail when downloading `ffmpeg`.

Flash **Raspberry Pi OS Lite 64-bit** with the following settings:

- Hostname: `repeact-PI[IDENTIFIER]`
- Username: `repeact-PI[IDENTIFIER]` (or any username you prefer)
- Wi-Fi SSID and password
- SSH enabled, using public key authentication
- SSH public key: `~/.ssh/repeact-PI[IDENTIFIER]_id-rsa.pub`
- RPi Connect: disabled

## SSH host/remote link

Create a `config` file in your `~/.ssh/` folder and add the following:

```
Host repeact
    HostName        repeact-PI[IDENTIFIER]
    User            repeact-PI[IDENTIFIER]
    IdentityFile    ~/.ssh/repeact-PI[IDENTIFIER]_id-rsa
    IdentitiesOnly  yes
```

## Setup validation

Verify the setup by connecting to the device:

```bash
ssh repeact
```

Accept the device fingerprint when prompted.

> [!NOTE]
> Resolving known-hosts conflicts
> If you encounter a fingerprint conflict, remove the stale entries from `~/.ssh/known_hosts`:
> ```
> repeact-PI[IDENTIFIER] ssh-ed25519 XXX
> repeact-PI[IDENTIFIER] ssh-rsa XXX [...] XXX
> repeact-PI[IDENTIFIER] ecdsa-sha2-nistp256 XXX [...] XXX
> ```

## Installation and deployment, from host to remote

The project is deployed as a Debian package: see [Debian package documentation](package.md).

## Make autocompletion *(optionnal)*

<!-- ref: https://stackoverflow.com/questions/4188324/bash-completion-of-makefile-target -->
Edit or create either ``.bashrc`` or ``.bash_profile``, in your home directory ``~/``.  
Add this line: 
```
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
```  
And source the new config with ``source ~/.bashrc`` or ``source ~/.bash_profile``

Run all commands from project root folder.

<!-- TODO: Remove default value and use magic values instead -->
> [!NOTE] 
> Provide your device hostname/sudo password to make using ``DEVICE_NAME`` and ``SUDO`` (optional).
