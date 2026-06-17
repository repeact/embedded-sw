# Setup project

- [Setup project](#setup-project)
  - [Project prerequisite: HW and workspace setup](#project-prerequisite-hw-and-workspace-setup)
    - [Generate an SSH RSA key](#generate-an-ssh-rsa-key)
    - [RPi OS setup](#rpi-os-setup)
    - [SSH host/remote link](#ssh-hostremote-link)
    - [Setup validation](#setup-validation)
  - [Installation and deployment, from host to remote](#installation-and-deployment-from-host-to-remote)
      - [First install](#first-install)
      - [Re-runs](#re-runs)

## Project prerequisite: HW and workspace setup

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

> [!IMPORTANT]
> Adapt the remote host
> Replace `repeact` with the actual host name of your target device (e.g. `repeact-PI01`).  
> Replace the password literal `repeact` in `echo "repeact" |` with the actual `root` password.

Run all commands from project root folder (default: `embedded-sw`).

#### First install

Recommended on a fresh device:
-  `--update` to run `apt-get update` 
-  `--upgrade` to run `apt-get upgrade` 

```bash
scp -r scripts config repeact:~/ && \
ssh repeact "chmod +x ~/scripts/install.sh" && \
echo "repeact" | ssh repeact "sudo -S ~/scripts/install.sh --update --upgrade"
```

#### Re-runs

Skips OS upgrade step for faster execution.  
Use once device has already been fully updated.

```bash
scp -r scripts config repeact:~/ && \
ssh repeact "chmod +x ~/scripts/install.sh" && \
echo "repeact" | ssh repeact "sudo -S ~/scripts/install.sh"
```

To verify installation, refer to the [run tests](tests.md) documentation.
