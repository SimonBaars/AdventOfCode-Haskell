import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2016 16

dragonCurve :: String -> String
dragonCurve a = a ++ "0" ++ reverse (map flip' a)
  where flip' '0' = '1'
        flip' '1' = '0'
        flip' c = c

fillDisk :: String -> Int -> String
fillDisk initial len = take len $ head $ dropWhile (\s -> length s < len) $ iterate dragonCurve initial

checksum :: String -> String
checksum s
    | odd (length s) = s
    | otherwise = checksum $ map pair $ pairs s
  where
    pairs [] = []
    pairs [x] = [[x]]
    pairs (x:y:rest) = [x,y] : pairs rest
    pair [a, b] = if a == b then '1' else '0'
    pair s' = head s'

part1 :: String
part1 = checksum $ fillDisk (filter (/= '\n') input) 272

part2 :: String
part2 = checksum $ fillDisk (filter (/= '\n') input) 35651584
