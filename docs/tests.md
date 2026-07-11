# Run tests

Utility to quickly refer to when running tests.
- [Run tests](#run-tests)
  - [Deployment](#deployment)
    - [Install](#install)


> [!NOTE]
> Ensure your [setup is complete](setup.md) before proceeding.


Adapt the remote host  
Replace `repeact` with the actual host name of your target device (e.g. `repeact-PI01`).   
Replace the password literal `repeact` in `echo "repeact" |` with the actual `root` password.

Run all commands from project root folder (default: `embedded-sw`).

## Deployment 

### Install

Run in a shell ``make test-install``  
