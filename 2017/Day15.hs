import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 15

parseGen :: String -> Int
parseGen str = read $ last $ words str

genA, genB :: Int
[genA, genB] = map parseGen input

nextA, nextB :: Int -> Int
nextA n = (n * 16807) `mod` 2147483647
nextB n = (n * 48271) `mod` 2147483647

matches :: (Int, Int) -> Bool
matches (a, b) = (a `mod` 65536) == (b `mod` 65536)

generate :: Int -> (Int -> Int) -> [Int]
generate start next = tail $ iterate next start

part1 :: Int
part1 = length $ filter matches $ take 40000000 $ zip (generate genA nextA) (generate genB nextB)

part2 :: Int
part2 = length $ filter matches $ take 5000000 $ zip as bs
  where
    as = filter (\x -> x `mod` 4 == 0) $ generate genA nextA
    bs = filter (\x -> x `mod` 8 == 0) $ generate genB nextB
