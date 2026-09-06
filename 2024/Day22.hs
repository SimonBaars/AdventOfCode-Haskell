-- Day 22: Monkey Market
-- Part 1: Sum of 2000th secret numbers
-- Part 2: Best sequence of 4 price changes

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [Integer]
input = unsafePerformIO $ map read <$> readInputLines 2024 22

-- Generate next secret number
nextSecret :: Integer -> Integer
nextSecret n = step3
  where
    step1 = ((n * 64) `xor` n) `mod` 16777216
    step2 = ((step1 `div` 32) `xor` step1) `mod` 16777216
    step3 = ((step2 * 2048) `xor` step2) `mod` 16777216

-- Generate nth secret
nthSecret :: Integer -> Int -> Integer
nthSecret initial 0 = initial
nthSecret initial n = nthSecret (nextSecret initial) (n - 1)

part1 :: Integer
part1 = sum [nthSecret s 2000 | s <- input]

-- Part 2: Find best price change sequence
part2 :: Integer
part2 = maximum [scoreSequence seq | seq <- allSequences]
  where
    allSequences = [[-9..9], [-9..9], [-9..9], [-9..9]]  -- 4-element sequences
    
    scoreSequence targetSeq = sum [findSequencePrice s targetSeq | s <- input]
    
    findSequencePrice initial targetSeq = 
        case findFirst (generatePrices initial 2000) targetSeq of
            Just price -> toInteger price
            Nothing -> 0
    
    generatePrices n 0 = []
    generatePrices n count = 
        let next = nextSecret n
            price = fromInteger (next `mod` 10)
            prevPrice = fromInteger (n `mod` 10)
        in (price, price - prevPrice) : generatePrices next (count - 1)
    
    findFirst ((price, _):rest) targetSeq = 
        if take 4 (map snd ((price, 0):rest)) == targetSeq
        then Just price
        else findFirst rest targetSeq
    findFirst [] _ = Nothing
