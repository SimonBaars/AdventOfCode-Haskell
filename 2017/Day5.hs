import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array.ST
import Data.STRef
import Control.Monad.ST
import Control.Monad (when)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 5

jumps :: [Int]
jumps = map read input

simulate :: (Int -> Int) -> [Int] -> Int
simulate update js = runST $ do
    let n = length js
    arr <- newListArray (0, n - 1) js :: ST s (STArray s Int Int)
    posRef <- newSTRef 0
    stepsRef <- newSTRef 0
    let loop = do
          pos <- readSTRef posRef
          if pos < 0 || pos >= n
            then readSTRef stepsRef
            else do
              offset <- readArray arr pos
              writeArray arr pos (update offset)
              writeSTRef posRef (pos + offset)
              modifySTRef' stepsRef (+1)
              loop
    loop

part1 :: Int
part1 = simulate (+1) jumps

part2 :: Int
part2 = simulate (\x -> if x >= 3 then x - 1 else x + 1) jumps
