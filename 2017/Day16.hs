import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (intercalate)

input :: String
input = unsafePerformIO $ readInput 2017 16

type Programs = String

dance :: Programs -> String -> Programs
dance progs move
    | head move == 's' = 
        let n = read (tail move)
        in drop (length progs - n) progs ++ take (length progs - n) progs
    | head move == 'x' =
        let [a, b] = map read $ words $ map (\c -> if c == '/' then ' ' else c) $ tail move
            pa = progs !! a
            pb = progs !! b
        in [if i == a then pb else if i == b then pa else progs !! i | i <- [0..length progs - 1]]
    | head move == 'p' =
        let [pa, pb] = tail move
            Just a = lookup pa (zip progs [0..])
            Just b = lookup pb (zip progs [0..])
        in [if i == a then pb else if i == b then pa else progs !! i | i <- [0..length progs - 1]]
    | otherwise = progs

danceAll :: Programs -> [String] -> Programs
danceAll = foldl dance

moves :: [String]
moves = words $ map (\c -> if c == ',' then ' ' else c) $ filter (/= '\n') input

findCycle :: Programs -> [String] -> Int
findCycle start mvs = go start 1
  where
    go current count
        | current == start && count > 1 = count
        | count > 1000000000 = count
        | otherwise = go (danceAll current mvs) (count + 1)

part1 :: String
part1 = danceAll "abcdefghijklmnop" moves

part2 :: String
part2 = iterate (`danceAll` moves) "abcdefghijklmnop" !! (1000000000 `mod` cycleLen)
  where cycleLen = findCycle "abcdefghijklmnop" moves
