# Sparky AD Client

This repository provides a set of scripts to join a SparkyLinux machine to a Windows Server Active Directory (AD) domain, plus a comprehensive service manager with multilingual support for small business environments. It automates the process of installing prerequisites, configuring system settings, joining the domain, and managing system services with time-based sound notifications.

## Features

### Active Directory Integration
*   **Automated AD Integration**: The `sparky-ad-client` script automates the entire process of joining a SparkyLinux machine to an AD domain.
*   **Comprehensive Prerequisites Installation**: The script installs all the necessary packages for full functionality as a client station.
*   **System Configuration**: The script configures network settings, time synchronization, and various system services for seamless AD integration.
*   **User-Friendly**: The script interactively prompts the user for the required information, making the setup process easy and straightforward.
*   **Automated Cleanup**: The `sparky-ad-leave` script provides a simple way to disconnect the machine from the AD domain and revert all the configuration changes.
*   **Verification Tests**: The `sparky-client-tests` script allows you to verify the successful integration of the machine with the AD domain.

### Service Manager (NEW!)
*   **Multi-Language Support**: Full support for 40+ Debian-supported languages including English, Spanish, French, German, Portuguese, Italian, Russian, Chinese, Japanese, Arabic, and many more.
*   **Dual Interface**: Both Text User Interface (TUI) and Graphical User Interface (GUI) with auto-detection based on environment.
*   **Service Management**: Start, stop, restart, enable, and disable system services with an intuitive interface.
*   **Service Monitoring**: Track and monitor important services for your business operations.
*   **Time-Based Sound Notifications**: Schedule sounds to play at specific times when services are running (e.g., business hour notifications, shift changes, reminders).
*   **Desktop Environment Agnostic**: Works with any Linux desktop environment (KDE, GNOME, XFCE, etc.) or terminal.
*   **Easy Configuration**: User-friendly dialogs for managing all settings.

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

## Service Manager

The SparkyOS Service Manager is a powerful tool designed for small businesses to manage system services and schedule time-based sound notifications.

### Installation

To install the Service Manager, run:

```bash
sudo ./install-service-manager.sh
```

To uninstall:

```bash
sudo ./install-service-manager.sh uninstall
```

### Usage

The Service Manager can be launched in multiple ways:

**From Command Line:**
```bash
# Auto-detect interface (GUI or TUI)
sudo sparky-service-manager

# Force GUI mode
sudo sparky-service-manager --gui

# Force TUI mode
sudo sparky-service-manager --tui
```

**From Application Menu:**
Search for "Sparky Service Manager" in your desktop environment's application menu.

### Features Overview

#### Service Management
- View all system services
- View running services only
- Start, stop, or restart services
- Enable or disable services at boot
- View detailed service status

#### Service Monitoring
- Add services to a monitoring list
- Track important services for your business
- Quick overview of monitored service states

#### Time-Based Sound Notifications
Schedule sounds to play at specific times when services are active:
- **Business Hours**: Play a tune at opening/closing time
- **Shift Changes**: Notify when shift times occur
- **Reminders**: Custom reminders based on service availability
- **Custom Schedules**: Configure any time pattern (specific days, all days, weekends, etc.)

Example use cases for small businesses:
- Play a sound at 9 AM when the web server is running (business open)
- Play a different sound at 5 PM (business close)
- Reminder sounds for backup services running
- Notification when critical services start or stop

#### Multi-Language Support

The Service Manager automatically detects your system language and supports:

**European Languages**: English, Spanish, French, German, Portuguese, Italian, Dutch, Swedish, Norwegian, Danish, Finnish, Polish, Czech, Slovak, Romanian, Hungarian, Croatian, Serbian, Slovenian, Bulgarian, Greek, Estonian, Latvian, Lithuanian

**Asian Languages**: Chinese, Japanese, Korean, Vietnamese, Indonesian

**Middle Eastern Languages**: Arabic, Hebrew, Turkish

**Other**: Basque, Catalan, Galician, Ukrainian, Russian

### Configuration Files

After installation, configuration files are located in:
- `/etc/sparky-service-manager/services.conf` - Monitored services
- `/etc/sparky-service-manager/tunes.conf` - Scheduled sound notifications
- `/etc/sparky-service-manager/sounds/` - Custom sound files directory

### Adding Custom Sounds

To add your own sound files:
1. Copy WAV, OGG, or MP3 files to `/etc/sparky-service-manager/sounds/`
2. Launch the Service Manager
3. Select "Tune Scheduler" → "Add Tune Schedule"
4. Your custom sounds will appear in the sound selection list

### Requirements

The Service Manager requires:
- **For TUI mode**: `dialog` or `whiptail` (usually pre-installed)
- **For GUI mode**: `yad` or `zenity`
- **For sound playback**: `pulseaudio-utils` or `alsa-utils`
- **For scheduling**: `cron`

All dependencies are automatically installed by the install script.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).
