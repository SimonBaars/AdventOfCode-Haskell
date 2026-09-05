import Data.List (isPrefixOf)
import qualified Data.Map.Strict as M
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

type Sue = (Int, M.Map String Int)

input :: [Sue]
input = map parse $ unsafePerformIO $ readInputLines 2015 16
  where
    parse line =
      let -- Sue 1: goldfish: 6, trees: 9, akitas: 0
          n = read $ takeWhile (/=':') $ drop 4 line :: Int
          rest = drop 2 $ dropWhile (/=':') line
          parts = splitCommas rest
          kvs = M.fromList [ (k, read v) | p <- parts, let (k,v)=splitKV p ]
      in (n, kvs)
    splitCommas s = case break (==',') s of
      (a,"") -> [trim a]
      (a,',':b) -> trim a : splitCommas b
      _ -> [s]
    trim = dropWhile (==' ') . reverse . dropWhile (==' ') . reverse
    splitKV s =
      let (k, ':':v) = break (==':') (trim s)
      in (trim k, trim v)

target :: M.Map String Int
target = M.fromList
  [ ("children",3),("cats",7),("samoyeds",2),("pomeranians",3)
  , ("akitas",0),("vizslas",0),("goldfish",5),("trees",3)
  , ("cars",2),("perfumes",1) ]

match1 :: Sue -> Bool
match1 (_, m) = all (\(k,v) -> M.findWithDefault v k target == v) (M.toList m)

match2 :: Sue -> Bool
match2 (_, m) = all ok (M.toList m)
  where
    ok (k,v)
      | k `elem` ["cats","trees"] = v > target M.! k
      | k `elem` ["pomeranians","goldfish"] = v < target M.! k
      | otherwise = target M.! k == v

part1 :: Int
part1 = fst . head $ filter match1 input

part2 :: Int
part2 = fst . head $ filter match2 input
