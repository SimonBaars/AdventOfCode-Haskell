import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2017 17

steps :: Int
steps = read $ filter (/= '\n') input

spinlock :: Int -> Int -> (Int, [Int])
spinlock stepSize count = go 0 [0] 1
  where
    go _ buffer n | n > count = (head $ tail $ dropWhile (/= count) $ cycle buffer, buffer)
    go pos buffer n =
        let newPos = ((pos + stepSize) `mod` length buffer) + 1
            newBuffer = take newPos buffer ++ [n] ++ drop newPos buffer
        in go newPos newBuffer (n + 1)

spinlockFast :: Int -> Int -> Int
spinlockFast stepSize count = go 0 0 0 1
  where
    go pos len afterZero n
        | n > count = afterZero
        | otherwise =
            let newPos = ((pos + stepSize) `mod` len) + 1
                newAfterZero = if newPos == 1 then n else afterZero
            in go newPos (len + 1) newAfterZero (n + 1)

part1 :: Int
part1 = fst $ spinlock steps 2017

part2 :: Int
part2 = spinlockFast steps 50000000
