#!/bin/bash

OUTPUT_FILE="log.csv"
INTERVAL=5        # seconds
DURATION=300      # 5 minutes
ITERATIONS=$((DURATION / INTERVAL))

# Write CSV header
echo "Time,CPU,MEMORY" > "$OUTPUT_FILE"

time_elapsed=0

for ((i=1; i<=ITERATIONS; i++)); do

    # --- Get CPU usage (%)
    # uptime output example: "load average: 0.35, 0.40, 0.45"
    load_avg=$(uptime | awk -F 'load average:' '{ print $2 }' | awk '{ print $1 }' | sed 's/,//')
    cpu_usage=$(echo "$load_avg * 100" | bc -l)

    # --- Get Memory usage (%)
    # free output contains total and used memory
    mem_usage=$(free | awk '/Mem:/ { printf("%.2f", $3/$2 * 100) }')

    # Write values to CSV
    printf "%s,%.2f,%.2f\n" "$time_elapsed" "$cpu_usage" "$mem_usage" >> "$OUTPUT_FILE"

    # Wait for next interval
    sleep "$INTERVAL"
    time_elapsed=$((time_elapsed + INTERVAL))

done
