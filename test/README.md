# Test

Test toolchain for REPEACT install script.

>[!important] TODO
> Verify then update that using ``repeact-PI[IDENTIDIER]`` in target name is not creating conflicts

## Prerequisites

### SSH RSA key

Open git bash or powershell

Run ``ssh-keygen -t rsa``

When asked, set destination folder/name file with the specific target name: ``[PATH].ssh/repeact-PI[IDENTIDIER]_id-rsa``

### Pi OS setup

>[!important] You shall flash the 64-bit version.
> Failing to do so will result in ``apt-get update`` failing to download ``ffmpeg`` and cause a crash.

Flash **Raspberry Pi OS Lite 64-bit**.
- Set hostname to `repeact-PI[IDENTIDIER]`
- Set username to ``repeact`` __(see below warning)__
- Setup wifi SSID/password
- Enable SSH for authentication mechanism
- Load ras key pub file (``[path].ssh/repeact-PI[identifier-]_id-rsa``) as the SSH Key
- Dont enable RPI connect

### SSH host/remote link

Create a ``config`` file in .ssh folder

Add those line:
```
Host repeact
    HostName repeact-PI[IDENTIDIER]
    User repeact-PI[IDENTIDIER]
    IdentityFile ~/.ssh/repeact-PI[identifier-]_id-rsa # Your RSA key name
    IdentitiesOnly yes
```

### Toolchain setup validation

You shall be able to connect to ``repeact@repeact-PI[IDENTIDIER]`` user by typing: ``ssh repeact-PI[IDENTIDIER]`` in any shell.
When asked, at first connection, accept device finger print.

>[!warning] Knownhost conflicts
> If there a conflict in fingerprint you can delete in ``known-hosts`` file the following lines:
> ```
> repeact-PI[IDENTIDIER] ssh-ed25519 XXX
> repeact-PI[IDENTIDIER] ssh-rsa XXX [...] XXX
> repeact-PI[IDENTIDIER] ecdsa-sha2-nistp256 XXX [...] XXX
> ```

## Deployment test

### Deploy files and launch tests on device (from host)

>[!warning] Replace ``repeact`` with your remote host name: ``repeact-PI[IDENTIDIER]``

Run command in project root folder (default: `embedded-sw`).

```bash
scp -r scripts repeact:~/ && \
scp -r config repeact:~/scripts && \
scp -r test/test-install.sh repeact:~/scripts && \
ssh repeact "cd scripts && chmod +x ./install.sh ./test-install.sh" && \
echo "repeact" | ssh repeact "sudo -S bash -c 'cd scripts && ./install.sh && ./test-install.sh'"
```

---
> [!note] First-time setup, update/upgrade packages dependencies
> Pass `--pkg-update` and ``--pkg-upgrade``to upgrade OS packages before installing:
> ```bash
> scp -r scripts repeact:~/ && \
> scp -r config repeact:~/scripts && \
> scp -r test/test-install.sh repeact:~/scripts && \
> ssh repeact "cd scripts && chmod +x ./install.sh ./test-install.sh" && \
> echo "repeact" | \
> ssh repeact "sudo -S bash -c 'cd scripts && \
> ./install.sh --pkg-update --pkg-upgrade \
> && ./test-install.sh'"
> ```
