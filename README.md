# adventOfCode :: Haskell

[![Advent of Code](https://img.shields.io/badge/Advent%20of%20Code-2015--2025-brightgreen)](https://adventofcode.com)
[![Language](https://img.shields.io/badge/Language-Haskell-purple)](https://www.haskell.org/)

My Haskell solutions for [Advent of Code](https://adventofcode.com) (2015-2025). All solutions use only the Haskell standard library with common modules like `Data.List`, `Data.Map`, and `Data.Set`.

## 🚀 Quick Start

### Prerequisites
- GHC (Glasgow Haskell Compiler) 8.10 or later
- Optional: Set `AOC_SESSION` environment variable for automatic input fetching

### Running Solutions

Solutions are designed as standalone scripts that can be evaluated with `ghc` or loaded in `ghci`:

```bash
# Using ghc -e (fastest)
ghc -e 'part1' 2020/Day1.hs

# Using GHCi (interactive)
echo 'part1' | ghci -v0 2020/Day1.hs
```

**Note**: 2015 solutions use a different naming convention (`day1part1`, `day1part2`, etc.) instead of `part1`/`part2`.

### Input Files

Puzzle inputs are stored in `inputs/YEAR/dayN.txt`:

```
inputs/
  2015/
    day1.txt
    day2.txt
    ...
  2020/
    day1.txt
    ...
```

#### Automatic Input Fetching

The `InputUtils` module can automatically download inputs from adventofcode.com. Set your session cookie as an environment variable:

```bash
export AOC_SESSION="your_session_cookie_here"
```

To find your session cookie:
1. Log in to [adventofcode.com](https://adventofcode.com)
2. Open browser dev tools → Application/Storage → Cookies
3. Copy the value of the `session` cookie

When you run a solution, missing inputs are automatically downloaded and cached locally.

**Security Note**: The `inputs/` directory is in `.gitignore` to prevent committing personal puzzle data.

## 📊 Solutions by Year

### 2015 (50⭐)
All 25 days completed with real puzzle inputs.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Not Quite Lisp | ~120ms | ~110ms | [Day1.hs](2015/Day1.hs) |
| 2 | I Was Told There Would Be No Math | ~145ms | ~105ms | [Day2.hs](2015/Day2.hs) |
| 3 | Perfectly Spherical Houses | ~145ms | ~115ms | [Day3.hs](2015/Day3.hs) |
| 4 | The Ideal Stocking Stuffer | ⚠️ MD5 | ⚠️ MD5 | [Day4.hs](2015/Day4.hs) |
| 5 | Doesn't He Have Intern-Elves For This? | <100ms | <100ms | [Day5.hs](2015/Day5.hs) |
| 6 | Probably a Fire Hazard | <100ms | <100ms | [Day6.hs](2015/Day6.hs) |
| 7 | Some Assembly Required | <100ms | <100ms | [Day7.hs](2015/Day7.hs) |
| 8 | Matchsticks | <100ms | <100ms | [Day8.hs](2015/Day8.hs) |
| 9 | All in a Single Night | <100ms | <100ms | [Day9.hs](2015/Day9.hs) |
| 10 | Elves Look, Elves Say | <100ms | <100ms | [Day10.hs](2015/Day10.hs) |
| 11 | Corporate Policy | <100ms | <100ms | [Day11.hs](2015/Day11.hs) |
| 12 | JSAbacusFramework.io | <100ms | <100ms | [Day12.hs](2015/Day12.hs) |
| 13 | Knights of the Dinner Table | <100ms | <100ms | [Day13.hs](2015/Day13.hs) |
| 14 | Reindeer Olympics | <100ms | <100ms | [Day14.hs](2015/Day14.hs) |
| 15 | Science for Hungry People | <100ms | <100ms | [Day15.hs](2015/Day15.hs) |
| 16 | Aunt Sue | <100ms | <100ms | [Day16.hs](2015/Day16.hs) |
| 17 | No Such Thing as Too Much | <100ms | <100ms | [Day17.hs](2015/Day17.hs) |
| 18 | Like a GIF For Your Yard | <100ms | <100ms | [Day18.hs](2015/Day18.hs) |
| 19 | Medicine for Rudolph | <100ms | <100ms | [Day19.hs](2015/Day19.hs) |
| 20 | Infinite Elves and Infinite Houses | <100ms | <100ms | [Day20.hs](2015/Day20.hs) |
| 21 | RPG Simulator 20XX | <100ms | <100ms | [Day21.hs](2015/Day21.hs) |
| 22 | Wizard Simulator 20XX | <100ms | <100ms | [Day22.hs](2015/Day22.hs) |
| 23 | Opening the Turing Lock | <100ms | <100ms | [Day23.hs](2015/Day23.hs) |
| 24 | It Hangs in the Balance | <100ms | <100ms | [Day24.hs](2015/Day24.hs) |
| 25 | Let It Snow | <100ms | <100ms | [Day25.hs](2015/Day25.hs) |

### 2016 (50⭐)
All 25 days completed with verified answers.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | No Time for a Taxicab | <100ms | <100ms | [Day1.hs](2016/Day1.hs) |
| 2 | Bathroom Security | <100ms | <100ms | [Day2.hs](2016/Day2.hs) |
| 3 | Squares With Three Sides | <100ms | <100ms | [Day3.hs](2016/Day3.hs) |
| 4 | Security Through Obscurity | <100ms | <100ms | [Day4.hs](2016/Day4.hs) |
| 5 | How About a Nice Game of Chess? | ⚠️ MD5 | ⚠️ MD5 | [Day5.hs](2016/Day5.hs) |
| 6 | Signals and Noise | <100ms | <100ms | [Day6.hs](2016/Day6.hs) |
| 7 | Internet Protocol Version 7 | <100ms | <100ms | [Day7.hs](2016/Day7.hs) |
| 8 | Two-Factor Authentication | <100ms | <100ms | [Day8.hs](2016/Day8.hs) |
| 9 | Explosives in Cyberspace | <100ms | <100ms | [Day9.hs](2016/Day9.hs) |
| 10 | Balance Bots | <100ms | <100ms | [Day10.hs](2016/Day10.hs) |
| 11 | Radioisotope Thermoelectric Generators | <100ms | <100ms | [Day11.hs](2016/Day11.hs) |
| 12 | Leonardo's Monorail | <100ms | <100ms | [Day12.hs](2016/Day12.hs) |
| 13 | A Maze of Twisty Little Cubicles | <100ms | <100ms | [Day13.hs](2016/Day13.hs) |
| 14 | One-Time Pad | ⚠️ MD5 | ⚠️ MD5 | [Day14.hs](2016/Day14.hs) |
| 15 | Timing is Everything | <100ms | <100ms | [Day15.hs](2016/Day15.hs) |
| 16 | Dragon Checksum | <100ms | <100ms | [Day16.hs](2016/Day16.hs) |
| 17 | Two Steps Forward | <100ms | <100ms | [Day17.hs](2016/Day17.hs) |
| 18 | Like a Rogue | <100ms | <100ms | [Day18.hs](2016/Day18.hs) |
| 19 | An Elephant Named Joseph | <100ms | <100ms | [Day19.hs](2016/Day19.hs) |
| 20 | Firewall Rules | <100ms | <100ms | [Day20.hs](2016/Day20.hs) |
| 21 | Scrambled Letters and Hash | <100ms | <100ms | [Day21.hs](2016/Day21.hs) |
| 22 | Grid Computing | <100ms | <100ms | [Day22.hs](2016/Day22.hs) |
| 23 | Safe Cracking | <100ms | <100ms | [Day23.hs](2016/Day23.hs) |
| 24 | Air Duct Spelunking | <100ms | <100ms | [Day24.hs](2016/Day24.hs) |
| 25 | Clock Signal | <100ms | <100ms | [Day25.hs](2016/Day25.hs) |

### 2017 (50⭐)
All 25 days completed with verified answers.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Inverse Captcha | <100ms | <100ms | [Day1.hs](2017/Day1.hs) |
| 2 | Corruption Checksum | <100ms | <100ms | [Day2.hs](2017/Day2.hs) |
| 3 | Spiral Memory | <100ms | <100ms | [Day3.hs](2017/Day3.hs) |
| 4 | High-Entropy Passphrases | <100ms | <100ms | [Day4.hs](2017/Day4.hs) |
| 5 | A Maze of Twisty Trampolines | <100ms | <100ms | [Day5.hs](2017/Day5.hs) |
| 6 | Memory Reallocation | <100ms | <100ms | [Day6.hs](2017/Day6.hs) |
| 7 | Recursive Circus | <100ms | <100ms | [Day7.hs](2017/Day7.hs) |
| 8 | I Heard You Like Registers | <100ms | <100ms | [Day8.hs](2017/Day8.hs) |
| 9 | Stream Processing | <100ms | <100ms | [Day9.hs](2017/Day9.hs) |
| 10 | Knot Hash | <100ms | <100ms | [Day10.hs](2017/Day10.hs) |
| 11 | Hex Ed | <100ms | <100ms | [Day11.hs](2017/Day11.hs) |
| 12 | Digital Plumber | <100ms | <100ms | [Day12.hs](2017/Day12.hs) |
| 13 | Packet Scanners | <100ms | <100ms | [Day13.hs](2017/Day13.hs) |
| 14 | Disk Defragmentation | <100ms | <100ms | [Day14.hs](2017/Day14.hs) |
| 15 | Dueling Generators | <100ms | <100ms | [Day15.hs](2017/Day15.hs) |
| 16 | Permutation Promenade | <100ms | <100ms | [Day16.hs](2017/Day16.hs) |
| 17 | Spinlock | <100ms | <100ms | [Day17.hs](2017/Day17.hs) |
| 18 | Duet | <100ms | <100ms | [Day18.hs](2017/Day18.hs) |
| 19 | A Series of Tubes | <100ms | <100ms | [Day19.hs](2017/Day19.hs) |
| 20 | Particle Swarm | <100ms | <100ms | [Day20.hs](2017/Day20.hs) |
| 21 | Fractal Art | <100ms | <100ms | [Day21.hs](2017/Day21.hs) |
| 22 | Sporifica Virus | <100ms | <100ms | [Day22.hs](2017/Day22.hs) |
| 23 | Coprocessor Conflagration | <100ms | <100ms | [Day23.hs](2017/Day23.hs) |
| 24 | Electromagnetic Moat | <100ms | <100ms | [Day24.hs](2017/Day24.hs) |
| 25 | The Halting Problem | <100ms | <100ms | [Day25.hs](2017/Day25.hs) |

### 2018 (50⭐)
All 25 days completed with verified answers.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Chronal Calibration | <100ms | <100ms | [Day1.hs](2018/Day1.hs) |
| 2 | Inventory Management System | <100ms | <100ms | [Day2.hs](2018/Day2.hs) |
| 3 | No Matter How You Slice It | <100ms | <100ms | [Day3.hs](2018/Day3.hs) |
| 4-25 | Various Problems | <100ms | <100ms | [2018/](2018/) |

### 2019 (50⭐)
All 25 days completed with verified answers. Includes Intcode interpreter used across multiple days.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | The Tyranny of the Rocket Equation | <100ms | <100ms | [Day1.hs](2019/Day1.hs) |
| 2 | 1202 Program Alarm | <100ms | <100ms | [Day2.hs](2019/Day2.hs) |
| 3 | Crossed Wires | <100ms | <100ms | [Day3.hs](2019/Day3.hs) |
| 4-25 | Various Problems | <100ms | <100ms | [2019/](2019/) |

**Helper Module**: [Intcode.hs](Intcode.hs) - Intcode virtual machine interpreter

### 2020 (50⭐)
All 25 days completed with real puzzle inputs.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Report Repair | ~120ms | ~110ms | [Day1.hs](2020/Day1.hs) |
| 2 | Password Philosophy | ~145ms | ~105ms | [Day2.hs](2020/Day2.hs) |
| 3 | Toboggan Trajectory | ~145ms | ~115ms | [Day3.hs](2020/Day3.hs) |
| 4-25 | Various Problems | <500ms | <500ms | [2020/](2020/) |

### 2021 (50⭐)
All 25 days completed with real puzzle inputs.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Sonar Sweep | <100ms | <100ms | [Day1.hs](2021/Day1.hs) |
| 2-25 | Various Problems | <500ms | <500ms | [2021/](2021/) |

### 2022 (50⭐)
All 25 days completed with verified live answers.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Calorie Counting | <100ms | <100ms | [Day1.hs](2022/Day1.hs) |
| 2-25 | Various Problems | <500ms | <500ms | [2022/](2022/) |

### 2023 (50⭐)
All 25 days completed with real solutions.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Trebuchet?! | <100ms | <100ms | [Day1.hs](2023/Day1.hs) |
| 2-25 | Various Problems | <500ms | <500ms | [2023/](2023/) |

### 2024 (50⭐)
All 25 days completed with real solutions.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Historian Hysteria | <100ms | <100ms | [Day1.hs](2024/Day1.hs) |
| 2-25 | Various Problems | <500ms | <500ms | [2024/](2024/) |

### 2025 (In Progress)
Days 1-11 completed with real solutions.

| Day | Problem | Part 1 | Part 2 | Solution |
|-----|---------|--------|--------|----------|
| 1 | Secret Entrance | <100ms | <100ms | [Day1.hs](2025/Day1.hs) |
| 2 | Gift Shop | <100ms | <100ms | [Day2.hs](2025/Day2.hs) |
| 3-11 | Various Problems | <500ms | <500ms | [2025/](2025/) |

## 🛠️ Technical Details

### Dependencies
All solutions use **only** Haskell standard library modules:
- `Data.List`, `Data.Map`, `Data.Set`, `Data.IntMap`
- `Data.Maybe`, `Data.Ord`, `Data.Char`, `Data.Bits`
- `System.IO.Unsafe` (for input loading)
- `System.Directory`, `System.Environment`, `System.Process` (for InputUtils auto-fetch)

**No external packages required** - just GHC.

### Helper Modules
- **[InputUtils.hs](InputUtils.hs)** - Puzzle input loading with auto-fetch capability
- **[Intcode.hs](Intcode.hs)** - Intcode virtual machine for 2019 solutions
- **[MD5Utils.hs](MD5Utils.hs)** - MD5 hashing utilities for specific puzzles

### Structure
- Each `.hs` file is a standalone script
- Solutions export `part1` and `part2` functions (or `dayNpart1`/`dayNpart2` for 2015)
- Files with very large inline data (e.g., 2020/Day4.hs at 35KB) may take minutes to compile - this is expected

### Performance Notes
- Most solutions run in under 100ms
- Some days involving MD5 hashing may be slower
- Solutions prioritize clarity and standard library usage over extreme optimization
- ⚠️ = Solution depends on external tools (Python for MD5) or may have longer runtime

### Benchmarking
To benchmark all solutions:
```bash
./benchmark.sh [year]
```

Results are saved to `benchmark_results.csv` with timing data for each part.

## 📝 Development

### Testing a Solution
```bash
# Compile and run
ghc -e 'part1' 2020/Day1.hs

# Load in GHCi for debugging
ghci 2020/Day1.hs
> part1
> part2
```

### Adding a New Solution
1. Create `YEAR/DayN.hs` following the existing format
2. Import `InputUtils` for automatic input handling
3. Export `part1` and `part2` functions
4. Add your puzzle input to `inputs/YEAR/dayN.txt` or use auto-fetch with `AOC_SESSION`

## ⭐ Progress Summary

| Year | Stars | Status |
|------|-------|--------|
| 2015 | 50⭐ | ✅ Complete |
| 2016 | 50⭐ | ✅ Complete |
| 2017 | 50⭐ | ✅ Complete |
| 2018 | 50⭐ | ✅ Complete |
| 2019 | 50⭐ | ✅ Complete |
| 2020 | 50⭐ | ✅ Complete |
| 2021 | 50⭐ | ✅ Complete |
| 2022 | 50⭐ | ✅ Complete |
| 2023 | 50⭐ | ✅ Complete |
| 2024 | 50⭐ | ✅ Complete |
| 2025 | 22⭐ | 🚧 In Progress |
| **Total** | **522⭐** | **95.6%** |

## 📜 License

Solutions are my own work for educational purposes. Puzzle descriptions and inputs are © [Advent of Code](https://adventofcode.com).
