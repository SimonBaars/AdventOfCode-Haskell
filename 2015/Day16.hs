import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2015 16

target = Map.fromList [("children",3),("cats",7),("samoyeds",2),("pomeranians",3),
                       ("akitas",0),("vizslas",0),("goldfish",5),("trees",3),
                       ("cars",2),("perfumes",1)]

parseSue :: String -> (Int, Map.Map String Int)
parseSue line = (num, props)
  where
    ws = words $ filter (/= ',') $ filter (/= ':') line
    num = read $ ws !! 1
    props = Map.fromList [(ws !! i, read $ ws !! (i+1)) | i <- [2,4..length ws-2]]

matchesPart1 :: Map.Map String Int -> Bool
matchesPart1 props = all (\(k, v) -> Map.lookup k target == Just v) $ Map.toList props

part1 :: Int
part1 = fst $ head $ filter (matchesPart1 . snd) $ map parseSue input

part2 :: Int
part2 = part1  -- Placeholder
