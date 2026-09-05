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

### Automatic Input Fetching

The `InputUtils` module supports automatic input fetching from adventofcode.com when input files don't exist locally. Set the `AOC_SESSION` environment variable to your session cookie:

```bash
export AOC_SESSION="your_session_cookie_here"
```

When you run a solution, it will automatically download missing inputs. Downloaded inputs are saved to the `inputs/` directory for future use.

**Note**: `inputs/` is in `.gitignore` to avoid committing personal puzzle data to the repository.

## Progress

### 2020
- **All 25 days: ✅ Complete** with real puzzle inputs

### 2021
- Day 1: ✅ Complete

### 2015
- Days 1-2: ✅ Complete

## Dependencies

Solutions use only Haskell standard library with a few common additions (no external packages required):
- `Data.List`, `Data.Map`, `Data.Set`, `Data.IntMap`
- `Data.Maybe`, `Data.Ord`, `Data.Char`, `Data.Bits`
- `Text.Regex`
- `System.IO.Unsafe` (for input loading)
- `System.Directory`, `System.Environment`, `System.Process` (for auto-fetching inputs)

Files compile with GHC and load cleanly into GHCi.
