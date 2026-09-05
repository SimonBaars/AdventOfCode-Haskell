import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (foldl')

input :: [String]
input = unsafePerformIO $ readInputLines 2021 24

-- Parse the 14 blocks to extract the 3 varying parameters per block
-- Line 4: div z {1|26}
-- Line 5: add x {checkValue}
-- Line 15: add y {addValue}
parseBlocks :: [String] -> [(Int, Int, Int)]
parseBlocks ls = map extractParams blocks
  where
    blocks = splitIntoBlocks ls
    extractParams block = 
        let divLine = block !! 4   -- "div z N"
            addxLine = block !! 5  -- "add x N"
            addyLine = block !! 15 -- "add y N"
            divZ = read $ last $ words divLine
            addX = read $ last $ words addxLine
            addY = read $ last $ words addyLine
        in (divZ, addX, addY)

splitIntoBlocks :: [String] -> [[String]]
splitIntoBlocks [] = []
splitIntoBlocks ls = 
    let (block, rest) = splitAt 18 ls
    in if null block then [] else block : splitIntoBlocks rest

-- The ALU uses z as a base-26 stack
-- When divZ=1: push (digit + addY) onto stack
-- When divZ=26: pop from stack, check if (popped value) == (digit - addX)
-- 
-- For z to be 0 at the end, each push must pair with a pop
-- This creates constraints: digit[i] = digit[j] + offset
type Constraint = (Int, Int, Int)  -- (iPop, iPush, offset) means digit[iPop] = digit[iPush] + offset

findConstraints :: [(Int, Int, Int)] -> [Constraint]
findConstraints blocks = snd $ foldl' process ([], []) (zip [0..] blocks)
  where
    process (stack, constraints) (i, (divZ, addX, addY))
        | divZ == 1 = ((i, addY) : stack, constraints)  -- Push
        | otherwise = case stack of  -- Pop
            ((iPush, addYPush) : restStack) ->
                let offset = addYPush + addX  -- digit[i] = digit[iPush] + offset
                in (restStack, (i, iPush, offset) : constraints)
            [] -> (stack, constraints)  -- Should not happen in valid input

-- Given constraints, find max valid model number
solveMax :: [Constraint] -> Integer
solveMax constraints = foldl' (\acc d -> acc * 10 + toInteger d) 0 digits
  where
    digits = foldl' applyConstraint (replicate 14 9) constraints
    applyConstraint ds (iPop, iPush, offset)
        | offset >= 0 = 
            let dPush = min 9 (9 - offset)
                dPop = dPush + offset
            in setDigit iPush dPush $ setDigit iPop dPop ds
        | otherwise =
            let dPop = 9
                dPush = dPop - offset
            in setDigit iPush dPush $ setDigit iPop dPop ds
    setDigit i val ds = take i ds ++ [val] ++ drop (i + 1) ds

-- Given constraints, find min valid model number
solveMin :: [Constraint] -> Integer
solveMin constraints = foldl' (\acc d -> acc * 10 + toInteger d) 0 digits
  where
    digits = foldl' applyConstraint (replicate 14 1) constraints
    applyConstraint ds (iPop, iPush, offset)
        | offset >= 0 =
            let dPush = 1
                dPop = max 1 (dPush + offset)
            in setDigit iPush dPush $ setDigit iPop dPop ds
        | otherwise =
            let dPop = max 1 (1 - offset)
                dPush = dPop - offset
            in setDigit iPush dPush $ setDigit iPop dPop ds
    setDigit i val ds = take i ds ++ [val] ++ drop (i + 1) ds

part1 :: Integer
part1 = solveMax constraints
  where
    blocks = parseBlocks input
    constraints = findConstraints blocks

part2 :: Integer
part2 = solveMin constraints
  where
    blocks = parseBlocks input
    constraints = findConstraints blocks
