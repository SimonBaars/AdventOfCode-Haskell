import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: (Int, Int)
input = unsafePerformIO $ parseInput <$> readInput 2021 21

parseInput :: String -> (Int, Int)
parseInput s = (read $ last $ words l1, read $ last $ words l2)
  where [l1, l2] = lines s

playDeterministic :: (Int, Int) -> Int
playDeterministic (p1, p2) = go p1 p2 0 0 1 0
  where
    go pos1 pos2 score1 score2 die rolls
        | score2 >= 1000 = score1 * rolls
        | otherwise = 
            let moves = sum [mod die 100 + 1, mod (die+1) 100 + 1, mod (die+2) 100 + 1]
                pos1' = mod (pos1 + moves - 1) 10 + 1
                score1' = score1 + pos1'
            in go pos2 pos1' score2 score1' (die + 3) (rolls + 3)

part1 :: Int
part1 = playDeterministic input

type State = ((Int, Int), (Int, Int))

playQuantum :: State -> Map.Map State (Integer, Integer) -> (Integer, Integer)
playQuantum state cache = case Map.lookup state cache of
    Just result -> result
    Nothing -> 
        let ((p1, s1), (p2, s2)) = state
        in if s2 >= 21
           then (0, 1)
           else 
               let results = [playQuantum ((p2, s2), (p1', s1')) cache'
                            | roll <- [3,4,5,6,7,8,9]
                            , let p1' = mod (p1 + roll - 1) 10 + 1
                            , let s1' = s1 + p1'
                            , let cache' = Map.insert state undefined cache
                            ]
                   (w2s, w1s) = unzip results
                   freq = [1,3,6,7,6,3,1]
                   w1 = sum $ zipWith (*) freq w1s
                   w2 = sum $ zipWith (*) freq w2s
               in (w1, w2)

part2 :: Integer
part2 = max w1 w2
  where
    (p1, p2) = input
    (w1, w2) = playQuantum ((p1, 0), (p2, 0)) Map.empty
