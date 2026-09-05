import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 15

data Disc = Disc { discNum :: Int, positions :: Int, startPos :: Int } deriving Show

parseDisc :: String -> Disc
parseDisc str = Disc num pos start
  where
    ws = words $ map (\c -> if c `elem` "#.;," then ' ' else c) str
    num = read $ ws !! 1
    pos = read $ ws !! 3
    start = read $ ws !! 11

findTime :: [Disc] -> Int
findTime discs = head [t | t <- [0..], all (aligned t) discs]
  where
    aligned t (Disc n p s) = (s + t + n) `mod` p == 0

discs :: [Disc]
discs = map parseDisc input

part1 :: Int
part1 = findTime discs

part2 :: Int
part2 = findTime (discs ++ [Disc (length discs + 1) 11 0])
