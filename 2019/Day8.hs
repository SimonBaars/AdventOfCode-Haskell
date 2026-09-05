import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (group)

input :: String
input = unsafePerformIO $ readInput 2019 8

width, height :: Int
width = 25
height = 6

layers :: [String]
layers = chunksOf (width * height) $ filter (/= '\n') input
  where chunksOf n [] = []
        chunksOf n xs = take n xs : chunksOf n (drop n xs)

part1 :: Int
part1 = let minLayer = head $ filter (\l -> length (filter (== '0') l) == minimum [length (filter (== '0') layer) | layer <- layers]) layers
        in length (filter (== '1') minLayer) * length (filter (== '2') minLayer)

part2 :: String
part2 = unlines [take width $ drop (y * width) decoded | y <- [0..height-1]]
  where
    decoded = [head [c | c <- pixels, c /= '2'] | pixels <- transpose layers]
    transpose [] = repeat []
    transpose (xs:xss) = zipWith (:) xs (transpose xss)
