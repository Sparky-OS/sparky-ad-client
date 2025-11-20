# CLAUDE.md - AI Assistant Guide for Sparky AD Client

This document provides comprehensive guidance for AI assistants working with the Sparky AD Client codebase.

## Project Overview

**Sparky AD Client** is a collection of Bash scripts designed to automate the integration of SparkyLinux machines with Windows Server Active Directory (AD) domains. The project simplifies domain joining, configuration, and management for SparkyLinux client stations.

### Key Information
- **Language**: Bash (shell scripts)
- **License**: GNU GPL v3
- **Platform**: SparkyLinux (Debian-based)
- **Primary Purpose**: Active Directory domain integration for Linux clients
- **Total Lines of Code**: ~353 lines across main scripts
- **Authors**: Paweł Pijanowski "pavroo" & Daniel Campos Ramos "Capitain_Jack"

## Repository Structure

```
sparky-ad-client/
├── README.md                          # User-facing documentation
├── bin/                               # Executable scripts
│   ├── sparky-ad-client              # Main AD join script (must run as root)
│   ├── sparky-ad-leave               # AD domain leave script
│   └── sparky-client-tests           # AD integration verification tests
├── etc/                               # Configuration files
│   ├── init.d/
│   │   └── host_file_update          # Init script for /etc/hosts management
│   ├── issue                          # Login banner (pre-login)
│   ├── issue.net                      # Network login banner
│   ├── issue.mgetty                   # Mgetty login banner
│   ├── motd                           # Message of the day (post-login)
│   └── update-motd.d/
│       └── 10-uname                   # Dynamic MOTD component
└── lib/
    └── systemd/
        └── system/
            └── host_file_update.service  # Systemd service unit
```

## Core Components

### 1. sparky-ad-client (bin/sparky-ad-client)
**Purpose**: Automates joining a SparkyLinux machine to an AD domain.

**Key Operations**:
- Installs comprehensive prerequisite packages (Samba, SSSD, Kerberos, etc.)
- Backs up existing Samba configuration
- Configures DNS settings for AD integration
- Discovers and joins the AD domain using `realm`
- Configures NSS, PAM, and authentication modules
- Sets up home directory auto-creation for domain users
- Grants sudo privileges to Domain Admins group

**Important Notes**:
- Must be run with sudo/root privileges
- Interactively prompts for AD server IP, domain name, and TLD
- Backs up all existing Samba databases (.tdb and .ldb files)
- Modifies critical system files: /etc/nsswitch.conf, /etc/pam.d/*, /etc/sudoers
- Line 19: Contains a massive aptitude install command with 100+ packages

**Dependencies**: apt, bash, coreutils, dpkg, dialog, gawk, grep, hostname, nano, iputils-ping, sed, sudo

### 2. sparky-ad-leave (bin/sparky-ad-leave)
**Purpose**: Disconnects machine from AD domain and reverts configuration changes.

**Key Operations**:
- Uses `realm leave` to remove machine from domain
- Reverts changes to /etc/nsswitch.conf
- Removes PAM configurations for domain users
- Removes Domain Admins from sudoers
- Cleans up home directory auto-creation settings

**Important Notes**:
- Hardcoded domain reference: `mybusiness.intranet` (line 10)
- This should be parameterized or made configurable for production use

### 3. sparky-client-tests (bin/sparky-client-tests)
**Purpose**: Verifies successful AD integration.

**Test Cases**:
1. Retrieves AD user information using `id` command
2. Tests user switching to domain account with `su`
3. Verifies home directory auto-creation
4. Confirms user security context

**Important Notes**:
- Contains hardcoded test domain: `MYBUSINESS\administrator`
- Expected output is documented inline for verification

### 4. host_file_update (etc/init.d/host_file_update)
**Purpose**: Dynamically updates /etc/hosts file with current DHCP-assigned IP addresses.

**Key Operations**:
- Retrieves current IPv4 and IPv6 addresses
- Rebuilds /etc/hosts file with current network configuration
- Ensures FQDN resolution works correctly
- Handles both start and stop actions

**Important Notes**:
- Uses legacy init.d format (LSB-compliant)
- Managed by systemd service: host_file_update.service
- Critical for AD integration where hostname resolution is important
- Uses `ifconfig` (deprecated, but still functional)

## Development Workflows

### Installation Process
The scripts are designed to be installed system-wide, though the current repository doesn't include an `install.sh` script (mentioned in README but not present in repo).

**Expected Installation Steps** (per README):
```bash
sudo ./install.sh           # Install scripts
sudo ./install.sh uninstall # Uninstall scripts
```

### Usage Workflow
1. **Join AD Domain**:
   ```bash
   sudo ./sparky-ad-client
   ```
   - Script prompts for AD server IP
   - Script prompts for domain name (lowercase)
   - Script prompts for TLD (lowercase)
   - Script discovers domain and requests confirmation
   - Script configures system and joins domain

2. **Verify Integration**:
   ```bash
   sudo ./sparky-client-tests
   ```

3. **Leave AD Domain**:
   ```bash
   sudo ./sparky-ad-leave
   ```

## Key Conventions for AI Assistants

### Code Style
1. **Bash Best Practices**:
   - Scripts use `#!/bin/bash` shebang
   - Variables use mixed case (e.g., `ADIP`, `myHostName`, `DOMAIN`)
   - User input collected with `read` command
   - Extensive comments explaining each operation

2. **Variable Naming**:
   - UPPERCASE for user-provided configuration (ADIP, DOMAIN, TLD)
   - camelCase for derived values (myHostName, myFQDN)
   - Mixed convention (consider standardizing in future updates)

3. **Comments**:
   - Multi-line comments at file headers
   - Inline comments explain purpose of each command block
   - Good practice of documenting expected outputs

### Security Considerations

**CRITICAL - Handle with Care**:
- Scripts modify sensitive system files (/etc/sudoers, PAM configuration)
- Scripts require root privileges
- Scripts install 100+ packages (potential attack surface)
- Backup mechanisms are in place but rudimentary

**Security Review Items**:
1. Line 19 in sparky-ad-client: Massive package installation should be reviewed
2. Hardcoded credentials risk: Test scripts reference specific domain/user
3. No input validation on user-provided domain names and IPs
4. DNS configuration changes could break networking if misconfigured
5. sudoers modification grants broad privileges to Domain Admins

### Testing Approach

**When Modifying Scripts**:
1. Always test in a VM or non-production environment
2. Verify backup mechanisms work before making changes
3. Test both join and leave operations
4. Verify network connectivity is maintained
5. Confirm user authentication works after changes

**Manual Testing Checklist**:
- [ ] DNS resolution works (ping AD server)
- [ ] Domain discovery succeeds (realm discover)
- [ ] Domain join completes without errors
- [ ] AD users can be queried (id DOMAIN\\user)
- [ ] AD users can log in (su - DOMAIN\\user)
- [ ] Home directories are created automatically
- [ ] Domain users have appropriate permissions
- [ ] Leave operation cleanly reverts changes

### Common Issues and Solutions

1. **DNS Resolution Failures**:
   - Check /etc/dhcp/dhclient.conf for AD DNS server entry
   - Verify network connectivity to AD server
   - Restart networking service

2. **Domain Join Failures**:
   - Verify domain name spelling (case-sensitive)
   - Check administrator credentials
   - Ensure time synchronization with AD server (Kerberos requirement)

3. **Authentication Issues**:
   - Check /etc/sssd/sssd.conf configuration
   - Verify PAM modules are loaded correctly
   - Review /var/log/auth.log for errors

## File Modification Guidelines

### When Editing Scripts

1. **Preserve Root Requirement**:
   - All main scripts must run as root
   - Add validation at script start if missing

2. **Maintain Idempotency Where Possible**:
   - Check if operations have already been performed
   - Avoid duplicate entries in configuration files
   - Use sed with care (some operations use line numbers)

3. **Improve Error Handling**:
   - Current scripts have minimal error checking
   - Add `set -e` for fail-fast behavior where appropriate
   - Validate user input before using it
   - Check command exit codes before proceeding

4. **Configuration Files**:
   - etc/issue*: ASCII art login banners (modify with care)
   - etc/motd: Message shown after login
   - etc/init.d/host_file_update: LSB init script (consider systemd native)
   - lib/systemd/system/*.service: Systemd units

### Hardcoded Values to Parameterize

**High Priority**:
- `mybusiness.intranet` in sparky-ad-leave (line 10)
- `MYBUSINESS\\administrator` in sparky-client-tests (lines 14, 24, 35)

**Medium Priority**:
- Package list in sparky-ad-client (line 19) - consider external package list file
- Timeout values (if any are added)

### Adding New Features

**Recommended Enhancements**:
1. Create missing install.sh script (referenced in README)
2. Add configuration file support (e.g., /etc/sparky-ad-client.conf)
3. Add command-line argument parsing (currently all interactive)
4. Improve logging (currently uses echo, consider logger)
5. Add progress indicators for long operations
6. Implement rollback functionality if join fails
7. Add support for non-interactive mode (for automation)

**Coding Standards for New Code**:
- Follow existing comment style (explain why, not just what)
- Add error handling for all external commands
- Validate all user input
- Use meaningful variable names
- Add to sparky-client-tests for verification

## Dependencies and Package Management

### Core Dependencies
Listed in README.md and script comments:
- apt, bash, coreutils, dialog, dpkg, gawk, grep
- hostname, iputils-ping, nano, sed, sudo

### AD Integration Packages (installed by sparky-ad-client)
Key packages:
- **Samba**: samba, samba-common, smbclient, winbind
- **SSSD**: sssd, sssd-tools, libnss-sss, libpam-sss
- **Kerberos**: (mentioned but specific package TBD)
- **Realm**: realmd (for domain discovery and joining)
- **Authentication**: adcli, libnss-winbind, libpam-winbind

### Desktop Environment Packages
Large installation includes:
- KDE Plasma desktop components
- Office suite (LibreOffice)
- Graphics tools (GIMP, Inkscape)
- Hardware support (firmware packages)
- Network tools

**Note**: The massive package list (line 19) may need review - not all packages are strictly necessary for AD integration.

## Git Workflow

### Branch Strategy
- Main branch: Default branch for stable releases
- Feature branches: Use descriptive names (e.g., `feature/add-config-file`)
- Fix branches: Use format `fix/issue-description`
- Claude branches: Follow pattern `claude/claude-md-*` (current: `claude/claude-md-mi7zofyklzahue1a-01Uj55AZNJD3mMD9HUehyW1g`)

### Commit Guidelines
1. Use clear, descriptive commit messages
2. Reference issues if applicable
3. Group related changes in single commits
4. Test changes before committing

### Current Branch
Working on: `claude/claude-md-mi7zofyklzahue1a-01Uj55AZNJD3mMD9HUehyW1g`

## Important Files Reference

| File | Purpose | Modify with Caution |
|------|---------|-------------------|
| bin/sparky-ad-client | Main join script | HIGH - System critical |
| bin/sparky-ad-leave | Domain leave script | HIGH - System critical |
| bin/sparky-client-tests | Verification tests | LOW - Safe to modify |
| etc/init.d/host_file_update | /etc/hosts updater | MEDIUM - Network critical |
| lib/systemd/system/host_file_update.service | Systemd unit | MEDIUM - Service config |
| etc/issue* | Login banners | LOW - Cosmetic |
| etc/motd | Post-login message | LOW - Cosmetic |

## Known Issues and TODOs

1. **Missing install.sh**: Referenced in README but not present in repository
2. **Hardcoded domains**: Test scripts and leave script have hardcoded domain names
3. **No configuration file**: All configuration is interactive or hardcoded
4. **Limited error handling**: Scripts proceed even if commands fail
5. **Deprecated commands**: Uses `ifconfig` instead of `ip` command
6. **Line number dependencies**: sed commands use line numbers which are fragile
7. **No rollback mechanism**: If join fails partway through, manual cleanup required
8. **Package list maintenance**: 100+ package list is difficult to maintain

## Quick Reference Commands

```bash
# View script details
head -20 bin/sparky-ad-client        # View script header and license
grep "^#" bin/sparky-ad-client       # View all comments

# Test syntax
bash -n bin/sparky-ad-client         # Syntax check without execution

# View system modifications
grep -E "(sed|echo.*>>)" bin/sparky-ad-client  # Find file modifications

# Check service status
systemctl status host_file_update.service      # Check systemd service

# View logs (after running)
journalctl -u host_file_update.service         # Systemd logs
tail -f /var/log/auth.log                       # Authentication logs
```

## Resources and Documentation

- **README.md**: User-facing installation and usage guide
- **Inline Comments**: Extensive documentation within scripts
- **SparkyLinux**: https://sparkylinux.org/
- **Samba AD Integration**: https://wiki.samba.org/
- **SSSD Documentation**: https://sssd.io/
- **Realm Documentation**: Part of realmd package

## Contact and Contributing

For questions about this codebase:
- Review inline script comments for implementation details
- Check README.md for user-facing documentation
- Examine test scripts for expected behavior
- Original authors: Paweł Pijanowski "pavroo" <pavroo@onet.eu> & Daniel Campos Ramos "Capitain_Jack"

---

**Last Updated**: 2025-11-20
**For**: AI Assistant (Claude) working with sparky-ad-client repository
**Document Version**: 1.0
