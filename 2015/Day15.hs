import Data.List (foldl1')
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- capacity durability flavor texture calories
type Ing = [Int]

input :: [Ing]
input = map parse $ unsafePerformIO $ readInputLines 2015 15
  where
    parse line =
      let ws = words $ map (\c -> if c==',' then ' ' else c) line
          nums = map (read . filter (/=' ')) [ws!!2, ws!!4, ws!!6, ws!!8, ws!!10]
      in nums

distributions :: Int -> Int -> [[Int]]
distributions 1 total = [[total]]
distributions n total = [ x:rest | x <- [0..total], rest <- distributions (n-1) (total-x) ]

score :: Bool -> [Int] -> Int
score calorieLimit amounts =
  let mixed = foldl1' (zipWith (+)) $ zipWith (\amt ing -> map (amt*) ing) amounts input
      props = take 4 mixed
      cals = mixed !! 4
  in if calorieLimit && cals /= 500 then 0 else product (map (max 0) props)

part1 :: Int
part1 = maximum [ score False d | d <- distributions (length input) 100 ]

part2 :: Int
part2 = maximum [ score True d | d <- distributions (length input) 100 ]
