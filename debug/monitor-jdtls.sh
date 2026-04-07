#!/bin/bash
# Monitor JDTLS Language Server Performance
# Usage: ./monitor-jdtls.sh

set -e

echo "=== JDTLS Performance Monitor ==="
echo ""

# Find JDTLS process(es) - look for Java process with eclipse.jdt.ls
JDTLS_PIDS=$(pgrep -f "java.*eclipse.jdt.ls" || echo "")

if [ -z "$JDTLS_PIDS" ]; then
    echo "❌ JDTLS process not found. Is Emacs running with a Java file open?"
    exit 1
fi

# Count how many processes found
PID_COUNT=$(echo "$JDTLS_PIDS" | wc -l)

if [ "$PID_COUNT" -gt 1 ]; then
    echo "⚠️  Found multiple JDTLS processes:"
    echo "$JDTLS_PIDS" | while read pid; do
        echo "  - PID $pid: $(ps -p $pid -o args= | cut -c1-80)..."
    done
    echo ""
    echo "Monitoring the first process (PID: $(echo "$JDTLS_PIDS" | head -1))"
    echo "Note: Multiple instances may indicate multiple projects open"
    echo ""
fi

# Use the first PID if multiple found
JDTLS_PID=$(echo "$JDTLS_PIDS" | head -1)

echo "✓ Monitoring JDTLS process: PID $JDTLS_PID"
echo ""

# Get process info
echo "=== Process Information ==="
ps -p $JDTLS_PID -o pid,ppid,%cpu,%mem,vsz,rss,etime,args | head -2
echo ""

# Memory details
echo "=== Memory Usage ==="
RSS_KB=$(ps -p $JDTLS_PID -o rss= | tr -d ' ')
RSS_MB=$((RSS_KB / 1024))
RSS_GB=$(echo "scale=2; $RSS_KB / 1024 / 1024" | bc)
echo "RSS (Resident Set Size): ${RSS_MB} MB (${RSS_GB} GB)"

# Check against configured max (-Xmx8G)
MAX_HEAP_GB=8
USAGE_PCT=$(echo "scale=1; ($RSS_GB / $MAX_HEAP_GB) * 100" | bc)
echo "Heap usage: ${USAGE_PCT}% of configured max (${MAX_HEAP_GB}GB)"

if (( $(echo "$USAGE_PCT > 80" | bc -l) )); then
    echo "⚠️  WARNING: Memory usage > 80% - may need to increase -Xmx"
fi
echo ""

# Check workspace size
echo "=== Workspace Size ==="
WORKSPACE_DIR="$HOME/.emacs.d/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
    WORKSPACE_SIZE=$(du -sh "$WORKSPACE_DIR/.metadata" 2>/dev/null | cut -f1)
    echo "Workspace metadata: $WORKSPACE_SIZE"

    # Check for large metadata (> 1GB indicates possible issues)
    SIZE_MB=$(du -sm "$WORKSPACE_DIR/.metadata" 2>/dev/null | cut -f1)
    if [ "$SIZE_MB" -gt 1024 ]; then
        echo "⚠️  WARNING: Large workspace (${SIZE_MB}MB) - consider cleanup"
    fi
else
    echo "Workspace directory not found"
fi
echo ""

# Check recent errors in log
echo "=== Recent JDTLS Errors ==="
LOG_FILE="$HOME/.emacs.d/workspace/.metadata/.log"
if [ -f "$LOG_FILE" ]; then
    ERROR_COUNT=$(grep -c "!MESSAGE" "$LOG_FILE" 2>/dev/null || echo "0")
    echo "Total error messages: $ERROR_COUNT"

    echo ""
    echo "Last 5 errors:"
    grep "!MESSAGE\|!STACK" "$LOG_FILE" 2>/dev/null | tail -10 || echo "No recent errors"
else
    echo "Log file not found (server may not have started yet)"
fi
echo ""

# Live monitoring option
echo "=== Live Monitoring ==="
echo "Press Ctrl+C to stop"
echo ""
printf "%-8s  %5s %5s  %7s  %s\n" "HH:MM:SS" "CPU%" "MEM%" "RSS(MB)" "Status"
echo "========================================================"

while true; do
    if ! ps -p $JDTLS_PID > /dev/null 2>&1; then
        echo "❌ JDTLS process terminated"
        exit 1
    fi

    STATS=$(ps -p $JDTLS_PID -o %cpu,%mem,rss --no-headers)
    CPU=$(echo $STATS | awk '{print $1}')
    MEM=$(echo $STATS | awk '{print $2}')
    RSS_MB=$(echo $STATS | awk '{print int($3/1024)}')

    # Determine status
    STATUS="✓ OK"
    if (( $(echo "$CPU > 150" | bc -l) )); then
        STATUS="⚠️  High CPU"
    fi
    if (( $(echo "$MEM > 15" | bc -l) )); then
        STATUS="⚠️  High Memory"
    fi

    printf "%s  %5.1f %5.1f  %7d  %s\n" \
        "$(date '+%H:%M:%S')" "$CPU" "$MEM" "$RSS_MB" "$STATUS"

    sleep 2
done
