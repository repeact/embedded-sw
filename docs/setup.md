# Setup project

- [Setup project](#setup-project)
  - [Project prerequisite: HW and workspace setup](#project-prerequisite-hw-and-workspace-setup)
    - [Install make](#install-make)
    - [Generate an SSH RSA key](#generate-an-ssh-rsa-key)
    - [RPi OS setup](#rpi-os-setup)
    - [SSH host/remote link](#ssh-hostremote-link)
    - [Setup validation](#setup-validation)
  - [Installation and deployment, from host to remote](#installation-and-deployment-from-host-to-remote)
    - [Make autocompletion](#make-autocompletion)
      - [First install](#first-install)
      - [Re-runs](#re-runs)

## Project prerequisite: HW and workspace setup

### Install make

To use deployment/test toolchain, ``make`` is required and shall be downloaded.

### Generate an SSH RSA key

Open Git Bash or PowerShell and run:

```bash
ssh-keygen -t rsa
```

When prompted for a destination, enter: `~/.ssh/repeact-PI[IDENTIFIER]_id-rsa`

### RPi OS setup

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

### SSH host/remote link

Create a `config` file in your `~/.ssh/` folder and add the following:

```
Host repeact
    HostName        repeact-PI[IDENTIFIER]
    User            repeact-PI[IDENTIFIER]
    IdentityFile    ~/.ssh/repeact-PI[IDENTIFIER]_id-rsa
    IdentitiesOnly  yes
```

### Setup validation

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

### Make autocompletion

Edit or create etiher ``.bashrc`` or ``.bash_profile``, in your home directory ``~/``.  
Add this line: 
```
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
```  
And source the new config with ``source ~/.bashrc`` or ``source ~/.bash_profile``

> [!IMPORTANT]
> Adapt the remote host
> Replace `repeact` with the actual host name of your target device (e.g. `repeact-PI01`).  
> Replace the password literal `repeact` in `echo "repeact" |` with the actual `root` password.

Run all commands from project root folder (default: `embedded-sw`).

> [!NOTE] 
> You can specify your device hostname/sudo password using ``DEVICE_NAME`` and ``SUDO`` optionnal arguments.  
> Defaults to: see [Makefile](../Makefile)

#### First install

Run in shell make ``first-install``

Difference with raw ``install`` is the added ``--update`` and ``--upgrade`` flags.  
Which will run the equivalent ``apt`` commands.

#### Re-runs

Run in a shell make ``install``  

To verify installation, refer to the [run tests](tests.md) documentation.
