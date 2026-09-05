import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)

input :: String
input = unsafePerformIO $ readInput 2016 9

decompress :: String -> Int
decompress [] = 0
decompress ('(':rest) = 
    let (marker, afterMarker) = break (== ')') rest
        [len, times] = map read $ words $ map (\c -> if c == 'x' then ' ' else c) marker
        (repeated, remaining) = splitAt len (tail afterMarker)
    in length repeated * times + decompress remaining
decompress (_:rest) = 1 + decompress rest

decompressV2 :: String -> Int
decompressV2 [] = 0
decompressV2 ('(':rest) = 
    let (marker, afterMarker) = break (== ')') rest
        [len, times] = map read $ words $ map (\c -> if c == 'x' then ' ' else c) marker
        (repeated, remaining) = splitAt len (tail afterMarker)
    in decompressV2 repeated * times + decompressV2 remaining
decompressV2 (_:rest) = 1 + decompressV2 rest

part1 :: Int
part1 = decompress $ filter (/= '\n') input

part2 :: Int
part2 = decompressV2 $ filter (/= '\n') input
