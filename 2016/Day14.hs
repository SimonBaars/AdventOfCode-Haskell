import InputUtils (readInput)
import MD5Utils (md5)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isInfixOf, group)
import Data.Maybe (mapMaybe)

input :: String
input = unsafePerformIO $ readInput 2016 14

salt :: String
salt = filter (/= '\n') input

hasTriple :: String -> Maybe Char
hasTriple s = case [c | (c:_:_:_) <- group s, length (takeWhile (== c) s) >= 3] of
    [] -> Nothing
    (c:_) -> Just c

hasFive :: Char -> String -> Bool
hasFive c s = replicate 5 c `isInfixOf` s

stretchHash :: String -> String
stretchHash s = iterate (\h -> unsafePerformIO $ md5 h) s !! 2017

findKeys :: Bool -> String -> [Int]
findKeys stretch salt = take 64 $ mapMaybe checkKey [0..]
  where
    hashes = [(i, if stretch then stretchHash h else h) | i <- [0..], let h = unsafePerformIO $ md5 (salt ++ show i)]
    checkKey i =
        let hash = snd $ hashes !! i
        in case hasTriple hash of
            Nothing -> Nothing
            Just c -> if any (hasFive c . snd) (take 1000 $ drop (i + 1) hashes)
                      then Just i
                      else Nothing

part1 :: Int
part1 = last $ findKeys False salt

part2 :: Int
part2 = last $ findKeys True salt
