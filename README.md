# Sparky AD Client

This repository provides a set of scripts to join a SparkyLinux machine to a Windows Server Active Directory (AD) domain. It automates the process of installing prerequisites, configuring system settings, and joining the domain.

## Features

*   **Automated AD Integration**: The `sparky-ad-client` script automates the entire process of joining a SparkyLinux machine to an AD domain.
*   **Comprehensive Prerequisites Installation**: The script installs all the necessary packages for full functionality as a client station.
*   **System Configuration**: The script configures network settings, time synchronization, and various system services for seamless AD integration.
*   **User-Friendly**: The script interactively prompts the user for the required information, making the setup process easy and straightforward.
*   **Automated Cleanup**: The `sparky-ad-leave` script provides a simple way to disconnect the machine from the AD domain and revert all the configuration changes.
*   **Verification Tests**: The `sparky-client-tests` script allows you to verify the successful integration of the machine with the AD domain.

## Dependencies

The following dependencies are required to run the scripts:

*   `apt`
*   `bash`
*   `coreutils`
*   `dialog`
*   `dpkg`
*   `gawk`
*   `grep`
*   `hostname`
*   `iputils-ping`
*   `nano`
*   `sed`
*   `sudo`

## Installation

To install the scripts, run the following command with `sudo` privileges:

```bash
sudo ./install.sh
```

## Uninstallation

To uninstall the scripts, run the following command with `sudo` privileges:

```bash
sudo ./install.sh uninstall
```

## Usage

### Joining an AD Domain

To join a SparkyLinux machine to an AD domain, run the `sparky-ad-client` script:

```bash
sudo ./sparky-ad-client
```

The script will guide you through the setup process by prompting for the required information.

### Leaving an AD Domain

To disconnect a SparkyLinux machine from an AD domain, run the `sparky-ad-leave` script:

```bash
sudo ./sparky-ad-leave
```

The script will remove the machine from the domain and revert all the configuration changes.

### Verifying AD Integration

To verify the successful integration of the machine with the AD domain, run the `sparky-client-tests` script:

```bash
sudo ./sparky-client-tests
```

The script will perform a series of tests to ensure that the machine can correctly retrieve user information and that AD users can log in and function as expected.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).
