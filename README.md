# AdventOfCode-Haskell

My Haskell solutions for Advent of Code

## Structure

Each year has its own directory with solution files named `DayN.hs`. Puzzle inputs are stored in `inputs/YEAR/dayN.txt`.

## Running Solutions

Solutions are designed to be run with GHCi or `ghc -e`. Each file exports named functions (typically `part1` and `part2`):

```bash
# Using GHCi
echo 'part1' | ghci -v0 2020/Day1.hs

# Using ghc -e
ghc -e 'part1' 2020/Day1.hs
```

**Note:** 2015 solutions use a different naming convention (`day1part1`, `day1part2`, etc.)

## Input Files

Puzzle inputs are stored in the `inputs/` directory organized by year:
```
inputs/
  2015/
    day1.txt
    day2.txt
    ...
  2020/
    day1.txt
    day2.txt
    ...
```

Add your puzzle inputs from [adventofcode.com](https://adventofcode.com) to the appropriate files.

### Optional: Automatic Input Fetching

You can optionally set the `AOC_SESSION` environment variable to your Advent of Code session cookie to enable automatic input fetching (feature in `InputUtils.hs`). However, the current implementation focuses on manual input management via files.

## Progress

### 2020
- Days 1-11: ✅ Complete (Day 8 has placeholder structure)
- Days 12-25: 📝 Placeholder files created, awaiting implementation

### 2021
- Day 1: ✅ Complete

### 2015
- Days 1-2: ✅ Complete

## Dependencies

Solutions use only Haskell standard library (no Cabal/Stack required):
- `Data.List`
- `Data.Map`
- `Data.Maybe`
- `Text.Regex`

Files compile with GHC and load cleanly into GHCi.
