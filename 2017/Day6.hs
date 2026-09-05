import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map
import Data.List (elemIndex, maximumBy)
import Data.Ord (comparing)

input :: String
input = unsafePerformIO $ readInput 2017 6

banks :: [Int]
banks = map read $ words input

redistribute :: [Int] -> [Int]
redistribute bs =
  let maxIdx = head [i | i <- [0 .. length bs - 1], bs !! i == maximum bs]
      blocks = bs !! maxIdx
      zeroed = take maxIdx bs ++ [0] ++ drop (maxIdx + 1) bs
      go idx 0 result = result
      go idx n result =
        let i = idx `mod` length result
            result' = take i result ++ [(result !! i) + 1] ++ drop (i + 1) result
        in go (idx + 1) (n - 1) result'
  in go (maxIdx + 1) blocks zeroed

findCycle :: [Int] -> (Int, Int)
findCycle start = go start (Map.singleton start 0) 0
  where
    go current seen step =
      let next = redistribute current
          step' = step + 1
      in case Map.lookup next seen of
           Just first -> (step', step' - first)
           Nothing -> go next (Map.insert next step' seen) step'

(cycles, loopSize) = findCycle banks

part1 :: Int
part1 = cycles

part2 :: Int
part2 = loopSize
