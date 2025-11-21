#!/bin/bash
# install-service-manager.sh - Installer for SparkyOS Service Manager
# Copyright SparkyOS Team
# Under the GNU GPL3 License
#
# Installs the service manager and all dependencies
# Last update 2025/11/21

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${NC}"
    echo "Please run with sudo: sudo $0"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}=== SparkyOS Service Manager Installer ===${NC}"
echo ""

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"

    # Update package list
    apt-get update -qq

    # Install required packages
    apt-get install -y \
        dialog \
        whiptail \
        zenity \
        yad \
        pulseaudio-utils \
        alsa-utils \
        mpg123 \
        cron \
        systemd \
        libnotify-bin

    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

# Function to install scripts
install_scripts() {
    echo -e "${YELLOW}Installing scripts...${NC}"

    # Install library files
    mkdir -p /usr/lib/sparky-service-manager
    cp "${SCRIPT_DIR}/lib/sparky-i18n.sh" /usr/lib/sparky-service-manager/
    cp "${SCRIPT_DIR}/lib/sparky-service-lib.sh" /usr/lib/sparky-service-manager/
    chmod 644 /usr/lib/sparky-service-manager/*.sh

    # Install executables
    cp "${SCRIPT_DIR}/bin/sparky-service-manager" /usr/bin/
    cp "${SCRIPT_DIR}/bin/sparky-service-tui" /usr/bin/
    cp "${SCRIPT_DIR}/bin/sparky-service-gui" /usr/bin/
    chmod 755 /usr/bin/sparky-service-manager
    chmod 755 /usr/bin/sparky-service-tui
    chmod 755 /usr/bin/sparky-service-gui

    # Update library paths in executables
    sed -i 's|LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"|LIB_DIR="/usr/lib/sparky-service-manager"|g' /usr/bin/sparky-service-tui
    sed -i 's|LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"|LIB_DIR="/usr/lib/sparky-service-manager"|g' /usr/bin/sparky-service-gui

    echo -e "${GREEN}✓ Scripts installed${NC}"
}

# Function to install desktop entry
install_desktop_entry() {
    echo -e "${YELLOW}Installing desktop entry...${NC}"

    # Create desktop file
    cat > /usr/share/applications/sparky-service-manager.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Sparky Service Manager
Name[es]=Gestor de Servicios Sparky
Name[fr]=Gestionnaire de Services Sparky
Name[de]=Sparky Dienst-Manager
Name[pt]=Gestor de Serviços Sparky
Name[it]=Gestore Servizi Sparky
Name[ru]=Менеджер Служб Sparky
Name[zh]=Sparky 服务管理器
Name[ja]=Sparky サービスマネージャー
Name[ar]=مدير خدمات Sparky
GenericName=Service Manager
GenericName[es]=Gestor de Servicios
GenericName[fr]=Gestionnaire de Services
GenericName[de]=Dienst-Manager
GenericName[pt]=Gestor de Serviços
GenericName[it]=Gestore Servizi
GenericName[ru]=Менеджер Служб
GenericName[zh]=服务管理器
GenericName[ja]=サービスマネージャー
GenericName[ar]=مدير الخدمات
Comment=Manage system services and schedule sound notifications
Comment[es]=Gestionar servicios del sistema y programar notificaciones de sonido
Comment[fr]=Gérer les services système et planifier des notifications sonores
Comment[de]=Systemdienste verwalten und Tonbenachrichtigungen planen
Comment[pt]=Gerenciar serviços do sistema e agendar notificações sonoras
Comment[it]=Gestire i servizi di sistema e pianificare notifiche sonore
Comment[ru]=Управление системными службами и планирование звуковых уведомлений
Comment[zh]=管理系统服务并安排声音通知
Comment[ja]=システムサービスを管理しサウンド通知をスケジュール
Comment[ar]=إدارة خدمات النظام وجدولة الإشعارات الصوتية
Exec=pkexec /usr/bin/sparky-service-manager --gui
Icon=preferences-system
Terminal=false
Categories=System;Settings;
Keywords=service;systemd;manager;sound;notification;schedule;
EOF

    chmod 644 /usr/share/applications/sparky-service-manager.desktop

    echo -e "${GREEN}✓ Desktop entry installed${NC}"
}

# Function to create polkit policy
install_polkit_policy() {
    echo -e "${YELLOW}Installing polkit policy...${NC}"

    cat > /usr/share/polkit-1/actions/org.sparkyos.service-manager.policy << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="org.sparkyos.service-manager">
    <description>Run Sparky Service Manager</description>
    <message>Authentication is required to manage system services</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_admin</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/sparky-service-manager</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>
</policyconfig>
EOF

    chmod 644 /usr/share/polkit-1/actions/org.sparkyos.service-manager.policy

    echo -e "${GREEN}✓ Polkit policy installed${NC}"
}

# Function to create configuration directories
create_config_dirs() {
    echo -e "${YELLOW}Creating configuration directories...${NC}"

    mkdir -p /etc/sparky-service-manager/sounds
    mkdir -p /usr/share/sounds/sparky

    # Create sample configuration files
    cat > /etc/sparky-service-manager/README << 'EOF'
SparkyOS Service Manager Configuration

This directory contains configuration files for the Sparky Service Manager.

Files:
- services.conf: List of monitored services
- tunes.conf: Scheduled sound notifications

Format for services.conf:
service_name:enabled

Format for tunes.conf:
service_name:HH:MM:sound_file:days

Where days can be:
- * for all days
- 0-6 (0=Sunday, 6=Saturday)
- Multiple days separated by commas (e.g., 1,3,5 for Mon, Wed, Fri)

Custom sound files can be placed in:
/etc/sparky-service-manager/sounds/
EOF

    chmod 755 /etc/sparky-service-manager
    chmod 755 /etc/sparky-service-manager/sounds
    chmod 644 /etc/sparky-service-manager/README

    echo -e "${GREEN}✓ Configuration directories created${NC}"
}

# Function to install sample sounds
install_sample_sounds() {
    echo -e "${YELLOW}Setting up sound files...${NC}"

    # Create symlinks to system sounds if they exist
    if [ -d /usr/share/sounds/freedesktop/stereo ]; then
        for sound in /usr/share/sounds/freedesktop/stereo/*.oga; do
            if [ -f "$sound" ]; then
                ln -sf "$sound" "/usr/share/sounds/sparky/" 2>/dev/null || true
            fi
        done
    fi

    echo -e "${GREEN}✓ Sound files configured${NC}"
}

# Function to display completion message
show_completion() {
    echo ""
    echo -e "${GREEN}=== Installation Complete ===${NC}"
    echo ""
    echo "The SparkyOS Service Manager has been successfully installed!"
    echo ""
    echo "Usage:"
    echo "  • From command line (auto-detect): sudo sparky-service-manager"
    echo "  • Force GUI mode: sudo sparky-service-manager --gui"
    echo "  • Force TUI mode: sudo sparky-service-manager --tui"
    echo "  • From application menu: Search for 'Sparky Service Manager'"
    echo ""
    echo "Features:"
    echo "  ✓ Multi-language support (40+ languages)"
    echo "  ✓ Service management (start, stop, restart, enable, disable)"
    echo "  ✓ Service monitoring"
    echo "  ✓ Time-based sound notifications"
    echo "  ✓ Works in any Desktop Environment"
    echo ""
    echo "Configuration files:"
    echo "  • /etc/sparky-service-manager/services.conf"
    echo "  • /etc/sparky-service-manager/tunes.conf"
    echo "  • /etc/sparky-service-manager/sounds/ (custom sounds)"
    echo ""
    echo "For help: sparky-service-manager --help"
    echo ""
}

# Uninstall function
uninstall() {
    echo -e "${YELLOW}Uninstalling SparkyOS Service Manager...${NC}"

    # Remove executables
    rm -f /usr/bin/sparky-service-manager
    rm -f /usr/bin/sparky-service-tui
    rm -f /usr/bin/sparky-service-gui

    # Remove libraries
    rm -rf /usr/lib/sparky-service-manager

    # Remove desktop entry
    rm -f /usr/share/applications/sparky-service-manager.desktop

    # Remove polkit policy
    rm -f /usr/share/polkit-1/actions/org.sparkyos.service-manager.policy

    # Ask about configuration
    read -p "Remove configuration files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf /etc/sparky-service-manager
        rm -rf /usr/share/sounds/sparky
        rm -f /etc/cron.d/sparky-service-tunes
        echo -e "${GREEN}✓ Configuration removed${NC}"
    else
        echo -e "${YELLOW}Configuration preserved in /etc/sparky-service-manager${NC}"
    fi

    echo -e "${GREEN}✓ Uninstallation complete${NC}"
}

# Main installation
main() {
    if [ "$1" = "uninstall" ]; then
        uninstall
    else
        install_dependencies
        install_scripts
        install_desktop_entry
        install_polkit_policy
        create_config_dirs
        install_sample_sounds
        show_completion
    fi
}

main "$@"
