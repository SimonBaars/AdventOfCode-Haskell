import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import System.Process (readProcess)
import Data.List (isPrefixOf)

-- Day 4: The Ideal Stocking Stuffer  
-- Find MD5 hashes with leading zeros
-- Note: Uses external md5sum command

input :: String
input = unsafePerformIO $ readInput 2015 4

-- Compute MD5 hash using external command
md5Hash :: String -> String
md5Hash s = unsafePerformIO $ do
    result <- readProcess "md5sum" [] s
    return $ takeWhile (/= ' ') result

-- Find lowest number producing MD5 hash with n leading zeros
findHashWithZeros :: String -> Int -> Int
findHashWithZeros key zeros = head [n | n <- [1..], hasLeadingZeros (md5Hash (key ++ show n)) zeros]

hasLeadingZeros :: String -> Int -> Bool
hasLeadingZeros hash n = replicate n '0' `isPrefixOf` hash

part1 :: Int
part1 = findHashWithZeros input 5

part2 :: Int
part2 = findHashWithZeros input 6
