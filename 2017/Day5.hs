import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array
import Data.Array.ST
import Control.Monad.ST

input :: [String]
input = unsafePerformIO $ readInputLines 2017 5

jumps :: [Int]
jumps = map read input

simulate :: (Int -> Int) -> [Int] -> Int
simulate update js = runST $ do
    arr <- newListArray (0, length js - 1) js :: ST s (STArray s Int Int)
    let go pos steps
            | pos < 0 || pos >= length js = return steps
            | otherwise = do
                offset <- readArray arr pos
                writeArray arr pos (update offset)
                go (pos + offset) (steps + 1)
    go 0 0

part1 :: Int
part1 = simulate (+1) jumps

part2 :: Int
part2 = simulate (\x -> if x >= 3 then x - 1 else x + 1) jumps
