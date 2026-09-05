import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set
import Data.List (elemIndex)

input :: String
input = unsafePerformIO $ readInput 2017 6

banks :: [Int]
banks = map read $ words input

redistribute :: [Int] -> [Int]
redistribute bs = go (maxIdx + 1) (bs !! maxIdx) (take maxIdx bs ++ [0] ++ drop (maxIdx + 1) bs)
  where
    maxIdx = head [i | i <- [0..length bs - 1], bs !! i == maximum bs]
    go _ 0 result = result
    go idx blocks result = 
        let i = idx `mod` length result
            newResult = take i result ++ [result !! i + 1] ++ drop (i + 1) result
        in go (idx + 1) (blocks - 1) newResult

findCycle :: [Int] -> (Int, Int)
findCycle start = go start (Set.singleton start) 1
  where
    go current seen count =
        let next = redistribute current
        in if Set.member next seen
           then (count, count - (case elemIndex next (reverse $ Set.toList seen) of Just i -> i; Nothing -> 0))
           else go next (Set.insert next seen) (count + 1)

(cycles, loopSize) = findCycle banks

part1 :: Int
part1 = cycles

part2 :: Int
part2 = loopSize
