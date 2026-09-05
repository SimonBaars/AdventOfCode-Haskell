import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List.Split (splitOn)

input :: String
input = unsafePerformIO $ readInput 2019 2

program :: [Int]
program = map read $ splitOn "," $ filter (/= '\n') input

runIntcode :: [Int] -> [Int]
runIntcode mem = go 0 mem
  where
    go pc m
        | pc >= length m || m !! pc == 99 = m
        | m !! pc == 1 = 
            let [a, b, dest] = take 3 $ drop (pc + 1) m
            in go (pc + 4) (take dest m ++ [m !! a + m !! b] ++ drop (dest + 1) m)
        | m !! pc == 2 =
            let [a, b, dest] = take 3 $ drop (pc + 1) m
            in go (pc + 4) (take dest m ++ [m !! a * m !! b] ++ drop (dest + 1) m)
        | otherwise = m

part1 :: Int
part1 = head $ runIntcode $ 12 : 2 : drop 2 program

part2 :: Int
part2 = head [(100 * noun + verb) | noun <- [0..99], verb <- [0..99], head (runIntcode (noun : verb : drop 2 program)) == 19690720]
