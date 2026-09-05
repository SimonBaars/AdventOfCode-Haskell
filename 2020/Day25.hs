{-# LANGUAGE BangPatterns #-}
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: (Int, Int)
input = unsafePerformIO $ parseKeys <$> readInputLines 2020 25

parseKeys :: [String] -> (Int, Int)
parseKeys [a, b] = (read a, read b)
parseKeys _ = error "Invalid input"

transform :: Int -> Int -> Int -> Int
transform subject loopSize modulus = go 1 loopSize
  where
    go !value 0 = value
    go !value n = go ((value * subject) `mod` modulus) (n - 1)

findLoopSize :: Int -> Int -> Int
findLoopSize target subject = go 1 0
  where
    modulus = 20201227
    go !value !loop
        | value == target = loop
        | otherwise = go ((value * subject) `mod` modulus) (loop + 1)

part1 :: Int
part1 = transform publicKey2 loopSize1 20201227
  where
    (publicKey1, publicKey2) = input
    loopSize1 = findLoopSize publicKey1 7

part2 :: String
part2 = "Merry Christmas!"
