import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.IntMap.Strict as IntMap

-- Day 23: Crab Cups
-- Circular cup arrangement simulation

input :: [Int]
input = unsafePerformIO $ map (read . (:[])) <$> readInput 2020 23

-- Simulate cup moves using an IntMap (cup -> next cup)
simulateCups :: Int -> Int -> [Int] -> IntMap.IntMap Int
simulateCups moves maxCup initial = go moves cups current
  where
    allCups = initial ++ [length initial + 1 .. maxCup]
    current = head initial
    cups = IntMap.fromList $ zip allCups (tail allCups ++ [head allCups])
    
    go 0 cups _ = cups
    go n cups cur = 
        let pickup1 = cups IntMap.! cur
            pickup2 = cups IntMap.! pickup1
            pickup3 = cups IntMap.! pickup2
            afterPickup = cups IntMap.! pickup3
            pickups = [pickup1, pickup2, pickup3]
            dest = findDest (cur - 1) pickups
            afterDest = cups IntMap.! dest
            cups' = IntMap.insert cur afterPickup $
                   IntMap.insert dest pickup1 $
                   IntMap.insert pickup3 afterDest cups
            next = cups' IntMap.! cur
        in go (n - 1) cups' next
    
    findDest n pickups
        | n < 1 = findDest maxCup pickups
        | n `elem` pickups = findDest (n - 1) pickups
        | otherwise = n

-- Get cups after cup 1
cupsAfter1 :: IntMap.IntMap Int -> [Int]
cupsAfter1 cups = take 8 $ tail $ iterate (cups IntMap.!) 1

part1 :: String
part1 = concatMap show $ cupsAfter1 $ simulateCups 100 9 input

-- Part 2: Simulate with 1 million cups for 10 million moves
part2 :: Int
part2 = product $ take 2 $ cupsAfter1 $ simulateCups 10000000 1000000 input
