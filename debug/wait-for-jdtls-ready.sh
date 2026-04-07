#!/bin/bash
# Wait for JDTLS to finish indexing and notify when ready
# Usage: ./wait-for-jdtls-ready.sh [threshold_cpu]

set -e

THRESHOLD=${1:-20}  # Default: wait for CPU < 20%
CHECK_INTERVAL=5    # Check every 5 seconds
STABLE_COUNT=3      # Must stay below threshold for 3 checks

echo "=== JDTLS Indexing Monitor ==="
echo "Waiting for CPU to drop below ${THRESHOLD}%..."
echo "Will check every ${CHECK_INTERVAL} seconds"
echo ""

# Find JDTLS process
JDTLS_PID=$(pgrep -f "java.*eclipse.jdt.ls" | head -1)

if [ -z "$JDTLS_PID" ]; then
    echo "❌ JDTLS process not found. Is Emacs running with a Java file open?"
    exit 1
fi

echo "Monitoring JDTLS PID: $JDTLS_PID"
echo ""

STABLE_CHECKS=0
START_TIME=$(date +%s)

while true; do
    # Check if process still exists
    if ! ps -p $JDTLS_PID > /dev/null 2>&1; then
        echo ""
        echo "❌ JDTLS process terminated"
        exit 1
    fi

    # Get current CPU usage
    CPU=$(ps -p $JDTLS_PID -o %cpu --no-headers | tr -d ' ' | cut -d. -f1)

    # Handle empty or invalid CPU value
    if [ -z "$CPU" ]; then
        CPU=0
    fi

    ELAPSED=$(($(date +%s) - START_TIME))
    MINS=$((ELAPSED / 60))
    SECS=$((ELAPSED % 60))

    if [ "$CPU" -lt "$THRESHOLD" ]; then
        STABLE_CHECKS=$((STABLE_CHECKS + 1))
        printf "\r[%02d:%02d] CPU: %3d%% ✓ Below threshold (%d/%d stable checks)" \
            $MINS $SECS $CPU $STABLE_CHECKS $STABLE_COUNT

        if [ $STABLE_CHECKS -ge $STABLE_COUNT ]; then
            echo ""
            echo ""
            echo "================================================"
            echo "🎉 JDTLS is ready!"
            echo "================================================"
            echo "CPU settled at: ${CPU}%"
            echo "Total time: ${MINS}m ${SECS}s"

            # Send desktop notification if notify-send is available
            if command -v notify-send &> /dev/null; then
                notify-send -u normal -t 5000 \
                    "JDTLS Ready" \
                    "Indexing complete! CPU: ${CPU}%"
            fi

            # Play a beep if available
            if command -v paplay &> /dev/null; then
                paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
            elif command -v beep &> /dev/null; then
                beep -f 800 -l 200 2>/dev/null &
            fi

            echo ""
            echo "You can now use JDTLS without performance issues."
            exit 0
        fi
    else
        STABLE_CHECKS=0
        printf "\r[%02d:%02d] CPU: %3d%% ⚙️  Indexing..." $MINS $SECS $CPU
    fi

    sleep $CHECK_INTERVAL
done
