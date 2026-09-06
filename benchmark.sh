#!/bin/bash
# Benchmark all Advent of Code solutions
# Usage: ./benchmark.sh [year]

set -e

# Export AOC_SESSION for InputUtils
export AOC_SESSION="${AOC_SESSION:-}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to time a solution
time_solution() {
    local file=$1
    local func=$2
    local year=$(basename $(dirname "$file"))
    local day=$(basename "$file" .hs | sed 's/Day//')
    
    # Run with timeout of 30 seconds
    local start=$(date +%s%N)
    local result=$(timeout 30s ghc -e "$func" "$file" 2>&1 || echo "TIMEOUT_OR_ERROR")
    local end=$(date +%s%N)
    
    # Calculate time in milliseconds
    local time_ms=$(( (end - start) / 1000000 ))
    
    # Check if it succeeded
    if [[ "$result" == "TIMEOUT_OR_ERROR" ]] || [[ -z "$result" ]]; then
        echo "$year,$day,$func,ERROR,0"
    else
        echo "$year,$day,$func,$time_ms,$result"
    fi
}

# Main benchmarking
echo "year,day,part,time_ms,result" > benchmark_results.csv

YEARS="${1:-2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025}"

for year in $YEARS; do
    if [ ! -d "$year" ]; then
        echo "Skipping $year (directory not found)"
        continue
    fi
    
    echo -e "${GREEN}Benchmarking $year...${NC}"
    
    for day in {1..25}; do
        file="$year/Day$day.hs"
        
        if [ ! -f "$file" ]; then
            continue
        fi
        
        echo -n "  Day $day: "
        
        # Determine function names (2015 uses different naming)
        if [ "$year" = "2015" ]; then
            # Check if file uses day1part1 naming
            if grep -q "day${day}part1" "$file" 2>/dev/null; then
                func1="day${day}part1"
                func2="day${day}part2"
            else
                func1="part1"
                func2="part2"
            fi
        else
            func1="part1"
            func2="part2"
        fi
        
        # Time part 1
        result1=$(time_solution "$file" "$func1")
        echo "$result1" >> benchmark_results.csv
        time1=$(echo "$result1" | cut -d',' -f4)
        
        # Time part 2
        result2=$(time_solution "$file" "$func2")
        echo "$result2" >> benchmark_results.csv
        time2=$(echo "$result2" | cut -d',' -f4)
        
        # Color code based on time
        if [ "$time1" != "ERROR" ] && [ "$time2" != "ERROR" ]; then
            total=$((time1 + time2))
            if [ $total -lt 100 ]; then
                echo -e "${GREEN}✓${NC} (${time1}ms + ${time2}ms)"
            elif [ $total -lt 1000 ]; then
                echo -e "${YELLOW}~${NC} (${time1}ms + ${time2}ms)"
            else
                echo -e "${RED}!${NC} (${time1}ms + ${time2}ms)"
            fi
        else
            echo -e "${RED}ERROR${NC}"
        fi
    done
done

echo ""
echo "Results saved to benchmark_results.csv"
echo ""
echo "Summary:"
echo "--------"

# Count errors
errors=$(grep -c "ERROR" benchmark_results.csv || true)
echo "Errors: $errors"

# Find slowest solutions
echo ""
echo "Top 10 slowest solutions:"
tail -n +2 benchmark_results.csv | grep -v "ERROR" | sort -t',' -k4 -rn | head -10 | \
    awk -F',' '{printf "  %s Day %s Part %s: %d ms\n", $1, $2, substr($3,5), $4}'
