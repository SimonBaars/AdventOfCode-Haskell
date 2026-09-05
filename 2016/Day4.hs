import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sortBy, group, sort, isInfixOf)
import Data.Ord (comparing, Down(..))
import Data.Char (ord, chr, isDigit, isAlpha)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 4

data Room = Room { name :: String, sector :: Int, checksum :: String }

parseRoom :: String -> Room
parseRoom str = Room roomName sectorId checksumStr
  where
    (rest, checksumPart) = break (== '[') str
    checksumStr = filter (/= ']') $ drop 1 checksumPart
    parts = reverse $ words $ map (\c -> if c == '-' then ' ' else c) rest
    sectorId = read (head parts)
    roomName = unwords $ reverse $ tail parts

computeChecksum :: String -> String
computeChecksum name = take 5 $ map head $ sortBy cmp $ group $ sort cleanName
  where
    cleanName = filter (/= ' ') name
    cmp a b = case comparing (negate . length) a b of
                EQ -> comparing head a b
                x -> x

isReal :: Room -> Bool
isReal room = computeChecksum (name room) == checksum room

decrypt :: Int -> Char -> Char
decrypt n c
    | isAlpha c = chr $ ord 'a' + ((ord c - ord 'a' + n) `mod` 26)
    | otherwise = c

decryptName :: Room -> String
decryptName room = map (decrypt (sector room)) (name room)

part1 :: Int
part1 = sum $ map sector $ filter isReal $ map parseRoom input

part2 :: Int
part2 = sector $ head $ filter (\r -> "northpole" `isInfixOf` decryptName r) 
                               $ filter isReal $ map parseRoom input
