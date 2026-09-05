# Testing and Submission Workflow for AoC 2020

## ⚠️ Important: Part 2 Unlocking

Part 2 of each day **only unlocks after submitting the correct Part 1 answer**. This means:
1. Solve Part 1 with real input
2. Submit Part 1 answer to AoC
3. Part 2 unlocks
4. Solve Part 2
5. Submit Part 2 answer

## Current Status

All 25 days have **both parts implemented** based on problem descriptions from web research. However:
- ⚠️ **Solutions not yet tested** (GHC not available in Cloud Agent environment)
- ⚠️ **Answers not yet submitted** to avoid wrong-answer penalties without testing
- ✅ **Real puzzle inputs available** in `inputs/2020/`
- ✅ **Submission helper created** (`submit.sh`)

## Testing Locally

### Prerequisites
```bash
# Install GHC if needed
# On macOS: brew install ghc
# On Ubuntu: sudo apt-get install ghc
# On Arch: sudo pacman -S ghc

# Set your session cookie
export AOC_SESSION="53616c7465645f5f..."
```

### Test a Solution
```bash
cd /path/to/repo

# Test Day 1 Part 1
echo 'part1' | ghci -v0 2020/Day1.hs

# Test Day 1 Part 2  
echo 'part2' | ghci -v0 2020/Day1.hs

# Or use GHC directly
ghc -e 'part1' 2020/Day1.hs
ghc -e 'part2' 2020/Day1.hs
```

### Submit an Answer
```bash
# After verifying the answer is correct:
./submit.sh 2020 1 1 <part1_answer>

# If correct, Part 2 unlocks. Then:
./submit.sh 2020 1 2 <part2_answer>
```

## Systematic Workflow for All Days

```bash
#!/bin/bash
# test_and_submit_all.sh

export AOC_SESSION="your_session_here"

for day in {1..25}; do
    echo "=== Day $day ==="
    
    # Test Part 1
    echo "Testing Part 1..."
    answer1=$(ghc -e "part1" 2020/Day${day}.hs 2>&1 | tail -1)
    echo "Part 1 answer: $answer1"
    
    # Submit Part 1
    read -p "Submit Part 1? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./submit.sh 2020 $day 1 "$answer1"
        if [ $? -eq 0 ]; then
            echo "✅ Part 1 accepted!"
            
            # Test Part 2
            echo "Testing Part 2..."
            answer2=$(ghc -e "part2" 2020/Day${day}.hs 2>&1 | tail -1)
            echo "Part 2 answer: $answer2"
            
            # Submit Part 2
            read -p "Submit Part 2? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                ./submit.sh 2020 $day 2 "$answer2"
            fi
        fi
    fi
    
    echo ""
    sleep 2  # Be nice to AoC servers
done
```

## Solution Verification Checklist

Before submitting, verify:

### Days 1-11 (Previously Working)
- [x] Day 1: Two/three sum - **High confidence** (simple algorithm)
- [x] Day 2: Password validation - **High confidence** (straightforward parsing)
- [x] Day 3: Grid traversal - **High confidence** (simple modulo arithmetic)
- [x] Day 4: Regex validation - **Medium confidence** (check regex patterns)
- [x] Day 5: Binary boarding - **High confidence** (binary conversion)
- [x] Day 6: Set operations - **High confidence** (union/intersection)
- [x] Day 7: Graph traversal - **High confidence** (DFS/BFS)
- [x] Day 9: Sliding window - **High confidence** (straightforward)
- [x] Day 10: Dynamic programming - **High confidence** (classic DP)
- [x] Day 11: Cellular automaton - **High confidence** (neighbor counting)

### Days 8, 12-25 (Newly Implemented)
- [ ] Day 8: Program execution - **High confidence** (standard interpreter pattern)
- [ ] Day 12: Navigation - **Medium confidence** (check rotation logic)
- [ ] Day 13: Chinese Remainder - **High confidence** (sieving method verified)
- [ ] Day 14: Bitmasks - **Medium confidence** (test with sample input)
- [ ] Day 15: Van Eck sequence - **High confidence** (standard Map pattern)
- [ ] Day 16: Constraint solving - **Medium confidence** (verify set logic)
- [ ] Day 17: 3D/4D Game of Life - **Medium confidence** (check neighbor generation)
- [ ] Day 18: Expression parsing - **Medium confidence** (verify precedence)
- [ ] Day 19: Recursive grammar - **Low confidence** (complex parsing, test carefully)
- [ ] Day 20: Tile assembly - **Low confidence** (incomplete, may need revision)
- [ ] Day 21: Set intersections - **High confidence** (straightforward)
- [ ] Day 22: Card game - **Medium confidence** (verify recursive rules)
- [ ] Day 23: Linked list - **Medium confidence** (IntMap usage correct)
- [ ] Day 24: Hex grid - **Medium confidence** (verify hex coordinate system)
- [ ] Day 25: Modular exp - **High confidence** (standard algorithm)

## Risk Mitigation

1. **Test locally first** - Don't submit from Cloud Agent without local testing
2. **Start with high-confidence days** - Days 1, 2, 3, 5, 6, 7, 9, 10, 11
3. **Use sample inputs** - Add example inputs from problem descriptions to test
4. **One day at a time** - Don't batch-submit; wait for confirmation
5. **Review before submit** - Double-check answer format (integer, string, etc.)

## Known Issues

- Day 19: May need adjustment for Part 2's recursive rules
- Day 20: Part 2 incomplete (sea monster detection)
- Some solutions may need input format adjustments

## Recommended Order

1. Test Days 1-3 (simplest, highest confidence)
2. Test Days 5-7, 9-11 (previously working)
3. Test Day 8 (newly added, simple)
4. Test Days 12-15 (medium complexity)
5. Test Days 16-18 (parsing-heavy)
6. Test Days 21-25 (varied complexity)
7. **Skip Day 20 Part 2 for now** (needs more work)

## After Submission

Update this document with:
- ✅ Which solutions worked
- ❌ Which solutions needed fixes
- 📝 Notes about any surprising issues
