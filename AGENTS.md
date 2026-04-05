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

### Caveats

- Files with very large inline data (e.g., `2020/Day4.hs` at 35KB, `2020/Day11.hs` at 54KB) can take minutes to compile in GHCi. This is expected.
- Only standard library imports are used (`Data.List`, `Data.Map`, `Data.Maybe`) — no external packages needed.
- There are no automated tests, linters, or build steps. "Testing" means evaluating the solution functions and checking they return numeric results.
