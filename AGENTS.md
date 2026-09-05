# AGENTS.md

## Cursor Cloud specific instructions

This is a Haskell Advent of Code solutions repository. There is no build system (no `.cabal`, `stack.yaml`, or `package.yaml`). Each `.hs` file is a standalone script.

### Running solutions

Files are meant to be loaded into GHCi. They export named expressions (not `main`). To evaluate a solution:

```
echo 'part1' | ghci -v0 2020/Day1.hs
```

Or use `ghc -e`:

```
ghc -e 'part1' 2020/Day1.hs
```

Function names vary by file — most use `part1`/`part2`, but 2015 files use `day1part1`/`day1part2` style names.

### Input System

Puzzle inputs are now stored in external files under `inputs/YEAR/dayN.txt` instead of being embedded as large literals in the `.hs` files. The shared `InputUtils.hs` module provides helper functions:

- `readInput year day` - reads entire input as string (with trailing newline stripped)
- `readInputLines year day` - reads input as list of lines
- `readInputInts year day` - reads input as list of integers (one per line)

Solutions use `unsafePerformIO` to load inputs at the top level, allowing pure function signatures while reading from files.

### Structure

```
.
├── InputUtils.hs        # Shared input loading utilities
├── 2020/
│   ├── Day1.hs         # Solution exports part1, part2
│   ├── Day2.hs
│   └── ...
├── inputs/
│   ├── 2020/
│   │   ├── day1.txt    # Puzzle input from adventofcode.com
│   │   ├── day2.txt
│   │   └── ...
│   └── 2021/
│       └── ...
```

### Caveats

- Only standard library imports are used (`Data.List`, `Data.Map`, `Data.Maybe`, `Text.Regex`) — no external packages needed.
- There are no automated tests, linters, or build steps. "Testing" means evaluating the solution functions and checking they return numeric results.
- Input files must be obtained from [adventofcode.com](https://adventofcode.com) (inputs are user-specific and not included in the repository).
