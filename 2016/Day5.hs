import InputUtils (readInput)
import MD5Utils (md5)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf)

input :: String
input = unsafePerformIO $ readInput 2016 5

doorId :: String
doorId = filter (/= '\n') input

findPassword1 :: String -> String
findPassword1 door = take 8 $ map (!! 5) $ filter ("00000" `isPrefixOf`) hashes
  where
    hashes = [unsafePerformIO $ md5 (door ++ show i) | i <- [0..]]

findPassword2 :: String -> String
findPassword2 door = go 0 [('_', i) | i <- [0..7]] []
  where
    hashes = [unsafePerformIO $ md5 (door ++ show i) | i <- [0..]]
    go _ result found | length found == 8 = map fst result
    go idx result found =
        let hash = hashes !! idx
        in if "00000" `isPrefixOf` hash
           then let pos = hash !! 5
                    char = hash !! 6
                in if pos `elem` "01234567"
                   then let p = read [pos]
                        in if p `notElem` found
                           then go (idx + 1) (take p result ++ [(char, p)] ++ drop (p + 1) result) (p : found)
                           else go (idx + 1) result found
                   else go (idx + 1) result found
           else go (idx + 1) result found

part1 :: String
part1 = findPassword1 doorId

part2 :: String
part2 = findPassword2 doorId
