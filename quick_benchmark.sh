#!/bin/bash
# Quick benchmark - measures compilation + execution time
set -e

export AOC_SESSION="${AOC_SESSION:-}"

echo "year,day,part,time_ms,status" > quick_results.csv

for year in 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025; do
    [ ! -d "$year" ] && continue
    echo "Benchmarking $year..."
    
    for day in {1..25}; do
        file="$year/Day$day.hs"
        [ ! -f "$file" ] && continue
        
        # Determine function names
        if [ "$year" = "2015" ] && grep -q "day${day}part" "$file" 2>/dev/null; then
            p1="day${day}part1"
            p2="day${day}part2"
        else
            p1="part1"
            p2="part2"
        fi
        
        # Time part 1
        start=$(date +%s%N)
        if timeout 10s ghc -e "$p1" "$file" >/dev/null 2>&1; then
            end=$(date +%s%N)
            time_ms=$(( (end - start) / 1000000 ))
            echo "$year,$day,part1,$time_ms,ok" >> quick_results.csv
            echo -n "."
        else
            echo "$year,$day,part1,0,error" >> quick_results.csv
            echo -n "E"
        fi
        
        # Time part 2
        start=$(date +%s%N)
        if timeout 10s ghc -e "$p2" "$file" >/dev/null 2>&1; then
            end=$(date +%s%N)
            time_ms=$(( (end - start) / 1000000 ))
            echo "$year,$day,part2,$time_ms,ok" >> quick_results.csv
            echo -n "."
        else
            echo "$year,$day,part2,0,error" >> quick_results.csv
            echo -n "E"
        fi
    done
    echo ""
done

echo ""
echo "Results in quick_results.csv"
echo "Slowest 15 solutions:"
grep ",ok$" quick_results.csv | sort -t',' -k4 -rn | head -15
