import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 13

type Layer = (Int, Int)

parseLayer :: String -> Layer
parseLayer str = case words $ filter (/= ':') str of
    [d, r] -> (read d, read r)
    _ -> error "Invalid layer"

caughtAt :: Int -> Layer -> Bool
caughtAt delay (depth, range) = ((depth + delay) `mod` (2 * (range - 1))) == 0

severity :: Int -> [Layer] -> Int
severity delay layers = sum [d * r | (d, r) <- layers, caughtAt delay (d, r)]

findSafe :: [Layer] -> Int
findSafe layers = head [delay | delay <- [0..], not $ any (caughtAt delay) layers]

layers :: [Layer]
layers = map parseLayer input

part1 :: Int
part1 = severity 0 layers

part2 :: Int
part2 = findSafe layers
