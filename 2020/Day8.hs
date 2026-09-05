import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

-- Day 8: Handheld Halting
-- Part 1: Find accumulator value before infinite loop
-- Part 2: Fix program by changing one jmp<->nop to make it terminate

data Instruction = Acc Int | Jmp Int | Nop Int deriving (Show, Eq)

input :: [Instruction]
input = unsafePerformIO $ map parseInstruction <$> readInputLines 2020 8

parseInstruction :: String -> Instruction
parseInstruction line = case words line of
    ["acc", arg] -> Acc (parseArg arg)
    ["jmp", arg] -> Jmp (parseArg arg)
    ["nop", arg] -> Nop (parseArg arg)
    _ -> error $ "Invalid instruction: " ++ line
  where
    parseArg ('+':n) = read n
    parseArg n = read n

-- Execute program and detect infinite loop
-- Returns (terminated, accumulator)
execute :: [Instruction] -> (Bool, Int)
execute instrs = go 0 0 Set.empty
  where
    go pc acc visited
      | pc >= length instrs = (True, acc)
      | pc < 0 = (False, acc)
      | Set.member pc visited = (False, acc)
      | otherwise = 
          let visited' = Set.insert pc visited
              instr = instrs !! pc
          in case instr of
              Acc n -> go (pc + 1) (acc + n) visited'
              Jmp n -> go (pc + n) acc visited'
              Nop _ -> go (pc + 1) acc visited'

part1 :: Int
part1 = snd $ execute input

-- Try swapping each jmp<->nop until program terminates
part2 :: Int
part2 = head [acc | i <- [0..length input - 1], 
                    let modified = swapAt i input,
                    let (term, acc) = execute modified,
                    term]

swapAt :: Int -> [Instruction] -> [Instruction]
swapAt i instrs = take i instrs ++ [swapped] ++ drop (i + 1) instrs
  where
    swapped = case instrs !! i of
        Jmp n -> Nop n
        Nop n -> Jmp n
        acc -> acc
