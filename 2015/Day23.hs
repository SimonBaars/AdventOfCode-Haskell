import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2015 23

data State = State { pc :: Int, regs :: Map.Map Char Int }

execute :: [String] -> State -> State
execute instrs state
    | pc state >= length instrs = state
    | otherwise = execute instrs nextState
  where
    instr = instrs !! pc state
    ws = words $ filter (/= ',') instr
    nextState = case head ws of
        "hlf" -> state { pc = pc state + 1, regs = Map.adjust (`div` 2) (head $ ws !! 1) (regs state) }
        "tpl" -> state { pc = pc state + 1, regs = Map.adjust (* 3) (head $ ws !! 1) (regs state) }
        "inc" -> state { pc = pc state + 1, regs = Map.adjust (+ 1) (head $ ws !! 1) (regs state) }
        "jmp" -> state { pc = pc state + read (ws !! 1) }
        "jie" -> if even (regs state Map.! head (ws !! 1)) 
                 then state { pc = pc state + read (ws !! 2) }
                 else state { pc = pc state + 1 }
        "jio" -> if regs state Map.! head (ws !! 1) == 1
                 then state { pc = pc state + read (ws !! 2) }
                 else state { pc = pc state + 1 }

part1 :: Int
part1 = regs final Map.! 'b'
  where
    final = execute input (State 0 (Map.fromList [('a', 0), ('b', 0)]))

part2 :: Int
part2 = regs final Map.! 'b'
  where
    final = execute input (State 0 (Map.fromList [('a', 1), ('b', 0)]))
