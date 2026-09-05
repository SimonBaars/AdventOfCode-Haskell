import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- Day 25: Combo Breaker
-- Cryptographic handshake using modular exponentiation

input :: (Int, Int)
input = unsafePerformIO $ parseKeys <$> readInputLines 2020 25

parseKeys :: [String] -> (Int, Int)
parseKeys [a, b] = (read a, read b)
parseKeys _ = error "Invalid input"

-- Transform a subject number
transform :: Int -> Int -> Int -> Int
transform subject loopSize modulus = go 1 loopSize
  where
    go value 0 = value
    go value n = go ((value * subject) `mod` modulus) (n - 1)

-- Find loop size that produces the target
findLoopSize :: Int -> Int -> Int
findLoopSize target subject = go 1 0
  where
    modulus = 20201227
    go value loop
        | value == target = loop
        | otherwise = go ((value * subject) `mod` modulus) (loop + 1)

part1 :: Int
part1 = transform publicKey2 loopSize1 20201227
  where
    (publicKey1, publicKey2) = input
    loopSize1 = findLoopSize publicKey1 7

-- Day 25 traditionally has no part 2 - it's just getting all 49 other stars
part2 :: String
part2 = "Merry Christmas!"
