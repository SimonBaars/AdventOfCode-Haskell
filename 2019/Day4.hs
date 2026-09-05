import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 4

range :: (Int, Int)
range = let [a, b] = map read $ words $ map (\c -> if c == '-' then ' ' else c) $ filter (/= '\n') input
        in (a, b)

hasDouble :: String -> Bool
hasDouble (a:b:rest) = a == b || hasDouble (b:rest)
hasDouble _ = False

neverDecreases :: String -> Bool
neverDecreases (a:b:rest) = a <= b && neverDecreases (b:rest)
neverDecreases _ = True

hasExactDouble :: String -> Bool
hasExactDouble s = any (\c -> length (filter (== c) s) == 2) s

isValid1 :: Int -> Bool
isValid1 n = let s = show n in hasDouble s && neverDecreases s

isValid2 :: Int -> Bool
isValid2 n = let s = show n in hasExactDouble s && neverDecreases s

part1 :: Int
part1 = length [n | n <- [fst range .. snd range], isValid1 n]

part2 :: Int
part2 = length [n | n <- [fst range .. snd range], isValid2 n]
