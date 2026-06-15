# Run tests

Utility to quickly refer to when running tests.
- [Run tests](#run-tests)
  - [Deployment test (installation)](#deployment-test-installation)


> [!NOTE]
> Ensure your [setup is complete](setup.md) before proceeding.


Adapt the remote host  
Replace `repeact` with the actual host name of your target device (e.g. `repeact-PI01`).   
Replace the password literal `repeact` in `echo "repeact" |` with the actual `root` password.

Run all commands from project root folder (default: `embedded-sw`).

## Deployment test (installation)

Run
```bash
scp test/test-install.sh repeact:~/scripts && \
ssh repeact "chmod +x ~/scripts/test-install.sh" && \
echo "repeact" | ssh repeact "sudo -S ~/scripts/test-install.sh"
```
