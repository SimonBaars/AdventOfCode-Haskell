import qualified Data.Map.Strict as M
import Data.Array
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data Instr = Hlf Char | Tpl Char | Inc Char | Jmp Int | Jie Char Int | Jio Char Int deriving Show

input :: Array Int Instr
input =
  let ls = unsafePerformIO $ readInputLines 2015 23
  in listArray (0, length ls - 1) (map parse ls)

parse :: String -> Instr
parse line =
  let clean = filter (/=',') line
      ws = words clean
  in case ws of
       ["hlf", [r]] -> Hlf r
       ["tpl", [r]] -> Tpl r
       ["inc", [r]] -> Inc r
       ["jmp", off] -> Jmp (readOffset off)
       ["jie", [r], off] -> Jie r (readOffset off)
       ["jio", [r], off] -> Jio r (readOffset off)
       _ -> error line

readOffset :: String -> Int
readOffset ('+':xs) = read xs
readOffset xs = read xs

run :: M.Map Char Integer -> Integer
run regs0 = go regs0 0
  where
    (lo,hi) = bounds input
    go regs ip
      | ip < lo || ip > hi = regs M.! 'b'
      | otherwise = case input ! ip of
          Hlf r -> go (M.adjust (`div` 2) r regs) (ip+1)
          Tpl r -> go (M.adjust (*3) r regs) (ip+1)
          Inc r -> go (M.adjust (+1) r regs) (ip+1)
          Jmp o -> go regs (ip+o)
          Jie r o -> go regs (if even (regs M.! r) then ip+o else ip+1)
          Jio r o -> go regs (if regs M.! r == 1 then ip+o else ip+1)

part1 :: Integer
part1 = run (M.fromList [('a',0),('b',0)])

part2 :: Integer
part2 = run (M.fromList [('a',1),('b',0)])
