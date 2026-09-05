import Data.List
import Data.Maybe
import qualified Data.Map as Map
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

type Bag = (Int, String)

input :: [(String, [Bag])]
input = unsafePerformIO $ map parseBagRule <$> readInputLines 2020 7

parseBagRule :: String -> (String, [Bag])
parseBagRule line = (bagColor, contents)
  where
    parts = words line
    bagColor = unwords $ take 2 parts
    contentsStr = unwords $ drop 4 parts
    contents = if contentsStr == "no other bags." 
               then []
               else parseContents contentsStr

parseContents :: String -> [Bag]
parseContents str = map parseBag $ splitOn ',' $ init str
  where
    parseBag s = let ws = words s
                 in (read (head ws), unwords $ take 2 $ tail ws)

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

part1 :: Int
part1 = (length . nub) $ insideBags "shiny gold"

insideBags :: String -> [String]
insideBags s = bags ++ concatMap insideBags bags
  where bags = [fst x | x <- input, any (\y -> snd y == s) (snd x)]

part2 :: Int
part2 = findBags "shiny gold" - 1

findBags :: String -> Int
findBags s = 1 + sum (map findBags (concatMap (uncurry replicate) (concat $ maybeToList (Map.lookup s inputMap))))

inputMap :: Map.Map String [Bag]
inputMap = Map.fromList input
