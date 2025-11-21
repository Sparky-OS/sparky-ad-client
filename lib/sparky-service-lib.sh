#!/bin/bash
# sparky-service-lib.sh - Service management library for SparkyOS
# Copyright SparkyOS Team
# Under the GNU GPL3 License
#
# This library provides service management and tune scheduling functions
# Last update 2025/11/21

# Configuration directory and files
SPARKY_CONFIG_DIR="/etc/sparky-service-manager"
SPARKY_CONFIG_FILE="${SPARKY_CONFIG_DIR}/services.conf"
SPARKY_TUNE_CONFIG="${SPARKY_CONFIG_DIR}/tunes.conf"
SPARKY_SOUNDS_DIR="/usr/share/sounds/sparky"
SPARKY_CUSTOM_SOUNDS_DIR="${SPARKY_CONFIG_DIR}/sounds"

# Initialize configuration directories
init_config() {
    if [ ! -d "$SPARKY_CONFIG_DIR" ]; then
        mkdir -p "$SPARKY_CONFIG_DIR"
        chmod 755 "$SPARKY_CONFIG_DIR"
    fi

    if [ ! -d "$SPARKY_CUSTOM_SOUNDS_DIR" ]; then
        mkdir -p "$SPARKY_CUSTOM_SOUNDS_DIR"
        chmod 755 "$SPARKY_CUSTOM_SOUNDS_DIR"
    fi

    if [ ! -f "$SPARKY_CONFIG_FILE" ]; then
        touch "$SPARKY_CONFIG_FILE"
        chmod 644 "$SPARKY_CONFIG_FILE"
    fi

    if [ ! -f "$SPARKY_TUNE_CONFIG" ]; then
        touch "$SPARKY_TUNE_CONFIG"
        chmod 644 "$SPARKY_TUNE_CONFIG"
    fi
}

# Get list of all systemd services
get_all_services() {
    systemctl list-unit-files --type=service --no-pager --no-legend | \
        awk '{print $1}' | \
        sed 's/.service$//' | \
        sort
}

# Get list of running services
get_running_services() {
    systemctl list-units --type=service --state=running --no-pager --no-legend | \
        awk '{print $1}' | \
        sed 's/.service$//' | \
        sort
}

# Get service status
get_service_status() {
    local service="$1"
    systemctl is-active "$service.service" 2>/dev/null
}

# Get service enabled status
get_service_enabled() {
    local service="$1"
    systemctl is-enabled "$service.service" 2>/dev/null
}

# Start a service
start_service() {
    local service="$1"
    systemctl start "$service.service"
    return $?
}

# Stop a service
stop_service() {
    local service="$1"
    systemctl stop "$service.service"
    return $?
}

# Restart a service
restart_service() {
    local service="$1"
    systemctl restart "$service.service"
    return $?
}

# Enable a service
enable_service() {
    local service="$1"
    systemctl enable "$service.service"
    return $?
}

# Disable a service
disable_service() {
    local service="$1"
    systemctl disable "$service.service"
    return $?
}

# Get monitored services from config
get_monitored_services() {
    if [ -f "$SPARKY_CONFIG_FILE" ]; then
        grep -v '^#' "$SPARKY_CONFIG_FILE" | grep -v '^$' | awk -F: '{print $1}'
    fi
}

# Add service to monitoring
add_monitored_service() {
    local service="$1"
    if ! grep -q "^${service}:" "$SPARKY_CONFIG_FILE" 2>/dev/null; then
        echo "${service}:enabled" >> "$SPARKY_CONFIG_FILE"
        return 0
    fi
    return 1
}

# Remove service from monitoring
remove_monitored_service() {
    local service="$1"
    if [ -f "$SPARKY_CONFIG_FILE" ]; then
        sed -i "/^${service}:/d" "$SPARKY_CONFIG_FILE"
        return 0
    fi
    return 1
}

# Check if service is monitored
is_service_monitored() {
    local service="$1"
    grep -q "^${service}:" "$SPARKY_CONFIG_FILE" 2>/dev/null
    return $?
}

# Get available sound files
get_available_sounds() {
    local sounds=""

    # System sounds
    if [ -d "$SPARKY_SOUNDS_DIR" ]; then
        sounds="${sounds}$(find "$SPARKY_SOUNDS_DIR" -type f \( -name "*.wav" -o -name "*.ogg" -o -name "*.mp3" \) -printf "%f\n" 2>/dev/null)"
    fi

    # Custom sounds
    if [ -d "$SPARKY_CUSTOM_SOUNDS_DIR" ]; then
        sounds="${sounds}
$(find "$SPARKY_CUSTOM_SOUNDS_DIR" -type f \( -name "*.wav" -o -name "*.ogg" -o -name "*.mp3" \) -printf "%f\n" 2>/dev/null)"
    fi

    # Common system sounds
    for sounddir in /usr/share/sounds/freedesktop/stereo /usr/share/sounds; do
        if [ -d "$sounddir" ]; then
            sounds="${sounds}
$(find "$sounddir" -type f \( -name "*.wav" -o -name "*.ogg" -o -name "*.oga" \) -printf "%f\n" 2>/dev/null)"
        fi
    done

    echo "$sounds" | grep -v '^$' | sort -u
}

# Get full path to sound file
get_sound_path() {
    local sound_name="$1"

    # Check custom sounds first
    if [ -f "${SPARKY_CUSTOM_SOUNDS_DIR}/${sound_name}" ]; then
        echo "${SPARKY_CUSTOM_SOUNDS_DIR}/${sound_name}"
        return 0
    fi

    # Check system sounds
    if [ -f "${SPARKY_SOUNDS_DIR}/${sound_name}" ]; then
        echo "${SPARKY_SOUNDS_DIR}/${sound_name}"
        return 0
    fi

    # Search in common locations
    for sounddir in /usr/share/sounds/freedesktop/stereo /usr/share/sounds; do
        local found=$(find "$sounddir" -type f -name "$sound_name" 2>/dev/null | head -n1)
        if [ -n "$found" ]; then
            echo "$found"
            return 0
        fi
    done

    return 1
}

# Play a sound file
play_sound() {
    local sound_file="$1"

    # Try different audio players
    if command -v paplay &>/dev/null; then
        paplay "$sound_file" &>/dev/null &
    elif command -v aplay &>/dev/null; then
        aplay "$sound_file" &>/dev/null &
    elif command -v mpg123 &>/dev/null; then
        mpg123 -q "$sound_file" &>/dev/null &
    elif command -v ffplay &>/dev/null; then
        ffplay -nodisp -autoexit "$sound_file" &>/dev/null &
    else
        return 1
    fi

    return 0
}

# Add tune schedule
# Format: service:time:sound:days
# Days: 0-6 (0=Sunday) or * for all days
add_tune_schedule() {
    local service="$1"
    local time="$2"
    local sound="$3"
    local days="${4:-*}"

    # Validate time format (HH:MM)
    if ! [[ "$time" =~ ^([0-1][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
        return 1
    fi

    # Remove existing entry for this service/time combination
    sed -i "/^${service}:${time}:/d" "$SPARKY_TUNE_CONFIG" 2>/dev/null

    # Add new entry
    echo "${service}:${time}:${sound}:${days}" >> "$SPARKY_TUNE_CONFIG"

    # Create/update cron job
    update_cron_jobs

    return 0
}

# Remove tune schedule
remove_tune_schedule() {
    local service="$1"
    local time="$2"

    sed -i "/^${service}:${time}:/d" "$SPARKY_TUNE_CONFIG" 2>/dev/null

    # Update cron jobs
    update_cron_jobs

    return 0
}

# Get tune schedules for a service
get_service_tunes() {
    local service="$1"

    if [ -f "$SPARKY_TUNE_CONFIG" ]; then
        grep "^${service}:" "$SPARKY_TUNE_CONFIG" 2>/dev/null
    fi
}

# Get all tune schedules
get_all_tunes() {
    if [ -f "$SPARKY_TUNE_CONFIG" ]; then
        grep -v '^#' "$SPARKY_TUNE_CONFIG" | grep -v '^$'
    fi
}

# Update cron jobs for scheduled tunes
update_cron_jobs() {
    local cron_file="/etc/cron.d/sparky-service-tunes"

    # Create cron file header
    cat > "$cron_file" << 'EOF'
# Sparky Service Manager - Automated tune schedules
# Do not edit manually - managed by sparky-service-manager
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

EOF

    # Add entries from tune config
    while IFS=: read -r service time sound days; do
        [ -z "$service" ] && continue
        [ "$service" = "#"* ] && continue

        local hour="${time%%:*}"
        local minute="${time##*:}"

        # Get sound file path
        local sound_path=$(get_sound_path "$sound")

        if [ -n "$sound_path" ]; then
            # Check if service is running before playing sound
            if [ "$days" = "*" ]; then
                echo "${minute} ${hour} * * * root systemctl is-active --quiet ${service}.service && (paplay '${sound_path}' || aplay '${sound_path}' || mpg123 -q '${sound_path}') 2>/dev/null" >> "$cron_file"
            else
                echo "${minute} ${hour} * * ${days} root systemctl is-active --quiet ${service}.service && (paplay '${sound_path}' || aplay '${sound_path}' || mpg123 -q '${sound_path}') 2>/dev/null" >> "$cron_file"
            fi
        fi
    done < "$SPARKY_TUNE_CONFIG"

    # Reload cron
    if command -v systemctl &>/dev/null; then
        systemctl reload cron 2>/dev/null || systemctl reload crond 2>/dev/null
    fi

    return 0
}

# Monitor service and play tune on status change
monitor_service_with_tune() {
    local service="$1"
    local sound="$2"
    local event="${3:-start}" # start, stop, restart

    local sound_path=$(get_sound_path "$sound")

    if [ -z "$sound_path" ]; then
        return 1
    fi

    # Create systemd drop-in for service monitoring
    local override_dir="/etc/systemd/system/${service}.service.d"
    mkdir -p "$override_dir"

    local override_file="${override_dir}/sparky-tune.conf"

    case "$event" in
        start)
            cat > "$override_file" << EOF
[Service]
ExecStartPost=/bin/bash -c 'sleep 1; paplay "${sound_path}" || aplay "${sound_path}" || mpg123 -q "${sound_path}"'
EOF
            ;;
        stop)
            cat > "$override_file" << EOF
[Service]
ExecStopPost=/bin/bash -c 'paplay "${sound_path}" || aplay "${sound_path}" || mpg123 -q "${sound_path}"'
EOF
            ;;
        restart)
            cat > "$override_file" << EOF
[Service]
ExecStartPost=/bin/bash -c 'sleep 1; paplay "${sound_path}" || aplay "${sound_path}" || mpg123 -q "${sound_path}"'
ExecStopPost=/bin/bash -c 'paplay "${sound_path}" || aplay "${sound_path}" || mpg123 -q "${sound_path}"'
EOF
            ;;
    esac

    # Reload systemd
    systemctl daemon-reload

    return 0
}

# Remove service monitoring tune
remove_service_monitor_tune() {
    local service="$1"

    local override_file="/etc/systemd/system/${service}.service.d/sparky-tune.conf"

    if [ -f "$override_file" ]; then
        rm -f "$override_file"

        # Remove directory if empty
        local override_dir=$(dirname "$override_file")
        rmdir "$override_dir" 2>/dev/null

        # Reload systemd
        systemctl daemon-reload

        return 0
    fi

    return 1
}

# Export configuration to readable format
export_config() {
    local output_file="${1:-/tmp/sparky-service-config.txt}"

    {
        echo "=== SparkyOS Service Manager Configuration ==="
        echo "Generated: $(date)"
        echo ""
        echo "=== Monitored Services ==="
        if [ -f "$SPARKY_CONFIG_FILE" ]; then
            cat "$SPARKY_CONFIG_FILE"
        else
            echo "None"
        fi
        echo ""
        echo "=== Tune Schedules ==="
        if [ -f "$SPARKY_TUNE_CONFIG" ]; then
            echo "Format: service:time:sound:days"
            cat "$SPARKY_TUNE_CONFIG"
        else
            echo "None"
        fi
    } > "$output_file"

    echo "$output_file"
}

# Validate dependencies
check_dependencies() {
    local missing=""

    for cmd in systemctl paplay aplay; do
        if ! command -v "$cmd" &>/dev/null; then
            missing="${missing} $cmd"
        fi
    done

    if [ -n "$missing" ]; then
        echo "Missing dependencies:$missing"
        return 1
    fi

    return 0
}

# Export functions
export -f init_config
export -f get_all_services
export -f get_running_services
export -f get_service_status
export -f get_service_enabled
export -f start_service
export -f stop_service
export -f restart_service
export -f enable_service
export -f disable_service
export -f get_monitored_services
export -f add_monitored_service
export -f remove_monitored_service
export -f is_service_monitored
export -f get_available_sounds
export -f get_sound_path
export -f play_sound
export -f add_tune_schedule
export -f remove_tune_schedule
export -f get_service_tunes
export -f get_all_tunes
export -f update_cron_jobs
export -f monitor_service_with_tune
export -f remove_service_monitor_tune
export -f export_config
export -f check_dependencies
